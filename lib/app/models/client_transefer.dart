class ClientTransefer {
  static const String collectionName = "clients";
  String? id;
  String? name;
  String? imageURL;

  ClientTransefer({
    required this.id,
    required this.name,
    this.imageURL,
  });

  ClientTransefer.fromFirestore(Map<String, dynamic> data)
      : this(
          id: data['id'] as String,
          name: data['name'] as String,
          imageURL: data['imageURL'] as String,
        );
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'imageURL': imageURL,
    };
  }
}
