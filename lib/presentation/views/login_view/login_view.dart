import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/views/login_view/login_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/authentication_layout.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
        body: AuthenticationLayout(
          busy: model.isBusy,
          title: 'Welcome',
          subtitle: 'Enter your email address to sign in.',
          form: FormBuilder(
            key: model.loginFormKey,
            onChanged: () {},
            autovalidateMode: AutovalidateMode.disabled,
            initialValue: {
              model.formEmailField: '',
              model.formPasswordField: '',
            },
            child: Column(
              children: [
                FormBuilderTextField(
                  name: model.formEmailField,
                  validator: FormBuilderValidators.required(context),
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                FormBuilderTextField(
                  name: model.formPasswordField,
                  validator: FormBuilderValidators.required(context),
                  decoration: InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
          ),
          mainButtonTitle: 'SIGN IN',
          validationMessage: model.validationMessage,
          onMainButtonTapped: () => model.saveData,
          onCreateAccountTapped: () => model.navigateToSignUp,
          onForgotPassword: () {
            // TODO implement password recovery
          },
        ),
      ),
    );
  }
}
