import 'package:wh40k_crusader/app/app_constants.dart';

class BattleHonour {
  String title;
  String? description;

  BattleHonour({required this.title, this.description});
}

class BattleScar {
  String title;
  String? description;

  BattleScar({required this.title, this.description});
}

class CrusadeUnitDataModel {
  static const List<String> battleFieldRoles = [
    'HQ',
    'Elite',
    'Troop',
    'Fast Attack',
    'Heavy Support',
    'Dedicated Transport',
    'Super-Heavy',
  ];
  String? documentUID;

  String unitName;
  String battleFieldRole;
  String crusadeFaction;
  List<String>? selectableKeywords;

  int powerRating;
  int experiance;
  int? crusadePoints;

  String unitType;
  String? equipment;
  List<String>? psychicPowers;
  List<String>? warlordTraits;
  List<String>? relics;

  int battlesPlayed;
  int battleSurvived;

  List<BattleHonour>? battleHonours;
  List<BattleScar>? battleScars;

  DateTime? createdAt;
  DateTime? updatedAt;

  CrusadeUnitDataModel({
    this.documentUID,
    required this.unitName,
    required this.battleFieldRole,
    required this.crusadeFaction,
    this.selectableKeywords,
    required this.unitType,
    required this.powerRating,
    this.crusadePoints,
    this.experiance = 0,
    this.equipment,
    this.psychicPowers,
    this.warlordTraits,
    this.relics,
    this.battlesPlayed = 0,
    this.battleSurvived = 0,
    this.battleHonours,
    this.battleScars,
    this.createdAt,
    this.updatedAt,
  });

  String getRank() {
    if (this.experiance > 50) {
      return kUnitRankLegendary;
    } else if (this.experiance > 30) {
      return kUnitRankHeroic;
    } else if (this.experiance > 15) {
      return kUnitRankBattleHardened;
    } else if (this.experiance > 5) {
      return kUnitRankBlooded;
    } else {
      return kUnitRankBattleReady;
    }
  }
}
