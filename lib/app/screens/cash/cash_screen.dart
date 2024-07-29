import 'package:cashes/app/core/pdf_api.dart';
import 'package:cashes/app/models/invoice.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/cash_provider.dart';
import 'package:cashes/app/screens/cash/cash_list_widget.dart';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';
import 'cash_add_update_widget.dart';
import 'cash_images_widget.dart';
import 'clients_money_widget.dart';

class CashScreen extends StatefulWidget {
  static const String routeName = 'Cash-Screen';
  const CashScreen({super.key});
  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  // Future<void> requestStoragePermission() async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     status = await Permission.storage.request();
  //     if (status.isGranted) {
  //       print("Storage permission granted");
  //     } else {
  //       print("Storage permission denied");
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      final authProvider =
          Provider.of<AuthManagerProvider>(context, listen: false);
      final cashProvider = Provider.of<CashProvider>(context, listen: false);
      cashProvider.getCashes(
        userId: authProvider.currentUser!.id!,
        projectId: projectProvider.currentProject!.id!,
      );
    });
  }

  // var cashProvider;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var project = ModalRoute.of(context)!.settings.arguments as Project;
    var cashProvider = Provider.of<CashProvider>(context);
    var authProvider = Provider.of<AuthManagerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name ?? 'Zmzm Project'),
        toolbarHeight: 80.0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              PdfApi.createPdf(
                Invoice(
                  projectName: project.name!,
                  engineerName: authProvider.currentUser!.name!,
                  items: cashProvider.cashes,
                ),
              );
            },
            icon: const Icon(Icons.print),
          ),
        ],
      ),
      body: screens[selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInvoiceDialog(context: context, isAdd: false);
        },
        child: const Icon(Icons.add, color: AppTheme.primaryColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (currentIndex) {
          setState(() {
            selectedIndex = currentIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_center),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_rounded),
            label: 'Clients Transfer',
          ),
        ],
      ),
    );
  }

  List<Widget> screens = const [
    CashListWidget(),
    CashImagesWidget(),
    ClientMoney(),
  ];

  void showInvoiceDialog({
    required BuildContext context,
    required bool isAdd,
    index,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUpdateTask(isAdd: isAdd, index: index);
      },
    );
  }
}
