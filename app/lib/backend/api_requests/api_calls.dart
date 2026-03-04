import 'dart:convert';
import '../cloud_functions/cloud_functions.dart';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateStripeApiCalls';

/// Start Firebase Cloud Functions Group Code

class FirebaseCloudFunctionsGroup {
  static String getBaseUrl() =>
      'https://us-west1-habu-1gxak2.cloudfunctions.net/';
  static Map<String, String> headers = {};
  static CloudCalcsCall cloudCalcsCall = CloudCalcsCall();
}

class CloudCalcsCall {
  Future<ApiCallResponse> call({
    String? location = 'Sacremento',
    int? minPrice = 1000,
    int? maxPrice = 750000,
    String? propertyType = 'SINGLE_FAMILY',
    int? daysOn = 7,
    int? lotSizeMin = 3000,
    double? dwnPmtRate,
    double? salRate,
    double? financingRate,
    double? taxInsRate,
    int? fnfImpRate,
    int? aduImpRate,
    int? newImpRate,
    double? fnfImpFactor,
    int? twoBedAvgValue,
    int? twoBdrmAduCost,
    int? newFutValSalperSFRate,
    int? oneBdrmMarketValue,
    double? loanFeesRate,
    int? propertyIns,
    int? propertyTaxes,
    int? permitsFees,
    int? fixnflipDuration,
    int? addOnDuration,
    int? aduDuration,
    int? newDuration,
    int? newBuildRate,
    bool? isInterestOnly,
    int? addOnSqftRate,
    double? addOnImpFactor,
    int? addOnBeds,
    int? addOnBaths,
    int? aduBeds,
    int? aduBaths,
    int? aduArea,
    int? newArea,
    int? newBeds,
    int? newBaths,
    String? statusType = '',
    int? addOnArea,
    int? addOnRate,
    String? address = '',
    double? aduImpFactor,
    int? bathrooms,
    int? bedrooms,
    int? comp1LvgArea,
    int? comp1Price,
    int? comp2LvgArea,
    int? comp2Price,
    int? comp3LvgArea,
    int? comp3Price,
    String? detailUrl = '',
    String? imgSrc = '',
    double? latitude,
    double? longitude,
    double? newImpFactor,
    int? price,
    int? yearBuilt,
    int? livingArea,
    String? listingStatus = '',
    String? description = '',
    int? maintenanceRate,
    int? operatingExpenseRate,
    double? propertyManagementFeeRate,
    int? utilities,
    double? vacanyRate,
    String? method = '',
  }) async {
    final baseUrl = FirebaseCloudFunctionsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "description": "${escapeStringForJson(description)}",
  "price": ${price},
  "addOnArea": ${addOnArea},
  "addOnBaths": ${addOnBaths},
  "addOnBeds": ${addOnBeds},
  "addOnDuration": ${addOnDuration},
  "addOnImpFactor": ${addOnImpFactor},
  "addOnRate": ${addOnRate},
  "addOnSqftRate": ${addOnSqftRate},
  "address": "${escapeStringForJson(address)}",
  "aduArea": ${aduArea},
  "aduBaths": ${aduBaths},
  "aduBeds": ${aduBeds},
  "aduDuration": ${aduDuration},
  "aduImpFactor": ${aduImpFactor},
  "aduImpRate": ${aduImpRate},
  "bathrooms": ${bathrooms},
  "bedrooms": ${bedrooms},
  "comp1LvgArea": ${comp1LvgArea},
  "comp1Price": ${comp1Price},
  "comp2LvgArea": ${comp2LvgArea},
  "comp2Price": ${comp2Price},
  "comp3LvgArea": ${comp3LvgArea},
  "comp3Price": ${comp3Price},
  "daysOn": ${daysOn},
  "detailUrl": "${escapeStringForJson(detailUrl)}",
  "dwnPmtRate": ${dwnPmtRate},
  "financingRate": ${financingRate},
  "fixnflipDuration": ${fixnflipDuration},
  "fnfImpFactor": ${fnfImpFactor},
  "fnfImpRate": ${fnfImpRate},
  "imgSrc": "${escapeStringForJson(imgSrc)}",
  "isInterestOnly": ${isInterestOnly},
  "latitude": ${latitude},
  "listingStatus": "${escapeStringForJson(listingStatus)}",
  "livingArea": ${livingArea},
  "loanFeesRate": ${loanFeesRate},
  "location": "${escapeStringForJson(location)}",
  "longitude": ${longitude},
  "lotSizeMin": ${lotSizeMin},
  "maxPrice": ${maxPrice},
  "minPrice": ${minPrice},
  "method": "${escapeStringForJson(method)}",
  "newArea": ${newArea},
  "newBaths": ${newBaths},
  "newBeds": ${newBeds},
  "newBuildRate": ${newBuildRate},
  "newDuration": ${newDuration},
  "newFutValSalperSFRate": ${newFutValSalperSFRate},
  "newImpFactor": ${newImpFactor},
  "newImpRate": ${newImpRate},
  "oneBdrmMarketValue": ${oneBdrmMarketValue},
  "permitsFees": ${permitsFees},
  "propertyIns": ${propertyIns},
  "propertyTaxes": ${propertyTaxes},
  "propertyType": "${escapeStringForJson(propertyType)}",
  "salRate": ${salRate},
  "statusType": "${escapeStringForJson(statusType)}",
  "taxInsRate": ${taxInsRate},
  "twoBdrmAduCost": ${twoBdrmAduCost},
  "twoBedAvgValue": ${twoBedAvgValue},
  "yearBuilt": ${yearBuilt},
  "maintenanceRate": ${maintenanceRate},
  "operatingExpenseRate": ${operatingExpenseRate},
  "propertyManagementFeeRate": ${propertyManagementFeeRate},
  "utilities": ${utilities},
  "vacanyRate": ${vacanyRate}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CloudCalcs',
      apiUrl: '${baseUrl}/cloudCalcs',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: true,
      alwaysAllowBody: false,
    );
  }

  String? address(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.address''',
      ));
  int? avgPricePerArea(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.avgPricePerArea''',
      ));
  int? bathrooms(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.bathrooms''',
      ));
  int? bedrooms(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.bedrooms''',
      ));
  int? cashNeeded(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.cashNeeded''',
      ));
  String? detailUrl(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.detailUrl''',
      ));
  int? downPayment(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.downPayment''',
      ));
  int? durationMonths(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.durationMonths''',
      ));
  int? futureValue(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.futureValue''',
      ));
  int? grossReturn(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.grossReturn''',
      ));
  String? imgSrc(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.imgSrc''',
      ));
  int? impValue(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.impValue''',
      ));
  dynamic latlng(dynamic response) => getJsonField(
        response,
        r'''$.latlng''',
      );
  double? latlnglatitude(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.latlng.latitude''',
      ));
  double? latlnglongitude(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.latlng.longitude''',
      ));
  int? livingArea(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.livingArea''',
      ));
  int? loanFees(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.loanFees''',
      ));
  String? method(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.method''',
      ));
  int? mortgage(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.mortgage''',
      ));
  int? netReturn(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.netReturn''',
      ));
  int? oneBdrmMarketValue(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.oneBdrmMarketValue''',
      ));
  int? netROI(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.netROI''',
      ));
  int? price(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.price''',
      ));
  int? pricePerSqft(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.pricePerSqft''',
      ));
  int? taxInsRate(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.taxInsRate''',
      ));
  int? total(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.total''',
      ));
  int? totalCost(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.totalCosts''',
      ));
  int? twoBedAvgValue(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.twoBedAvgValue''',
      ));
  int? zestimate(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.zestimate''',
      ));
  String? zpid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.zpid''',
      ));
  List? compBreakdown(dynamic response) => getJsonField(
        response,
        r'''$.compBreakdown''',
        true,
      ) as List?;
  List<int>? compBreakdownprice(dynamic response) => (getJsonField(
        response,
        r'''$.compBreakdown[:].price''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<int>? compBreakdownarea(dynamic response) => (getJsonField(
        response,
        r'''$.compBreakdown[:].area''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<int>? compBreakdownpricePerSf(dynamic response) => (getJsonField(
        response,
        r'''$.compBreakdown[:].pricePerSf''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<bool>? compBreakdownincluded(dynamic response) => (getJsonField(
        response,
        r'''$.compBreakdown[:].included''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  List? twoBedCompBreakdown(dynamic response) => getJsonField(
        response,
        r'''$.twoBedCompBreakdown''',
        true,
      ) as List?;
  dynamic descriptionAnalysis(dynamic response) => getJsonField(
        response,
        r'''$.descriptionAnalysis''',
      );
  bool? descriptionAnalysishasKeywords(dynamic response) =>
      castToType<bool>(getJsonField(
        response,
        r'''$.descriptionAnalysis.hasKeywords''',
      ));
  List? descriptionAnalysiskeywords(dynamic response) => getJsonField(
        response,
        r'''$.descriptionAnalysis.keywords''',
        true,
      ) as List?;
  dynamic loanPayments(dynamic response) => getJsonField(
        response,
        r'''$.loanPayments''',
      );
  int? monthlyPayment(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.monthlyPayment''',
      ));
  int? propTaxIns(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.propTaxIns''',
      ));
  int? permitsFees(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.permitsFees''',
      ));
  dynamic yearBuilt(dynamic response) => getJsonField(
        response,
        r'''$.yearBuilt''',
      );
  int? loanAmount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.loanAmount''',
      ));
  int? sellingCosts(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.sellingCosts''',
      ));
  String? purchCloseDate(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.purchCloseDate''',
      ));
  String? saleCloseDate(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.saleCloseDate''',
      ));
  int? propertyIns(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.propertyIns''',
      ));
  double? mtgRate(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.mtgRate''',
      ));
  int? lotAreaValue(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.lotAreaValue''',
      ));
  int? propertyTaxes(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.propertyTaxes''',
      ));
  dynamic stories(dynamic response) => getJsonField(
        response,
        r'''$.stories''',
      );
  dynamic totalReturn(dynamic response) => getJsonField(
        response,
        r'''$.totalReturn''',
      );
}

