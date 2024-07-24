import 'package:cashes/app/core/pdf_api.dart';
import 'package:cashes/app/models/cash.dart';
import 'package:cashes/app/models/invoice.dart';
import 'package:cashes/app/providers/cash_provider.dart';
import 'package:cashes/app/widget/custom_dialog_widget.dart';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/date_picker.dart';

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

  bool _isSortAsc = true;
  var cashProvider;
  @override
  Widget build(BuildContext context) {
    cashProvider = Provider.of<CashProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                PdfApi.createPdf(
                  Invoice(
                    logo: '',
                    items: cashProvider.cashes,
                  ),
                );
              },
              icon: const Icon(Icons.print),
            ),
          ],
        ),
        body: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder.all(),
                      columns: _createColumn(),
                      rows: _createRows(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showInvoiceDialog(context: context, isAdd: false);
          },
          child: const Icon(Icons.add, color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  List<DataColumn> _createColumn() {
    return [
      DataColumn(
        label: const Text(
          'م',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onSort: (columnIndex, _) {
          setState(() {
            if (_isSortAsc) {
              cashProvider.cashes.sort((a, b) => a.id!.compareTo(b.id!));
            } else {
              cashProvider.cashes.sort((a, b) => b.id!.compareTo(a.id!));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(
        label: const Expanded(
          child: Text(
            'التاريخ',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        onSort: (columnIndex, _) {
          setState(() {
            if (_isSortAsc) {
              cashProvider.cashes.sort((a, b) => a.date!.compareTo(b.date!));
            } else {
              cashProvider.cashes.sort((a, b) => b.date!.compareTo(a.date!));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(
        label: const Expanded(
            child: Text(
          'رقم الإيصال',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        onSort: (columnIndex, _) {
          setState(() {
            if (_isSortAsc) {
              cashProvider.cashes
                  .sort((a, b) => a.cashNumber!.compareTo(b.cashNumber!));
            } else {
              cashProvider.cashes
                  .sort((a, b) => b.cashNumber!.compareTo(a.cashNumber!));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(
        label: const Expanded(
          child: Text(
            'البيان',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        onSort: (columnIndex, _) {
          setState(() {
            if (_isSortAsc) {
              cashProvider.cashes.sort((a, b) => a.name!.compareTo(b.name!));
            } else {
              cashProvider.cashes.sort((a, b) => b.name!.compareTo(a.name!));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(
        label: const Expanded(
          child: Center(
            child: Text(
              'المبلغ',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onSort: (columnIndex, _) {
          setState(() {
            if (_isSortAsc) {
              cashProvider.cashes.sort((a, b) => a.price!.compareTo(b.price!));
            } else {
              cashProvider.cashes.sort((a, b) => b.price!.compareTo(a.price!));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      const DataColumn(
        label: Expanded(
          child: Text(
            'التعديل',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }

  List<DataRow> _createRows() {
    return cashProvider.cashes.map<DataRow>((Cash cash) {
      return DataRow(cells: <DataCell>[
        DataCell(Center(
          child: Text(
            '${cash.id}',
            textAlign: TextAlign.center,
          ),
        )),
        DataCell(Center(
          child: Text(
            cash.date!,
            textAlign: TextAlign.center,
          ),
        )),
        DataCell(Center(
          child: Text(
            '${cash.cashNumber}',
            textAlign: TextAlign.center,
          ),
        )),
        DataCell(Center(
          child: Text(
            cash.name!,
            textAlign: TextAlign.center,
          ),
        )),
        DataCell(Center(
          child: Text(
            cash.price!,
            textAlign: TextAlign.center,
          ),
        )),
        DataCell(Row(
          children: [
            IconButton(
                onPressed: () {
                  int index = cashProvider.cashes.indexOf(cash) ?? 0;
                  showInvoiceDialog(
                      context: context, isAdd: true, index: index);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  DialogUtls.showDeleteConfirmationDialog(
                      context: context,
                      deleteFunction: () {
                        Navigator.pop(context);
                        cashProvider.deleteCash(cash);
                      });
                },
                icon: const Icon(Icons.delete)),
            const SizedBox(
              width: 10,
            )
          ],
        )),
      ]);
    }).toList();
  }

  void showInvoiceDialog(
      {required BuildContext context, required bool isAdd, index}) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
        text: isAdd ? cashProvider.cashes[index].name : '');
    final priceController = TextEditingController(
        text: isAdd ? cashProvider.cashes[index].price : '');
    final dateController = TextEditingController(
        text: isAdd ? cashProvider.cashes[index].date : '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.white,
          title: const Text(
            'Cash Details',
            style: TextStyle(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        controller: nameController,
                        text: 'Cash Name',
                        keyboardType: TextInputType.text,
                        hasIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter cash name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: priceController,
                        text: 'Price',
                        keyboardType: TextInputType.number,
                        hasIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DatePickerFormField(
                        controller: dateController,
                        text: 'Cash date',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomBtn(
                        text: isAdd ? 'Update Cash' : 'Add Cash',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            isAdd
                                ? cashProvider.updateCash(
                                    cash: Cash(
                                      id: '${cashProvider.cashes[index].id}',
                                      name: nameController.text,
                                      cashNumber: '',
                                      price: priceController.text,
                                      date: dateController.text,
                                    ),
                                  )
                                : cashProvider.addCash(
                                    Cash(
                                      id: '${cashProvider.cashes.length}',
                                      name: nameController.text,
                                      cashNumber: '',
                                      price: priceController.text,
                                      date: dateController.text,
                                    ),
                                  );
                            nameController.clear();
                            priceController.clear();
                            dateController.clear();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isAdd
                                      ? 'Updated successfully'
                                      : 'Added successfully',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
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
  }
}
