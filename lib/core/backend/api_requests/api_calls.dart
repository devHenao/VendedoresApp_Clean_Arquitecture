import 'dart:convert';
import 'package:app_vendedores/core/backend/api_requests/_/api_manager.dart';

import 'package:flutter/foundation.dart';

/// Start Auth Group Code

class AuthGroup {
  static String getBaseUrl({
    String? enviroment = 'prod-appseller-ofima',
  }) =>
      'https://us-central1-$enviroment.cloudfunctions.net/appAuthSeller/';
  static Map<String, String> headers = {};
  static LoginSellerCall loginSellerCall = LoginSellerCall();
  static RecoveryPasswordCall recoveryPasswordCall = RecoveryPasswordCall();
}

class LoginSellerCall {
  Future<ApiCallResponse> call({
    String? identification = '',
    String? email = '',
    String? password = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = AuthGroup.getBaseUrl(
      enviroment: enviroment,
    );

    final ffApiRequestBody = '''
{
  "identification": "$identification",
  "email": "$email",
  "password": "$password"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'loginSeller',
      apiUrl: '${baseUrl}loginSeller',
      callType: ApiCallType.POST,
      headers: {},
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

class RecoveryPasswordCall {
  Future<ApiCallResponse> call({
    String? nit = '',
    String? email = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = AuthGroup.getBaseUrl(
      enviroment: enviroment,
    );

    final ffApiRequestBody = '''
{
  "identification": "${escapeStringForJson(nit)}",
  "email": "${escapeStringForJson(email)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RecoveryPassword',
      apiUrl: '${baseUrl}sendEmailRecoveryPassword',
      callType: ApiCallType.POST,
      headers: {},
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

/// End Auth Group Code

/// Start Clients Group Code

class ClientsGroup {
  static String getBaseUrl({
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) =>
      'https://us-central1-$enviroment.cloudfunctions.net/appSeller/';
  static Map<String, String> headers = {
    'Authorization': 'Bearer [token]',
  };
  static ListClientByVendenCall listClientByVendenCall =
      ListClientByVendenCall();
  static UpdateClientCall updateClientCall = UpdateClientCall();
}

class ListClientByVendenCall {
  Future<ApiCallResponse> call({
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = ClientsGroup.getBaseUrl(
      token: token,
      enviroment: enviroment,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ListClientByVenden',
      apiUrl: '${baseUrl}clients/getListClientByVenden',
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

class UpdateClientCall {
  Future<ApiCallResponse> call({
    dynamic dataJson,
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = ClientsGroup.getBaseUrl(
      token: token,
      enviroment: enviroment,
    );

    final data = _serializeJson(dataJson);
    final ffApiRequestBody = ''' $data''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateClient',
      apiUrl: '${baseUrl}clients/updateClientByNit',
      callType: ApiCallType.PUT,
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

/// End Clients Group Code

/// Start Maestras Group Code

class MaestrasGroup {
  static String getBaseUrl({
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) =>
      'https://us-central1-$enviroment.cloudfunctions.net/appMaster/';
  static Map<String, String> headers = {
    'Authorization': 'Bearer [token]',
  };
  static GetListDeptoCall getListDeptoCall = GetListDeptoCall();
  static ListCitiesCall listCitiesCall = ListCitiesCall();
}

class GetListDeptoCall {
  Future<ApiCallResponse> call({
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = MaestrasGroup.getBaseUrl(
      token: token,
      enviroment: enviroment,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'getListDepto',
      apiUrl: '${baseUrl}getListDepto',
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

class ListCitiesCall {
  Future<ApiCallResponse> call({
    String? deparment = '',
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = MaestrasGroup.getBaseUrl(
      token: token,
      enviroment: enviroment,
    );

    final ffApiRequestBody = '''
{
  "nomdpto": "${escapeStringForJson(deparment)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ListCities',
      apiUrl: '${baseUrl}getListCities',
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

/// End Maestras Group Code

/// Start Products Group Code

class ProductsGroup {
  static String getBaseUrl({
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) =>
      'https://us-central1-$enviroment.cloudfunctions.net/appSeller/';
  static Map<String, String> headers = {
    'Authorization': 'Bearer [token]',
  };
  static PostListProductByCodPrecioCall postListProductByCodPrecioCall =
      PostListProductByCodPrecioCall();
  static GetListStorageByProductCall getListStorageByProductCall =
      GetListStorageByProductCall();
  static CreateOrderClientCall createOrderClientCall = CreateOrderClientCall();
}

class PostListProductByCodPrecioCall {
  Future<ApiCallResponse> call({
    int? pageNumber,
    int? pageSize,
    String? filter = '',
    String? codprecio = '',
    String? token = '',
    String? enviroment = 'prod-appseller-ofima',
  }) async {
    final baseUrl = ProductsGroup.getBaseUrl(
      token: token,
      enviroment: enviroment,
    );

    final ffApiRequestBody = '''
{
  "pageNumber": $pageNumber,
  "pageSize": $pageSize,
  "filters": [
    {
      "type": "like",
      "field": "descripcio",
      "valueFilter": "${escapeStringForJson(filter)}"
    },
    {
      "type": "like",
      "field": "codproduc",
      "valueFilter": "${escapeStringForJson(filter)}"
    },
    {
      "type": "==",
      "field": "codbarras",
      "valueFilter": "${escapeStringForJson(filter)}"
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'postListProductByCodPrecio',
      apiUrl: '${baseUrl}products/getListProductByCodPrecio/$codprecio',
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
