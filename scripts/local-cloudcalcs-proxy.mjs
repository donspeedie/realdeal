import http from "node:http";

const HOST = "127.0.0.1";
const PORT = Number(process.env.REALDEAL_LOCAL_API_PORT || 5181);
const CLOUD_CALCS_URL =
  process.env.REALDEAL_CLOUD_CALCS_URL ||
  "https://us-west1-habu-1gxak2.cloudfunctions.net/cloudCalcs";
const USER_AGENT = "getrealdeal-local-dev/1.0 (localhost restore)";
const geocodeCache = new Map();
let lastGeocodeAt = 0;

function setCors(res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, Connection");
  res.setHeader("Access-Control-Max-Age", "3600");
}

function isInvalidCoordinate(latlng) {
  const latitude = Number(latlng?.latitude);
  const longitude = Number(latlng?.longitude);
  return (
    !Number.isFinite(latitude) ||
    !Number.isFinite(longitude) ||
    (Math.abs(latitude) < 0.0001 && Math.abs(longitude) < 0.0001)
  );
}

async function waitForGeocodeSlot() {
  const elapsed = Date.now() - lastGeocodeAt;
  if (elapsed < 1100) {
    await new Promise((resolve) => setTimeout(resolve, 1100 - elapsed));
  }
  lastGeocodeAt = Date.now();
}

function addressCandidates(address) {
  const value = String(address || "").trim();
  if (!value) return [];
  const candidates = [
    value,
    value
      .replace(/\b(?:spc|space|unit|apt|apartment|suite|ste|#)\s*[\w-]+/ig, "")
      .replace(/\s+,/g, ",")
      .replace(/\s{2,}/g, " ")
      .trim(),
  ];
  const cityStateZip = value.match(/,\s*([^,]+,\s*[A-Z]{2}(?:\s+\d{5})?)/i)?.[1];
  if (cityStateZip) candidates.push(cityStateZip);
  return [...new Set(candidates.filter(Boolean))];
}

async function fetchGeocode(address) {
  await waitForGeocodeSlot();
  const url = new URL("https://nominatim.openstreetmap.org/search");
  url.searchParams.set("format", "jsonv2");
  url.searchParams.set("limit", "1");
  url.searchParams.set("countrycodes", "us");
  url.searchParams.set("q", address);

  try {
    const response = await fetch(url, {
      headers: {
        "Accept": "application/json",
        "User-Agent": USER_AGENT,
      },
    });
    if (!response.ok) throw new Error(`Nominatim ${response.status}`);
    const places = await response.json();
    const place = Array.isArray(places) ? places[0] : null;
    const latitude = Number(place?.lat);
    const longitude = Number(place?.lon);
    const result = Number.isFinite(latitude) && Number.isFinite(longitude)
      ? {
          latitude: Number(latitude.toFixed(6)),
          longitude: Number(longitude.toFixed(6)),
        }
      : null;
    return result;
  } catch (error) {
    console.warn(`Geocode failed for "${address}": ${error.message}`);
    return null;
  }
}

async function geocodeAddress(address) {
  const key = String(address || "").trim().toLowerCase();
  if (!key) return null;
  if (geocodeCache.has(key)) return geocodeCache.get(key);

  for (const candidate of addressCandidates(address)) {
    const result = await fetchGeocode(candidate);
    if (result) {
      geocodeCache.set(key, result);
      return result;
    }
  }

  geocodeCache.set(key, null);
  return null;
}

async function enrichPayload(eventName, data) {
  if (eventName !== "data") return data;

  let payload;
  try {
    payload = JSON.parse(data);
  } catch {
    return data;
  }

  if (payload && typeof payload === "object" && isInvalidCoordinate(payload.latlng)) {
    const coordinates = await geocodeAddress(payload.address);
    if (coordinates) {
      payload.latlng = coordinates;
    }
  }

  if (payload && typeof payload === "object" && /^https:\/\/www\.zillow\.com\/https?:\/\//i.test(payload.detailUrl || "")) {
    payload.detailUrl = payload.detailUrl.replace(/^https:\/\/www\.zillow\.com\//i, "");
  }

  return JSON.stringify(payload);
}

async function writeEvent(res, eventName, dataLines) {
  if (eventName) res.write(`event: ${eventName}\n`);
  const enrichedData = await enrichPayload(eventName, dataLines.join("\n"));
  for (const line of String(enrichedData).split("\n")) {
    res.write(`data: ${line}\n`);
  }
  res.write("\n");
}

async function proxyCloudCalcs(req, res) {
  setCors(res);
  res.writeHead(200, {
    "Content-Type": "text/event-stream; charset=utf-8",
    "Cache-Control": "no-cache, no-transform",
    "Connection": "keep-alive",
    "X-Accel-Buffering": "no",
  });

  let upstream;
  try {
    upstream = await fetch(CLOUD_CALCS_URL, {
      method: "POST",
      headers: {
        "Content-Type": req.headers["content-type"] || "application/json",
        "Accept": "text/event-stream",
      },
      body: req,
      duplex: "half",
    });
  } catch (error) {
    res.write(`event: error\ndata: ${JSON.stringify({error: "Local proxy failed to reach cloudCalcs", details: error.message})}\n\n`);
    res.end();
    return;
  }

  if (!upstream.ok || !upstream.body) {
    res.write(`event: error\ndata: ${JSON.stringify({error: "cloudCalcs returned an error", status: upstream.status})}\n\n`);
    res.end();
    return;
  }

  const reader = upstream.body.getReader();
  const decoder = new TextDecoder();
  let buffer = "";
  let eventName = "";
  let dataLines = [];

  const flush = async () => {
    if (!eventName && dataLines.length === 0) return;
    await writeEvent(res, eventName, dataLines);
    eventName = "";
    dataLines = [];
  };

  try {
    while (true) {
      const {done, value} = await reader.read();
      if (done) break;
      buffer += decoder.decode(value, {stream: true});
      let index;
      while ((index = buffer.indexOf("\n")) >= 0) {
        let line = buffer.slice(0, index);
        buffer = buffer.slice(index + 1);
        if (line.endsWith("\r")) line = line.slice(0, -1);
        if (line === "") {
          await flush();
        } else if (line.startsWith("event:")) {
          eventName = line.slice(6).trim();
        } else if (line.startsWith("data:")) {
          dataLines.push(line.slice(5).trimStart());
        } else {
          res.write(`${line}\n`);
        }
      }
    }
    await flush();
  } catch (error) {
    res.write(`event: error\ndata: ${JSON.stringify({error: "Local proxy stream failed", details: error.message})}\n\n`);
  } finally {
    res.end();
  }
}

const server = http.createServer((req, res) => {
  setCors(res);

  if (req.method === "OPTIONS") {
    res.writeHead(204);
    res.end();
    return;
  }

  if (req.method === "POST" && req.url?.split("?")[0] === "/cloudCalcs") {
    proxyCloudCalcs(req, res);
    return;
  }

  if (req.method === "GET" && req.url?.split("?")[0] === "/health") {
    res.writeHead(200, {"Content-Type": "application/json"});
    res.end(JSON.stringify({ok: true, geocodeCacheSize: geocodeCache.size}));
    return;
  }

  res.writeHead(404, {"Content-Type": "application/json"});
  res.end(JSON.stringify({error: "Not found"}));
});

server.listen(PORT, HOST, () => {
  console.log(`local cloudCalcs proxy listening at http://${HOST}:${PORT}`);
});
