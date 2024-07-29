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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      projectProvider.getProjects(uId: authProvider.currentUser.id);
    });
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    projectProvider = Provider.of<ProjectProvider>(context);
    authProvider = Provider.of<AuthManagerProvider>(context, listen: false);
    return Scaffold(
      body: ProjectListWidget(user: authProvider.currentUser),
      // selectedIndex == 0
      //     ? ProjectListWidget(user: authProvider.currentUser)
      //     : const ClientMoney(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.white,
        onPressed: () {
          showProjectDialog(context: context, isAdd: true, project: null);
        },
        child: const Icon(Icons.add, color: AppTheme.primaryColor),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: selectedIndex,
      //   onTap: (currentIndex) {
      //     setState(() {
      //       selectedIndex = currentIndex;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Projects',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.money),
      //       label: 'Clients Transefer',
      //     ),
      //   ],
      // ),
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
