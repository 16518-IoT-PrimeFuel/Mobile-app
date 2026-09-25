part of 'missing_pages.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Inventario de productos',
    subtitle: 'Catálogo y existencias',
    actions: [
      IconButton(
        onPressed: () => context.push('/inventory/products/new'),
        icon: const Icon(Icons.add),
        tooltip: 'Agregar producto',
      ),
    ],
    child: Column(
      children: [
        _ProductTile(
          name: 'Diésel B5',
          stock: '48,000 L disponibles',
          price: 'S/ 3.55/L',
          onTap: () => context.push('/inventory/products/diesel'),
        ),
        _ProductTile(
          name: 'Gasolina regular',
          stock: '22,400 L disponibles',
          price: 'S/ 4.20/L',
          onTap: () => context.push('/inventory/products/gasolina'),
        ),
        _ProductTile(
          name: 'Gasolina premium',
          stock: '8,600 L disponibles',
          price: 'S/ 4.85/L',
          onTap: () => context.push('/inventory/products/premium'),
        ),
      ],
    ),
  );
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.name,
    required this.stock,
    required this.price,
    required this.onTap,
  });
  final String name;
  final String stock;
  final String price;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: _Panel(
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: _orangeSoft,
            child: Icon(Icons.water_drop_outlined, color: _orange),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                Text(stock, style: const TextStyle(color: _muted)),
                Text(
                  price,
                  style: const TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _muted),
        ],
      ),
    ),
  );
}

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({this.productId, super.key});
  final String? productId;
  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: widget.productId == null ? '' : 'Diésel B5',
  );
  late final _price = TextEditingController(
    text: widget.productId == null ? '' : '3.55',
  );
  late final _stock = TextEditingController(
    text: widget.productId == null ? '' : '48000',
  );

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _stock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: widget.productId == null ? 'Agregar producto' : 'Editar producto',
    subtitle: 'Mantén actualizado tu catálogo',
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          _Panel(
            child: Column(
              children: [
                _FormField(label: 'Nombre del producto', controller: _name),
                _FormField(
                  label: 'Precio por litro',
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                _FormField(
                  label: 'Stock disponible (L)',
                  controller: _stock,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _PrimaryButton(
            label: widget.productId == null
                ? 'Guardar producto'
                : 'Guardar cambios',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _message(context, 'Producto guardado correctamente.');
              }
            },
          ),
          if (widget.productId != null)
            TextButton(
              onPressed: () => _message(context, 'Producto archivado.'),
              child: const Text(
                'Archivar producto',
                style: TextStyle(color: _red),
              ),
            ),
        ],
      ),
    ),
  );
}

void _message(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
