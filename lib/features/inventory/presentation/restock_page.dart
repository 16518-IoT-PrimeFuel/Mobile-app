part of 'inventory_page.dart';

class RestockPage extends StatefulWidget {
  const RestockPage({required this.tankId, super.key});

  final String tankId;

  @override
  State<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends State<RestockPage> {
  late final TankData _tank;
  late final TextEditingController _quantityController;
  String _priority = 'urgent';
  int _quantity = 9000;

  @override
  void initState() {
    super.initState();
    _tank = _tankForId(widget.tankId);
    _quantityController = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _setQuantity(int value) {
    final next = value.clamp(0, _tank.capacity - _tank.current).toInt();
    setState(() {
      _quantity = next;
      _quantityController.text = next.toString();
      _quantityController.selection = TextSelection.collapsed(
        offset: _quantityController.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxQuantity = _tank.capacity - _tank.current;
    final delivery = switch (_priority) {
      'urgent' => 340.0,
      'standard' => 120.0,
      _ => 0.0,
    };
    final fuel = _quantity * 1.28;
    final taxes = _quantity == 9000 && _priority == 'urgent'
        ? 1884.16
        : (fuel + delivery) * .16;
    final total = fuel + delivery + taxes;
    return _withInventoryScale(
      context,
      _InventoryShell(
        title: 'Solicitud de reposición',
        subtitle: 'Solicita combustible para el tanque',
        back: true,
        hasBottomNav: false,
        children: [
          _TargetTankCard(tank: _tank),
          SizedBox(height: 18 * _uiScale),
          _InventorySectionLabel('Prioridad'),
          SizedBox(height: 8 * _uiScale),
          Row(
            children: [
              Expanded(
                child: _PriorityChip(
                  id: 'urgent',
                  label: 'Urgente',
                  detail: '< 4 h',
                  status: _TankStatus.critical,
                  selected: _priority == 'urgent',
                  onPressed: () => setState(() => _priority = 'urgent'),
                ),
              ),
              SizedBox(width: 8 * _uiScale),
              Expanded(
                child: _PriorityChip(
                  id: 'standard',
                  label: 'Estándar',
                  detail: '24 h',
                  status: _TankStatus.warning,
                  selected: _priority == 'standard',
                  onPressed: () => setState(() => _priority = 'standard'),
                ),
              ),
              SizedBox(width: 8 * _uiScale),
              Expanded(
                child: _PriorityChip(
                  id: 'planned',
                  label: 'Programada',
                  detail: '3–5 días',
                  status: _TankStatus.optimal,
                  selected: _priority == 'planned',
                  onPressed: () => setState(() => _priority = 'planned'),
                ),
              ),
            ],
          ),
          SizedBox(height: 18 * _uiScale),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const _InventorySectionLabel('Cantidad'),
              Text(
                'máx. ${_liters(maxQuantity)} L',
                style: const TextStyle(
                  color: FullTankColors.inkSoft,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8 * _uiScale),
          _QuantityPicker(
            controller: _quantityController,
            onChanged: (value) {
              final parsed = int.tryParse(value.replaceAll(',', '')) ?? 0;
              _quantity = parsed.clamp(0, maxQuantity).toInt();
            },
            onSubmitted: (value) => _setQuantity(
              int.tryParse(value.replaceAll(',', '')) ?? _quantity,
            ),
            onQuickPick: _setQuantity,
            maxQuantity: maxQuantity,
          ),
          SizedBox(height: 18 * _uiScale),
          const _FormInfoRow(
            icon: Icons.local_gas_station_outlined,
            label: 'Proveedor preferido',
            value: 'Global Fuel Corp',
          ),
          SizedBox(height: 12 * _uiScale),
          Row(
            children: [
              const Expanded(
                child: _FormInfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Fecha de entrega',
                  value: 'Hoy',
                ),
              ),
              SizedBox(width: 10 * _uiScale),
              const Expanded(
                child: _FormInfoRow(
                  icon: Icons.access_time,
                  label: 'Horario',
                  value: '14:00 – 17:00',
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * _uiScale),
          const _FormInfoRow(
            icon: Icons.send_outlined,
            label: 'Notas para el conductor',
            value: 'Puerta B, preguntar al supervisor de turno',
          ),
          SizedBox(height: 18 * _uiScale),
          _OrderSummary(
            quantity: _quantity,
            fuel: fuel,
            delivery: delivery,
            taxes: taxes,
            total: total,
          ),
          SizedBox(height: 18 * _uiScale),
          _PrimaryButton(
            label: 'Enviar solicitud',
            onPressed: () {
              if (_quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ingresa una cantidad primero.'),
                  ),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Solicitud lista para enviar.')),
              );
            },
          ),
          SizedBox(height: 10 * _uiScale),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 14,
                color: FullTankColors.inkSoft,
              ),
              SizedBox(width: 5),
              Text(
                'Transmisión cifrada · SLA garantizado',
                style: TextStyle(color: FullTankColors.inkSoft, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
