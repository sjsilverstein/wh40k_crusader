import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/views/startup_view/startup_view_model.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('StartUp Bar'),
        ),
      ),
    );
  }
}
