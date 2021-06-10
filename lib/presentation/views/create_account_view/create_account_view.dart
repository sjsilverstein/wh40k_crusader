import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/views/create_account_view/create_account_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/authentication_layout.dart';

class CreateAccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateAccountViewModel>.reactive(
      viewModelBuilder: () => CreateAccountViewModel(),
      builder: (context, model, child) => Scaffold(
        body: AuthenticationLayout(
          busy: model.isBusy,
          title: 'Create Account',
          subtitle: 'Enter your name, email, and password to sign up.',
          mainButtonTitle: 'SIGN UP',
          form: FormBuilder(
            key: model.signUpFormKey,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
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
          validationMessage: model.validationMessage,
          showTermsText: true,
          onMainButtonTapped: () => model.saveData,
          onBackPressed: () => model.navigateBack,
        ),
      ),
    );
  }
}
