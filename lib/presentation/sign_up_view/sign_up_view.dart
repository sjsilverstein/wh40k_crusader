import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/dumb_widgets/authentication_layout.dart';
import 'package:wh40k_crusader/presentation/sign_up_view/sign_up_view_model.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        body: AuthenticationLayout(
          busy: model.isBusy,
          title: 'Create Account',
          subtitle: 'Enter your name, email, and password to sign up.',
          mainButtonTitle: 'SIGN UP',
          form: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          showTermsText: true,
          onMainButtonTapped: () {},
          onBackPressed: () {},
        ),
      ),
    );
  }
}
