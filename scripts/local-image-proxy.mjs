import http from 'node:http';

const port = Number(process.env.REALDEAL_IMAGE_PROXY_PORT || 5180);

const sendCors = (res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, HEAD, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Max-Age', '3600');
};

const server = http.createServer(async (req, res) => {
  sendCors(res);

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const requestUrl = new URL(req.url || '/', `http://${req.headers.host}`);
  if (requestUrl.pathname !== '/image') {
    res.writeHead(404, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({error: 'Not found'}));
    return;
  }

  const targetUrl = requestUrl.searchParams.get('url');
  if (!targetUrl) {
    res.writeHead(400, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({error: 'Missing url query parameter'}));
    return;
  }

  let parsedUrl;
  try {
    parsedUrl = new URL(targetUrl);
  } catch {
    res.writeHead(400, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({error: 'Invalid url query parameter'}));
    return;
  }

  if (!['http:', 'https:'].includes(parsedUrl.protocol)) {
    res.writeHead(400, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({error: 'Only http and https URLs are supported'}));
    return;
  }

  try {
    const upstream = await fetch(parsedUrl, {
      headers: {
        Accept: 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
        'User-Agent': 'Mozilla/5.0 getRealDeal.ai local image proxy',
      },
    });

    if (!upstream.ok) {
      res.writeHead(upstream.status, {'Content-Type': 'text/plain'});
      res.end(`Upstream image request failed: ${upstream.statusText}`);
      return;
    }

    const headers = {
      'Content-Type': upstream.headers.get('content-type') || 'application/octet-stream',
      'Cache-Control': 'public, max-age=86400',
    };
    res.writeHead(200, headers);

    if (req.method === 'HEAD') {
      res.end();
      return;
    }

    const body = Buffer.from(await upstream.arrayBuffer());
    res.end(body);
  } catch (error) {
    res.writeHead(502, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({error: 'Image proxy request failed'}));
  }
});

server.listen(port, '127.0.0.1', () => {
  console.log(`RealDeal local image proxy listening on http://127.0.0.1:${port}`);
});
