import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cash.dart';
import '../../providers/cash_provider.dart';
import '../../widget/custom_dialog_widget.dart';
import '../../widget/empty_screen.dart';
import 'cash_add_update_widget.dart';

// ignore: must_be_immutable
class CashListWidget extends StatefulWidget {
  const CashListWidget({super.key});
  @override
  State<CashListWidget> createState() => _CashListWidgetState();
}

class _CashListWidgetState extends State<CashListWidget> {
  var cashProvider;
  var authProvider;
  var projectProvider;
  bool _isSortAsc = true;
  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthManagerProvider>(context);
    cashProvider = Provider.of<CashProvider>(context);
    projectProvider = Provider.of<ProjectProvider>(context);
    return cashProvider.cashes.isEmpty
        ? EmptyScreen(message: 'No Invoices Yet!')
        : Directionality(
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
      const DataColumn(
        label: Expanded(
          child: Text(
            'التاريخ',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // onSort: (columnIndex, _) {
        //   setState(() {
        //     if (_isSortAsc) {
        //       cashProvider.cashes.sort((a, b) => a.date!.compareTo(b.date!));
        //     } else {
        //       cashProvider.cashes.sort((a, b) => b.date!.compareTo(a.date!));
        //     }
        //     _isSortAsc = !_isSortAsc;
        //   });
        // },
      ),
      // DataColumn(
      //   label: const Expanded(
      //       child: Text(
      //     'رقم الإيصال',
      //     textAlign: TextAlign.center,
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   )),
      //   onSort: (columnIndex, _) {
      //     setState(() {
      //       if (_isSortAsc) {
      //         cashProvider.cashes
      //             .sort((a, b) => a.cashNumber!.compareTo(b.cashNumber!));
      //       } else {
      //         cashProvider.cashes
      //             .sort((a, b) => b.cashNumber!.compareTo(a.cashNumber!));
      //       }
      //       _isSortAsc = !_isSortAsc;
      //     });
      //   },
      // ),
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
              cashProvider.cashes.sort(
                  (a, b) => int.parse(a.price!).compareTo(int.parse(b.price!)));
            } else {
              cashProvider.cashes.sort(
                  (a, b) => int.parse(b.price!).compareTo(int.parse(a.price!)));
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
    return cashProvider.cashes.asMap().entries.map<DataRow>((entry) {
      int index = entry.key; // Get the index
      Cash cash = entry.value; // Get the Cash item
      return DataRow(cells: <DataCell>[
        DataCell(Center(
          child: Text(
            '${index + 1}',
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
                    context: context,
                    isAdd: true,
                    index: index,
                  );
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  DialogUtls.showDeleteConfirmationDialog(
                      context: context,
                      deleteFunction: () {
                        cashProvider.deleteCash(
                          userId: authProvider.currentUser.id,
                          projectId: projectProvider.currentProject.id,
                          cash: cash,
                        );
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUpdateTask(isAdd: isAdd, index: index);
      },
    );
  }
}
