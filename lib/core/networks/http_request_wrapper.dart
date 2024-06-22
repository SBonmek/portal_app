import "dart:convert";

import "package:portal_app/core/config/server_addresses.dart";
import "package:portal_app/core/errors/exceptions.dart";
import "package:http/http.dart" as http;
import "package:portal_app/core/utils/secure_token_storage.dart";

abstract class HttpRequestWrapper {
  // GET Method
  Future<Map<String, dynamic>> loadPagedRestful({
    required String pagedRestful,
    required int id,
    String? template,
    String? customUrl,
  });
  Future<dynamic> listPagedRestful({
    required String pagedRestful,
    Map<String, dynamic>? filters,
    String? template,
    String? sort,
    String? order,
    int? offset,
    int? max,
    String? customUrl,
  });
  Future<Map<String, dynamic>> postWithEndPointAndData({
    required String endpoint,
    required Map<String, dynamic> data,
    bool isLoginRequest = false,
  });
}

class HttpRequestWrapperImpl implements HttpRequestWrapper {
  @override
  Future<Map<String, dynamic>> loadPagedRestful({
    required String pagedRestful,
    required int id,
    String? template,
    String? customUrl,
  }) async {
    String params = "";
    if (template != null) {
      params += "__template=$template";
    }

    Uri uri = Uri.parse(
      "${customUrl ?? ServerAddresses.restEnpoint}/$pagedRestful/$id?$params",
    );

    return await _getMethod(uri);
  }

  @override
  Future<dynamic> listPagedRestful({
    required String pagedRestful,
    Map<String, dynamic>? filters,
    String? template,
    String? sort,
    String? order,
    int? offset,
    int? max,
    String? customUrl,
  }) async {
    String params = "";
    if (template != null) {
      params += "__template=$template&";
    }
    if (filters != null) {
      params += _getFilters(filters);
    }
    if (sort != null) {
      params += "sort=$sort&";
    }
    if (order != null) {
      params += "order=$order&";
    }
    if (offset != null) {
      params += "offset=$offset&";
    }
    if (max != null) {
      params += "max=$max&";
    }

    Uri uri = Uri.parse(
      "${customUrl ?? ServerAddresses.restEnpoint}/$pagedRestful?$params",
    );

    return await _getMethod(uri);
  }

  @override
  Future<Map<String, dynamic>> postWithEndPointAndData({
    required String endpoint,
    required Map<String, dynamic> data,
    bool isLoginRequest = false,
  }) async {
    return await _postMethod(
      uri: Uri.parse(endpoint),
      data: data,
      isLoginRequest: isLoginRequest,
    );
  }

  Future<dynamic> _getMethod(Uri uri) async {
    final client = http.Client();
    final interceptorHeader = _getInterceptorHeader();

    try {
      final response = await client.get(uri, headers: {...interceptorHeader});
      final jsonResponse =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200) {
        return jsonResponse["data"] ?? jsonResponse;
      } else {
        throw ServerException(
          errorStatus: response.statusCode,
          message:
              "Status ${response.statusCode} : ${jsonResponse?["error"] != null ? jsonResponse["error"]["message"] : "request error"}",
        );
      }
    } catch (error) {
      throw error.toString();
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> _postMethod(
      {required Uri uri,
      required Map<String, dynamic> data,
      bool isLoginRequest = false}) async {
    final client = http.Client();
    final interceptorHeader = isLoginRequest ? {} : _getInterceptorHeader();

    try {
      final response = await client.post(
        uri,
        headers: {...interceptorHeader},
        body: json.encode(data),
      );
      final jsonResponse =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200) {
        return jsonResponse["data"] ?? jsonResponse;
      } else {
        throw ServerException(
          errorStatus: response.statusCode,
          message:
              "Status ${response.statusCode} : ${jsonResponse?["error"] != null ? jsonResponse["error"]["message"] : "request error"}",
        );
      }
    } catch (error) {
      throw error.toString();
    } finally {
      client.close();
    }
  }

  Map<String, dynamic> _getInterceptorHeader() {
    // final accessToken = await getToken();
    final accessToken = "";

    if (accessToken.isNotEmpty) {
      return {
        "Authorization": "Bearer DEV::sagolwong::ROLE_USER",
        "content-type": "application/json"
      };
    } else {
      return {"content-type": "application/json"};
    }
  }

  String _getFilters(filters) {
    String result = "";
    filters.forEach(
      (k, v) => {
        if (v != null) {result += "$k=$v&"}
      },
    );
    return result;
  }
}
