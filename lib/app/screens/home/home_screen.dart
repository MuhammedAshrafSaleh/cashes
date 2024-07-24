import 'package:cashes/app/models/project.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../core/utls.dart';
import '../../providers/auth_manager_provider.dart';
import '../../providers/project_provider.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_textfield.dart';
import 'project_list_widget.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  static const String routeName = 'Home-Screen';
  var projectProvider;
  var authProvider;
  @override
  Widget build(BuildContext context) {
    projectProvider = Provider.of<ProjectProvider>(context);
    authProvider = Provider.of<AuthManagerProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: ProjectListWidget(user: authProvider.currentUser),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.white,
          onPressed: () {
            showFormDialog(context);
          },
          child: const Icon(Icons.add, color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  void showFormDialog(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final moneyController = TextEditingController();
    final typeController = TextEditingController();
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
                        text: 'Add Project',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            projectProvider.addProject(
                              Project(
                                id: '${projectProvider.projects.length}',
                                name: nameController.text,
                                money: moneyController.text,
                                date: formatDate(DateTime.now().toString()),
                                type: typeController.text,
                                userId: authProvider.currentUser.id,
                              ),
                            );
                            print(nameController.text);
                            print(moneyController.text);
                            nameController.clear();
                            moneyController.clear();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added successfully!'),
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
