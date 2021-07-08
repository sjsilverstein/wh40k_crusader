import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/presentation/widgets/crusade_card_view_model.dart';

class CrusadeCard extends StatelessWidget {
  final CrusadeDataModel crusade;

  CrusadeCard(this.crusade);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CrusaderCardModel>.reactive(
      viewModelBuilder: () => CrusaderCardModel(crusade),
      builder: (context, model, child) => Card(
        child: ExpansionTile(
          title: Text(crusade.name),
          subtitle: Text(crusade.faction),
          trailing: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green)),
            child: Icon(Icons.edit),
            onPressed: () {
              // model.deleteCrusadeDocumentByUID(crusade);
              model.pushCrusadeRoute();
            },
          ),
          children: [
            _CrusadeCardExpansionRow('Battle Tally: ${crusade.battleTally}'),
            _CrusadeCardExpansionRow('Victories: ${crusade.victories}'),
            _CrusadeCardExpansionRow(
                'Requisition Points: ${crusade.requisition}'),
            _CrusadeCardExpansionRow('Supply Limit: ${crusade.supplyLimit}'),
            _CrusadeCardExpansionRow('Supply Used: ${crusade.supplyUsed}'),
            _CrusadeCardExpansionRow('Document UID : ${crusade.documentUID}'),
            _CrusadeCardExpansionRow('Created Ad : ${crusade.createdAt}'),
          ],
        ),
      ),
    );
  }
}

class _CrusadeCardExpansionRow extends StatelessWidget {
  final String data;

  _CrusadeCardExpansionRow(this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(data)],
    );
  }
}
