import 'package:cashes/app/widget/loader.dart';
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
  bool _isLoading = false;
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Schedule the initialization after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Access the providers now
      projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      authProvider = Provider.of<AuthManagerProvider>(context, listen: false);
      // Ensure authProvider is initialized
      if (authProvider.currentUser != null) {
        // projectProvider.getTotalMoney(uId: authProvider.currentUser!.id);
        projectProvider.getProjects(uId: authProvider.currentUser!.id);
        _fetchData();
      }
    });
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await projectProvider.getProjects(
        uId: authProvider.currentUser.id!,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    projectProvider = Provider.of<ProjectProvider>(context);
    authProvider = Provider.of<AuthManagerProvider>(context, listen: false);
    final bool showBackButton =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    if (_isLoading) {
      return const Loader(
        color1: AppTheme.primaryColor,
        color2: AppTheme.secondaryColor,
      );
    }
    return PopScope(
      canPop: showBackButton,
      child: Scaffold(
        body: RefreshIndicator(
            color: AppTheme.primaryColor,
            backgroundColor: AppTheme.white,
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              projectProvider.getTotalMoney();
              projectProvider.getProjects(uId: authProvider.currentUser.id!);
            },
            child: ProjectListWidget(user: authProvider.currentUser)),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.white,
          onPressed: () async {
            await authProvider.fetchUsers();
            showProjectDialog(context: context, isAdd: true, project: null);
          },
          child: const Icon(Icons.add, color: AppTheme.primaryColor),
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
