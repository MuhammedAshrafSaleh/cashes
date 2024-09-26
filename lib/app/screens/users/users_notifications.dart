import 'package:cashes/app/core/theme.dart';
import 'package:cashes/app/models/app_user.dart';
import 'package:cashes/app/models/project.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/project_provider.dart';
import 'package:cashes/app/screens/cash/cash_screen.dart';
import 'package:cashes/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersNotifications extends StatefulWidget {
  static const String routeName = "UsersNotifications";
  const UsersNotifications({super.key});

  @override
  State<UsersNotifications> createState() => _UsersNotificationsState();
}

class _UsersNotificationsState extends State<UsersNotifications> {
  @override
  void initState() {
    super.initState();
    // Schedule the data fetch after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Accessing the provider to fetch the data
      Provider.of<AuthManagerProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthManagerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("الإشعارات"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          authProvider.fetchUsers();
        },
        child: authProvider.notifications.isEmpty
            ? const Loader(
                color1: AppTheme.primaryColor,
                color2: AppTheme.secondaryColor,
              ) // Loading indicator
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: authProvider.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = authProvider.notifications[index];
                        // print(authProvider.notifications.length);
                        // print(notification.values.first.name);
                        // print(notification.keys.first.name);
                        return titleWidget(notification);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  titleWidget(notification) {
    final authProvider = Provider.of<AuthManagerProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final String projectName = notification.values.first.name;
    final String messageType = notification.values.first.hasNotification;
    Project project = notification.values.first;
    AppUser user = notification.keys.first;
    // final String userName = notification.keys.first.name;
    final String message = "$messageType بند فى عهدة $projectName";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        color: AppTheme.primaryColor,
      ),
      child: InkWell(
        onTap: () async {
          await authProvider.removeNotification(
            notification.values.first,
            notification.keys.first,
          );
          authProvider.updateUser(user);
          projectProvider.changeProject(project: project);
          if (projectProvider.currentProject != null) {
            Navigator.pushNamed(
              context,
              CashScreen.routeName,
              arguments: project,
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.keys.first.name!,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              message,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
