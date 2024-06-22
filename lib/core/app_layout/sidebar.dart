import 'package:flutter/material.dart';
import 'package:portal_app/core/config/app_routes.dart';
import 'package:portal_app/features/data/repositories/authen_repository.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthenRepository>(context, listen: false);
    return Drawer(
      child: Consumer<AuthenRepository>(
        builder: (_, authenState, __) {
          return Column(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  child: Visibility(
                    visible: authenState.isLogin,
                    replacement: const Icon(
                      Icons.person,
                      size: 80,
                    ),
                    child: Image.network(
                      authenState.userInfoes?.photoUrl ?? "",
                      errorBuilder: (context, error, stackTrace) => Text(
                        authenState.userInfoes?.displayName != null
                            ? authenState.userInfoes!.displayName!
                                .substring(0, 1)
                            : "N/A",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: authenState.isLogin,
                child: Text(
                  authenState.userInfoes?.displayName ?? "N/A",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Visibility(
                visible: authenState.isLogin,
                replacement: Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      authenState.signInWithGoogle(context);
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: Text(
                      "Login",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () => authenState.signOut(),
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(
                      "Logout",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
