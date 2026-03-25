class AppNotification {
  final String id, title, body;
  final DateTime createdAt;
  final bool read;
  const AppNotification({required this.id, required this.title, required this.body, required this.createdAt, this.read = false});
}
