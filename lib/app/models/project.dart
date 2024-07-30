class Project {
  static const String collectionName = 'projects';
  String? id;
  String? name;
  String? money;
  String? date;
  String? type;
  String? userId;

  Project({
    required this.id,
    required this.name,
    this.money,
    required this.date,
    required this.type,
    required this.userId,
  });

  Project.formFirestore(Map<String, dynamic> data)
      : this(
          id: data['id'] as String,
          name: data['name'] as String,
          // money: data['money'] as String,
          date: data['date'] as String,
          type: data['type'] as String,
          userId: data['userId'] as String,
        );

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      // 'money': money,
      'date': date,
      'type': type,
      'userId': userId,
    };
  }
}
