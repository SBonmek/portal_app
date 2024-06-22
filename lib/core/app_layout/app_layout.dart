import 'package:flutter/material.dart';
import 'package:portal_app/core/app_layout/sidebar.dart';
import 'package:portal_app/core/config/app_routes.dart';
import 'package:portal_app/features/data/repositories/authen_repository.dart';
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
    Provider.of<AuthenRepository>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
          actions: <Widget>[
            ...actions,
            Consumer<AuthenRepository>(
              builder: (_, authenState, __) {
                return Visibility(
                  visible: !authenState.isLogin,
                  child: IconButton(
                    icon: const Icon(
                      Icons.login_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => authenState.signInWithGoogle(context),
                  ),
                );
              },
            )
          ],
        ),
        body: body,
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        drawer: const Sidebar(),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
