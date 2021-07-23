import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';

class BattleDataModel {
  static const List<String> battleSizes = [
    'Combat Patrol',
    'Incursion',
    'Strike Force',
    'Onslaught',
  ];

  DateTime battleDate;
  String battleSize;
  int battlePowerLevel;
  String? mission;
  String opponentName;
  String opponentFaction;
  int score;
  int opponentScore;
  String? notes;

  //
  List<CrusadeUnitDataModel>? roster;
  List<CrusadeUnitBattlePerformanceDataModel>? rosterPerformance;
  CrusadeUnitDataModel? markedForGlory;
  //
  DateTime? createdAt;
  DateTime? updatedAt;

  BattleDataModel({
    required this.battleDate,
    required this.battleSize,
    required this.battlePowerLevel,
    required this.opponentName,
    required this.opponentFaction,
    required this.score,
    required this.opponentScore,
    this.mission,
    this.notes,
    this.roster,
    this.rosterPerformance,
    this.markedForGlory,
  });
}

class CrusadeUnitBattlePerformanceDataModel {
  final CrusadeUnitDataModel unit;
  int unitsDestroyed;
  int bonusXp;
  bool wasDestroyed;

  CrusadeUnitBattlePerformanceDataModel({
    required this.unit,
    required this.unitsDestroyed,
    required this.bonusXp,
    required this.wasDestroyed,
  });
}
