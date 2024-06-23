import 'package:flutter/material.dart';
import 'package:portal_app/features/data/models/news_model.dart';
import 'package:portal_app/features/data/remotes/news_remote.dart';

class NewsRepository extends ChangeNotifier {
  NewsRepository() {
    getNewsList();
  }
  // temp data
  bool isLoaded = false;
  List<NewsModel> newsList = [];

  final NewsRemote _newsRemote = NewsRemoteImpl();

  Future<void> getNewsList() async {
    try {
      isLoaded = false;
      notifyListeners();
      newsList.clear();

      newsList = await _newsRemote.getNewsList();
      
    } catch (error) {
      print(error);
      newsList.clear();
    }

    isLoaded = true;
    notifyListeners();
  }
}
