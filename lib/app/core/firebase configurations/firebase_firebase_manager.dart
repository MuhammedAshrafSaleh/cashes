import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/app_user.dart';

class FirebaseFirestoreManager {
  static CollectionReference<AppUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(AppUser.collectionName)
        .withConverter(
            fromFirestore: (snapshot, options) => AppUser.fromFirestore(
                  snapshot.data()!,
                ),
            toFirestore: (appUser, options) => appUser.toFireStore());
  }

  static Future<void> addUserToFireStore({required AppUser user}) {
    return getUsersCollection().doc(user.id).set(user);
  }

  static Future<AppUser?> getUser({required String userId}) async {
    var userSnapshot = await getUsersCollection().doc(userId).get();
    return userSnapshot.data();
  }
}
