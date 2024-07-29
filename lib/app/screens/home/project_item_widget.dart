// ignore: must_be_immutable
import 'package:cashes/app/providers/project_provider.dart';
import 'package:cashes/app/screens/cash/cash_screen.dart';
import 'package:cashes/app/widget/custom_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import 'add_project_widget.dart';

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
                showProjectDialog(
                  context: context,
                  isAdd: false,
                  project: project,
                );
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
              projectProvider.changeProject(project: project);
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

  void showProjectDialog({
    required BuildContext context,
    required bool isAdd,
    project,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUpdateProject(
          isAdd: isAdd,
          project: project,
        );
      },
    );
  }
}
