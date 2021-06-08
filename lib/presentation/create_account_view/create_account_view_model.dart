import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/presentation/base/authenticaton_view_model.dart';
import 'package:wh40k_crusader/routing/routes.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';

class CreateAccountViewModel extends AuthenticationViewModel {
  final _navigationService = locator<NavigationService>();
  final _firebaseAuthentication = locator<FirebaseAuthenicationService>();

  final _signUpFormKey = GlobalKey<FormBuilderState>();
  get signUpFormKey => _signUpFormKey;

  final String formEmailField = 'email';
  final String formPasswordField = 'password';

  CreateAccountViewModel() : super(successRoute: rNavigationRoutes.HomeRoute);

  String get _emailValue =>
      _signUpFormKey.currentState!.fields[formEmailField]!.value;
  String get _passwordValue =>
      _signUpFormKey.currentState!.fields[formPasswordField]!.value;

  navigateBack() {
    _navigationService.replaceWith(rNavigationRoutes.LoginRoute);
  }

  @override
  Future<FirebaseAuthenticationResult> runAuthentication() =>
      _firebaseAuthentication.createAccountWithEmail(
          email: _emailValue, password: _passwordValue);
}
