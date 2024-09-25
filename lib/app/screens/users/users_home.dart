import 'package:cashes/app/core/theme.dart';
import 'package:cashes/app/models/app_user.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/screens/home/home_screen.dart';
import 'package:cashes/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersHome extends StatefulWidget {
  static const String routeName = "UsersHomeScreen";
  const UsersHome({super.key});

  @override
  State<UsersHome> createState() => _UsersHomeState();
}

class _UsersHomeState extends State<UsersHome> {
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
        title: const Text(
          'كل المستخدمين',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          authProvider.fetchUsers();
        },
        child: authProvider.users.isEmpty
            ? const Loader(
                color1: AppTheme.primaryColor,
                color2: AppTheme.secondaryColor,
              ) // Loading indicator
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: authProvider.users.length,
                      itemBuilder: (context, index) {
                        final user = authProvider.users[index];
                        return titleWidget(user);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  titleWidget(AppUser user) {
    final authProvider = Provider.of<AuthManagerProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        color: AppTheme.primaryColor,
      ),
      child: InkWell(
        onTap: () {
          authProvider.updateUser(user);
          Navigator.pushNamed(context, HomeScreen.routeName, arguments: true);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name!,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              user.email!,
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
