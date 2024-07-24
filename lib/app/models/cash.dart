class Cash {
  String? id;
  String? name;
  String? cashNumber;
  String? price;
  String? date;

  Cash({
    required this.id,
    required this.name,
    required this.cashNumber,
    required this.price,
    required this.date,
  });

  Cash.fromFirestore(Map<String, dynamic> data)
      : this(
          id: data['id'] as String,
          name: data['name'] as String,
          cashNumber: data['cashNumber'] as String,
          price: data['price'] as String,
          date: data['date'] as String,
        );
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'cashNumber': cashNumber,
      'price': price,
      'date': date,
    };
  }
}
