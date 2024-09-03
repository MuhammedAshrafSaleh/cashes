import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_manager_provider.dart';
import '../../providers/project_provider.dart';
import 'add_project_widget.dart';
import 'project_list_widget.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const String routeName = 'Home-Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var projectProvider;
  var authProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Schedule the initialization after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the providers now
      projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      authProvider = Provider.of<AuthManagerProvider>(context, listen: false);

      // Ensure authProvider is initialized
      if (authProvider.currentUser != null) {
        // projectProvider.getTotalMoney(uId: authProvider.currentUser!.id);
        projectProvider.getProjects(uId: authProvider.currentUser!.id);
      }
    });
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    projectProvider = Provider.of<ProjectProvider>(context);
    authProvider = Provider.of<AuthManagerProvider>(context, listen: false);
    return Scaffold(
      body: ProjectListWidget(user: authProvider.currentUser),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.white,
        onPressed: () {
          showProjectDialog(context: context, isAdd: true, project: null);
        },
        child: const Icon(Icons.add, color: AppTheme.primaryColor),
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
