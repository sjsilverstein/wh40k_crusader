import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/presentation/home_view/home_view.dart';
import 'package:wh40k_crusader/presentation/startup_view/startup_view.dart';
import 'package:wh40k_crusader/routing/routes.dart';

class Router {
  static GlobalKey<NavigatorState>? navigatorKey = StackedService.navigatorKey;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    RoutingData routingData = settings.name!.getRoutingData;

    print('Settings Name: ${settings.name}');
    Widget pageWidget;

    switch (routingData.route) {
      case rNavigationRoutes.HomeRoute:
        pageWidget = HomeView();

        break;

      case rNavigationRoutes.StartUpRoute:
        pageWidget = StartUpView();

        break;

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => pageWidget,
    );
  }
}

class RoutingData {
  final String route;
  final Map<String, String> _queryParameters;

  RoutingData(
      {required this.route, required Map<String, String> queryParameters})
      : _queryParameters = queryParameters;

  operator [](String key) => _queryParameters[key];
}

extension StringExtensions on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);

    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}
