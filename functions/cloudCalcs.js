// const {onRequest} = require("firebase-functions/v2/https");
// const {setGlobalOptions} = require("firebase-functions/v2/options");
// const axios = require("axios");
// const admin = require("firebase-admin");

// // Initialize Firebase Admin
// if (admin.apps.length === 0) {
//   admin.initializeApp();
// }

// // Configure global options
// setGlobalOptions({
//   region: "us-west1",
//   memory: "2GiB",
//   timeoutSeconds: 540,
//   concurrency: 50,
//   minInstances: 1,
// });

// // Helper function to construct Zillow URLs
// const appendZillowUrl = (url) => {
//   if (!url) return "";
//   const cleaned = url.trim().startsWith("/") ? url : `/${url}`;
//   return encodeURI(`https://www.zillow.com${cleaned}`);
// };

// // Text analysis for property descriptions
// const analyzeDescription = (text) => {
//   const keywords = ["fix", "repair", "contractor", "investor", "flip", "damage"];
//   const lower = (text || "").toLowerCase();
//   return {
//     hasKeywords: keywords.some((k) => lower.includes(k)),
//     keywords: keywords.filter((k) => lower.includes(k)),
//     keywordCount: keywords.filter((k) => lower.includes(k)).length,
//   };
// };

// // Calculate bedroom price averages
// const calculateBedroomPriceAverages = (properties) => {
//   if (!Array.isArray(properties)) return [];

//   const bedroomGroups = Array(5).fill().map(() => []);

//   properties.forEach((property) => {
//     if (!property || typeof property !== "object") return;

//     const beds = Math.min(5, Math.max(1, Math.floor(Number(property.bedrooms) || 0)));
//     const price = Number(property.price);
//     const livingArea = Number(property.livingArea) || 0;

//     if (!isNaN(price)) {
//       bedroomGroups[beds - 1].push({price, livingArea});
//     }
//   });

//   return bedroomGroups.map((group, idx) => {
//     if (group.length === 0) return null;

//     const prices = group.map((p) => p.price).filter((p) => !isNaN(p));
//     if (prices.length === 0) return null;

//     const sorted = [...prices].sort((a, b) => a - b);
//     const total = sorted.reduce((sum, val) => sum + val, 0);
//     const avg = Math.round(total / sorted.length);

//     return {
//       bedrooms: idx + 1,
//       count: sorted.length,
//       avgPrice: avg,
//       minPrice: sorted[0],
//       maxPrice: sorted[sorted.length - 1],
//       avgPricePerSqFt: calculateAvgSqFt(group),
//     };
//   }).filter(Boolean);
// };

// function calculateAvgSqFt(group) {
//   const validEntries = group.filter((p) => p.livingArea > 0 && p.price > 0);
//   if (validEntries.length === 0) return 0;

//   const totalSqFtCost = validEntries.reduce(
//       (sum, p) => sum + (p.price / p.livingArea),
//       0,
//   );

//   return Math.round(totalSqFtCost / validEntries.length);
// }

// // Rate limit handling
// const calculateWaitTime = (headers) => {
//   const now = Date.now();
//   const resetHeader = headers["x-ratelimit-requests-reset"];
//   const resetTime = resetHeader ? parseInt(resetHeader) * 1000 : now + 60000;
//   const jitter = Math.random() * 5000;

//   return Math.min(Math.max(resetTime - now, 0) + jitter, 120000);
// };

// // Main Cloud Function
// exports.cloudCalcs = onRequest(async (req, res) => {
//   // Handle CORS preflight requests
//   if (req.method === "OPTIONS") {
//     res.set({
//       "Access-Control-Allow-Origin": "*",
//       "Access-Control-Allow-Methods": "POST, OPTIONS",
//       "Access-Control-Allow-Headers": "Content-Type, Authorization",
//       "Content-Length": "0",
//     });
//     return res.status(204).send("");
//   }

//   // Set proper SSE headers
//   res.set({
//     "Content-Type": "text/event-stream",
//     "Cache-Control": "no-cache",
//     "Connection": "keep-alive",
//     "Access-Control-Allow-Origin": "*",
//   });

//   res.flushHeaders();
//   res.write(": Initializing property search\n\n");
//   if (res.flush) res.flush();

