import 'package:flutter/material.dart';
import 'package:wh40k_crusader/routing/router.dart' as projectRouter;
import 'package:wh40k_crusader/routing/routes.dart';

import 'app/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      navigatorKey: projectRouter.Router.navigatorKey,
      onGenerateRoute: projectRouter.Router.generateRoute,
      initialRoute: rNavigationRoutes.HomeRoute,
    );
  }
}
