// ignore: must_be_immutable
import 'package:cashes/app/providers/project_provider.dart';
import 'package:cashes/app/screens/cash/cash_screen.dart';
import 'package:cashes/app/widget/custom_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/project.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_textfield.dart';

// ignore: must_be_immutable
class ProjectItem extends StatelessWidget {
  ProjectItem({super.key, required this.project, required this.user});
  var project;
  var projectProvider;
  var user;
  @override
  Widget build(BuildContext context) {
    projectProvider = Provider.of<ProjectProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                DialogUtls.showDeleteConfirmationDialog(
                    context: context,
                    deleteFunction: () {
                      // DialogUtls.showLoading(
                      //     context: context, message: 'Deleting Now...');
                      projectProvider.deleteProject(
                        project: project,
                        userId: user.id,
                      );
                      print('Deleted From this user ${user.id}');
                    });
                // DialogUtls.hideLoading(context: context);
              },
              backgroundColor: AppTheme.redColor,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: 'Delete Task',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: (context) {
                showFormDialog(context);
              },
              backgroundColor: AppTheme.lightBlue,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Edit',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            color: AppTheme.primaryColor,
          ),
          child: InkWell(
            onTap: () {
              projectProvider.getProject(project: project);
              Navigator.pushNamed(
                context,
                CashScreen.routeName,
                arguments: project,
              );
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${project.money}\$',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      project.date,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Text(
                      project.type,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showFormDialog(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: project.name);
    final moneyController = TextEditingController(text: project.money);
    final typeController = TextEditingController(text: project.type);
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                        controller: moneyController,
                        text: 'Please Enter The Money',
                        keyboardType: TextInputType.number,
                        hasIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter add money';
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
                        text: 'Update Project',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            print("=================================");
                            print(project.id);
                            print(project.name);
                            print(project.money);
                            print("=================================");
                            projectProvider.updateProject(
                              project: Project(
                                id: project.id,
                                name: nameController.text,
                                money: moneyController.text,
                                date: project.date,
                                type: typeController.text,
                                userId: user.id,
                              ),
                              userId: user.id,
                            );
                            print(nameController.text);
                            print(moneyController.text);
                            nameController.clear();
                            moneyController.clear();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Updated successfully!'),
                                duration: Duration(seconds: 2),
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
      },
    );
  }
}
