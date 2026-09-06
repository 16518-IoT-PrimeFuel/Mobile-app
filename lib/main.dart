import 'package:flutter/material.dart';

void main() => runApp(const FullTankApp());

class FullTankApp extends StatefulWidget {
  const FullTankApp({super.key});
  @override
  State<FullTankApp> createState() => _FullTankAppState();
}

class _FullTankAppState extends State<FullTankApp> {
  final viewModel = AppViewModel();
  final orders = demoOrders;

  @override
  void initState() {
    super.initState();
    viewModel.addListener(_refresh);
  }

  @override
  void dispose() {
    viewModel.removeListener(_refresh);
    viewModel.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onOrder: () => push(context, const NewOrderPage())),
      OrdersPage(orders: orders),
      const InventoryPage(),
      const PricingPage(),
      ProfilePage(
        language: viewModel.language,
        onLanguage: viewModel.toggleLanguage,
      ),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FullTank',
      theme: appTheme,
      home: Scaffold(
        body: SafeArea(child: pages[viewModel.tab]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: viewModel.tab,
          onDestinationSelected: viewModel.selectTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Pedidos',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2),
              label: 'Inventario',
            ),
            NavigationDestination(
              icon: Icon(Icons.sell_outlined),
              selectedIcon: Icon(Icons.sell),
              label: 'Precios',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

class AppViewModel extends ChangeNotifier {
  var tab = 0;
  var language = 'ES';

  void selectTab(int value) {
    tab = value;
    notifyListeners();
  }

  void toggleLanguage() {
    language = language == 'ES' ? 'EN' : 'ES';
    notifyListeners();
  }
}

enum OrderStatus { pending, approved, transit, delivered }

extension StatusText on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => 'Pendiente',
    OrderStatus.approved => 'Aprobado',
    OrderStatus.transit => 'En tránsito',
    OrderStatus.delivered => 'Entregado',
  };
  Color get color => switch (this) {
    OrderStatus.pending => AppColors.orange,
    OrderStatus.approved => AppColors.blue,
    OrderStatus.transit => AppColors.orange,
    OrderStatus.delivered => AppColors.green,
  };
}

class Order {
  const Order({
    required this.id,
    required this.product,
    required this.quantity,
    required this.status,
    required this.provider,
    required this.address,
    required this.total,
  });
  final String id;
  final String product;
  final int quantity;
  final OrderStatus status;
  final String provider;
  final String address;
  final double total;
}

const demoOrders = [
  Order(
    id: '#FT-88421',
    product: 'Diésel · ULSD B5',
    quantity: 6000,
    status: OrderStatus.transit,
    provider: 'Global Fuel Corp',
    address: 'Av. Néstor Gambetta 1240, Callao',
    total: 9274.80,
  ),
  Order(
    id: '#FT-88418',
    product: 'Gasolina 95',
    quantity: 3200,
    status: OrderStatus.approved,
    provider: 'Midwest PetroLink',
    address: 'Jr. Los Ángeles 421, Lima',
    total: 5120,
  ),
  Order(
    id: '#FT-88415',
    product: 'Diésel · ULSD B5',
    quantity: 2000,
    status: OrderStatus.pending,
    provider: 'Global Fuel Corp',
    address: 'Parque Industrial, Arequipa',
    total: 3180,
  ),
  Order(
    id: '#FT-88402',
    product: 'GNV',
    quantity: 10500,
    status: OrderStatus.delivered,
    provider: 'Global Fuel Corp',
    address: 'Av. Argentina 900, Lima',
    total: 15720,
  ),
];

class FuelProduct {
  const FuelProduct(this.name, this.type, this.price, this.status);
  final String name;
  final String type;
  final double price;
  final String status;
}

const demoProducts = [
  FuelProduct('Diesel B5', 'DIESEL', 24.10, 'Available'),
  FuelProduct('Diesel Premium', 'DIESEL', 25.80, 'Available'),
  FuelProduct('Gasoline 91', 'GASOLINE', 22.35, 'Available'),
  FuelProduct('Gasoline 95', 'GASOLINE', 24.90, 'Low stock'),
  FuelProduct('Premium Racing', 'PREMIUM', 32.50, 'Available'),
  FuelProduct('Marine Diesel', 'DIESEL', 26.40, 'Inactive'),
];

abstract final class AppColors {
  static const ink = Color(0xFF222832);
  static const muted = Color(0xFF747B87);
  static const canvas = Color(0xFFF2F1ED);
  static const orange = Color(0xFFFF9800);
  static const blue = Color(0xFF356AE6);
  static const green = Color(0xFF12B981);
  static const red = Color(0xFFEF4444);
  static const line = Color(0xFFE7E8EC);
  static const lavender = Color(0xFFEEF1FF);
}

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.canvas,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange)
      .copyWith(primary: AppColors.orange, surface: Colors.white),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 31,
      height: 1.05,
      fontWeight: FontWeight.w800,
      color: AppColors.ink,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: AppColors.ink,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: AppColors.ink,
    ),
    titleMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    bodyLarge: TextStyle(fontSize: 16, height: 1.4, color: AppColors.ink),
    bodyMedium: TextStyle(fontSize: 13, height: 1.35, color: AppColors.muted),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF6F7F9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
  ),
);

