import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';

class CrusadeUnitBattlePerformanceDataModel {
  CrusadeUnitDataModel? unit;

  String? documentUID;
  int unitsDestroyed;
  int bonusXP;
  bool wasDestroyed;
  bool markedForGreatness;

  CrusadeUnitBattlePerformanceDataModel({
    this.documentUID,
    this.unit,
    required this.unitsDestroyed,
    required this.bonusXP,
    required this.wasDestroyed,
    required this.markedForGreatness,
  });

  CrusadeUnitBattlePerformanceDataModel.fromJson(
      Map<String, Object?> data, String documentUID)
      : this(
          documentUID: documentUID,
          unitsDestroyed: data[kUnitsDestroyed] as int,
          bonusXP: data[kBonusXP] as int,
          wasDestroyed: data[kWasDestroyed] as bool,
          markedForGreatness: data[kMarkedForGreatness] as bool,
        );

  Map<String, Object> toJson() {
    return {
      kUnitsDestroyed: unitsDestroyed,
      kBonusXP: bonusXP,
      kWasDestroyed: wasDestroyed,
      kMarkedForGreatness: markedForGreatness,
    };
  }

  CrusadeUnitBattlePerformanceDataModel copyWith({
    int? unitsDestroyed,
    int? bonusXP,
    bool? wasDestroyed,
    bool? markedForGreatness,
  }) =>
      CrusadeUnitBattlePerformanceDataModel(
        unitsDestroyed: unitsDestroyed ?? this.unitsDestroyed,
        bonusXP: bonusXP ?? this.bonusXP,
        wasDestroyed: wasDestroyed ?? this.wasDestroyed,
        markedForGreatness: markedForGreatness ?? this.markedForGreatness,
        documentUID: this.documentUID,
      );
}
