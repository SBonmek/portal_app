import 'package:flutter/material.dart';
import 'package:portal_app/core/app_layout/sidebar.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/features/data/repositories/auth_repository.dart';
import 'package:provider/provider.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget> actions;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  AppLayout({
    required this.body,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.title = "Portal App",
    this.actions = const [],
    super.key,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthRepository>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: AppColors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
          actions: <Widget>[
            ...actions,
            Consumer<AuthRepository>(
              builder: (_, authRepo, __) {
                return Visibility(
                  visible: !authRepo.isSignedIn,
                  child: IconButton(
                    icon: const Icon(Icons.login_rounded),
                    onPressed: () => authRepo.signIn(context),
                  ),
                );
              },
            )
          ],
        ),
        body: body,
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        drawer: Sidebar(context),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