void push(BuildContext context, Widget page) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));

class HomePage extends StatelessWidget {
  const HomePage({required this.onOrder, super.key});
  final VoidCallback onOrder;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buenos días, Alex',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 3),
              Text(
                'Miércoles, 03 de septiembre',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const CircleAvatar(
            backgroundColor: AppColors.ink,
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 30),
      Text(
        'Tu operación,\nbajo control.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 9),
      Text(
        'Combustible confiable y entregas visibles desde un solo lugar.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 20),
      FilledButton.icon(
        onPressed: onOrder,
        icon: const Icon(Icons.add),
        label: const Text('Registrar nuevo pedido'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(50),
        ),
      ),
      const SizedBox(height: 25),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pedido en curso',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextButton(onPressed: () {}, child: const Text('Ver todos')),
        ],
      ),
      const SizedBox(height: 8),
      OrderCard(
        order: demoOrders.first,
        onTap: () => push(context, OrderDetailPage(order: demoOrders.first)),
      ),
      const SizedBox(height: 26),
      Text('Accesos rápidos', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: QuickAction(
              icon: Icons.local_gas_station_outlined,
              label: 'Pedir combustible',
              onTap: onOrder,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: QuickAction(
              icon: Icons.route_outlined,
              label: 'Ver seguimiento',
              onTap: () => push(context, TrackingPage(order: demoOrders.first)),
            ),
          ),
        ],
      ),
    ],
  );
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({required this.orders, super.key});
  final List<Order> orders;
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var filter = 'Todos';
  @override
  Widget build(BuildContext context) {
    final visible = filter == 'Todos'
        ? widget.orders
        : widget.orders.where((item) => item.status.label == filter).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        Text('Mis pedidos', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 5),
        Text(
          '5 pedidos · sincronizados hace 2 min',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 7,
          children:
              ['Todos', 'Pendiente', 'Aprobado', 'En tránsito', 'Entregado']
                  .map(
                    (item) => ChoiceChip(
                      label: Text(item),
                      selected: filter == item,
                      onSelected: (_) => setState(() => filter = item),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 18),
        ...visible.map(
          (order) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OrderCard(
              order: order,
              onTap: () => push(context, OrderDetailPage(order: order)),
            ),
          ),
        ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, required this.onTap, super.key});
  final Order order;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.id, style: Theme.of(context).textTheme.titleMedium),
                StatusPill(status: order.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  order.product.contains('Gas')
                      ? Icons.local_gas_station_outlined
                      : Icons.water_drop_outlined,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.product,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${order.quantity} L · ${order.provider}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Text(
                  'S/ ${order.total.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    order.address,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.status, super.key});
  final OrderStatus status;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: status.color.withAlpha(25),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      status.label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: status.color,
      ),
    ),
  );
}

