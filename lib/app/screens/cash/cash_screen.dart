import 'package:cashes/app/core/pdf_api.dart';
import 'package:cashes/app/models/invoice.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/cash_provider.dart';
import 'package:cashes/app/providers/clients_transefer_provider.dart';
import 'package:cashes/app/screens/cash/cash_list_widget.dart';
import 'package:cashes/app/widget/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme.dart';
import '../../core/utls.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';
import '../../widget/date_picker.dart';
import 'cash_add_update_widget.dart';
import 'cash_images_widget.dart';
import '../clients_transefer/client_transfer_add_update_widget.dart';
import '../clients_transefer/clients_money_widget.dart';

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
      final clientTranseferProvider =
          Provider.of<ClientsTranseferProvider>(context, listen: false);
      clientTranseferProvider.getAllClientTransfers(
          userId: authProvider.currentUser!.id!,
          projectId: projectProvider.currentProject!.id!);
      cashProvider.getCashes(
        userId: authProvider.currentUser!.id!,
        project: projectProvider.currentProject,
      );
    });
  }

  // var cashProvider;
  int selectedIndex = 0;
  bool isLoading = false;
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
              // showPrintDialog(
              //   context: context,
              //   onPressed: () {
              //     PdfApi.createPdf(
              //       Invoice(
              //         projectName: project.name!,
              //         engineerName: authProvider.currentUser!.name!,
              //         items: cashProvider.cashes,
              //         date: '30-07-2024',
              //       ),
              //     );
              //   },
              // );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  GlobalKey<FormState> formKey = GlobalKey<FormState>();
                  var dateController = TextEditingController();
                  return AlertDialog(
                    backgroundColor: AppTheme.white,
                    title: Text(
                      AppLocalizations.of(context)!.cashDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                DatePickerFormField(
                                  controller: dateController,
                                  text: AppLocalizations.of(context)!.cashDate,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .enterCashDate;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                CustomBtn(
                                  text: AppLocalizations.of(context)!
                                      .printInvoice,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      if (cashProvider.cashes.isEmpty) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .noCashes),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          isLoading = true;
                                          print(
                                              'isLoading===========================================');
                                        });
                                        Navigator.pop(context);
                                        try {
                                          final pdfFile =
                                              await PdfApi.createPdf(
                                            Invoice(
                                              projectName: project.name!,
                                              engineerName: authProvider
                                                  .currentUser!.name!,
                                              items: cashProvider.cashes,
                                              date: formatDateWithoutTime(
                                                  dateController.text),
                                            ),
                                          );

                                          await OpenFilex.open(pdfFile.path);
                                        } catch (e) {
                                          print('Failed to open PDF: $e');
                                        } finally {
                                          setState(() {
                                            isLoading = false;
                                            print(
                                                'loaded===========================================');
                                          });
                                        }
                                      }
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.print),
          ),
        ],
      ),
      body:
          // screens[selectedIndex],
          Stack(
        children: [
          screens[selectedIndex],
          isLoading
              ? const Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 10),
                    Text('PDF is Opeing Now...')
                  ],
                ))
              : const Center(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndex == 2) {
            showClientTransferDialog(context: context, isAdd: true);
          } else {
            showInvoiceDialog(context: context, isAdd: false);
          }
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.format_align_center),
            label: AppLocalizations.of(context)!.cashesTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.image),
            label: AppLocalizations.of(context)!.cashesImage,
          ),
          // BottomNavigationBarItem(
          //   icon: const Icon(Icons.money_rounded),
          //   label:AppLocalizations.of(context)!.clientTransfer
          // ),
        ],
      ),
    );
  }

  List<Widget> screens = const [
    CashListWidget(),
    CashImagesWidget(),
    // ClientMoney(),
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

  showClientTransferDialog({required BuildContext context, required isAdd}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUpdateClientTransefer(isAdd: isAdd);
      },
    );
  }
}
