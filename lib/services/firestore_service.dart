import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String crusadeCollectionName = 'crusade';

  final CollectionReference _crusadeCollection =
      _db.collection(crusadeCollectionName);
  // final StreamController<List<CrusadeDataModel>> _crusadeStreamController =
  //     StreamController<List<CrusadeDataModel>>.broadcast();
}