//   let clientConnected = true;

//   // Start keep-alive pings
//   const keepAliveInterval = setInterval(() => {
//     if (clientConnected) {
//       res.write(`: keep-alive\n\n`);
//       if (res.flush) res.flush();
//     }
//   }, 5000); // send every 5 seconds

//   req.on("close", () => {
//     clearInterval(keepAliveInterval); // stop pinging when client disconnects
//     console.log("Client disconnected");
//     clientConnected = false;
//   });

//   try {
//     const params = req.body || {};
//     console.log("Received parameters:", params);

//     // Validate required parameters
//     if (!params.location) {
//       res.write(`event: error\ndata: ${JSON.stringify({error: "Missing required 'location' parameter"})}\n\n`);
//       return res.end();
//     }

//     let page = 1;
//     let totalPages = 1;
//     let totalProcessed = 0;

//     // Safety limits
//     const MAX_PAGES = 5;
//     const MAX_PROPERTIES = 50;

//     do {
//       if (!clientConnected) {
//         console.log("Client disconnected, aborting");
//         return res.end();
//       }

//       if (page > MAX_PAGES || totalProcessed >= MAX_PROPERTIES) {
//         res.write(`event: info\ndata: ${JSON.stringify({
//           message: `Reached safety limit (${MAX_PROPERTIES} properties)`,
//         })}\n\n`);
//         break;
//       }

//       // Log API request details
//       const requestParams = {
//         location: params.location,
//         page,
//         minPrice: params.minPrice ? Math.round(params.minPrice) : undefined,
//         maxPrice: params.maxPrice ? Math.round(params.maxPrice) : undefined,
//         status_Type: params.status_Type || "FOR_SALE",
//         propertyType: params.propertyType || "SINGLE_FAMILY",
//       };
//       console.log(`Fetching page ${page} with params:`, requestParams);

//       let pageResponse;
//       try {
//         pageResponse = await axiosGetWithRetry(
//             "https://zillow-com1.p.rapidapi.com/propertyExtendedSearch",
//             {
//               params: requestParams,
//               headers: {
//                 "X-Rapidapi-Key": process.env.ZILLOW_API_KEY,
//                 "X-Rapidapi-Host": "zillow-com1.p.rapidapi.com",
//               },
//               timeout: 30000,
//             },
//         );
//       } catch (apiError) {
//         console.error("Zillow API error:", apiError.message);
//         res.write(`event: error\ndata: ${JSON.stringify({
//           error: "Zillow API request failed",
//           details: apiError.message,
//         })}\n\n`);
//         return res.end();
//       }

//       const responseData = pageResponse.data || {};
//       console.log(`Page ${page} response:`, {
//         totalPages: responseData.totalPages,
//         totalResultCount: responseData.totalResultCount,
//         propsCount: responseData.props ? responseData.props.length : 0,
//       });

//       // Validate API response
//       if (!responseData.props || !Array.isArray(responseData.props)) {
//         console.error("Invalid Zillow response structure:", responseData);
//         res.write(`event: error\ndata: ${JSON.stringify({
//           error: "Invalid response from Zillow API",
//           response: responseData,
//         })}\n\n`);
//         return res.end();
//       }

//       const properties = responseData.props;
//       totalPages = Math.min(responseData.totalPages || 1, MAX_PAGES);

//       if (properties.length === 0) {
//         if (page === 1) {
//           res.write(`event: info\ndata: ${JSON.stringify({
//             message: "No properties found for the given criteria",
//           })}\n\n`);
//         }
//         break;
//       }

//       res.write(`event: page-start\ndata: ${JSON.stringify({
//         page,
//         totalPages,
//         propertiesCount: properties.length,
//       })}\n\n`);
//       if (res.flush) res.flush();

//       // DEBUG: Log property count
//       console.log(`Processing ${properties.length} properties for page ${page}`);

//       for (const prop of properties) {
//         if (!clientConnected || totalProcessed >= MAX_PROPERTIES) break;

//         totalProcessed++;
//         console.log(`Processing property ${totalProcessed}: ${prop.zpid}`);

//         // DEBUG: Log property details
//         console.log(`Property details:`, {
//           zpid: prop.zpid,
//           price: prop.price,
//           livingArea: prop.livingArea,
//           address: prop.address,
//         });

