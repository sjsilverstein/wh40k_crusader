import 'package:cloud_firestore/cloud_firestore.dart';
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
  static const List<String> battleFieldRoles = const [
    'HQ',
    'Elite',
    'Troop',
    'Transport',
    'Fast Attack',
    'Heavy Support',
    'Flyer',
    'Lord of War',
    'Supreme Commander'
  ];
  String? documentUID;

  String unitName;
  String battleFieldRole;
  String crusadeFaction;
  List<String>? selectableKeywords;

  int powerRating;
  int experience;
  int crusadePoints;

  String unitType;
  String equipment;
  List<String>? psychicPowers;
  List<String>? warlordTraits;
  List<String>? relics;

  int battlesPlayed;
  int battlesSurvived;

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
    this.crusadePoints = 0,
    this.experience = 0,
    this.equipment = 'Default Equipment',
    this.psychicPowers,
    this.warlordTraits,
    this.relics,
    this.battlesPlayed = 0,
    this.battlesSurvived = 0,
    this.battleHonours,
    this.battleScars,
    this.createdAt,
    this.updatedAt,
  });

  CrusadeUnitDataModel.fromJson(Map<String, Object?> data, String documentUID)
      : this(
          documentUID: documentUID,
          unitName: data[kName]! as String,
          battleFieldRole: data[kBattleFieldRole]! as String,
          crusadeFaction: data[kFaction]! as String,
          unitType: data[kUnitType]! as String,
          powerRating: data[kPowerRating]! as int,
          experience: data[kExperience]! as int,
          equipment: data[kEquipment] as String,
          crusadePoints: data[kCrusadePoints]! as int,
          battlesPlayed: data[kBattlesPlayed]! as int,
          battlesSurvived: data[kBattlesSurvived]! as int,
          createdAt: DateTime.parse(
              (data[kCreatedAt]! as Timestamp).toDate().toString()),
          updatedAt: DateTime.parse(
              (data[kUpdatedAt]! as Timestamp).toDate().toString()),
        );

  String getRank() {
    if (this.experience > 50) {
      return kUnitRankLegendary;
    } else if (this.experience > 30) {
      return kUnitRankHeroic;
    } else if (this.experience > 15) {
      return kUnitRankBattleHardened;
    } else if (this.experience > 5) {
      return kUnitRankBlooded;
    } else {
      return kUnitRankBattleReady;
    }
  }

  Map<String, Object?> toJson() {
    return {
      kName: unitName,
      kBattleFieldRole: battleFieldRole,
      kFaction: crusadeFaction,
      kSelectableKeywords: selectableKeywords,
      kUnitType: unitType,
      kPowerRating: powerRating,
      kCrusadePoints: crusadePoints,
      kExperience: experience,
      kEquipment: equipment,
      kPowers: psychicPowers,
      kWarlordTraits: warlordTraits,
      kRelics: relics,
      kBattlesPlayed: battlesPlayed,
      kBattlesSurvived: battlesSurvived,
      kBattleHonors: battleHonours,
      kBattleScars: battleScars,
      kCreatedAt: createdAt ?? FieldValue.serverTimestamp(),
      kUpdatedAt: FieldValue.serverTimestamp(),
    };
  }
}
