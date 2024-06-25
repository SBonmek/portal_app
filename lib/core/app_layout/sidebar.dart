import 'package:flutter/material.dart';
import 'package:portal_app/core/config/config.dart';
import 'package:portal_app/features/data/repositories/auth_repository.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  final BuildContext appLayoutContext;
  const Sidebar(this.appLayoutContext, {super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthRepository>(context, listen: false);
    return Drawer(
      child: Consumer<AuthRepository>(
        builder: (_, authRepo, __) {
          return Column(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 4,
                  ),
                ),
                child: CircleAvatar(
                  foregroundColor: AppColors.white,
                  backgroundColor: AppColors.green,
                  foregroundImage:
                      NetworkImage(authRepo.userProfile?.profileImage ?? ""),
                  child: Visibility(
                    visible: authRepo.isSignedIn,
                    replacement: const Icon(
                      Icons.person,
                      size: 80,
                    ),
                    child: authRepo.userProfile?.profileImage == null
                        ? Text(
                            authRepo.userProfile?.givenName != null
                                ? authRepo.userProfile!.givenName
                                    .substring(0, 1)
                                : "N/A",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: AppColors.white),
                          )
                        : Container(),
                  ),
                ),
              ),
              Visibility(
                visible: authRepo.isSignedIn,
                child: Text(
                  authRepo.userProfile?.givenName ?? "N/A",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Visibility(
                visible: authRepo.isSignedIn,
                replacement: Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      authRepo.signIn(appLayoutContext);
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: Text(
                      "Login",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () => authRepo.signOut(context),
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(
                      "Logout",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
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
