import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/core/errors/exceptions.dart';
import 'package:portal_app/core/networks/http_request_wrapper.dart';

class WebViewRepository {
  final HttpRequestWrapper _httpRequestWrapper = HttpRequestWrapperImpl();
  final String api = "picsum.photos";

  Future<List<String>> getWebViewImageUrlList() async {
    try {
      final results = await _httpRequestWrapper.listPagedRestful(
        pagedRestful: "v2/list",
        customUrl: "${ServerAddresses.serverUrl}$api",
      );

      if (results.isNotEmpty) {
        return results
            .map((result) => result["download_url"])
            .cast<String>()
            .toList();
      } else {
        return [];
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (error) {
      throw ServerException(
        message: "GetWebViewImageUrlList | ${error.toString()}",
      );
    }
  }
}
