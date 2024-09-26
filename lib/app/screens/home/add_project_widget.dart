import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme.dart';
import '../../core/utls.dart';
import '../../models/project.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class AddUpdateProject extends StatelessWidget {
  AddUpdateProject({super.key, required this.isAdd, this.project});
  bool isAdd;
  Project? project;
  @override
  Widget build(BuildContext context) {
    var projectProvider = Provider.of<ProjectProvider>(context);
    var authProvider = Provider.of<AuthManagerProvider>(context);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameController =
        TextEditingController(text: isAdd ? '' : project!.name);
    final typeController =
        TextEditingController(text: isAdd ? '' : project!.type);
    return AlertDialog(
      backgroundColor: AppTheme.white,
      title: Text(
        AppLocalizations.of(context)!.projectDetails,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    controller: nameController,
                    text: AppLocalizations.of(context)!.enterProjectName,
                    keyboardType: TextInputType.text,
                    hasIcon: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterProjectName;
                      }
                      return null;
                    },
                  ),
                  // const SizedBox(height: 20),
                  // CustomTextFormField(
                  //   controller: typeController,
                  //   text: AppLocalizations.of(context)!.enterProjectType,
                  //   keyboardType: TextInputType.text,
                  //   hasIcon: false,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return AppLocalizations.of(context)!.enterProjectType;
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  CustomBtn(
                    text: isAdd
                        ? AppLocalizations.of(context)!.addProject
                        : AppLocalizations.of(context)!.updateProject,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var uuid = const Uuid();
                        isAdd
                            ? projectProvider.addProject(
                                project: Project(
                                  id: uuid.v4(),
                                  name: nameController.text,
                                  money: '0',
                                  date: formatDate(DateTime.now().toString()),
                                  type: formateTime(DateTime.now()),
                                  userId: authProvider.currentUser!.id!,
                                ),
                                uId: authProvider.currentUser!.id!,
                                context: context,
                              )
                            : projectProvider.updateProject(
                                project: Project(
                                  id: project!.id,
                                  name: nameController.text,
                                  money: project!.money ?? '0',
                                  date: project!.date,
                                  type: '',
                                  userId: authProvider.currentUser!.id,
                                ),
                                userId: authProvider.currentUser!.id,
                                context: context,
                              );

                        nameController.clear();
                        typeController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
