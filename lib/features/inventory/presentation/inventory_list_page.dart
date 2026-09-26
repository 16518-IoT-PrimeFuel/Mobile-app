part of 'inventory_page.dart';

class TankData {
  const TankData({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.level,
    required this.capacity,
    required this.current,
    required this.sensor,
    required this.updated,
  });

  final String id;
  final String name;
  final String location;
  final String type;
  final int level;
  final int capacity;
  final int current;
  final String sensor;
  final String updated;
}

const _tanks = [
  TankData(
    id: 'A-102',
    name: 'Tanque diésel A-102',
    location: 'Patio norte · Sector 4',
    type: 'Diésel',
    level: 12,
    capacity: 12000,
    current: 1440,
    sensor: 'SN-4492',
    updated: 'hace 2 min',
  ),
  TankData(
    id: 'B-05',
    name: 'Tanque de agua B-05',
    location: 'Sector 1',
    type: 'Refrigerante',
    level: 84,
    capacity: 50000,
    current: 42000,
    sensor: 'SN-2011',
    updated: 'hace 1 min',
  ),
  TankData(
    id: 'C-12',
    name: 'Tanque de lubricante C-12',
    location: 'Sector 9',
    type: 'Lubricante',
    level: 35,
    capacity: 8000,
    current: 2800,
    sensor: 'SN-8821',
    updated: 'hace 3 min',
  ),
  TankData(
    id: 'A-204',
    name: 'Tanque diésel A-204',
    location: 'Patio norte · Sector 4',
    type: 'Diésel',
    level: 72,
    capacity: 15000,
    current: 10800,
    sensor: 'SN-4499',
    updated: 'ahora mismo',
  ),
  TankData(
    id: 'G-11',
    name: 'Propano G-11',
    location: 'Sector 6',
    type: 'Propano',
    level: 18,
    capacity: 6000,
    current: 1080,
    sensor: 'SN-9002',
    updated: 'hace 5 min',
  ),
  TankData(
    id: 'D-4',
    name: 'Hidráulico D-4',
    location: 'Sector 2',
    type: 'Hidráulico',
    level: 58,
    capacity: 4000,
    current: 2320,
    sensor: 'SN-3355',
    updated: 'hace 4 min',
  ),
];

TankData _tankForId(String id) {
  for (final tank in _tanks) {
    if (tank.id == id) return tank;
  }
  if (id == 'B-07') {
    return const TankData(
      id: 'B-07',
      name: 'Refrigerante B-07',
      location: 'Sector 1',
      type: 'Refrigerante',
      level: 28,
      capacity: 50000,
      current: 14000,
      sensor: 'SN-2018',
      updated: 'hace 18 min',
    );
  }
  return _tanks.first;
}

_TankStatus _statusFor(int level) {
  if (level < 20) return _TankStatus.critical;
  if (level < 40) return _TankStatus.warning;
  return _TankStatus.optimal;
}

Color _statusColor(_TankStatus status) => switch (status) {
  _TankStatus.critical => _red,
  _TankStatus.warning => _amber,
  _TankStatus.optimal => _green,
};

Color _statusSoft(_TankStatus status) => switch (status) {
  _TankStatus.critical => _redSoft,
  _TankStatus.warning => _amberSoft,
  _TankStatus.optimal => _greenSoft,
};

String _statusLabel(_TankStatus status) => switch (status) {
  _TankStatus.critical => 'Crítico',
  _TankStatus.warning => 'Advertencia',
  _TankStatus.optimal => 'Óptimo',
};

