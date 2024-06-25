import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:portal_app/core/app_layout/app_layout.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/core/utils/show_error_snack_bar.dart';
import 'package:portal_app/features/data/repositories/auth_repository.dart';
import 'package:portal_app/features/data/repositories/news_repository.dart';
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
    return AppLayout(
      body: Visibility(
        visible: authRepo.isLoaded,
        replacement: const Center(child: CircularProgressIndicator()),
        child: ListView(
          children: <Widget>[
            Consumer<NewsRepository>(
              builder: (_, newsRepo, __) {
                if (newsRepo.isLoaded) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 5 / 2,
                      autoPlay: true,
                    ),
                    items: newsRepo.newsList
                        .map(
                          (news) => Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              image: DecorationImage(
                                image: NetworkImage(
                                  news.imageUrl,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                        .cast<Widget>()
                        .toList(),
                  );
                } else {
                  return const AspectRatio(
                    aspectRatio: 5 / 2,
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
                        .map(
                          (portal) => InkWell(
                            onTap: () {
                              if (portal.link != null) {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.webView,
                                  arguments: WebViewParameter(
                                    webUri: portal.link!,
                                  ),
                                );
                              } else {
                                showErrorSnackBar(
                                  context,
                                  errorText: "Don't have link.",
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: AppColors.darkGray.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(
                                    portal.imageUrl,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
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
          ],
        ),
      ),
    );
  }
}
