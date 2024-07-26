import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/app_user.dart';
import '../../models/project.dart';

class FirebaseFirestoreManager {
  static var users = FirebaseFirestore.instance
      .collection(AppUser.collectionName)
      .withConverter(
          fromFirestore: (snapshot, options) => AppUser.fromFirestore(
                snapshot.data()!,
              ),
          toFirestore: (appUser, options) => appUser.toFireStore());
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

  static CollectionReference<Project> getProjectsCollection(
      {required String userId}) {
    return getUsersCollection()
        .doc(userId)
        .collection(Project.collectionName)
        .withConverter(
            fromFirestore: (snapshot, options) => Project.formFirestore(
                  snapshot.data()!,
                ),
            toFirestore: (project, options) => project.toFirestore());
  }

  static Future addProjects({
    required String userId,
    required projectId,
    required Project project,
  }) async {
    return getProjectsCollection(userId: userId).doc(projectId).set(project);
  }

  static Future<List<Project>> getAllProjectByUserId({
    required String userId,
  }) {
    return getProjectsCollection(userId: userId).get().then((project) {
      return project.docs.map((project) => project.data()).toList();
    });
  }
}