class QuickAction extends StatelessWidget {
  const QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.blue, size: 27),
            const SizedBox(height: 23),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    ),
  );
}

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({required this.order, super.key});
  final Order order;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(order.id)),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        OrderSummary(order: order),
        const SizedBox(height: 22),
        Text(
          'Estado del pedido',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Timeline(status: order.status),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: () => push(context, TrackingPage(order: order)),
          icon: const Icon(Icons.route_outlined),
          label: const Text('Ver tracking'),
        ),
      ],
    ),
  );
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({required this.order, super.key});
  final Order order;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.product,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'S/ ${order.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${order.quantity} L · ${order.provider}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(height: 26),
          Text(order.address, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          const Text(
            'Entrega estimada · Hoy, 15:30',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ],
      ),
    ),
  );
}

class Timeline extends StatelessWidget {
  const Timeline({required this.status, super.key});
  final OrderStatus status;
  @override
  Widget build(BuildContext context) {
    final items = OrderStatus.values;
    final current = items.indexOf(status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            for (var index = 0; index < items.length; index++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Icon(
                        index <= current
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: index <= current
                            ? AppColors.blue
                            : AppColors.line,
                        size: 22,
                      ),
                      if (index < items.length - 1)
                        Container(
                          width: 2,
                          height: 28,
                          color: index < current
                              ? AppColors.blue
                              : AppColors.line,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 14),
                    child: Text(
                      items[index].label,
                      style: TextStyle(
                        fontWeight: index <= current
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: index <= current
                            ? AppColors.ink
                            : AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TrackingPage extends StatelessWidget {
  const TrackingPage({required this.order, super.key});
  final Order order;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Seguimiento')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Mis pedidos', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          'Última actualización hace 2 min',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Card(
          color: AppColors.lavender,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.blue,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'En tránsito',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'ETA en ~2h · 12,000 L restantes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Timeline(status: order.status),
        const SizedBox(height: 18),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Contactar soporte'),
        ),
      ],
    ),
  );
}

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});
  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  var fuel = 'Diésel';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Registrar pedido')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('Nuevo pedido', style: Theme.of(context).textTheme.headlineSmall),
        Text(
          'Registra la información para encontrar un proveedor.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 22),
        Text('TIPO DE COMBUSTIBLE', style: labelStyle),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Diésel', 'Gasolina', 'GLP', 'Otro']
              .map(
                (item) => ChoiceChip(
                  label: Text(item),
                  selected: fuel == item,
                  onSelected: (_) => setState(() => fuel = item),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 18),
        const TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Cantidad', suffixText: 'L'),
        ),
        const SizedBox(height: 14),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Ubicación de entrega',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        const SizedBox(height: 14),
        const TextField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Fecha requerida',
            prefixIcon: Icon(Icons.calendar_today_outlined),
            hintText: 'Seleccionar fecha',
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: AppColors.lavender,
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Buscaremos proveedores disponibles cerca de tu ubicación.',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Crear pedido'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.ink,
            minimumSize: const Size.fromHeight(52),
          ),
        ),
      ],
    ),
  );
}

const labelStyle = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w800,
  letterSpacing: .6,
  color: AppColors.muted,
);

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});
  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  var filter = 'All';
  @override
  Widget build(BuildContext context) {
    final products = filter == 'All'
        ? demoProducts
        : demoProducts.where((item) => item.status == filter).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inventory',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '6 tanks · live IoT',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Metric(label: 'AVAILABLE', value: '4', color: AppColors.green),
            const SizedBox(width: 8),
            Metric(label: 'LOW STOCK', value: '1', color: AppColors.orange),
            const SizedBox(width: 8),
            Metric(label: 'INACTIVE', value: '1', color: AppColors.muted),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Available', 'Low stock', 'Inactive']
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(item),
                      selected: filter == item,
                      onSelected: (_) => setState(() => filter = item),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 14),
        ...products.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: ProductCard(
              product: product,
              onTap: () => push(context, EditProductPage(product: product)),
            ),
          ),
        ),
      ],
    );
  }
}

