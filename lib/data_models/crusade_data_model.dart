import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wh40k_crusader/app/app_constants.dart';

class CrusadeDataModel {
  static const List<String> factions = [
    'Necrons',
    'Space Marines',
  ];
  final String? documentUID;
  final String name;
  final String userUID;
  final String faction;
  final int battleTally;
  final int requisition;
  final int supplyLimit;
  final int supplyUsed;
  final int victories;

  DateTime? createdAt;
  DateTime? updatedAt;

  CrusadeDataModel({
    this.documentUID,
    required this.userUID,
    required this.name,
    required this.faction,
    required this.battleTally,
    required this.requisition,
    required this.supplyLimit,
    required this.supplyUsed,
    required this.victories,
    this.createdAt,
    this.updatedAt,
  });

  CrusadeDataModel.fromJson(Map<String, Object?> data, String documentUID)
      : this(
          documentUID: documentUID,
          userUID: data[kUserUID]! as String,
          name: data[kName]! as String,
          faction: data[kFaction]! as String,
          battleTally: data[kBattleTally]! as int,
          requisition: data[kRequisition]! as int,
          supplyLimit: data[kSupplyLimit]! as int,
          supplyUsed: data[kSupplyUsed]! as int,
          victories: data[kVictories]! as int,
          createdAt: DateTime.parse(
              (data[kCreatedAt]! as Timestamp).toDate().toString()),
          updatedAt: DateTime.parse(
              (data[kUpdatedAt]! as Timestamp).toDate().toString()),
        );

  Map<String, Object?> toJson() {
    return {
      kUserUID: userUID,
      kName: name,
      kFaction: faction,
      kBattleTally: battleTally,
      kRequisition: requisition,
      kSupplyLimit: supplyLimit,
      kSupplyUsed: supplyUsed,
      kVictories: victories,
      kCreatedAt: createdAt ?? FieldValue.serverTimestamp(),
      kUpdatedAt: updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  String toJSONString() {
    return '{'
        '"$kUserUID": $userUID,'
        '"$kName": $name,'
        '"$kFaction": $faction,'
        '"$kBattleTally": $battleTally,'
        '"$kRequisition": $requisition,'
        '"$kSupplyLimit": $supplyLimit,'
        '"$kSupplyUsed": $supplyUsed,'
        '"$kVictories": $victories,'
        '}';
  }

  @override
  String toString() {
    return this.toJSONString();
  }
}
