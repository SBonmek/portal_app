import 'package:flutter/material.dart';
import 'package:portal_app/core/config/app_routes.dart';
import 'package:portal_app/features/data/repositories/repositories.dart';
import 'package:portal_app/features/presentation/home/home_screen.dart';
import 'package:portal_app/features/presentation/web_view/web_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthRepository()),
        ChangeNotifierProvider(create: (context) => NewsBannerRepository()),
        ChangeNotifierProvider(create: (context) => PortalRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    context.read<AuthRepository>().checkToken(context);
    return MaterialApp(
      title: "Portal App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: _registerRoutes(),
      onGenerateRoute: _registerRoutesWithParameters,
    );
  }
}

Map<String, WidgetBuilder> _registerRoutes() {
  return <String, WidgetBuilder>{
    AppRoutes.home: (context) {
      return const HomeScreen();
    }
  };
}

Route _registerRoutesWithParameters(RouteSettings settings) {
  if (settings.name == AppRoutes.webView) {
    WebViewParameter args = settings.arguments as WebViewParameter;
    return MaterialPageRoute(
      builder: (context) {
        return WebViewScreen(
          webUri: args.webUri,
        );
      },
    );
  }

  return MaterialPageRoute(
    builder: (context) {
      return const Center(
        child: Text("Error"),
      );
    },
  );
}
