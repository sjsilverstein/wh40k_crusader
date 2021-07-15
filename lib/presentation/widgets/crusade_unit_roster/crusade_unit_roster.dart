import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/crusade_unit_card/crusade_unit_card.dart';

class CrusadeUnitRoster extends ViewModelWidget<CrusadeViewModel> {
  @override
  Widget build(BuildContext context, CrusadeViewModel model) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Drop Roster'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red)),
                        onPressed: () async {
                          await model.showDropRosterDialog();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: model.roster.length,
                itemBuilder: (context, index) =>
                    CrusadeUnitCard(model.roster[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
