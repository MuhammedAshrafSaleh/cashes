import 'package:cashes/app/core/pdf_api.dart';
import 'package:cashes/app/models/invoice.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/cash_provider.dart';
import 'package:cashes/app/providers/clients_transefer_provider.dart';
import 'package:cashes/app/screens/cash/cash_list_widget.dart';
import 'package:cashes/app/widget/custom_btn.dart';
import 'package:cashes/app/widget/custom_dialog_widget.dart';
import 'package:cashes/app/widget/snakebar.dart';
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

enum OurCopmanies { zmzm, ds }

class CashScreen extends StatefulWidget {
  static const String routeName = 'Cash-Screen';
  const CashScreen({super.key});
  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
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
  // bool isLoading = false;
  OurCopmanies? _character = OurCopmanies.zmzm;
  @override
  Widget build(BuildContext context) {
    var project = ModalRoute.of(context)!.settings.arguments as Project;
    // ignore: unused_local_variable
    var cashProvider = Provider.of<CashProvider>(context);
    var authProvider = Provider.of<AuthManagerProvider>(context);
    var projectProvider = Provider.of<ProjectProvider>(context);
    return Consumer<CashProvider>(
      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
      builder: (
        BuildContext context,
        CashProvider cashProvider,
        Widget? child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text(project.name ?? 'Zmzm Project'),
            toolbarHeight: 80.0,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  projectProvider.getTotalMoney();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded)),
            actions: [
              IconButton(
                onPressed: () async {
                  DialogUtls.showLoading(
                      context: context,
                      message: AppLocalizations.of(context)!.loading);
                  await cashProvider.getCashes(
                      userId: authProvider.currentUser!.id!, project: project);
                  DialogUtls.hideLoading(context: context);
                  DialogUtls.showMessage(
                      context: context, message: "تم التحديث بنجاح");
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      GlobalKey<FormState> formKey = GlobalKey<FormState>();
                      var dateController = TextEditingController();
                      OurCopmanies? dialogCharacter = _character;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: AppTheme.white,
                            title: Text(
                              AppLocalizations.of(context)!.invoiceData,
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
                                          text: AppLocalizations.of(context)!
                                              .invoiceData,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .enterCashDate;
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        // Radio Buttons for zmzm and DS
                                        ListTile(
                                          title: const Text('Zmzm'),
                                          leading: Radio<OurCopmanies>(
                                            value: OurCopmanies.zmzm,
                                            groupValue: dialogCharacter,
                                            onChanged: (OurCopmanies? value) {
                                              if (mounted) {
                                                setState(() {
                                                  dialogCharacter = value;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('DS'),
                                          leading: Radio<OurCopmanies>(
                                            value: OurCopmanies.ds,
                                            groupValue: dialogCharacter,
                                            onChanged: (OurCopmanies? value) {
                                              if (mounted) {
                                                setState(() {
                                                  dialogCharacter = value;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        CustomBtn(
                                          text: AppLocalizations.of(context)!
                                              .printInvoice,
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              if (mounted) {
                                                setState(() {
                                                  _character =
                                                      dialogCharacter; // Save the selected value back to the state
                                                });
                                              }
                                              if (cashProvider.cashes.isEmpty) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .noCashes),
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ),
                                                );
                                              } else {
                                                Navigator.pop(context);
                                                showSnackBar(
                                                  content:
                                                      "يتم الان فتح العهدة...",
                                                  context: context,
                                                );
                                                try {
                                                  final projectName =
                                                      project.name ?? '';
                                                  final engineerName =
                                                      authProvider.currentUser
                                                              ?.name ??
                                                          '';

                                                  final pdfFile =
                                                      await PdfApi.createPdf(
                                                    Invoice(
                                                      projectName: projectName,
                                                      engineerName:
                                                          engineerName,
                                                      items:
                                                          cashProvider.cashes,
                                                      isZmzm: _character ==
                                                          OurCopmanies.zmzm,
                                                      date:
                                                          formatDateWithoutTime(
                                                              dateController
                                                                  .text),
                                                    ),
                                                  );

                                                  // Attempt to open the PDF if it is valid
                                                  await OpenFilex.open(
                                                      pdfFile.path);
                                                } catch (e) {
                                                  print(
                                                      'Failed to open PDF: $e');
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.print),
              ),
            ],
          ),
          body: screens[selectedIndex],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFloatinActionButton(),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  _buildFloatinActionButton() {
    return FloatingActionButton(
      onPressed: () {
        if (selectedIndex == 2) {
          showClientTransferDialog(context: context, isAdd: true);
        } else {
          showInvoiceDialog(context: context, isAdd: false);
        }
      },
      child: const Icon(Icons.add, color: AppTheme.primaryColor),
    );
  }

  _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (currentIndex) {
        if (mounted) {
          setState(() {
            selectedIndex = currentIndex;
          });
        }
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
      ],
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
