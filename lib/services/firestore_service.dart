import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/battle_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_battle_performance_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuthenticationService _auth =
      locator<FirebaseAuthenticationService>();
  static const String crusadeCollectionName = 'crusade';
  static const String rosterCollectionName = 'roster';
  static const String battlesCollectionName = 'battles';
  static const String unitPerformanceCollectionName = 'unitPerformance';

  final _crusadeCollectionRef =
      _db.collection(crusadeCollectionName).withConverter<CrusadeDataModel>(
            fromFirestore: (snapshot, _) =>
                CrusadeDataModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (crusade, _) => crusade.toJson(),
          );

  Stream<List<CrusadeDataModel>> listenToCrusadesRealTime() {
    logger.i('Firestore: Started Listening to Crusades In Real Time');
    return _crusadeCollectionRef
        .where(kUserUID, isEqualTo: _auth.currentUser!.uid)
        .orderBy(kCreatedAt, descending: false)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<CrusadeDataModel> listenToCrusadeRealTime(
      {required String crusadeUID}) {
    return _crusadeCollectionRef
        .doc(crusadeUID)
        .snapshots()
        .map((event) => event.data()!);
  }

  Stream<List<CrusadeUnitDataModel>> listenToCrusadeRoster(
      {required String crusadeUID}) {
    return _crusadeCollectionRef
        .doc(crusadeUID)
        .collection(rosterCollectionName)
        .withConverter<CrusadeUnitDataModel>(
          fromFirestore: (snapshot, _) =>
              CrusadeUnitDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (unit, _) => unit.toJson(),
        )
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<BattleDataModel>> listenToCrusadesBattles(
      {required String crusadeUID}) {
    logger.wtf('We are listening for battles for $crusadeUID');
    return _crusadeCollectionRef
        .doc(crusadeUID)
        .collection(battlesCollectionName)
        .withConverter<BattleDataModel>(
          fromFirestore: (snapshot, _) =>
              BattleDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (battle, _) => battle.toJson(),
        )
        .snapshots()
        .map((query) => query.docs.map((document) => document.data()).toList());
  }

  Future createNewCrusade(CrusadeDataModel crusade) async {
    logger.i('Firestore: Creating New Crusade');
    await _crusadeCollectionRef.add(crusade);
    logger.i('Firestore: New Crusade Created');
  }

  Future deleteCrusade(CrusadeDataModel crusade) async {
    logger.w('Firestore: Deleting Crusade');
    await deleteRoster(crusade);
    await _deleteAllBattles(crusade);
    await _crusadeCollectionRef
        .doc(crusade.documentUID)
        .delete()
        .then((value) => logger.w('Firestore: Crusade Deleted'))
        .catchError((error) => logger.e(error));
  }

  Future updateCrusade(CrusadeDataModel crusade) async {
    logger.i("Updating Crusade ${crusade.name} : ${crusade.documentUID}");

    await _crusadeCollectionRef
        .doc(crusade.documentUID)
        .update(crusade.toJson())
        .then((value) => logger.i("Crusade Updated"))
        .catchError((error) => logger.e("Failed to update crusade: $error"));
  }

  Future addUnitToCrusadeRoster(
      CrusadeDataModel crusade, CrusadeUnitDataModel unit) async {
    CrusadeDataModel updatedCrusade =
        crusade.copyWith(supplyUsed: crusade.supplyUsed + unit.powerRating);

    await _crusadeCollectionRef
        .doc(crusade.documentUID)
        .update(updatedCrusade.toJson());

    await _crusadeCollectionRef
        .doc(crusade.documentUID)
        .collection(rosterCollectionName)
        .add(unit.toJson());
  }

  Future updateCrusadeUnit({
    required CrusadeDataModel crusade,
    required CrusadeUnitDataModel unit,
  }) async {
    await updateCrusade(crusade);

    await _crusadeCollectionRef
        .doc(crusade.documentUID)
        .collection(rosterCollectionName)
        .doc(unit.documentUID)
        .update(unit.toJson());
  }

  Future<List<CrusadeUnitDataModel>> getRoster(
      {required String crusadeUID}) async {
    logger.i("Getting Roster for : $crusadeUID");
    List<CrusadeUnitDataModel> roster = [];
    var rosterRef = _crusadeCollectionRef
        .doc(crusadeUID)
        .collection(rosterCollectionName)
        .withConverter<CrusadeUnitDataModel>(
          fromFirestore: (snapshot, _) =>
              CrusadeUnitDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (unit, _) => unit.toJson(),
        );

    List<QueryDocumentSnapshot<CrusadeUnitDataModel>> rosterSnapshot =
        await rosterRef.get().then((snapshot) => snapshot.docs);

    logger.i("We found ${rosterSnapshot.length} Units in Rotser");
    rosterSnapshot.forEach((element) => roster.add(element.data()));

    return roster;
  }

  Future<void> deleteRoster(CrusadeDataModel crusade) async {
    logger.i('Deleting Crusade : ${crusade.name} roster');
    CollectionReference<CrusadeUnitDataModel> rosterRef = _crusadeCollectionRef
        .doc(crusade.documentUID)
        .collection(rosterCollectionName)
        .withConverter<CrusadeUnitDataModel>(
          fromFirestore: (snapshot, _) =>
              CrusadeUnitDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (unit, _) => unit.toJson(),
        );

    List<QueryDocumentSnapshot<CrusadeUnitDataModel>> rosterSnapshot =
        await rosterRef.get().then((snapshot) => snapshot.docs);

    rosterSnapshot.forEach((element) =>
        _removeUnitFromRosterWithOutCrusadeUpdate(
            crusadeUID: crusade.documentUID!, unitToRemove: element.data()));

    await _crusadeCollectionRef
        .doc(crusade.documentUID)
        .update({kSupplyUsed: 0});
  }

  Future<void> deleteRemoveUnitFromRoster(
      {required CrusadeDataModel crusade,
      required CrusadeUnitDataModel unitToDelete}) async {
    await updateCrusade(crusade.copyWith(
        supplyUsed: crusade.supplyUsed - unitToDelete.powerRating));

    await _removeUnitFromRosterWithOutCrusadeUpdate(
      crusadeUID: crusade.documentUID!,
      unitToRemove: unitToDelete,
    );
  }

  Future<void> deleteBattle({
    required CrusadeDataModel crusade,
    required BattleDataModel battle,
  }) async {
    // Update crusade Win / Loss based on the deleted battle.

    if (battle.score > battle.opponentScore) {
      // Victory
      await updateCrusade(
        crusade.copyWith(
          victories: crusade.victories - 1,
          battleTally: crusade.battleTally - 1,
        ),
      );
    } else {
      // Loss or defeat
      await updateCrusade(
        crusade.copyWith(
          battleTally: crusade.battleTally - 1,
        ),
      );
    }
    // delete all unit performances from battle
    // delete battle
    await _deleteBattleWithoutCrusadeOrUnitUpdates(
        crusadeUID: crusade.documentUID!, battleToDelete: battle);
  }

  Future recordBattle({
    required CrusadeDataModel crusade,
    required BattleDataModel battle,
    required List<CrusadeUnitBattlePerformanceDataModel> unitPerformanceList,
  }) async {
    // Update Crusade battle and victory counts

    CollectionReference<BattleDataModel> battleCollectionRef =
        _crusadeCollectionRef
            .doc(crusade.documentUID)
            .collection(battlesCollectionName)
            .withConverter<BattleDataModel>(
              fromFirestore: (snapshot, _) =>
                  BattleDataModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (battle, _) => battle.toJson(),
            );

    CrusadeDataModel updatedCrusade = crusade.copyWith(
      battleTally: crusade.battleTally + 1,
      victories: battle.score > battle.opponentScore
          ? crusade.victories + 1
          : crusade.victories,
    );
    await updateCrusade(updatedCrusade);
    DocumentReference<BattleDataModel> docRef =
        await battleCollectionRef.add(battle);

    unitPerformanceList.forEach((unitPerformance) async {
      await battleCollectionRef
          .doc(docRef.id)
          .collection(unitPerformanceCollectionName)
          .withConverter<CrusadeUnitBattlePerformanceDataModel>(
            fromFirestore: (snapshot, _) =>
                CrusadeUnitBattlePerformanceDataModel.fromJson(
                    snapshot.data()!, snapshot.id),
            toFirestore: (unitPerformance, _) => unitPerformance.toJson(),
          )
          .doc(unitPerformance.unit!.documentUID)
          .set(unitPerformance);
    });
  }

  Future<void> _deleteAllBattles(CrusadeDataModel crusade) async {
    CollectionReference<BattleDataModel> battlesRef = _crusadeCollectionRef
        .doc(crusade.documentUID)
        .collection(battlesCollectionName)
        .withConverter<BattleDataModel>(
          fromFirestore: (snapshot, _) =>
              BattleDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (battle, _) => battle.toJson(),
        );

    List<QueryDocumentSnapshot<BattleDataModel>> battlesSnapshot =
        await battlesRef.get().then((snapshot) => snapshot.docs);

    battlesSnapshot.forEach((element) async {
      QuerySnapshot<CrusadeUnitBattlePerformanceDataModel>
          battleUnitPerformanceList = await battlesRef
              .doc(element.id)
              .collection(unitPerformanceCollectionName)
              .withConverter<CrusadeUnitBattlePerformanceDataModel>(
                fromFirestore: (snapshot, _) =>
                    CrusadeUnitBattlePerformanceDataModel.fromJson(
                        snapshot.data()!, snapshot.id),
                toFirestore: (unitPerformance, _) => unitPerformance.toJson(),
              )
              .get();

      // Delete Each Unit Performance Document without updating the unit cards.
      battleUnitPerformanceList.docs.forEach((element) async {
        await battlesRef
            .doc(element.id)
            .collection(unitPerformanceCollectionName)
            .doc(element.id)
            .delete();
      });
      // Delete the Battle Record Document
      _deleteBattleWithoutCrusadeOrUnitUpdates(
          crusadeUID: crusade.documentUID!, battleToDelete: element.data());
    });
  }

  Future<void> _deleteBattleWithoutCrusadeOrUnitUpdates(
      {required String crusadeUID,
      required BattleDataModel battleToDelete}) async {
    CollectionReference<BattleDataModel> battlesRef = _crusadeCollectionRef
        .doc(crusadeUID)
        .collection(battlesCollectionName)
        .withConverter<BattleDataModel>(
          fromFirestore: (snapshot, _) =>
              BattleDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (battle, _) => battle.toJson(),
        );

    await battlesRef.doc(battleToDelete.documentUID).delete();
  }

  Future<void> _removeUnitFromRosterWithOutCrusadeUpdate(
      {required String crusadeUID,
      required CrusadeUnitDataModel unitToRemove}) async {
    var rosterRef = _crusadeCollectionRef
        .doc(crusadeUID)
        .collection(rosterCollectionName)
        .withConverter<CrusadeUnitDataModel>(
          fromFirestore: (snapshot, _) =>
              CrusadeUnitDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (unit, _) => unit.toJson(),
        );

    await rosterRef
        .doc(unitToRemove.documentUID)
        .delete()
        .then((value) => logger.w(
            'Firestore: Unit ${unitToRemove.documentUID} removed from roster'))
        .catchError((error) => logger.e(error));
  }
}