class Metric extends StatelessWidget {
  const Metric({
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, required this.onTap, super.key});
  final FuelProduct product;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: product.type == 'GASOLINE'
            ? const Color(0xFFFFF2E4)
            : AppColors.lavender,
        child: Icon(
          Icons.water_drop_outlined,
          color: product.type == 'GASOLINE' ? AppColors.orange : AppColors.blue,
          size: 20,
        ),
      ),
      title: Text(product.name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Row(
        children: [
          Text(
            product.type,
            style: TextStyle(
              fontSize: 9,
              color: product.type == 'GASOLINE'
                  ? AppColors.orange
                  : AppColors.blue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '• ${product.status}',
            style: TextStyle(
              fontSize: 10,
              color: product.status == 'Low stock'
                  ? AppColors.orange
                  : product.status == 'Inactive'
                  ? AppColors.muted
                  : AppColors.green,
            ),
          ),
        ],
      ),
      trailing: Text(
        '\$${product.price.toStringAsFixed(2)}/L',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
  );
}

class EditProductPage extends StatefulWidget {
  const EditProductPage({required this.product, super.key});
  final FuelProduct product;
  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  var availability = 'Available';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Edit fuel product'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete_outline, color: AppColors.red),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
      children: [
        Text(
          'Update pricing and availability',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Text('FUEL NAME', style: labelStyle),
        const SizedBox(height: 7),
        TextFormField(initialValue: widget.product.name),
        const SizedBox(height: 16),
        Text('FUEL TYPE', style: labelStyle),
        const SizedBox(height: 7),
        Wrap(
          spacing: 7,
          children: ['Diesel', 'Gasoline', 'Premium']
              .map(
                (item) => ChoiceChip(
                  label: Text(item),
                  selected: widget.product.type.startsWith(item.toUpperCase()),
                  onSelected: (_) {},
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Text('PRICE PER LITER', style: labelStyle),
        const SizedBox(height: 7),
        TextFormField(
          initialValue: widget.product.price.toStringAsFixed(2),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'MXN'),
        ),
        const SizedBox(height: 16),
        Text('AVAILABILITY', style: labelStyle),
        const SizedBox(height: 7),
        ...['Available', 'Low stock', 'Inactive'].map(
          (item) => Card(
            color: availability == item
                ? const Color(0xFFE9FFF6)
                : Colors.white,
            child: RadioListTile(
              value: item,
              groupValue: availability,
              onChanged: (value) => setState(() => availability = value!),
              title: Text(item),
              subtitle: Text(
                item == 'Available'
                    ? 'Visible to customers, orders accepted'
                    : item == 'Low stock'
                    ? 'Flag on customer catalog'
                    : 'Hidden — no new orders',
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.ink,
            minimumSize: const Size.fromHeight(52),
          ),
          child: const Text('Save product'),
        ),
      ],
    ),
  );
}

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
    children: [
      Text(
        'Planes y precios',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 6),
      Text(
        'Elige el plan que acompaña tu operación.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 20),
      Plan(
        title: 'Esencial',
        price: 'S/ 0',
        features: const ['Proveedores verificados', 'Seguimiento de pedidos'],
        dark: false,
      ),
      const SizedBox(height: 12),
      Plan(
        title: 'Operación',
        price: 'S/ 149',
        features: const [
          'Todo lo de Esencial',
          'Alertas de stock',
          'Soporte prioritario',
        ],
        dark: true,
      ),
    ],
  );
}

class Plan extends StatelessWidget {
  const Plan({
    required this.title,
    required this.price,
    required this.features,
    required this.dark,
    super.key,
  });
  final String title;
  final String price;
  final List<String> features;
  final bool dark;
  @override
  Widget build(BuildContext context) => Card(
    color: dark ? AppColors.ink : Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: dark ? Colors.white : AppColors.ink),
          ),
          const SizedBox(height: 12),
          Text(
            price,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: dark ? AppColors.orange : AppColors.ink,
            ),
          ),
          const SizedBox(height: 18),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 17,
                    color: dark ? AppColors.green : AppColors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    feature,
                    style: TextStyle(
                      color: dark ? Colors.white70 : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () {}, child: const Text('Comenzar')),
        ],
      ),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.language,
    required this.onLanguage,
    super.key,
  });
  final String language;
  final VoidCallback onLanguage;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
    children: [
      Text('Perfil', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 18),
      Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(14),
          leading: const CircleAvatar(
            backgroundColor: AppColors.ink,
            child: Text('A', style: TextStyle(color: Colors.white)),
          ),
          title: const Text('Alex Rodríguez'),
          subtitle: const Text('Empresa compradora'),
        ),
      ),
      const SizedBox(height: 18),
      ProfileRow(
        icon: Icons.info_outline,
        title: 'About Us',
        onTap: () => push(
          context,
          const InfoPage(
            title: 'About Us',
            heading: 'Energía que mueve mejores negocios.',
            body: 'FullTank conecta empresas compradoras con proveedores de combustible confiables para que cada operación tenga visibilidad, control y continuidad.',
          ),
        ),
      ),
      ProfileRow(
        icon: Icons.route_outlined,
        title: 'How it works',
        onTap: () => push(
          context,
          const InfoPage(
            title: 'How it works',
            heading: 'Pedir. Seguir. Recibir.',
            body: 'Encuentra el combustible, elige un proveedor verificado y sigue tu pedido hasta que llegue a tu operación.',
          ),
        ),
      ),
      ProfileRow(
        icon: Icons.payments_outlined,
        title: 'Registrar información de pago',
        onTap: () => push(context, const PaymentPage()),
      ),
      ProfileRow(
        icon: Icons.dashboard_outlined,
        title: 'Panel de operación',
        onTap: () => push(context, const ProviderDashboardPage()),
      ),
      ProfileRow(
        icon: Icons.search,
        title: 'Buscar pedidos',
        onTap: () => push(context, const SearchOrdersPage()),
      ),
      ProfileRow(
        icon: Icons.notifications_none,
        title: 'Notificaciones',
        onTap: () => push(context, const NotificationsPage()),
      ),
      ProfileRow(
        icon: Icons.support_agent_outlined,
        title: 'Soporte y contacto',
        onTap: () => push(context, const SupportPage()),
      ),
      ProfileRow(
        icon: Icons.bar_chart_outlined,
        title: 'Reportes de ventas',
        onTap: () => push(context, const ReportsPage()),
      ),
      ProfileRow(
        icon: Icons.translate,
        title: 'Cambiar idioma',
        trailing: language,
        onTap: onLanguage,
      ),
      ProfileRow(icon: Icons.logout, title: 'Cerrar sesión', onTap: () {}),
    ],
  );
}

