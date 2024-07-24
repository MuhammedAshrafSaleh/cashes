import 'cash.dart';

class Invoice {
  final String logo;
  final List<Cash> items;

  const Invoice({
    required this.logo,
    required this.items,
  });
}
