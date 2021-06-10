import 'package:flutter/material.dart';
import 'package:wh40k_crusader/presentation/shared/styles.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';

class AuthenticationLayout extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? mainButtonTitle;
  final Widget? form;
  final bool? showTermsText;
  final Function? onMainButtonTapped;
  final Function? onCreateAccountTapped;
  final Function? onForgotPassword;
  final Function? onBackPressed;
  final String? validationMessage;
  final bool busy;

  const AuthenticationLayout({
    Key? key,
    this.title,
    this.subtitle,
    this.mainButtonTitle,
    this.form,
    this.onMainButtonTapped,
    this.onCreateAccountTapped,
    this.onForgotPassword,
    this.onBackPressed,
    this.validationMessage,
    this.showTermsText = false,
    this.busy = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: ListView(
        children: [
          if (onBackPressed == null) VerticalSpace.large,
          if (onBackPressed != null) VerticalSpace.regular,
          if (onBackPressed != null)
            IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: onBackPressed!(),
            ),
          Text(
            title!,
            style: TextStyle(fontSize: 34),
          ),
          VerticalSpace.small,
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: screenWidthPercentage(context, percentage: 0.7),
              child: Text(
                subtitle!,
                style: ktsMediumGreyBodyText,
              ),
            ),
          ),
          VerticalSpace.regular,
          form!,
          VerticalSpace.regular,
          if (onForgotPassword != null)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onForgotPassword!(),
                child: Text(
                  'Forget Password?',
                  style: ktsMediumGreyBodyText.copyWith(
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          VerticalSpace.regular,
          if (validationMessage != null)
            Text(
              validationMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: kBodyTextSize,
              ),
            ),
          if (validationMessage != null) VerticalSpace.regular,
          GestureDetector(
            onTap: onMainButtonTapped!(),
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: busy
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : Text(
                      mainButtonTitle!,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
            ),
          ),
          VerticalSpace.regular,
          if (onCreateAccountTapped != null)
            GestureDetector(
              onTap: onCreateAccountTapped!(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  HorizontalSpace.tiny,
                  Text(
                    'Create an account',
                    style: TextStyle(color: kcPrimaryColor),
                  )
                ],
              ),
            ),
          if (showTermsText!)
            Text(
              'By signing up you agree to our terms, conditions, and privacy policy.',
              style: ktsMediumGreyBodyText,
              textAlign: TextAlign.center,
            )
        ],
      ),
    );
  }
}
