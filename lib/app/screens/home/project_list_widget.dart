// ignore_for_file: must_be_immutable
import 'package:cashes/app/core/firebase%20configurations/firebase_auth_manager.dart';
import 'package:cashes/app/models/cash.dart';
import 'package:cashes/app/providers/cash_provider.dart';
import 'package:cashes/app/screens/auth/login.dart';
import 'package:cashes/app/widget/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/app_user.dart';
import '../../providers/project_provider.dart';
import 'project_item_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectListWidget extends StatelessWidget {
  ProjectListWidget({super.key, required this.user});
  AppUser user;
  @override
  Widget build(BuildContext context) {
    var cashProvider = Provider.of<CashProvider>(context);
    var name = user.name ?? 'Zmzm User';
    return Consumer<ProjectProvider>(
      builder: (
        BuildContext context,
        ProjectProvider projectProvider,
        Widget? child,
      ) {
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
                        '${AppLocalizations.of(context)!.welcome}, $name',
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.yourProjects}, $name',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        FirebaseAuthManager.signOut();
                        projectProvider.changeProject(project: null);
                        projectProvider.changeProjects([]);
                        cashProvider.changeCurrentImage(null);
                        cashProvider.changeCashes(<Cash>[]);
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
                        );
                      },
                      icon: const Icon(Icons.logout)),
                ],
              ),
              const SizedBox(height: 10),
              projectProvider.projects.isEmpty
                  ? EmptyScreen(
                      message: AppLocalizations.of(context)!.noProjects)
                  : Expanded(
                      child: ListView.builder(
                        itemCount: projectProvider.projects.length,
                        itemBuilder: (context, index) {
                          return ProjectItem(
                            project: projectProvider.projects[index],
                            user: user,
                          );
                        },
                      ),
                    ),
              projectProvider.projects.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey[200],
                      child: Text(
                        '${AppLocalizations.of(context)!.total}: ${projectProvider.total}',
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
