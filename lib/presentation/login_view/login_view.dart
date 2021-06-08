import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/dumb_widgets/authentication_layout.dart';
import 'package:wh40k_crusader/presentation/login_view/login_view_model.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
        body: AuthenticationLayout(
          busy: model.isBusy,
          onCreateAccountTapped: () {},
          title: 'Welcome',
          subtitle: 'Enter your email address to sign in.',
          mainButtonTitle: 'SIGN IN',
          form: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: model.emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                controller: model.passwordController,
              ),
            ],
          ),
          onForgotPassword: () {},
          onMainButtonTapped: () {},
        ),
      ),
    );
  }
}
