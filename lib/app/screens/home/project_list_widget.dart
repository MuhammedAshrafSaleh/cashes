// ignore_for_file: must_be_immutable
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
    var projectProvider = Provider.of<ProjectProvider>(context);
    var name = user.name ?? 'Zmzm User';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Text(
            'Welcome, $name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          Text(
            'Here\'re your projects, $name',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGrey),
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
  }
}
