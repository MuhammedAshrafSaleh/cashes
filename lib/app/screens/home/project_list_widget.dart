// ignore_for_file: must_be_immutable
import 'package:cashes/app/core/firebase%20configurations/firebase_auth_manager.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/screens/auth/login.dart';
import 'package:cashes/app/widget/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme.dart';
import '../../core/utls.dart';
import '../../models/app_user.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_textfield.dart';
import 'project_item_widget.dart';

class ProjectListWidget extends StatelessWidget {
  ProjectListWidget({super.key, required this.user});
  AppUser user;
  var projectProvider;
  var authProvider;
  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthManagerProvider>(context, listen: false);
    var name = user.name ?? 'Zmzm User';
    return Consumer<ProjectProvider>(builder:
        (BuildContext context, ProjectProvider projectProvider, Widget? child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $name',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        'Here\'re your projects, $name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        FirebaseAuthManager.signOut();
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                        authProvider.updateUser(null);
                      },
                      icon: const Icon(Icons.logout)),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: projectProvider.projects.isEmpty
                    ? EmptyScreen(message: 'No Projects Yet!')
                    : ListView.builder(
                        itemCount: projectProvider.projects.length,
                        itemBuilder: (context, index) {
                          return ProjectItem(
                            project: projectProvider.projects[index],
                            user: user,
                          );
                        },
                      ),
              )
            ],
          ),
        ),
        // floatingActionButton: Container(
        //   margin: const EdgeInsets.only(bottom: 10),
        //   child: FloatingActionButton(
        //     backgroundColor: AppTheme.white,
        //     onPressed: () {
        //       showFormDialog(context);
        //     },
        //     child: const Icon(Icons.add, color: AppTheme.primaryColor),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
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
                          var uuid = const Uuid();
                          if (formKey.currentState!.validate()) {
                            projectProvider.addProject(
                              project: Project(
                                id: uuid.v4(),
                                name: nameController.text,
                                money: moneyController.text,
                                date: formatDate(DateTime.now().toString()),
                                type: typeController.text,
                                userId: authProvider.currentUser.id,
                              ),
                              uId: authProvider.currentUser.id,
                            );
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