//         let results;
//         try {
//           results = await processProperty(
//               prop,
//               params,
//               totalProcessed,
//               responseData.totalResultCount || properties.length,
//           );
//         } catch (processError) {
//           console.error(`Error processing property ${prop.zpid}:`, processError);
//           results = [{
//             error: processError.message,
//             zpid: prop.zpid,
//             sequence: totalProcessed,
//             total: responseData.totalResultCount || properties.length,
//           }];
//         }

//         // DEBUG: Log results count
//         console.log(`Generated ${results.length} results for property ${prop.zpid}`);

//         for (const result of results) {
//           try {
//             // DEBUG: Log before sending
//             console.log(`Sending result for ${prop.zpid}`);
//             res.write(`data: ${JSON.stringify(result)}\n\n`);
//             if (res.flush) res.flush();
//             console.log(`Result sent for ${prop.zpid}`);
//           } catch (writeError) {
//             console.error("Write error:", writeError);
//             clientConnected = false;
//             break;
//           }
//         }

//         await checkRateLimits(pageResponse.headers);
//       }

//       const headers = pageResponse.headers || {};
//       const remaining = parseInt(headers["x-ratelimit-requests-remaining"]) || 0;

//       if (remaining < 10) {
//         const waitTime = calculateWaitTime(headers);
//         console.log(`Approaching rate limit, waiting ${waitTime}ms`);
//         await new Promise((resolve) => setTimeout(resolve, waitTime));
//       }

//       page++;
//     } while (page <= totalPages && clientConnected);

//     res.write("event: end\ndata: {}\n\n");
//     res.end();
//     console.log("Stream completed successfully");
//   } catch (error) {
//     console.error("Top-level error:", error);
//     try {
//       res.write(`event: error\ndata: ${JSON.stringify({
//         error: "Unexpected error",
//         details: error.message,
//       })}\n\n`);
//       res.end();
//     } catch (finalError) {
//       console.error("Final write error:", finalError);
//     }
//   }
// });

// // API call wrapper with retry logic
// async function axiosGetWithRetry(url, config, maxRetries = 3) {
//   let attempt = 0;
//   config = config || {};

//   while (attempt <= maxRetries) {
//     try {
//       const response = await axios.get(url, {
//         ...config,
//         timeout: config.timeout || 15000,
//       });
//       return response;
//     } catch (error) {
//       if (!error.response) {
//         console.warn(`Request error (no response): ${error.message}`);
//         throw error;
//       }

//       if (error.response.status === 429) {
//         const waitTime = calculateWaitTime(error.response.headers);
//         console.warn(`Rate limited (429), waiting ${waitTime}ms`);
//         await new Promise((resolve) => setTimeout(resolve, waitTime));
//         attempt++;
//       } else if (error.response.status >= 500) {
//         attempt++;
//         const waitTime = 2000 * Math.pow(2, attempt);
//         console.warn(`Server error (${error.response.status}), retrying in ${waitTime}ms`);
//         await new Promise((resolve) => setTimeout(resolve, waitTime));
//       } else {
//         console.warn(`API error ${error.response.status}: ${JSON.stringify(error.response.data)}`);
//         throw new Error(`API responded with status ${error.response.status}`);
//       }
//     }
//   }
//   throw new Error(`Request failed after ${maxRetries} retries`);
// }

// // Property processing pipeline
// async function processProperty(prop, params, sequence, total) {
//   // DEBUG: Log property entry
//   console.log(`Starting processing for property ${prop.zpid}`);

//   // Validate required property fields
//   if (!prop.price || !prop.livingArea) {
//     console.log(`Skipping property ${prop.zpid} - missing price or livingArea`);
//     return [{
//       error: "Missing price or livingArea",
//       zpid: prop.zpid,
//       sequence,
//       total,
//     }];
//   }

//   // DEBUG: Log property values
//   console.log(`Property values: price=${prop.price}, livingArea=${prop.livingArea}`);

//   try {
//     console.log(`Fetching data for property ${prop.zpid}`);