/// End Firebase Cloud Functions Group Code

/// Start Stripe APIs Group Code

class StripeAPIsGroup {
  static ListAllProductsCall listAllProductsCall = ListAllProductsCall();
  static GetPriceCall getPriceCall = GetPriceCall();
  static CreateCheckoutSessionCall createCheckoutSessionCall =
      CreateCheckoutSessionCall();
  static GetCheckoutSessionCall getCheckoutSessionCall =
      GetCheckoutSessionCall();
  static CreateCustomerCall createCustomerCall = CreateCustomerCall();
}

class ListAllProductsCall {
  Future<ApiCallResponse> call() async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'ListAllProductsCall',
        'variables': {},
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class GetPriceCall {
  Future<ApiCallResponse> call({
    String? priceId = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'GetPriceCall',
        'variables': {
          'priceId': priceId,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  int? unitAmout(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.unit_amount''',
      ));
}

class CreateCheckoutSessionCall {
  Future<ApiCallResponse> call({
    String? successUrl = '',
    String? lineItems0PriceId = '',
    int? lineItems0Quantity,
    String? customer = '',
    int? token,
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CreateCheckoutSessionCall',
        'variables': {
          'successUrl': successUrl,
          'lineItems0PriceId': lineItems0PriceId,
          'lineItems0Quantity': lineItems0Quantity,
          'customer': customer,
          'token': token,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  String? checkoutId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.id''',
      ));
  String? checkoutUrl(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.url''',
      ));
}

class GetCheckoutSessionCall {
  Future<ApiCallResponse> call() async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'GetCheckoutSessionCall',
        'variables': {},
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }
}

class CreateCustomerCall {
  Future<ApiCallResponse> call({
    String? email = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CreateCustomerCall',
        'variables': {
          'email': email,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  String? id(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.id''',
      ));
}

/// End Stripe APIs Group Code


class GETZestimateCall {
  static Future<ApiCallResponse> call({
    String? zpid = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'GET zestimate',
      apiUrl:
          'https://us-west1-habu-1gxak2.cloudfunctions.net/propertyZestimate',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'zpid': zpid,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? zestimate(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.value''',
      ));
}

class GETPptyDetailsCall {
  static Future<ApiCallResponse> call({
    String? zpid = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'GET PptyDetails',
      apiUrl:
          'https://us-west1-habu-1gxak2.cloudfunctions.net/propertyDetails',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'zpid': zpid,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? yearBuilt(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.yearBuilt''',
      ));
  static String? description(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.description''',
      ));
}


class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
