import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wh40k_crusader/app/setup_dialog_ui.dart';
import 'package:wh40k_crusader/routing/router.dart' as projectRouter;
import 'package:wh40k_crusader/routing/routes.dart';

import 'app/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupDialogUi();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child:
                  Text('Something is Wrong', textDirection: TextDirection.ltr));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WH40k Crusader',
            theme: ThemeData.dark(),
            navigatorKey: projectRouter.Router.navigatorKey,
            onGenerateRoute: projectRouter.Router.generateRoute,
            initialRoute: rNavigationRoutes.LoginRoute,
            // home: HomeView(),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
