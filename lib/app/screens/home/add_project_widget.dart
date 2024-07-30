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
    // final moneyController =
    //     TextEditingController(text: isAdd ? '' : project!.money);
    final typeController =
        TextEditingController(text: isAdd ? '' : project!.type);
    return AlertDialog(
      backgroundColor: AppTheme.white,
      title: const Text(
        'Project Details',
        style: TextStyle(
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
                    text: 'Please Enter Project Name',
                    keyboardType: TextInputType.text,
                    hasIcon: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter project name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: typeController,
                    text: 'Please Enter the type',
                    keyboardType: TextInputType.text,
                    hasIcon: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomBtn(
                    text: isAdd ? 'Add Project' : 'Update Project',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var uuid = const Uuid();
                        isAdd
                            ? projectProvider.addProject(
                                project: Project(
                                  id: uuid.v4(),
                                  name: nameController.text,
                                  // money: moneyController.text,
                                  date: formatDate(DateTime.now().toString()),
                                  type: typeController.text,
                                  userId: authProvider.currentUser!.id!,
                                ),
                                uId: authProvider.currentUser!.id!,
                              )
                            : projectProvider.updateProject(
                                project: Project(
                                  id: project!.id,
                                  name: nameController.text,
                                  // money: moneyController.text,
                                  date: project!.date,
                                  type: typeController.text,
                                  userId: authProvider.currentUser!.id,
                                ),
                                userId: authProvider.currentUser!.id,
                              );
                        print(nameController.text);
                        // print(moneyController.text);
                        nameController.clear();
                        // moneyController.clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAdd
                                  ? 'Add Successfully!'
                                  : 'Updated successfully!',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
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
