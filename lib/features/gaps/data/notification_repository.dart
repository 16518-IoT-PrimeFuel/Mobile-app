import '../../../data/api_client.dart';
import '../../../data/fulltank_api.dart';

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.read,
  });

  final int id;
  final String title;
  final String detail;
  final bool read;
}

class NotificationRepository {
  NotificationRepository({FullTankApi? api})
    : api = api ?? FullTankApi(ApiClient());
  final FullTankApi api;

  Future<List<NotificationItem>> list(int userId) async {
    final raw = await api.notificationsV2(userId);
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_map).toList();
  }

  Future<void> markRead(int id) => api.markNotificationRead(id);

  NotificationItem _map(Map raw) => NotificationItem(
    id: raw['id'] is num ? (raw['id'] as num).toInt() : 0,
    title: '${raw['title'] ?? 'Notificación'}',
    detail: '${raw['message'] ?? ''}',
    read: raw['read'] == true,
  );
}
