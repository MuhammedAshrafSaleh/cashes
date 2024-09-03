class Work {
  String id;
  String name;
  Work({
    required this.id,
    required this.name,
  });

  Work.formFirestore(Map<String, dynamic> data)
      : this(
          id: data['id'] as String,
          name: data['name'] as String,
        );
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
    };
  }
}
