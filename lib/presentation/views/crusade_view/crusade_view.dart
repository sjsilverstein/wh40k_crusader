import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';

class CrusadeView extends StatelessWidget {
  final CrusadeDataModel crusade;

  CrusadeView(this.crusade);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CrusadeViewModel>.reactive(
      viewModelBuilder: () => CrusadeViewModel(crusade),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(crusade.name),
        ),
        body: Column(
          children: [
            Card(
              child: Column(
                children: [
                  Text('Name: ${model.crusade.name}'),
                  Text('Faction: ${model.crusade.faction}'),
                  Text('User ID: ${model.crusade.userUID}'),
                  Text('Document Id: ${model.crusade.documentUID}'),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    child: Icon(Icons.delete),
                    onPressed: () async {
                      await model.showConfirmDeleteDialog();
                    },
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Create Generic Unit'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
