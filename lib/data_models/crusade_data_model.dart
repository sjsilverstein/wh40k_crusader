import 'package:wh40k_crusader/app/app_constants.dart';

class CrusadeDataModel {
  static const List<String> factions = [
    'Necrons',
    'Space Marines',
  ];

  final String documentUID;
  final String userUID;
  final String faction;
  final int battleTally;
  final int requisition;
  final int supplyLimit;
  final int supplyUsed;
  final int victories;

  CrusadeDataModel(
      {required this.documentUID,
      required this.userUID,
      required this.faction,
      required this.battleTally,
      required this.requisition,
      required this.supplyLimit,
      required this.supplyUsed,
      required this.victories});

  factory CrusadeDataModel.fromMap(Map<String, dynamic> data) {
    return CrusadeDataModel(
      documentUID: data[kDocumentUID],
      userUID: data[kUserUID] ?? 'No User UID',
      faction: data[kFaction] ?? 'No Faction',
      battleTally: data[kBattleTally] ?? 0,
      requisition: data[kRequisition] ?? 0,
      supplyLimit: data[kSupplyLimit] ?? 0,
      supplyUsed: data[kSupplyUsed] ?? 0,
      victories: data[kVictories] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      kDocumentUID: documentUID,
      kUserUID: userUID,
      kFaction: faction,
      kBattleTally: battleTally,
      kRequisition: requisition,
      kSupplyLimit: supplyLimit,
      kSupplyUsed: supplyUsed,
      kVictories: victories,
    };
  }

  String toJSONString() {
    return '{'
        '"$kDocumentUID": $documentUID,'
        '"$kUserUID": $userUID,'
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
