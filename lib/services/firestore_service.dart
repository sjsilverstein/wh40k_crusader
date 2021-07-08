import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wh40k_crusader/app/app_constants.dart';
import 'package:wh40k_crusader/app/app_logger.dart';
import 'package:wh40k_crusader/app/locator.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';
import 'package:wh40k_crusader/services/firebase_auth_service.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuthenicationService _auth =
      locator<FirebaseAuthenicationService>();
  static const String crusadeCollectionName = 'crusade';

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
    await _crusadeCollectionRef
        .doc(crusade.documentUID)
        .delete()
        .then((value) => logger.w('Firestore: Crusade Deleted'))
        .catchError((err) => print(err));
  }
}
