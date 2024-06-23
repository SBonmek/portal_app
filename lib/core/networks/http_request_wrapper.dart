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
  });
  Future<dynamic> listPagedRestful({
    required String pagedRestful,
    Map<String, dynamic>? filters,
    String? template,
    String? sort,
    String? order,
    int? offset,
    int? max,
  });
}

class HttpRequestWrapperImpl implements HttpRequestWrapper {
  @override
  Future<Map<String, dynamic>> loadPagedRestful({
    required String pagedRestful,
    required int id,
    String? template,
  }) async {
    String params = "";
    if (template != null) {
      params += "__template=$template";
    }

    Uri uri = Uri.parse(
      "${ServerAddresses.serverUrl}/$pagedRestful/$id?$params",
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
      "${ServerAddresses.serverUrl}/$pagedRestful?$params",
    );

    return await _getMethod(uri);
  }

  Future<dynamic> _getMethod(Uri uri) async {
    final client = http.Client();
    final interceptorHeader = await _getInterceptorHeader();

    try {
      final response = await client.get(uri, headers: {...interceptorHeader});
      final jsonResponse =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200) {
        return jsonResponse;
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

  Future<Map<String, dynamic>> _getInterceptorHeader() async {
    final token = await getToken();

    if (token != null) {
      return {
        "Authorization": "Bearer ${token["accessToken"]}",
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
