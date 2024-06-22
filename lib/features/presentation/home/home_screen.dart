import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:portal_app/core/app_layout/app_layout.dart';
import 'package:portal_app/core/config/app_routes.dart';
import 'package:portal_app/features/data/repositories/authen_repository.dart';
import 'package:portal_app/features/data/repositories/news_banner_repository.dart';
import 'package:portal_app/features/data/repositories/web_view_repository.dart';
import 'package:portal_app/features/presentation/web_view/web_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsBannerRepository _newsBannerRepository = NewsBannerRepository();
  final WebViewRepository _webViewRepository = WebViewRepository();

  @override
  Widget build(BuildContext context) {
    final authenState = Provider.of<AuthenRepository>(context);
    return AppLayout(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Visibility(
          visible: authenState.isChecked,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView(
            children: <Widget>[
              FutureBuilder(
                future: _newsBannerRepository.getNewsBannerImageUrlList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<String> newsBannerList = [];
                    if ((snapshot.data ?? []).isNotEmpty) {
                      newsBannerList = snapshot.data!;
                    } else {
                      newsBannerList =
                          List.generate(10, (index) => "${index + 1}");
                    }

                    return CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 4 / 2,
                        autoPlay: true,
                      ),
                      items: newsBannerList
                          .map(
                            (newsBanner) => Container(
                              decoration: BoxDecoration(
                                color: Color(Random().nextInt(0xffffffff)),
                              ),
                              child: Center(child: Text(newsBanner)),
                            ),
                          )
                          .cast<Widget>()
                          .toList(),
                    );
                  } else {
                    return const AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
              FutureBuilder(
                future: _webViewRepository.getWebViewImageUrlList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<String> linkList = [];
                    if ((snapshot.data ?? []).isNotEmpty) {
                      linkList = snapshot.data!;
                    } else {
                      linkList = List.generate(20, (index) => "${index + 1}");
                    }

                    return GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      children: linkList
                          .map((link) => InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.webView,
                                    arguments: WebViewParameter(
                                      webUri: "https://flutter.dev",
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(Random().nextInt(0xffffffff)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(child: Text(link)),
                                ),
                              ))
                          .cast<Widget>()
                          .toList(),
                    );
                  } else {
                    return const AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