//     // Parallelize API requests with timeout
//     const apiCalls = [
//       axiosGetWithRetry(
//           "https://zillow-com1.p.rapidapi.com/zestimate",
//           {
//             params: {zpid: prop.zpid},
//             headers: {
//               "X-Rapidapi-Key": process.env.ZILLOW_API_KEY,
//               "X-Rapidapi-Host": "zillow-com1.p.rapidapi.com",
//             },
//           },
//       ).catch((error) => {
//         console.warn(`Zestimate failed for ${prop.zpid}: ${error.message}`);
//         return {data: {}};
//       }),

//       axiosGetWithRetry(
//           "https://zillow-com1.p.rapidapi.com/propertyComps",
//           {
//             params: {address: prop.address},
//             headers: {
//               "X-Rapidapi-Key": process.env.ZILLOW_API_KEY,
//               "X-Rapidapi-Host": "zillow-com1.p.rapidapi.com",
//             },
//           },
//       ).catch((error) => {
//         console.warn(`Comps failed for ${prop.zpid}: ${error.message}`);
//         return {data: {}};
//       }),

//       axiosGetWithRetry(
//           "https://zillow-com1.p.rapidapi.com/propertyExtendedSearch",
//           {
//             params: {
//               location: prop.address,
//               bedsMin: 1,
//               bedsMax: 5,
//               status_Type: "RECENTLY_SOLD",
//               page: 1,
//             },
//             headers: {
//               "X-Rapidapi-Key": process.env.ZILLOW_API_KEY,
//               "X-Rapidapi-Host": "zillow-com1.p.rapidapi.com",
//             },
//           },
//       ).catch((error) => {
//         console.warn(`Bed comps failed for ${prop.zpid}: ${error.message}`);
//         return {data: {}};
//       }),
//     ];

//     // Add timeout to API calls
//     const timeoutPromise = new Promise((resolve) =>
//       setTimeout(() => resolve({data: {}}), 20000),
//     );

//     const [zestimateRes, compsRes, allBedRes] = await Promise.all([
//       Promise.race([apiCalls[0], timeoutPromise]),
//       Promise.race([apiCalls[1], timeoutPromise]),
//       Promise.race([apiCalls[2], timeoutPromise]),
//     ]);

//     console.log(`API data received for property ${prop.zpid}`);

//     // Process bedroom comps
//     const bedroomProps = (allBedRes.data && Array.isArray(allBedRes.data.props)) ?
//       allBedRes.data.props :
//       [];

//     // Calculate 2-bedroom average
//     let twoBedAvg = 0;
//     const twoBedComps = bedroomProps.filter((c) => c.bedrooms === 2);
//     if (twoBedComps.length > 0) {
//       twoBedAvg = Math.round(
//           twoBedComps.reduce((s, c) => s + c.price, 0) / twoBedComps.length,
//       );
//     }

//     // Bedroom analysis
//     const bedroomAnalysis = calculateBedroomPriceAverages(bedroomProps) || [];
//     console.log(`Bedroom analysis for ${prop.zpid}:`, bedroomAnalysis);

//     // Data processing
//     const descriptionAnalysis = analyzeDescription(prop.description || "");
//     console.log(`Description analysis for ${prop.zpid}:`, descriptionAnalysis);

//     const compsArray = (compsRes.data && Array.isArray(compsRes.data.comps)) ?
//       compsRes.data.comps :
//       [];

//     const validComps = compsArray.filter((c) => c.price && c.livingArea);
//     let pricePerSqFt = 250;

//     if (validComps.length > 0) {
//       const totalPerSqFt = validComps.reduce(
//           (sum, c) => sum + (c.price / c.livingArea), 0,
//       );
//       pricePerSqFt = Math.round(totalPerSqFt / validComps.length);
//     }

//     console.log(`Calculated pricePerSqFt for ${prop.zpid}: ${pricePerSqFt}`);

