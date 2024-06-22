import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:portal_app/core/app_layout/app_layout.dart';
import 'package:portal_app/core/config/app_routes.dart';
import 'package:portal_app/features/data/repositories/auth_repository.dart';
import 'package:portal_app/features/data/repositories/news_banner_repository.dart';
import 'package:portal_app/features/data/repositories/portal_repository.dart';
import 'package:portal_app/features/presentation/web_view/web_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authRepo = Provider.of<AuthRepository>(context);
    Provider.of<NewsBannerRepository>(context, listen: false);
    Provider.of<PortalRepository>(context, listen: false);
    return AppLayout(
      body: Visibility(
        visible: authRepo.isLoaded,
        replacement: const Center(child: CircularProgressIndicator()),
        child: ListView(
          children: <Widget>[
            Consumer<NewsBannerRepository>(
              builder: (_, newsBannerRepo, __) {
                if (newsBannerRepo.isLoaded) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 4 / 2,
                      autoPlay: true,
                    ),
                    items: newsBannerRepo.newsBannerList
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
            Consumer<PortalRepository>(
              builder: (_, portalRepo, __) {
                if (portalRepo.isLoaded) {
                  return GridView.count(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: portalRepo.portalList
                        .map((portal) => InkWell(
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
                                child: Center(child: Text(portal)),
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
            ),
          ],
        ),
      ),
    );
  }
}
