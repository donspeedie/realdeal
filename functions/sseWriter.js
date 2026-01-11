function initSSE(res) {
  res.set({
    "Content-Type": "text/event-stream",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive",
    "Access-Control-Allow-Origin": "*",
  });
  res.flushHeaders();

  const keepAlive = setInterval(() => {
    res.write(`: keep-alive\n\n`);
    // Conditionally flush if available
    if (typeof res.flush === "function") res.flush();
  }, 5000);

  return {
    write: (msg) => {
      res.write(msg);
      if (typeof res.flush === "function") res.flush();
    },
    writeEvent: (event, data) => {
      res.write(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`);
      if (typeof res.flush === "function") res.flush();
    },
    end: () => {
      clearInterval(keepAlive);
      res.end();
    },
    flush: () => {
      if (typeof res.flush === "function") res.flush();
    },
    keepAlive: {stop: () => clearInterval(keepAlive)},
  };
}

module.exports = {
  initSSE,
  writeEvent: (res, event, data) => {
    res.write(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`);
    // Conditionally flush if available
    if (typeof res.flush === "function") res.flush();
  },
  closeSSE: (res) => res.end(),
};
