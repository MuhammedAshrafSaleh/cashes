import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/project_provider.dart';
import 'package:cashes/app/widget/custom_circle_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cash.dart';
import '../../providers/cash_provider.dart';
import '../../widget/custom_dialog_widget.dart';
import '../../widget/empty_screen.dart';
import 'cash_add_update_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _isLoading = false;

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
        _fetchData();
      }
    });
  }

  void _fetchData() async {
    setState(() {
      _isLoading =
          true; // Set loading state to true when starting to fetch data
    });
    try {
      await cashProvider.getCashes(
        userId: authProvider.currentUser.id!,
        project: projectProvider.currentProject,
      ); // Assuming you have a method to fetch data
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false once data is fetched
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthManagerProvider>(context);
    cashProvider = Provider.of<CashProvider>(context);
    projectProvider = Provider.of<ProjectProvider>(context);

    if (_isLoading) {
      return customProgress();
    }
    return cashProvider.cashes.isEmpty
        ? EmptyScreen(message: AppLocalizations.of(context)!.noCashes)
        : Directionality(
            textDirection: TextDirection.rtl,
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
      ),
      const DataColumn(
        label: Expanded(
          child: Text(
            'البيان',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
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
                        projectProvider.getTotalMoney();
                        cashProvider.deleteCash(
                          userId: authProvider.currentUser.id,
                          project: projectProvider.currentProject,
                          cash: cash,
                          context: context,
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
