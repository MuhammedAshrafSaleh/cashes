import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import '../../models/cash.dart';
import '../../models/client_transefer.dart';
import '../../models/project.dart';

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

  static Future<List<AppUser>> getAllUsers() async {
    try {
      // Get the users collection reference
      var usersCollection = getUsersCollection();

      // Fetch all users
      var querySnapshot = await usersCollection.get();

      // Map the fetched documents into a list of AppUser objects
      List<AppUser> users =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      return users;
    } catch (e) {
      // Handle any errors here (e.g., logging)
      print("Error fetching users: $e");
      return [];
    }
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
    required Project project,
    required String userId,
  }) async {
    return getProjectsCollection(userId: userId).doc(project.id).set(project);
  }

  static Future<List<Project>> getAllProjectByUserId({
    required String userId,
  }) {
    return getProjectsCollection(userId: userId).get().then((project) {
      return project.docs.map((project) => project.data()).toList();
    });
  }

  static Future updateProject(
      {required Project project, required userId}) async {
    return getProjectsCollection(userId: userId)
        .doc(project.id)
        .update(project.toFirestore());
  }

  static Future<void> removeProjectById({
    required String userId,
    required String projectId,
  }) {
    return getProjectsCollection(userId: userId).doc(projectId).delete();
  }

  static CollectionReference<Cash> getCashesCollections(
      {required userId, required projectId}) {
    return getUsersCollection()
        .doc(userId)
        .collection(Project.collectionName)
        .doc(projectId)
        .collection(Cash.collectionName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Cash.fromFirestore(snapshot.data()!),
          toFirestore: (cash, options) => cash.toFirestore(),
        );
  }

  static Future<List<Cash>> getAllCashes({
    required userId,
    required projectId,
  }) async {
    return getCashesCollections(userId: userId, projectId: projectId)
        .get()
        .then((cash) {
      return cash.docs.map((cash) => cash.data()).toList();
    });
  }

  static Future addtCashesByUserIdAndProjectId({
    required Cash cash,
    required userId,
    required projectId,
  }) async {
    return getCashesCollections(userId: userId, projectId: projectId)
        .doc(cash.id)
        .set(cash);
  }

  static Future updateCash({
    required cash,
    required projectId,
    required userId,
  }) async {
    return getCashesCollections(userId: userId, projectId: projectId)
        .doc(cash.id)
        .update(cash.toFirestore());
  }

  static Future deleteCashByUserIdAndProjectId({
    required Cash cash,
    required userId,
    required projectId,
  }) async {
    return getCashesCollections(userId: userId, projectId: projectId)
        .doc(cash.id)
        .delete();
  }

  static CollectionReference<ClientTransefer> getClientsTranferCollection(
      {required userId, required projectId}) {
    return getUsersCollection()
        .doc(userId)
        .collection(Project.collectionName)
        .doc(projectId)
        .collection(ClientTransefer.collectionName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              ClientTransefer.fromFirestore(snapshot.data()!),
          toFirestore: (client, options) => client.toFirestore(),
        );
  }

  static Future<List<ClientTransefer>> getAllClientTransfers({
    required userId,
    required projectId,
  }) async {
    return getClientsTranferCollection(userId: userId, projectId: projectId)
        .get()
        .then((clientTransfer) {
      return clientTransfer.docs
          .map((clientTransfer) => clientTransfer.data())
          .toList();
    });
  }

  static Future addClientTranserfer({
    required userId,
    required projectId,
    required ClientTransefer client,
  }) async {
    return getClientsTranferCollection(userId: userId, projectId: projectId)
        .doc(client.id)
        .set(client);
  }

  static Future deleteClientTransfer({
    required userId,
    required projectId,
    required ClientTransefer client,
  }) async {
    return getClientsTranferCollection(userId: userId, projectId: projectId)
        .doc(client.id)
        .delete();
  }

  static Future updateClientTransfer({
    required userId,
    required projectId,
    required ClientTransefer client,
  }) async {
    return getClientsTranferCollection(userId: userId, projectId: projectId)
        .doc(client.id)
        .update(client.toFirestore());
  }
}
