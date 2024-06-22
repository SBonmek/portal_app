import 'package:flutter/material.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/core/networks/http_request_wrapper.dart';

// default data when request error
List<String> _mockPortalList = List.generate(20, (index) => "${index + 1}");

class PortalRepository extends ChangeNotifier {
  PortalRepository() {
    getPortalList();
  }
  // temp data
  bool isLoaded = false;
  List<String> portalList = [];

  // request api
  final HttpRequestWrapper _httpRequestWrapper = HttpRequestWrapperImpl();
  final String api = "picsum.photos";

  Future<void> getPortalList() async {
    try {
      isLoaded = false;
      notifyListeners();
      portalList.clear();

      final results = await _httpRequestWrapper.listPagedRestful(
        pagedRestful: "v2/list",
        customUrl: "${ServerAddresses.serverUrl}$api",
      );

      if (results.isNotEmpty) {
        portalList.addAll(
          results
              .map((result) => result["download_url"])
              .cast<String>()
              .toList(),
        );
      }
    } catch (error) {
      portalList = _mockPortalList;
    }

    isLoaded = true;
    notifyListeners();
  }
}
