import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/presentation/base/authenticaton_view_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';

class CreateAccountViewModel extends AuthenticationViewModel {
  final _navigationService = locator<NavigationService>();
  final _firebaseAuthentication = locator<FirebaseAuthenticationService>();

  final signUpFormKey = GlobalKey<FormBuilderState>();

  final String formEmailField = 'email';
  final String formPasswordField = 'password';
  final String formConfirmPasswordField = 'confirmPassword';

  CreateAccountViewModel() : super(successRoute: rNavigationRoutes.HomeRoute);

  String get _emailValue =>
      signUpFormKey.currentState!.fields[formEmailField]!.value;
  String get _passwordValue =>
      signUpFormKey.currentState!.fields[formPasswordField]!.value;

  navigateBack() {
    _navigationService.replaceWith(rNavigationRoutes.LoginRoute);
  }

  saveAndValidate() {
    bool? isValid = signUpFormKey.currentState?.saveAndValidate();

    if (isValid != null && isValid) {
      saveData();
    }
  }

  @override
  Future<FirebaseAuthenticationResult> runAuthentication() =>
      _firebaseAuthentication.createAccountWithEmail(
          email: _emailValue, password: _passwordValue);
}
