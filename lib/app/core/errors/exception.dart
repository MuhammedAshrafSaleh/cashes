class ServerException implements Exception {
  final String message;
  const ServerException({required this.message});
  // This's Very Important
  @override
  String toString() => message;
}