class ProfileRow extends StatelessWidget {
  const ProfileRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    super.key,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? trailing;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: AppColors.blue),
    title: Text(title),
    trailing: trailing == null
        ? const Icon(Icons.chevron_right)
        : Text(trailing!),
    onTap: onTap,
  );
}

class InfoPage extends StatelessWidget {
  const InfoPage({
    required this.title,
    required this.heading,
    required this.body,
    super.key,
  });
  final String title;
  final String heading;
  final String body;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(heading, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 18),
        Text(body, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 30),
        const Benefit(
          icon: Icons.verified_user_outlined,
          title: 'Proveedores verificados',
          body: 'Información clara para decidir.',
        ),
        const Benefit(
          icon: Icons.track_changes,
          title: 'Visibilidad total',
          body: 'Conoce el estado en cada momento.',
        ),
        const Benefit(
          icon: Icons.bolt,
          title: 'Operación simple',
          body: 'Menos llamadas. Más control.',
        ),
        const SizedBox(height: 14),
        Text(
          'Lo que dicen nuestros clientes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Testimonial(
          name: 'Carlos Ramírez',
          company: 'PetroAndes S.A.',
          quote: 'Ahora sabemos exactamente cuándo llega cada pedido.',
        ),
        const Testimonial(
          name: 'María López',
          company: 'Callao Combustibles',
          quote: 'La operación dejó de depender de mensajes dispersos.',
        ),
      ],
    ),
  );
}

