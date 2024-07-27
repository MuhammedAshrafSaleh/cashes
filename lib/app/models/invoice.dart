import 'cash.dart';

class Invoice {
  final String projectName;
  final String engineerName;
  final List<Cash> items;

  const Invoice({
    required this.projectName,
    required this.engineerName,
    required this.items,
  });
}
