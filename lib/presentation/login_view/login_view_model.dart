import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/presentation/base/authenticaton_view_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';

class LoginViewModel extends AuthenticationViewModel {
  final FirebaseAuthenicationService _firebaseAuthenticationService =
      locator<FirebaseAuthenicationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  LoginViewModel() : super(successRoute: rNavigationRoutes.HomeRoute);

  @override
  Future<FirebaseAuthenticationResult> runAuthentication() =>
      _firebaseAuthenticationService.loginWithEmail(
          email: emailValue, password: passwordValue);

  void navigateToSignUp() =>
      _navigationService.navigateTo(rNavigationRoutes.SignUpRoute);
}
