// import 'package:flutter/material.dart';

// import '../../widget/custom_dialog_widget.dart';

// class CashListWidget extends StatefulWidget {
//   const CashListWidget({super.key});

//   @override
//   State<CashListWidget> createState() => _CashListWidgetState();
// }

// class _CashListWidgetState extends State<CashListWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Expanded(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               border: TableBorder.all(),
//               columns: _createColumn(),
//               rows: _createRows(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<DataColumn> _createColumn() {
//     return [
//       DataColumn(
//         label: const Text(
//           'م',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         onSort: (columnIndex, _) {
//           setState(() {
//             if (_isSortAsc) {
//               cashProvider.cashes.sort((a, b) => a.id!.compareTo(b.id!));
//             } else {
//               cashProvider.cashes.sort((a, b) => b.id!.compareTo(a.id!));
//             }
//             _isSortAsc = !_isSortAsc;
//           });
//         },
//       ),
//       DataColumn(
//         label: const Expanded(
//           child: Text(
//             'التاريخ',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         onSort: (columnIndex, _) {
//           setState(() {
//             if (_isSortAsc) {
//               cashProvider.cashes.sort((a, b) => a.date!.compareTo(b.date!));
//             } else {
//               cashProvider.cashes.sort((a, b) => b.date!.compareTo(a.date!));
//             }
//             _isSortAsc = !_isSortAsc;
//           });
//         },
//       ),
//       DataColumn(
//         label: const Expanded(
//             child: Text(
//           'رقم الإيصال',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         )),
//         onSort: (columnIndex, _) {
//           setState(() {
//             if (_isSortAsc) {
//               cashProvider.cashes
//                   .sort((a, b) => a.cashNumber!.compareTo(b.cashNumber!));
//             } else {
//               cashProvider.cashes
//                   .sort((a, b) => b.cashNumber!.compareTo(a.cashNumber!));
//             }
//             _isSortAsc = !_isSortAsc;
//           });
//         },
//       ),
//       DataColumn(
//         label: const Expanded(
//           child: Text(
//             'البيان',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         onSort: (columnIndex, _) {
//           setState(() {
//             if (_isSortAsc) {
//               cashProvider.cashes.sort((a, b) => a.name!.compareTo(b.name!));
//             } else {
//               cashProvider.cashes.sort((a, b) => b.name!.compareTo(a.name!));
//             }
//             _isSortAsc = !_isSortAsc;
//           });
//         },
//       ),
//       DataColumn(
//         label: const Expanded(
//           child: Center(
//             child: Text(
//               'المبلغ',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         onSort: (columnIndex, _) {
//           setState(() {
//             if (_isSortAsc) {
//               cashProvider.cashes.sort((a, b) => a.price!.compareTo(b.price!));
//             } else {
//               cashProvider.cashes.sort((a, b) => b.price!.compareTo(a.price!));
//             }
//             _isSortAsc = !_isSortAsc;
//           });
//         },
//       ),
//       const DataColumn(
//         label: Expanded(
//           child: Text(
//             'التعديل',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     ];
//   }

//   List<DataRow> _createRows() {
//     return cashProvider.cashes.map<DataRow>((Cash cash) {
//       return DataRow(cells: <DataCell>[
//         DataCell(Center(
//           child: Text(
//             '${cash.id}',
//             textAlign: TextAlign.center,
//           ),
//         )),
//         DataCell(Center(
//           child: Text(
//             cash.date!,
//             textAlign: TextAlign.center,
//           ),
//         )),
//         DataCell(Center(
//           child: Text(
//             '${cash.cashNumber}',
//             textAlign: TextAlign.center,
//           ),
//         )),
//         DataCell(Center(
//           child: Text(
//             cash.name!,
//             textAlign: TextAlign.center,
//           ),
//         )),
//         DataCell(Center(
//           child: Text(
//             cash.price!,
//             textAlign: TextAlign.center,
//           ),
//         )),
//         DataCell(Row(
//           children: [
//             IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
//             IconButton(
//                 onPressed: () {
//                   print('deleted');
//                   DialogUtls.showDeleteConfirmationDialog(
//                       context: context,
//                       deleteFunction: () {
//                         Navigator.pop(context);
//                         cashProvider.deleteCash(cash);
//                       });
//                 },
//                 icon: const Icon(Icons.delete)),
//             const SizedBox(
//               width: 10,
//             )
//           ],
//         )),
//       ]);
//     }).toList();
//   }
// }
