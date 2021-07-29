import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/presentation/views/crusade_view/crusade_view_model.dart';
import 'package:wh40k_crusader/presentation/widgets/battle_record_card/battle_record_card.dart';

class BattleHistory extends ViewModelWidget<CrusadeViewModel> {
  @override
  Widget build(BuildContext context, CrusadeViewModel model) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          model.dataMap?[kBattleStream] != null
              ? model.dataMap![kBattleStream].length > 0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: model.dataMap?[kBattleStream].length,
                        itemBuilder: (context, index) => BattleRecordCard(
                            model.dataMap?[kBattleStream][index]),
                      ),
                    )
                  : Container(
                      child: Text('No Recorded Battles'),
                    )
              : Container(
                  child: Text('Stream is Null'),
                )
        ],
      ),
    );
  }
}
