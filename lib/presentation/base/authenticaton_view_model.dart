import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';

abstract class AuthenticationViewModel extends FormViewModel {
  final NavigationService navigationService = locator<NavigationService>();

  final String successRoute;

  AuthenticationViewModel({required this.successRoute});

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }

  Future saveData() async {
    print('Authentication View Model Saving Data');
    final result = await runBusyFuture(runAuthentication());

    if (!result.hasError) {
      // Navigate to Success
      navigationService.replaceWith(successRoute);
    } else {
      print('We have an error');
      setValidationMessage(result.errorMessage);
      print(result.errorMessage);
    }
  }

  Future<FirebaseAuthenticationResult> runAuthentication();
}
