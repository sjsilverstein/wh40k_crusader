import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wh40k_crusader/data_models/crusade_data_model.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String crusadeCollectionName = 'crusade';

  final _crusadeCollectionRef =
      _db.collection(crusadeCollectionName).withConverter<CrusadeDataModel>(
            fromFirestore: (snapshot, _) =>
                CrusadeDataModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (crusade, _) => crusade.toJson(),
          );

  Future<List<CrusadeDataModel>> getCrusadeDataOneTime() async {
    List<CrusadeDataModel> crusades = [];

    List<QueryDocumentSnapshot<CrusadeDataModel>> crusadesSnapshot =
        await _crusadeCollectionRef.get().then((snapshot) => snapshot.docs);

    crusadesSnapshot.forEach((element) => crusades.add(element.data()));

    return crusades;
  }

  Future createNewCrusade(CrusadeDataModel crusade) async {
    await _crusadeCollectionRef.add(crusade);
  }

  Future deleteCrusade(CrusadeDataModel crusade) async {
    _crusadeCollectionRef
        .doc(crusade.documentUID)
        .delete()
        .then((value) => print('Crusade Deleted'))
        .catchError((err) => print(err));
  }
}