class Benefit extends StatelessWidget {
  const Benefit({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });
  final IconData icon;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.lavender,
          child: Icon(icon, color: AppColors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );
}

class Testimonial extends StatelessWidget {
  const Testimonial({
    required this.name,
    required this.company,
    required this.quote,
    super.key,
  });
  final String name;
  final String company;
  final String quote;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '“',
            style: TextStyle(fontSize: 30, color: AppColors.orange, height: .8),
          ),
          Text(quote, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          Text(name, style: Theme.of(context).textTheme.titleMedium),
          Text(company, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    ),
  );
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var bank = 'BBVA Continental';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Registrar pago')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const OrderSummary(order: demoOrders[0]),
        const SizedBox(height: 18),
        Text(
          'Información del pago',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Número de operación',
            prefixIcon: Icon(Icons.tag),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: bank,
          decoration: const InputDecoration(labelText: 'Banco'),
          items: const ['BBVA Continental', 'Interbank', 'BCP']
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) => setState(() => bank = value!),
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Fecha de depósito',
            prefixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 12),
        const TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Monto depositado',
            prefixText: 'S/ ',
          ),
        ),
        const SizedBox(height: 20),
        const StatusBanner(
          icon: Icons.check_circle,
          title: 'Monto coincidente',
          body: 'El monto coincide con el total del pedido.',
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => showSuccess(
            context,
            'Pago registrado correctamente',
            'El proveedor recibirá la validación de tu operación.',
          ),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.ink,
            minimumSize: const Size.fromHeight(52),
          ),
          child: const Text('Registrar pago'),
        ),
      ],
    ),
  );
}

class ProviderDashboardPage extends StatelessWidget {
  const ProviderDashboardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Panel de operación')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Pedidos pendientes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          '4 solicitudes · revisa y responde a tiempo',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Metric(label: 'PENDIENTES', value: '04', color: AppColors.orange),
            const SizedBox(width: 8),
            Metric(label: 'APROBADOS', value: '12', color: AppColors.blue),
            const SizedBox(width: 8),
            Metric(label: 'INGRESOS', value: '148k', color: AppColors.green),
          ],
        ),
        const SizedBox(height: 18),
        const Wrap(
          spacing: 7,
          children: [
            Chip(label: Text('Todos')),
            Chip(label: Text('Pendiente')),
            Chip(label: Text('Alta prioridad')),
          ],
        ),
        const SizedBox(height: 14),
        ...demoOrders
            .take(3)
            .map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ProviderOrderCard(order: order),
              ),
            ),
      ],
    ),
  );
}

class ProviderOrderCard extends StatelessWidget {
  const ProviderOrderCard({required this.order, super.key});
  final Order order;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Solicitud de hoy',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              StatusPill(status: order.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.provider, style: Theme.of(context).textTheme.titleLarge),
          Text(
            '${order.product} · ${order.quantity} L',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => push(context, RejectOrderPage(order: order)),
                  child: const Text('Rechazar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      push(context, ApproveOrderPage(order: order)),
                  child: const Text('Aprobar'),
                ),
              ),
            ],
          ),
          if (order.status == OrderStatus.approved)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => push(context, const DispatchPage()),
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text('Despachar pedido'),
              ),
            ),
          if (order.status == OrderStatus.transit)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => push(context, const CloseOrderPage()),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Cerrar pedido'),
              ),
            ),
        ],
      ),
    ),
  );
}

