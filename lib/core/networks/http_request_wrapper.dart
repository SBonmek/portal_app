import "package:dio/dio.dart";
import "package:portal_app/core/config/server_addresses.dart";
import "package:portal_app/core/errors/exceptions.dart";
import "package:portal_app/core/utils/secure_token_storage.dart";
import "package:portal_app/features/data/models/token_model.dart";

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

    return await _getMethod(
      "${ServerAddresses.serverUrl}/$pagedRestful/$id?$params",
    );
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

    return await _getMethod(
      "${ServerAddresses.serverUrl}/$pagedRestful?$params",
    );
  }

  Future<dynamic> _getMethod(String uri) async {
    final Dio dio = Dio();
    final interceptorHeader = await _getInterceptorHeader();

    try {
      final response = await dio.get(
        uri,
        options: Options(headers: {...interceptorHeader}),
      );
      final jsonResponse = response.data.isNotEmpty ? response.data : {};

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
      dio.close();
    }
  }

  Future<Map<String, dynamic>> _getInterceptorHeader() async {
    TokenModel? token = await getToken();

    if (token != null) {
      return {
        "Authorization": "Bearer ${token.accessToken}",
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
