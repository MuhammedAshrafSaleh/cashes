// ignore_for_file: must_be_immutable
import 'package:cashes/app/core/firebase%20configurations/firebase_auth_manager.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/screens/auth/login.dart';
import 'package:cashes/app/widget/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../models/app_user.dart';
import '../../providers/project_provider.dart';
import 'project_item_widget.dart';

class ProjectListWidget extends StatelessWidget {
  ProjectListWidget({super.key, required this.user});
  AppUser user;
  @override
  Widget build(BuildContext context) {
    var authProvder = Provider.of<AuthManagerProvider>(context, listen: false);
    var name = user.name ?? 'Zmzm User';
    return Consumer<ProjectProvider>(builder:
        (BuildContext context, ProjectProvider projectProvider, Widget? child) {
      return Padding(
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
                      authProvder.updateUser(null);
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
      );
    });
  }
}
