import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/views/create_account_view/create_account_view.dart';
import 'package:wh40k_crusader/presentation/views/create_crusade_unit_view/create_crusade_unit_view.dart';
import 'package:wh40k_crusader/presentation/views/create_crusade_view/create_crusade_view.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view.dart';
import 'package:wh40k_crusader/presentation/views/home_view/home_view.dart';
import 'package:wh40k_crusader/presentation/views/login_view/login_view.dart';
import 'package:wh40k_crusader/presentation/views/update_crusade_unit_view/update_crusade_unit_view.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/routing/routing_args.dart';

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

      case rNavigationRoutes.SignUpRoute:
        pageWidget = CreateAccountView();

        break;
      case rNavigationRoutes.LoginRoute:
        pageWidget = LoginView();

        break;
      case rNavigationRoutes.CrusadeRoute:
        CrusadeDataModel? crusade = settings.arguments as CrusadeDataModel;
        pageWidget = CrusadeView(crusade);

        break;
      case rNavigationRoutes.UpdateUnitRoute:
        UpdateCrusadeUnitRouteArgs? args =
            settings.arguments as UpdateCrusadeUnitRouteArgs;
        pageWidget = UpdateCrusadeUnitView(
          crusade: args.crusade,
          unit: args.unit,
        );

        break;
      case rNavigationRoutes.CreateUnitRoute:
        CrusadeDataModel? crusade = settings.arguments as CrusadeDataModel;
        logger.wtf('Router Crusade : ${crusade.name}');

        pageWidget = CreateUnitView(crusade);
        break;
      case rNavigationRoutes.NewCrusade:
        pageWidget = CreateCrusadeView();
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
