part of 'missing_pages.dart';

class SearchOrdersPage extends StatefulWidget {
  const SearchOrdersPage({super.key});
  @override
  State<SearchOrdersPage> createState() => _SearchOrdersPageState();
}

class _SearchOrdersPageState extends State<SearchOrdersPage> {
  String query = '';
  String status = 'Todos';

  @override
  Widget build(BuildContext context) {
    final orders =
        [
          ('FT-88421', 'AgroNorte', 'En tránsito'),
          ('FT-88418', 'Cementos B', 'Aprobado'),
          ('FT-88374', 'PetroAndes', 'Entregado'),
        ].where((order) {
          final matchesStatus = status == 'Todos' || order.$3 == status;
          final normalizedQuery = query.toLowerCase();
          final matchesQuery =
              query.isEmpty ||
              order.$1.toLowerCase().contains(normalizedQuery) ||
              order.$2.toLowerCase().contains(normalizedQuery);
          return matchesStatus && matchesQuery;
        }).toList();
    return MissingPageShell(
      title: 'Buscar pedidos',
      subtitle: 'Filtra por referencia, cliente o estado',
      bottomNav: 1,
      child: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: 'Ej. FT-88421',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                    'Todos',
                    'Pendiente',
                    'Aprobado',
                    'En tránsito',
                    'Entregado',
                  ].map((value) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: ChoiceChip(
                        label: Text(value),
                        selected: status == value,
                        onSelected: (_) => setState(() => status = value),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          if (orders.isEmpty)
            const _Panel(
              child: Text('No encontramos pedidos con esos filtros.'),
            )
          else
            ...orders.map(
              (order) => ListTile(
                onTap: () => context.push('/orders/${order.$1}'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: const CircleAvatar(
                  backgroundColor: _blueSoft,
                  child: Icon(Icons.receipt_long, color: _blue),
                ),
                title: Text(
                  '#${order.$1}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(order.$2),
                trailing: Text(order.$3, style: const TextStyle(color: _muted)),
              ),
            ),
        ],
      ),
    );
  }
}

class NotificationsCenterPage extends ConsumerStatefulWidget {
  const NotificationsCenterPage({super.key});
  @override
  ConsumerState<NotificationsCenterPage> createState() =>
      _NotificationsCenterPageState();
}

class _NotificationsCenterPageState
    extends ConsumerState<NotificationsCenterPage> {
  final _items = <({String title, String detail, IconData icon, bool read})>[
    (
      title: 'Pedido en tránsito',
      detail: 'FT-88421 salió del centro regional.',
      icon: Icons.local_shipping_outlined,
      read: false,
    ),
    (
      title: 'Pago confirmado',
      detail: 'Recibimos el pago de FT-88418.',
      icon: Icons.check_circle_outline,
      read: false,
    ),
    (
      title: 'Mantenimiento programado',
      detail: 'El sistema estará en mantenimiento el domingo.',
      icon: Icons.info_outline,
      read: true,
    ),
  ];
  final _ids = <int>[];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    int? userId;
    try {
      userId = ref.read(authControllerProvider).session?.userId;
    } catch (_) {
      return;
    }
    if (userId == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await NotificationRepository(
        api: ref.read(fullTankApiProvider),
      ).list(userId);
      if (!mounted) return;
      setState(() {
        _ids
          ..clear()
          ..addAll(items.map((item) => item.id));
        _items
          ..clear()
          ..addAll(
            items.map(
              (item) => (
                title: item.title,
                detail: item.detail,
                icon: Icons.notifications_none,
                read: item.read,
              ),
            ),
          );
      });
    } catch (_) {
      if (mounted)
        setState(() => _error = 'No se pudieron cargar las notificaciones.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _markRead(int index) async {
    final item = _items[index];
    if (item.read) return;
    int? userId;
    try {
      userId = ref.read(authControllerProvider).session?.userId;
    } catch (_) {
      userId = null;
    }
    setState(
      () => _items[index] = (
        title: item.title,
        detail: item.detail,
        icon: item.icon,
        read: true,
      ),
    );
    if (userId == null) return;
    try {
      if (index < _ids.length) {
        await NotificationRepository(
          api: ref.read(fullTankApiProvider),
        ).markRead(_ids[index]);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Notificaciones',
    subtitle: '${_items.where((item) => !item.read).length} sin leer',
    actions: [
      TextButton(
        onPressed: () => setState(() {
          for (var i = 0; i < _items.length; i++) {
            _items[i] = (
              title: _items[i].title,
              detail: _items[i].detail,
              icon: _items[i].icon,
              read: true,
            );
          }
        }),
        child: const Text('Marcar todo'),
      ),
    ],
    child: Column(
      children: [
        if (_loading) const LinearProgressIndicator(),
        if (_error != null) ...[
          Text(_error!, style: const TextStyle(color: _red)),
          TextButton(onPressed: _load, child: const Text('Reintentar')),
        ],
        for (var i = 0; i < _items.length; i++)
          _NotificationTile(item: _items[i], onTap: () => _markRead(i)),
      ],
    ),
  );
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});
  final ({String title, String detail, IconData icon, bool read}) item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: item.read ? _blueSoft : _orangeSoft,
            child: Icon(
              item.icon,
              color: item.read ? _blue : _orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: item.read ? FontWeight.w500 : FontWeight.w800,
                    color: _ink,
                  ),
                ),
                Text(item.detail, style: const TextStyle(color: _muted)),
              ],
            ),
          ),
          if (!item.read)
            const CircleAvatar(radius: 4, backgroundColor: _orange),
        ],
      ),
    ),
  );
}
