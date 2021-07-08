import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/views/home_view/home_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/crusade_card.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      // onModelReady: (model) => model.listenToCrusades(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Home App Bar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(model.title),
              ElevatedButton(
                child: Text('Log Off'),
                onPressed: () => model.logoff(),
              ),
              model.data != null
                  ? SizedBox(
                      height: 600,
                      child: ListView.builder(
                        itemCount: model.data!.length,
                        itemBuilder: (context, index) =>
                            CrusadeCard(model.data![index]),
                      ),
                    )
                  : Container(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            // TODO Dialog to Create a new crusade
            // await model.createNewCrusade();
            model.navigateToNewCrusadeForm();
          },
        ),
      ),
    );
  }
}
