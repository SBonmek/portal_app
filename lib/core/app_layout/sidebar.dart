import 'package:flutter/material.dart';
import 'package:portal_app/features/data/repositories/auth_repository.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

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
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  child: Visibility(
                    visible: authRepo.isSignedIn,
                    replacement: const Icon(
                      Icons.person,
                      size: 80,
                    ),
                    child: Image.network(
                      authRepo.userInfoes?.photoUrl ?? "",
                      errorBuilder: (context, error, stackTrace) => Text(
                        authRepo.userInfoes?.displayName != null
                            ? authRepo.userInfoes!.displayName!.substring(0, 1)
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
                visible: authRepo.isSignedIn,
                child: Text(
                  authRepo.userInfoes?.displayName ?? "N/A",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Visibility(
                visible: authRepo.isSignedIn,
                replacement: Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      authRepo.signInWithKeyCloak(context);
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
                    onPressed: () => authRepo.signOut(context),
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
