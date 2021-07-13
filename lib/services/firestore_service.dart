import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/data_models/crusade_unit_data_model.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuthenicationService _auth =
      locator<FirebaseAuthenicationService>();
  static const String crusadeCollectionName = 'crusade';
  static const String rosterCollectionName = 'roster';

  final _crusadeCollectionRef =
      _db.collection(crusadeCollectionName).withConverter<CrusadeDataModel>(
            fromFirestore: (snapshot, _) =>
                CrusadeDataModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (crusade, _) => crusade.toJson(),
          );

  final StreamController<List<CrusadeDataModel>> _crusadeController =
      StreamController<List<CrusadeDataModel>>.broadcast();

  Stream<List<CrusadeDataModel>> listenToCrusadesRealTime() {
    logger.i('Firestore: Started Listening to Crusades In Real Time');
    _crusadeCollectionRef
        .where(kUserUID, isEqualTo: _auth.currentUser!.uid)
        .orderBy(kCreatedAt, descending: false)
        .snapshots()
        .listen((crusadeSnapshots) {
      if (crusadeSnapshots.docs.isNotEmpty) {
        logger.i('New Crusades Realtime Snapshot');
        List<CrusadeDataModel> crusades =
            crusadeSnapshots.docs.map((crusade) => crusade.data()).toList();
        logger.i('Number of documents ${crusades.length}\n$crusades');
        _crusadeController.add(crusades);
      }
    });

    return _crusadeController.stream;
  }

  Future<List<CrusadeDataModel>> getCrusadeDataOneTime() async {
    List<CrusadeDataModel> crusades = [];

    List<QueryDocumentSnapshot<CrusadeDataModel>> crusadesSnapshot =
        await _crusadeCollectionRef.get().then((snapshot) => snapshot.docs);

    crusadesSnapshot.forEach((element) => crusades.add(element.data()));

    return crusades;
  }

  Future createNewCrusade(CrusadeDataModel crusade) async {
    logger.i('Firestore: Creating New Crusade');
    await _crusadeCollectionRef.add(crusade);
    logger.i('Firestore: New Crusade Created');
  }

  Future deleteCrusade(CrusadeDataModel crusade) async {
    logger.w('Firestore: Deleting Crusade');
    await deleteRoster(crusade.documentUID!);

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

  Future<CrusadeDataModel?> getCrusadeByUID(String documentUID) async {
    logger.i('Getting Crusade: $documentUID');

    DocumentSnapshot<CrusadeDataModel> snapshot =
        await _crusadeCollectionRef.doc(documentUID).get();

    CrusadeDataModel? crusade = snapshot.data();

    return crusade;
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

  Future<void> deleteRoster(String crusadeUID) async {
    logger.i('Deleting Crusade : $crusadeUID roster');
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

    rosterSnapshot.forEach((element) => deleteRemoveUnitFromRoster(
        crusadeUID: crusadeUID, unitUID: element.id));

    await _crusadeCollectionRef.doc(crusadeUID).update({kSupplyUsed: 0});
  }

  Future<void> deleteRemoveUnitFromRoster(
      {required String crusadeUID, required String unitUID}) async {
    var rosterRef = _crusadeCollectionRef
        .doc(crusadeUID)
        .collection(rosterCollectionName)
        .withConverter<CrusadeUnitDataModel>(
          fromFirestore: (snapshot, _) =>
              CrusadeUnitDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (unit, _) => unit.toJson(),
        );

    await rosterRef
        .doc(unitUID)
        .delete()
        .then(
            (value) => logger.w('Firestore: Unit $unitUID removed from roster'))
        .catchError((error) => logger.e(error));
  }
}
