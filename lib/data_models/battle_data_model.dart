import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_battle_performance_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';

class BattleDataModel {
  static const List<String> battleSizes = [
    'Combat Patrol',
    'Incursion',
    'Strike Force',
    'Onslaught',
  ];
  String? documentUID;

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
    this.documentUID,
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
    this.createdAt,
    this.updatedAt,
  });

  BattleDataModel.fromJson(Map<String, Object?> data, String documentUID)
      : this(
          documentUID: documentUID,
          battleDate: DateTime.parse(
              (data[kBattleDate] as Timestamp).toDate().toString()),
          battleSize: data[kBattleSize] as String,
          battlePowerLevel: data[kBattlePowerLevel] as int,
          opponentName: data[kOpponentName] as String,
          opponentFaction: data[kOpponentFaction] as String,
          score: data[kScore] as int,
          opponentScore: data[kOpponentScore] as int,
          mission: data[kMission] as String,
          notes: data[kNotes] as String,
          createdAt: DateTime.parse(
              (data[kCreatedAt]! as Timestamp).toDate().toString()),
          updatedAt: DateTime.parse(
              (data[kUpdatedAt]! as Timestamp).toDate().toString()),
        );

  Map<String, Object> toJson() {
    return {
      kBattleDate: battleDate,
      kBattleSize: battleSize,
      kBattlePowerLevel: battlePowerLevel,
      kOpponentName: opponentName,
      kOpponentFaction: opponentFaction,
      kScore: score,
      kOpponentScore: opponentScore,
      kMission: mission ?? '',
      kNotes: notes ?? '',
      kCreatedAt: createdAt ?? FieldValue.serverTimestamp(),
      kUpdatedAt: FieldValue.serverTimestamp(),
    };
  }
}