String _liters(int value) => value.toString().replaceAllMapped(
  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
  (match) => '${match[1]},',
);

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final visible = _tanks.where((tank) {
      return switch (_filter) {
        'critical' => tank.level < 20,
        'warning' => tank.level >= 20 && tank.level < 40,
        'optimal' => tank.level >= 40,
        _ => true,
      };
    }).toList();
    return _InventoryShell(
      title: 'Inventario',
      subtitle: '${_tanks.length} tanques · IoT en vivo',
      right: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HeaderIconButton(
            icon: Icons.search,
            label: 'Buscar tanques',
            onPressed: () async {
              final selected = await showSearch<TankData?>(
                context: context,
                delegate: _TankSearchDelegate(),
              );
              if (context.mounted && selected != null) {
                context.go('/inventory/tank/${selected.id}');
              }
            },
          ),
          _HeaderIconButton(
            icon: Icons.notifications_none_outlined,
            label: 'Ver alertas',
            badge: 3,
            onPressed: () => context.go('/inventory/alerts'),
          ),
        ],
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryMetric(
                label: 'Crítico',
                count: _tanks.where((tank) => tank.level < 20).length,
                status: _TankStatus.critical,
              ),
            ),
            SizedBox(width: 11.6),
            Expanded(
              child: _SummaryMetric(
                label: 'Advertencia',
                count: _tanks
                    .where((tank) => tank.level >= 20 && tank.level < 40)
                    .length,
                status: _TankStatus.warning,
              ),
            ),
            SizedBox(width: 11.6),
            Expanded(
              child: _SummaryMetric(
                label: 'Óptimo',
                count: _tanks.where((tank) => tank.level >= 40).length,
                status: _TankStatus.optimal,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'Todos',
                count: _tanks.length,
                selected: _filter == 'all',
                onPressed: () => setState(() => _filter = 'all'),
              ),
              _FilterChip(
                label: 'Crítico',
                count: 2,
                status: _TankStatus.critical,
                selected: _filter == 'critical',
                onPressed: () => setState(() => _filter = 'critical'),
              ),
              _FilterChip(
                label: 'Advertencia',
                count: 1,
                status: _TankStatus.warning,
                selected: _filter == 'warning',
                onPressed: () => setState(() => _filter = 'warning'),
              ),
              _FilterChip(
                label: 'Óptimo',
                count: 3,
                status: _TankStatus.optimal,
                selected: _filter == 'optimal',
                onPressed: () => setState(() => _filter = 'optimal'),
              ),
            ],
          ),
        ),
        SizedBox(height: 17.4),
        ...visible.map(
          (tank) => Padding(
            padding: EdgeInsets.only(bottom: 11.6),
            child: _TankRow(tank: tank),
          ),
        ),
        const SizedBox(height: 18),
        _ProductSection(
          state: ref.watch(inventoryControllerProvider),
          onRetry: () => ref.read(inventoryControllerProvider.notifier).load(),
          onEdit: _editProduct,
        ),
      ],
    );
  }

  Future<void> _editProduct(FuelProduct product) async {
    final name = TextEditingController(text: product.name);
    final price = TextEditingController(text: product.price.toString());
    final stock = TextEditingController(
      text: product.availableStock.toString(),
    );
    final formKey = GlobalKey<FormState>();
    final edited = await showDialog<FuelProduct>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar producto'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
              ),
              TextFormField(
                controller: price,
                decoration: const InputDecoration(
                  labelText: 'Precio por unidad',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) => double.tryParse(value ?? '') == null
                    ? 'Ingresa un número válido'
                    : null,
              ),
              TextFormField(
                controller: stock,
                decoration: const InputDecoration(
                  labelText: 'Stock disponible',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) => double.tryParse(value ?? '') == null
                    ? 'Ingresa un número válido'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.pop(
                context,
                FuelProduct(
                  id: product.id,
                  name: name.text.trim(),
                  type: product.type,
                  price: double.parse(price.text),
                  availability: product.availability,
                  unit: product.unit,
                  availableStock: double.parse(stock.text),
                  capacity: product.capacity,
                  providerId: product.providerId,
                  active: product.active,
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    name.dispose();
    price.dispose();
    stock.dispose();
    if (edited != null && mounted) {
      await ref.read(inventoryControllerProvider.notifier).save(edited);
    }
  }
}

class _ProductSection extends StatelessWidget {
  const _ProductSection({
    required this.state,
    required this.onRetry,
    required this.onEdit,
  });

  final AsyncValue<List<FuelProduct>> state;
  final VoidCallback onRetry;
  final ValueChanged<FuelProduct> onEdit;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Productos',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A202C),
        ),
      ),
      const SizedBox(height: 8),
      state.when(
        loading: () => const _ProductState(
          message: 'Cargando productos…',
          icon: Icons.hourglass_empty,
        ),
        error: (error, _) => _ProductState(
          message: 'No se pudieron cargar los productos',
          icon: Icons.error_outline,
          action: TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ),
        data: (products) => products.isEmpty
            ? const _ProductState(
                message: 'No hay productos registrados',
                icon: Icons.inventory_2_outlined,
              )
            : Column(
                children: products
                    .map(
                      (product) =>
                          _ProductTile(product: product, onEdit: onEdit),
                    )
                    .toList(),
              ),
      ),
    ],
  );
}

class _ProductState extends StatelessWidget {
  const _ProductState({required this.message, required this.icon, this.action});

  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Color(0xFF475569)),
          ),
        ),
        if (action != null) action!,
      ],
    ),
  );
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.onEdit});

  final FuelProduct product;
  final ValueChanged<FuelProduct> onEdit;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      leading: const CircleAvatar(
        backgroundColor: _amberSoft,
        child: Icon(Icons.water_drop_outlined, color: _amber),
      ),
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        '${product.availableStock.toStringAsFixed(0)} ${product.unit} · '
        '${product.price.toStringAsFixed(2)} / ${product.unit}',
      ),
      trailing: IconButton(
        tooltip: 'Editar ${product.name}',
        onPressed: () => onEdit(product),
        icon: const Icon(Icons.edit_outlined),
      ),
    ),
  );
}