//     // Strategy calculations
//     console.log(`Generating strategies for ${prop.zpid}`);
//     const strategyResults = ["Fix & Flip", "Add-On", "ADU", "New Build"]
//         .map((method) => {
//           try {
//             return calculateStrategy(
//                 method,
//                 prop,
//                 params,
//                 pricePerSqFt,
//                 twoBedAvg,
//                 bedroomAnalysis,
//             );
//           } catch (strategyError) {
//             console.error(`Strategy error for ${method}: ${strategyError.message}`);
//             return {
//               method,
//               error: strategyError.message,
//               zpid: prop.zpid,
//             };
//           }
//         })
//         .filter((r) => r) // Remove any undefined results
//         .map((strategyResult) => ({
//           ...strategyResult,
//           address: prop.address,
//           bathrooms: Math.round(prop.bathrooms || 0),
//           bedrooms: Math.round(prop.bedrooms || 0),
//           detailUrl: appendZillowUrl(prop.detailUrl),
//           imgSrc: prop.imgSrc,
//           latlng: {
//             latitude: prop.latitude ? Number(prop.latitude.toFixed(2)) : 0,
//             longitude: prop.longitude ? Number(prop.longitude.toFixed(2)) : 0,
//           },
//           livingArea: prop.livingArea || 0,
//           price: prop.price || 0,
//           zpid: prop.zpid,
//           descriptionAnalysis,
//           zestimate: zestimateRes.data && zestimateRes.data.value ?
//             Math.round(zestimateRes.data.value) :
//             0,
//           pricePerSqft: pricePerSqFt,
//           sequence,
//           total,
//         }));

//     console.log(`Generated ${strategyResults.length} strategies for ${prop.zpid}`);
//     return strategyResults;
//   } catch (error) {
//     console.error(`Property ${prop.zpid} failed:`, error);
//     return [{
//       error: error.message,
//       zpid: prop.zpid,
//       sequence,
//       total,
//     }];
//   }
// }

// // Rate limit checker
// async function checkRateLimits(headers) {
//   const remaining = parseInt(headers["x-ratelimit-requests-remaining"]) || 0;
//   if (remaining < 5) {
//     const waitTime = calculateWaitTime(headers);
//     console.warn(`Critical rate limit, waiting ${waitTime}ms`);
//     await new Promise((resolve) => setTimeout(resolve, waitTime));
//   }
// }

// // Investment strategy calculations
// function calculateStrategy(method, prop, params, pricePerSqFt, twoBedAvg, bedroomAnalysis) {
//   console.log(`Calculating ${method} strategy for $${prop.price}`);

//   // Common financial parameters
//   const purchasePrice = Math.round(Number(prop.price) || 0);
//   const livingArea = Math.round(Number(prop.livingArea) || 0);
//   const mtgRate = params.interestRate || 0.06;
//   const salRate = params.salRate || 0.05;
//   const loanFeesRate = params.loanFeesRate || 0.01;

//   // Strategy configurations
//   const configs = {
//     "Fix & Flip": {
//       duration: params.fixFlipDuration || 3,
//       impFactor: 1.03,
//       rate: 25,
//       areaMult: 1,
//       extraValue: 0,
//     },
//     "Add-On": {
//       duration: params.addOnDuration || 6,
//       impFactor: 1.0,
//       rate: 125,
//       areaMult: 1.2,
//       addOnArea: 240,
//       extraValue: params.oneBdrmMarketValue || 0,
//     },
//     "ADU": {
//       duration: params.aduDuration || 9,
//       impFactor: 1.0,
//       rate: 200,
//       areaMult: 1.5,
//       aduArea: 750,
//       extraValue: twoBedAvg,
//     },
//     "New Build": {
//       duration: params.newBuildDuration || 12,
//       impFactor: 1.15,
//       rate: 200,
//       areaMult: 1.2,
//       extraValue: 0,
//     },
//   };

//   const config = configs[method];
//   if (!config) {
//     throw new Error(`Invalid strategy method: ${method}`);
//   }

//   const duration = config.duration;
//   const impFactor = config.impFactor;
//   const rate = config.rate;
//   const areaMult = config.areaMult;
//   const extraValue = config.extraValue || 0;

//   // Calculate future living area
//   let futureLivingArea = livingArea;
//   if (method === "Add-On") futureLivingArea += config.addOnArea;
//   if (method === "ADU") futureLivingArea += config.aduArea;
//   if (method === "New Build") futureLivingArea = Math.round(livingArea * areaMult);

//   // Future value calculation
//   let futureValue;
//   let valuationMethod;

//   if (method === "Add-On") {
//     const targetBedrooms = Math.min(5, Math.round(prop.bedrooms || 0) + 1);
//     let bedStats = null;

