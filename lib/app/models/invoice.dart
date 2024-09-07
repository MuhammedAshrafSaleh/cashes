import 'cash.dart';

class Invoice {
  final String projectName;
  final String engineerName;
  final List<Cash> items;
  final String date;
  final bool isZmzm;

  const Invoice({
    required this.projectName,
    required this.engineerName,
    required this.items,
    required this.date,
    required this.isZmzm,
  });
}
