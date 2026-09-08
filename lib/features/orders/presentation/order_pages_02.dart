part of 'order_pages.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({
    this.initialState = NewOrderState.defaultState,
    super.key,
  });

  final NewOrderState initialState;

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  late NewOrderState _state = widget.initialState;
  String _fuel = 'Diesel';

  @override
  Widget build(BuildContext context) {
    final loading = _state == NewOrderState.loading;
    final success = _state == NewOrderState.success;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: success
              ? _successBody(context)
              : _formBody(context, loading: loading),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: _NewOrderAction(state: _state, onCreate: _create),
        ),
      ),
    );
  }

  Widget _formBody(BuildContext context, {required bool loading}) {
    final error = _state == NewOrderState.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: loading ? 'Creating order' : 'New Order',
          subtitle: loading
              ? 'Validating supplier availability...'
              : error
              ? 'Fix the errors below to continue'
              : 'Register a new fuel request',
          actions: [
            if (loading)
              _HeaderIcon(
                icon: Icons.close,
                label: 'Cancelar creación',
                onTap: () =>
                    setState(() => _state = NewOrderState.defaultState),
              )
            else
              _HeaderIcon(
                icon: Icons.more_horiz,
                label: 'Más opciones',
                onTap: () {},
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (loading)
          const _CreationLoading()
        else ...[
          if (error)
            _ConnectionErrorCard(
              onRetry: () =>
                  setState(() => _state = NewOrderState.defaultState),
            ),
          if (error) const SizedBox(height: 10),
          _FieldCaption(label: 'FUEL TYPE', error: error),
          const SizedBox(height: 6),
          _FuelGrid(
            selected: _fuel,
            error: error,
            onSelected: (fuel) => setState(() {
              _fuel = fuel;
              if (_state == NewOrderState.error)
                _state = NewOrderState.defaultState;
            }),
          ),
          if (error) ...[
            const SizedBox(height: 5),
            const Text(
              'ⓘ  Select a fuel type to continue.',
              style: TextStyle(
                color: _red,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const _FieldCaption(label: 'MONTO DEPOSITADO'),
          const SizedBox(height: 6),
          const _MoneyCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'ASSOCIATED TANK'),
          const SizedBox(height: 6),
          const _TankCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'PREFERRED SUPPLIER'),
          const SizedBox(height: 6),
          const _SupplierCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'DELIVERY WINDOW'),
          const SizedBox(height: 6),
          const _DeliveryField(),
        ],
      ],
    );
  }

  Widget _successBody(BuildContext context) => Column(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: _HeaderIcon(
          icon: Icons.close,
          label: 'Cerrar confirmación',
          onTap: () => context.pop(),
        ),
      ),
      const SizedBox(height: 30),
      Container(
        width: 68,
        height: 68,
        decoration: const BoxDecoration(
          color: _greenSoft,
          shape: BoxShape.circle,
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 28),
        ),
      ),
      const SizedBox(height: 15),
      const Text(
        'Pedido creado\ncorrectamente',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _ink,
          fontSize: 17,
          height: 1.1,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 9),
      const Text(
        'Tu solicitud fue enviada al proveedor.\nRecibirás una notificación cuando sea\naprobada.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.45),
      ),
      const SizedBox(height: 20),
      const _SuccessDetails(),
    ],
  );

  void _create() {
    setState(() => _state = NewOrderState.loading);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _state = NewOrderState.success);
    });
  }
}

class _FieldCaption extends StatelessWidget {
  const _FieldCaption({required this.label, this.error = false});
  final String label;
  final bool error;
  @override
  Widget build(BuildContext context) => Text(
    error ? '$label · REQUIRED' : label,
    style: TextStyle(
      color: error ? _red : _subtle,
      fontSize: 7,
      fontWeight: FontWeight.w800,
      letterSpacing: .35,
    ),
  );
}

class _FuelGrid extends StatelessWidget {
  const _FuelGrid({
    required this.selected,
    required this.onSelected,
    required this.error,
  });
  final String selected;
  final ValueChanged<String> onSelected;
  final bool error;
  @override
  Widget build(BuildContext context) {
    const fuels = [
      ('Diesel', 'ULSD B5', Icons.opacity_outlined),
      ('Gasoline', '95 · 97', Icons.receipt_long_outlined),
      ('LPG', 'Propano', Icons.local_fire_department_outlined),
      ('Other', 'Custom', Icons.storage_outlined),
    ];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: error ? Border.all(color: _red) : null,
        borderRadius: BorderRadius.circular(9),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 2.25,
        children: [
          for (final fuel in fuels)
            _FuelChoice(
              name: fuel.$1,
              detail: fuel.$2,
              icon: fuel.$3,
              selected: selected == fuel.$1 && !error,
              onTap: () => onSelected(fuel.$1),
            ),
        ],
      ),
    );
  }
}

class _FuelChoice extends StatelessWidget {
  const _FuelChoice({
    required this.name,
    required this.detail,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String name, detail;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: '$name $detail',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? _blueSoft : _panel,
          border: Border.all(color: selected ? _blue : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: selected ? _blue : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : _muted,
                size: 14,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: selected ? _blue : _ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    detail,
                    style: const TextStyle(color: _muted, fontSize: 7),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: _blue, size: 13),
          ],
        ),
      ),
    ),
  );
}
