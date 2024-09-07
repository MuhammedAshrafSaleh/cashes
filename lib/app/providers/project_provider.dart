import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/core/utls.dart';
import 'package:cashes/app/models/cash.dart';
import 'package:flutter/material.dart';

import '../core/firebase configurations/firebase_storage_manager.dart';
import '../models/project.dart';
import '../widget/custom_dialog_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectProvider extends ChangeNotifier {
  List cashes = [];
  List projects = [];
  Project? currentProject;
  int total = 0;
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
    total = 0;
    for (Project project in projects) {
      total += int.parse(project.money!);
    }
    notifyListeners();
  }

  getTotalMoney() {
    total = 0;
    for (Project project in projects) {
      total += int.parse(project.money!);
    }
    notifyListeners();
  }

  void addProject({
    required Project project,
    required String uId,
    required BuildContext context,
  }) async {
    try {
      DialogUtls.showLoading(
          context: context, message: AppLocalizations.of(context)!.addingNow);
      await FirebaseFirestoreManager.addProjects(
        project: project,
        userId: uId,
      );
      getProjects(uId: uId);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.addSucceccfuly);
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
      DialogUtls.showLoading(
          context: context, message: AppLocalizations.of(context)!.updatingNow);
      await FirebaseFirestoreManager.updateProject(
        project: project,
        userId: userId,
      );
      getProjects(uId: userId);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.addSucceccfuly);
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
    List<Cash> cashes = await FirebaseFirestoreManager.getAllCashes(
      userId: userId,
      projectId: project.id,
    );
    for (var cash in cashes) {
      await FirebaseStorageManager.deleteCashImage(
          cashId: getIdfromImage(url: cash.imageURl!));
    }
    await FirebaseFirestoreManager.removeProjectById(
      userId: userId,
      projectId: project.id!,
    );
    getProjects(uId: userId);
    DialogUtls.hideLoading(context: context);
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
