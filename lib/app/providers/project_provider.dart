import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:flutter/material.dart';

import '../models/project.dart';
import '../widget/custom_dialog_widget.dart';

class ProjectProvider extends ChangeNotifier {
  List cashes = [];
  List projects = [];
  Project? currentProject;

  
  void changeProject({required Project? project}) {
    currentProject = project;
    notifyListeners();
  }

  void changeProjects(newProjects) {
    projects = newProjects;
    notifyListeners();
  }

  void getProjects({
    required String uId,
  }) async {
    projects =
        await FirebaseFirestoreManager.getAllProjectByUserId(userId: uId);
    notifyListeners();
  }

  void addProject({
    required Project project,
    required String uId,
    required BuildContext context,
  }) async {
    try {
      DialogUtls.showLoading(context: context, message: 'Adding now...');
      await FirebaseFirestoreManager.addProjects(
        project: project,
        userId: uId,
      );
      getProjects(uId: uId);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(context: context, message: 'Added Successfully');
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }

  void updateProject({
    required Project project,
    required userId,
    required BuildContext context,
  }) async {
    try {
      DialogUtls.showLoading(context: context, message: 'Updating now...');
      await FirebaseFirestoreManager.updateProject(
        project: project,
        userId: userId,
      );
      getProjects(uId: userId);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(context: context, message: 'Added Successfully');
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }

  void deleteProject({
    required Project project,
    required String userId,
    required BuildContext context,
  }) async {
    await FirebaseFirestoreManager.removeProjectById(
      userId: userId,
      projectId: project.id!,
    );
    print('Deleteeeeeeeeeeeeeeeeeeeeeed');
    getProjects(uId: userId);
    // try {
    //   DialogUtls.showLoading(context: context, message: 'Deleting now...');
    //   await FirebaseFirestoreManager.removeProjectById(
    //     userId: userId,
    //     projectId: project.id!,
    //   );
    //   getProjects(uId: userId);
    //   DialogUtls.hideLoading(context: context);
    //   DialogUtls.showMessage(context: context, message: 'Deleted Successfully');
    //   // Navigator.pop(context);
    //   // Navigator.pop(context);
    // } catch (e) {
    //   if (context.mounted) {
    //     DialogUtls.hideLoading(context: context);
    //     DialogUtls.showMessage(context: context, message: e.toString());
    //     // Navigator.pop(context);
    //   }
    // }
  }
}
