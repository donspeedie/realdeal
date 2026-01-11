const axios = require("axios").default;
const qs = require("qs");

/// Start Stripe APIs Group Code

function createStripeAPIsGroup() {
  const stripeKey = process.env.STRIPE_SECRET_KEY;
  if (!stripeKey) {
    throw new Error('STRIPE_SECRET_KEY environment variable is required');
  }
  return {
    baseUrl: `https://api.stripe.com/v1`,
    headers: {
      Authorization: `Bearer ${stripeKey}`,
      "Content-Type": `application/x-www-form-urlencoded`,
    },
  };
}

async function _listAllProductsCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }

  const stripeAPIsGroup = createStripeAPIsGroup();

  var url = `${stripeAPIsGroup.baseUrl}/products`;
  var headers = {
    Authorization: stripeAPIsGroup.headers.Authorization,
    "Content-Type": `application/x-www-form-urlencoded`,
  };
  var params = {};
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _getPriceCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }
  var priceId = ffVariables["priceId"];
  const stripeAPIsGroup = createStripeAPIsGroup();

  var url = `${stripeAPIsGroup.baseUrl}/prices/${priceId}`;
  var headers = {
    Authorization: stripeAPIsGroup.headers.Authorization,
    "Content-Type": `application/x-www-form-urlencoded`,
  };
  var params = {};
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _createCheckoutSessionCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }
  var successUrl = ffVariables["successUrl"];
  var lineItems0PriceId = ffVariables["lineItems0PriceId"];
  var lineItems0Quantity = ffVariables["lineItems0Quantity"];
  var customer = ffVariables["customer"];
  var token = ffVariables["token"];
  const stripeAPIsGroup = createStripeAPIsGroup();

  var url = `${stripeAPIsGroup.baseUrl}/checkout/sessions`;
  var headers = {
    Authorization: stripeAPIsGroup.headers.Authorization,
    "Content-Type": `application/x-www-form-urlencoded`,
  };
  var params = {
    success_url: successUrl,
    "line_items[0][price]": lineItems0PriceId,
    "line_items[0][quantity]": lineItems0Quantity,
    mode: `payment`,
    customer: customer,
    "metadata[token]": token,
  };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "X_WWW_FORM_URL_ENCODED",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _getCheckoutSessionCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }

  const stripeAPIsGroup = createStripeAPIsGroup();

  var url = `${stripeAPIsGroup.baseUrl}/checkout/sessions`;
  var headers = {
    Authorization: stripeAPIsGroup.headers.Authorization,
    "Content-Type": `application/x-www-form-urlencoded`,
  };
  var params = {};
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}

async function _createCustomerCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }
  var email = ffVariables["email"];
  const stripeAPIsGroup = createStripeAPIsGroup();

  var url = `${stripeAPIsGroup.baseUrl}/customers`;
  var headers = {
    Authorization: stripeAPIsGroup.headers.Authorization,
    "Content-Type": `application/x-www-form-urlencoded`,
  };
  var params = { email: email };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "X_WWW_FORM_URL_ENCODED",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

/// End Stripe APIs Group Code

/// Helper functions to route to the appropriate API Call.

async function makeApiCall(context, data) {
  var callName = data["callName"] || "";
  var variables = data["variables"] || {};

  const callMap = {
    ListAllProductsCall: _listAllProductsCall,
    GetPriceCall: _getPriceCall,
    CreateCheckoutSessionCall: _createCheckoutSessionCall,
    GetCheckoutSessionCall: _getCheckoutSessionCall,
    CreateCustomerCall: _createCustomerCall,
  };

  if (!(callName in callMap)) {
    return {
      statusCode: 400,
      error: `API Call "${callName}" not defined as private API.`,
    };
  }

  var apiCall = callMap[callName];
  var response = await apiCall(context, variables);
  return response;
}

async function makeApiRequest({
  method,
  url,
  headers,
  params,
  body,
  returnBody,
  isStreamingApi,
}) {
  return axios
    .request({
      method: method,
      url: url,
      headers: headers,
      params: params,
      responseType: isStreamingApi ? "stream" : "json",
      ...(body && { data: body }),
    })
    .then((response) => {
      return {
        statusCode: response.status,
        headers: response.headers,
        ...(returnBody && { body: response.data }),
        isStreamingApi: isStreamingApi,
      };
    })
    .catch(function (error) {
      return {
        statusCode: error.response.status,
        headers: error.response.headers,
        ...(returnBody && { body: error.response.data }),
        error: error.message,
      };
    });
}

const _unauthenticatedResponse = {
  statusCode: 401,
  headers: {},
  error: "API call requires authentication",
};

function createBody({ headers, params, body, bodyType }) {
  switch (bodyType) {
    case "JSON":
      headers["Content-Type"] = "application/json";
      return body;
    case "TEXT":
      headers["Content-Type"] = "text/plain";
      return body;
    case "X_WWW_FORM_URL_ENCODED":
      headers["Content-Type"] = "application/x-www-form-urlencoded";
      return qs.stringify(params);
  }
}
function escapeStringForJson(val) {
  if (typeof val !== "string") {
    return val;
  }
  return val
    .replace(/[\\]/g, "\\\\")
    .replace(/["]/g, '\\"')
    .replace(/[\n]/g, "\\n")
    .replace(/[\t]/g, "\\t");
}

module.exports = { makeApiCall };
