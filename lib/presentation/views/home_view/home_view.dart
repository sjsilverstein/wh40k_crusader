import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/shared/ui_helpers.dart';
import 'package:wh40k_crusader/presentation/views/home_view/home_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/crusade_card/crusade_card.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(model.title),
          actions: [
            ElevatedButton(
              child: Icon(Icons.logout),
              onPressed: () => model.logoff(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              model.data != null
                  ? SizedBox(
                      height: 600,
                      child: StreamBuilder<List<CrusadeDataModel>>(
                          stream: model.stream,
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => CrusadeCard(
                                  crusade: snapshot.data![index],
                                  onPressed: () => model.pushCrusadeRoute(
                                    snapshot.data![index],
                                  ),
                                ),
                              );
                            }
                            return _NoCrusadesFoundWidget();
                          }),
                    )
                  : _NoCrusadesFoundWidget()
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

class _NoCrusadesFoundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Searching for Crusades...'),
          VerticalSpace.medium,
          CircularProgressIndicator(),
          VerticalSpace.medium,
          Text('Try Starting a Crusade.'),
        ],
      ),
    );
  }
}