class ApproveOrderPage extends StatelessWidget {
  const ApproveOrderPage({required this.order, super.key});
  final Order order;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Aprobar pedido')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        OrderSummary(order: order),
        const SizedBox(height: 18),
        Text(
          'Validación de pago',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const ValidationRow(label: 'Formato de operación válido', state: 'OK'),
        const ValidationRow(label: 'Banco verificado', state: 'OK'),
        const ValidationRow(label: 'Monto coincide con el pedido', state: 'OK'),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => showSuccess(
            context,
            'Pedido aprobado',
            'El cliente será notificado y el pedido pasará a despacho.',
          ),
          icon: const Icon(Icons.check),
          label: const Text('Sí, aprobar pedido'),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.green),
          ),
        ),
      ],
    ),
  );
}

class ValidationRow extends StatelessWidget {
  const ValidationRow({required this.label, required this.state, super.key});
  final String label;
  final String state;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.check_circle, color: AppColors.green),
      title: Text(label),
      trailing: Text(
        state,
        style: const TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class DispatchPage extends StatelessWidget {
  const DispatchPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Despachar pedido')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const StatusBanner(
          icon: Icons.local_shipping,
          title: 'Pedido aprobado',
          body: 'Listo para despacho',
        ),
        const SizedBox(height: 18),
        const Timeline(status: OrderStatus.approved),
        const SizedBox(height: 18),
        const TextField(
          decoration: InputDecoration(labelText: 'Vehículo asignado'),
        ),
        const SizedBox(height: 12),
        const TextField(decoration: InputDecoration(labelText: 'Conductor')),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => showSuccess(
            context,
            'Pedido en camino',
            'El cliente recibió la notificación.',
          ),
          icon: const Icon(Icons.local_shipping),
          label: const Text('Marcar como despachado'),
        ),
      ],
    ),
  );
}

class CloseOrderPage extends StatelessWidget {
  const CloseOrderPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cerrar pedido')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const StatusBanner(
          icon: Icons.check_circle,
          title: 'Entrega confirmada',
          body: 'Recibido por el cliente',
        ),
        const SizedBox(height: 18),
        Text(
          'Confirmación del cliente',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Card(
          color: const Color(0xFFE9FFF6),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Firma digital validada. El cliente confirmó la recepción.',
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => showSuccess(
            context,
            'Pedido cerrado',
            'La operación se guardó en el historial.',
          ),
          child: const Text('Confirmar cierre'),
        ),
      ],
    ),
  );
}

class RejectOrderPage extends StatefulWidget {
  const RejectOrderPage({required this.order, super.key});
  final Order order;
  @override
  State<RejectOrderPage> createState() => _RejectOrderPageState();
}

class _RejectOrderPageState extends State<RejectOrderPage> {
  var reason = 'Stock insuficiente';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Rechazar pedido')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Motivo del rechazo',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...[
          'Stock insuficiente',
          'Problemas logísticos',
          'Fuera de cobertura',
          'Otro motivo',
        ].map(
          (item) => Card(
            child: RadioListTile(
              value: item,
              groupValue: reason,
              onChanged: (value) => setState(() => reason = value!),
              title: Text(item),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => showSuccess(
            context,
            'Pedido rechazado',
            'El cliente será notificado con el motivo seleccionado.',
          ),
          style: FilledButton.styleFrom(backgroundColor: AppColors.red),
          child: const Text('Sí, rechazar'),
        ),
      ],
    ),
  );
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reportes de ventas')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Reporte de operaciones',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text('Últimos 30 días', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 18),
        Row(
          children: [
            Metric(label: 'VENTAS', value: 'S/ 148k', color: AppColors.green),
            const SizedBox(width: 8),
            Metric(label: 'LITROS', value: '42.8k', color: AppColors.blue),
          ],
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ventas por semana',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (final value in [
                        38.0,
                        58.0,
                        46.0,
                        78.0,
                        64.0,
                        92.0,
                        70.0,
                      ])
                        Container(
                          width: 24,
                          height: value,
                          decoration: BoxDecoration(
                            color: value == 92
                                ? AppColors.orange
                                : AppColors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'L   M   M   J   V   S   D',
                  style: TextStyle(color: AppColors.muted, letterSpacing: 7),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: () => showSuccess(
            context,
            'Reporte listo',
            'El reporte mock está disponible para descargar.',
          ),
          icon: const Icon(Icons.download),
          label: const Text('Generar reporte'),
        ),
      ],
    ),
  );
}

