import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/app/setup_dialog_ui.dart';
import 'package:wh40k_crusader/presentation/shared/wh40kAppTheme.dart';
import 'package:wh40k_crusader/routing/router.dart' as projectRouter;
import 'package:wh40k_crusader/routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock Landscape Mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  await Firebase.initializeApp();

  setupLocator();
  setupDialogUi();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WH40k Crusader',
      theme: wh40kAppTheme,
      navigatorKey: projectRouter.Router.navigatorKey,
      onGenerateRoute: projectRouter.Router.generateRoute,
      initialRoute: rNavigationRoutes.LoginRoute,
    );
  }
}