//     if (bedroomAnalysis && bedroomAnalysis.length > 0) {
//       for (const b of bedroomAnalysis) {
//         if (b && b.bedrooms === targetBedrooms) {
//           bedStats = b;
//           break;
//         }
//       }
//     }

//     if (bedStats && bedStats.avgPrice) {
//       futureValue = bedStats.avgPrice;
//       valuationMethod = "comparable_plus_one_bedroom";
//     } else {
//       futureValue = Math.round(futureLivingArea * pricePerSqFt * impFactor);
//       valuationMethod = "fallback_sqft_calculation";
//     }
//   } else if (method === "ADU") {
//     const fixFlipValue = Math.round(livingArea * pricePerSqFt * 1.03);
//     futureValue = fixFlipValue + twoBedAvg;
//     valuationMethod = "fixflip_plus_twobedroom";
//   } else {
//     futureValue = Math.round(futureLivingArea * pricePerSqFt * impFactor);
//     valuationMethod = "sqft_calculation";
//   }

//   // Improvement costs
//   let impValue;
//   if (method === "ADU") {
//     impValue = 50000;
//   } else if (method === "Add-On") {
//     impValue = rate * config.addOnArea;
//   } else {
//     impValue = Math.round(futureLivingArea * rate);
//   }

//   // Loan calculations
//   const totalProjectCost = purchasePrice + impValue;
//   const maxLtcLoan = totalProjectCost * 0.90;
//   const maxArvLoan = futureValue * 0.75;
//   const loanAmount = Math.min(maxLtcLoan, maxArvLoan);
//   const downPayment = totalProjectCost - loanAmount;

//   // Payment calculations
//   const monthlyPayment = Math.round(loanAmount * (mtgRate / 12));
//   const loanPayments = Math.round(monthlyPayment * duration);

//   // Fee calculations
//   const loanFees = Math.min(Math.round(loanAmount * loanFeesRate), 20000);
//   const permitsFees = params.permitsFees || 5000;

//   // Tax and insurance
//   const annualTaxRate = 0.01;
//   const annualInsRate = 0.005;
//   const projectDuration = duration / 12;
//   const propertyTaxes = Math.round(totalProjectCost * annualTaxRate * projectDuration);
//   const propertyIns = Math.round(totalProjectCost * annualInsRate * projectDuration);

//   // Date calculations
//   const purchCloseDate = new Date();
//   purchCloseDate.setDate(purchCloseDate.getDate() + 21);
//   const saleCloseDate = new Date(purchCloseDate);
//   saleCloseDate.setMonth(saleCloseDate.getMonth() + duration);

//   // Final costs
//   const sellingCosts = Math.round(futureValue * salRate);
//   const totalCosts = purchasePrice +
//     impValue +
//     loanPayments +
//     loanFees +
//     permitsFees +
//     propertyTaxes +
//     propertyIns +
//     sellingCosts;

//   const grossReturn = futureValue - sellingCosts;
//   const netReturn = grossReturn - totalCosts;
//   const netROI = Math.round((netReturn / downPayment) * 100);
//   const cashNeeded = downPayment + permitsFees + propertyTaxes;

//   const result = {
//     ...prop,
//     method,
//     duration,
//     futureValue,
//     futureLivingArea,
//     impValue,
//     loanAmount: Math.round(loanAmount),
//     downPayment: Math.round(downPayment),
//     monthlyPayment,
//     loanPayments,
//     loanFees,
//     permitsFees,
//     propertyTaxes,
//     propertyIns,
//     propTaxIns: propertyTaxes + propertyIns,
//     sellingCosts,
//     totalCosts: Math.round(totalCosts),
//     grossReturn: Math.round(grossReturn),
//     netReturn: Math.round(netReturn),
//     netROI,
//     cashNeeded,
//     purchCloseDate: purchCloseDate.toISOString().split("T")[0],
//     saleCloseDate: saleCloseDate.toISOString().split("T")[0],
//     valuationMethod,
//     extraValue: Math.round(extraValue),
//     mtgRate,
//   };

//   console.log(`Strategy result for ${method}:`, {
//     netReturn: result.netReturn,
//     futureValue: result.futureValue,
//     totalCosts: result.totalCosts,
//   });

//   return result;
// }
