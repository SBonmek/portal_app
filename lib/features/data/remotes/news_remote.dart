import 'package:portal_app/core/errors/exceptions.dart';
import 'package:portal_app/core/networks/http_request_wrapper.dart';
import 'package:portal_app/features/data/models/news_model.dart';

abstract class NewsRemote {
  Future<List<NewsModel>> getNewsList();
}

class NewsRemoteImpl implements NewsRemote {
  // request api
  final HttpRequestWrapper _httpRequestWrapper = HttpRequestWrapperImpl();
  final String api = "news";

  @override
  Future<List<NewsModel>> getNewsList() async {
    try {
      List<NewsModel> newsList = [];
      final results =
          await _httpRequestWrapper.listPagedRestful(pagedRestful: api);

      if (results.isNotEmpty) {
        newsList.addAll(
          results
              .map((result) => NewsModel.fromJson(result))
              .cast<NewsModel>()
              .toList(),
        );
      }

      return newsList;
    } on ServerException catch (_) {
      rethrow;
    } catch (error) {
      throw ServerException(message: "GetNewsList | ${error.toString()}");
    }
  }
}
