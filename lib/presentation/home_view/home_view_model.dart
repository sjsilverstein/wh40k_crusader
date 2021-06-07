import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/routing/routes.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final String _title = 'Warhammer 40K Crusader Home';
  String get title => _title;

  initialization() async {
    setBusy(true);
    // do Some async work

    setBusy(false);
    notifyListeners();
  }

  doSomething() {
    _navigationService.navigateTo(rNavigationRoutes.StartUpRoute);
  }
}
