import 'dart:convert';
import 'package:app_vendedores/core/backend/api_requests/_/api_manager.dart';
import 'package:flutter/foundation.dart';

class ProductsGroup {
  static String getBaseUrl({
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) =>
      'https://us-central1-$enviroment.cloudfunctions.net/appSeller/';
  static Map<String, String> headers = {
    'Authorization': 'Bearer [token]',
  };

  static GetListStorageByProductCall getListStorageByProductCall =
      GetListStorageByProductCall();
  static CreateOrderClientCall createOrderClientCall = CreateOrderClientCall();
}

class GetListStorageByProductCall {
  Future<ApiCallResponse> call({
    String? codprecio = '',
    String? codproduc = '',
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = ProductsGroup.getBaseUrl(
      token: token,
      enviroment: enviroment,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'getListStorageByProduct',
      apiUrl:
          '${baseUrl}products/getListStorageByProduct/$codprecio/$codproduc',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer $token',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateOrderClientCall {
  Future<ApiCallResponse> call({
    String? nit = '',
    dynamic listProductsJson,
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = ProductsGroup.getBaseUrl(
      token: token,
      enviroment: enviroment,
    );

    final listProducts = _serializeJson(listProductsJson, true);
    final ffApiRequestBody = '''
{
  "nit": "${escapeStringForJson(nit)}",
  "listProducts": $listProducts
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createOrderClient',
      apiUrl: '${baseUrl}products/createOrderClient',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer $token',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Products Group Code

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
  return item;
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
