import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/home_view/home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async => await model.initialization(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Home App Bar'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(model.title),
              ElevatedButton(
                child: Text('Do something'),
                onPressed: () => model.doSomething(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
