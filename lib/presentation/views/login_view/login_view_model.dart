import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/presentation/base/authenticaton_view_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';

class LoginViewModel extends AuthenticationViewModel {
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();

  final _loginFormKey = GlobalKey<FormBuilderState>();
  get loginFormKey => _loginFormKey;

  final String formEmailField = 'email';
  final String formPasswordField = 'password';

  LoginViewModel() : super(successRoute: rNavigationRoutes.HomeRoute);

  String get _emailValue =>
      _loginFormKey.currentState!.fields[formEmailField]!.value;
  String get _passwordValue =>
      _loginFormKey.currentState!.fields[formPasswordField]!.value;

  @override
  Future<FirebaseAuthenticationResult> runAuthentication() =>
      _firebaseAuthenticationService.loginWithEmail(
          email: _emailValue, password: _passwordValue);

  void navigateToSignUp() =>
      _navigationService.navigateTo(rNavigationRoutes.SignUpRoute);
}
