import 'package:flutter/material.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/core/networks/http_request_wrapper.dart';

// default data when request error
List<String> _mockNewsBanner1List =
    List.generate(10, (index) => "${index + 1}");
List<String> _mockNewsBanner2List = List.generate(1, (index) => "${index + 1}");

class NewsBannerRepository extends ChangeNotifier {
  NewsBannerRepository() {
    getNewsBannerList();
  }
  // temp data
  bool isLoaded = false;
  List<String> newsBannerList = [];

  // request api
  final HttpRequestWrapper _httpRequestWrapper = HttpRequestWrapperImpl();
  final String api = "newsBanner";

  Future<void> getNewsBannerList() async {
    try {
      isLoaded = false;
      notifyListeners();
      newsBannerList.clear();

      final results = await _httpRequestWrapper.listPagedRestful(
        pagedRestful: "v2/list",
        customUrl: "${ServerAddresses.serverUrl}$api",
      );

      if (results.isNotEmpty) {
        newsBannerList.addAll(
          results
              .map((result) => result["download_url"])
              .cast<String>()
              .toList(),
        );
      }
    } catch (error) {
      if (Storage.token.isNotEmpty) {
        newsBannerList.addAll(_mockNewsBanner2List);
      } else {
        newsBannerList.addAll(_mockNewsBanner1List);
      }
    }

    isLoaded = true;
    notifyListeners();
  }
}
