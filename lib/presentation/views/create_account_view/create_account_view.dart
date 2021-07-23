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
            initialValue: {
              model.formEmailField: '',
              model.formPasswordField: '',
              model.formConfirmPasswordField: '',
            },
            child: Column(
              children: [
                FormBuilderTextField(
                  name: model.formEmailField,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.email(context)
                  ]),
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                FormBuilderTextField(
                  name: model.formPasswordField,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.minLength(context, 6),
                    FormBuilderValidators.maxLength(context, 14),
                  ]),
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                FormBuilderTextField(
                  name: model.formConfirmPasswordField,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.minLength(context, 6),
                    FormBuilderValidators.maxLength(context, 14),
                    (value) {
                      model.signUpFormKey.currentState?.save();
                      if (value !=
                          model.signUpFormKey.currentState!
                              .fields[model.formPasswordField]?.value) {
                        return 'Password and Confirmation must match';
                      }

                      return null;
                    }
                  ]),
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                ),
              ],
            ),
          ),
          validationMessage: model.validationMessage,
          showTermsText: true,
          onMainButtonTapped: () => model.saveAndValidate,
          onBackPressed: () => model.navigateBack,
        ),
      ),
    );
  }
}
