import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wh40k_crusader/app/app_constants.dart';

class BattleHonor {
  String title;
  String? description;

  BattleHonor({required this.title, this.description});

  BattleHonor.fromJson(Map<String, dynamic> data)
      : this(
          title: data[kTitle] as String,
          description: data[kDescription] ?? 'No Description Provided',
        );
}

class BattleScar {
  String title;
  String? description;

  BattleScar({required this.title, this.description});

  BattleScar.fromJson(Map<String, dynamic> data)
      : this(
          title: data[kTitle]! as String,
          description: data[kDescription] ?? 'No Description Provided',
        );
}

class Power {
  String title;
  String? description;

  Power({required this.title, this.description});

  Power.fromJson(Map<String, dynamic> data)
      : this(
          title: data[kTitle]! as String,
          description: data[kDescription] ?? 'No Description Provided',
        );

  Map<String, dynamic> toJson() {
    return {
      kTitle: this.title,
      kDescription: this.description ?? null,
    };
  }
}

class WarlordTrait {
  String title;
  String? description;

  WarlordTrait({required this.title, this.description});

  WarlordTrait.fromJson(Map<String, dynamic> data)
      : this(
          title: data[kTitle]! as String,
          description: data[kDescription] ?? 'No Description Provided',
        );
}

class Relic {
  String title;
  String? description;

  Relic({required this.title, this.description});

  Relic.fromJson(Map<String, dynamic> data)
      : this(
          title: data[kTitle]! as String,
          description: data[kDescription] ?? 'No Description Provided',
        );
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

  int battlesPlayed;
  int battlesSurvived;

  List<Power> psychicPowers;
  List<WarlordTrait> warlordTraits;
  List<Relic> relics;

  List<BattleHonor> battleHonors;
  List<BattleScar> battleScars;

  DateTime? createdAt;
  DateTime? updatedAt;

  CrusadeUnitDataModel({
    this.documentUID,
    required this.unitName,
    required this.battleFieldRole,
    required this.crusadeFaction,
    required this.unitType,
    required this.powerRating,
    required this.psychicPowers,
    required this.warlordTraits,
    required this.relics,
    required this.battleHonors,
    required this.battleScars,
    this.selectableKeywords,
    this.crusadePoints = 0,
    this.experience = 0,
    this.equipment = 'Default Equipment',
    this.battlesPlayed = 0,
    this.battlesSurvived = 0,
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
          psychicPowers: List.castFrom(data[kPowers]! as List)
              .map((e) => Power.fromJson(e))
              .toList(),
          warlordTraits: List.castFrom(data[kWarlordTraits]! as List)
              .map((e) => WarlordTrait.fromJson(e))
              .toList(),
          relics: List.castFrom(data[kRelics]! as List)
              .map((e) => Relic.fromJson(e))
              .toList(),
          battleHonors: List.castFrom(data[kBattleHonors]! as List)
              .map((e) => BattleHonor.fromJson(e))
              .toList(),
          battleScars: List.castFrom(data[kBattleScars]! as List)
              .map((e) => BattleScar.fromJson(e))
              .toList(),
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
      kPowers: psychicPowers.map((e) => e.toJson()).toList(),
      kWarlordTraits: warlordTraits,
      kRelics: relics,
      kBattlesPlayed: battlesPlayed,
      kBattlesSurvived: battlesSurvived,
      kBattleHonors: battleHonors,
      kBattleScars: battleScars,
      kCreatedAt: createdAt ?? FieldValue.serverTimestamp(),
      kUpdatedAt: FieldValue.serverTimestamp(),
    };
  }

  CrusadeUnitDataModel copyWith({
    String? unitName,
    String? unitType,
    int? powerRating,
    int? crusadePoints,
    int? experience,
    String? battleFieldRole,
    String? equipment,
    List<Power>? psychicPowers,
    List<WarlordTrait>? warlordTraits,
    List<Relic>? relics,
    int? battlesPlayed,
    int? battlesSurvived,
    List<BattleHonor>? battleHonours,
    List<BattleScar>? battleScars,
  }) =>
      CrusadeUnitDataModel(
        documentUID: this.documentUID,
        unitName: unitName ?? this.unitName,
        battleFieldRole: battleFieldRole ?? this.battleFieldRole,
        crusadeFaction: this.crusadeFaction,
        selectableKeywords: this.selectableKeywords,
        unitType: unitType ?? this.unitType,
        powerRating: powerRating ?? this.powerRating,
        crusadePoints: crusadePoints ?? this.crusadePoints,
        experience: experience ?? this.experience,
        equipment: equipment ?? this.equipment,
        psychicPowers: psychicPowers ?? this.psychicPowers,
        warlordTraits: warlordTraits ?? this.warlordTraits,
        relics: relics ?? this.relics,
        battlesPlayed: battlesPlayed ?? this.battlesPlayed,
        battlesSurvived: battlesSurvived ?? this.battlesSurvived,
        battleHonors: battleHonours ?? this.battleHonors,
        battleScars: battleScars ?? this.battleScars,
        createdAt: this.createdAt,
      );
}