class SearchOrdersPage extends StatefulWidget {
  const SearchOrdersPage({super.key});
  @override
  State<SearchOrdersPage> createState() => _SearchOrdersPageState();
}

class _SearchOrdersPageState extends State<SearchOrdersPage> {
  var query = '';
  @override
  Widget build(BuildContext context) {
    final results = demoOrders
        .where(
          (order) =>
              order.id.toLowerCase().contains(query.toLowerCase()) ||
              order.provider.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar pedido')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Código, cliente o proveedor',
            ),
          ),
          const SizedBox(height: 18),
          if (results.isEmpty)
            const EmptyState(
              title: 'No encontramos pedidos',
              body: 'Verifica el código o intenta con otro término.',
            )
          else
            ...results.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OrderCard(
                  order: order,
                  onTap: () => push(context, OrderDetailPage(order: order)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Notificaciones'),
      actions: [
        TextButton(onPressed: () {}, child: const Text('Marcar leídas')),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        NotificationCard(
          icon: Icons.check_circle,
          color: AppColors.green,
          title: 'Pedido aprobado',
          body: 'Combustibles del Norte aprobó tu pedido.',
        ),
        NotificationCard(
          icon: Icons.local_shipping,
          color: AppColors.blue,
          title: 'Pedido despachado',
          body: 'Tu pedido FT-88421 salió a destino.',
        ),
        NotificationCard(
          icon: Icons.warning_amber,
          color: AppColors.orange,
          title: 'Tanque en advertencia',
          body: 'Diesel Tank A-102 está al 22%.',
        ),
      ],
    ),
  );
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    super.key,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: CircleAvatar(
        backgroundColor: color.withAlpha(22),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(body),
      trailing: const Text(
        'Hace 12 min',
        style: TextStyle(fontSize: 10, color: AppColors.muted),
      ),
    ),
  );
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Soporte y contacto')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: const Color(0xFFE9FFF6),
          child: const ListTile(
            leading: Icon(Icons.circle, color: AppColors.green),
            title: Text('En línea ahora'),
            subtitle: Text('Horario: Lun–Dom · respuesta rápida'),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Preguntas frecuentes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const ExpansionTile(
          title: Text('¿Cómo cambio mi contraseña?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Desde tu perfil, selecciona seguridad y sigue los pasos.',
              ),
            ),
          ],
        ),
        const ExpansionTile(
          title: Text('¿Cuándo se confirma un pedido?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'El proveedor valida disponibilidad y pago antes de aprobarlo.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('Contacto directo', style: Theme.of(context).textTheme.titleLarge),
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: const Text('soporte@fulltank.com'),
          trailing: TextButton(onPressed: () {}, child: const Text('Enviar')),
        ),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: const Text('+52 800 FUEL'),
          trailing: TextButton(onPressed: () {}, child: const Text('Llamar')),
        ),
      ],
    ),
  );
}

class StatusBanner extends StatelessWidget {
  const StatusBanner({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });
  final IconData icon;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.lavender,
    child: ListTile(
      leading: Icon(icon, color: AppColors.blue),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(body),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.title, required this.body, super.key});
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Icon(Icons.search_off, color: AppColors.blue, size: 46),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}

void showSuccess(BuildContext context, String title, String body) =>
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
