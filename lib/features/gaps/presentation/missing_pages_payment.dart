part of 'missing_pages.dart';

enum PaymentState { checkout, processing, pending, success, error }

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    this.orderId = 'FT-88421',
    this.initialState = PaymentState.checkout,
    this.api,
    super.key,
  });
  final String orderId;
  final PaymentState initialState;
  final FullTankApi? api;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late PaymentState _state = widget.initialState;
  String _method = 'Tarjeta corporativa';

  Future<void> _submitPayment() async {
    setState(() => _state = PaymentState.processing);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _processPayment();
    });
  }

  Future<void> _processPayment() async {
    try {
      final orderId = int.tryParse(widget.orderId);
      if (orderId == null) throw const FormatException('Invalid order id');
      final container = ProviderScope.containerOf(context, listen: false);
      final companyId = container
          .read(authControllerProvider)
          .session
          ?.companyId;
      if (companyId == null)
        throw StateError('Authenticated buyer company is required');
      final api =
          widget.api ?? container.read<FullTankApi>(fullTankApiProvider);
      final created = await api.createPayment({
        'orderId': orderId,
        'companyId': companyId,
        'paymentMethod': switch (_method) {
          'Transferencia bancaria' => 'BANK_TRANSFER',
          _ => 'CREDIT_CARD',
        },
      });
      if (created is! Map)
        throw const FormatException('Invalid payment response');
      final paymentId = _intValue(created['id'] ?? created['paymentId']);
      if (paymentId == null) throw const FormatException('Missing payment id');
      if (mounted) setState(() => _state = PaymentState.pending);
    } catch (_) {
      if (mounted) setState(() => _state = PaymentState.error);
    }
  }

  int? _intValue(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value');

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: switch (_state) {
      PaymentState.checkout => 'Confirmar pago',
      PaymentState.processing => 'Procesando pago',
      PaymentState.pending => 'Pago pendiente',
      PaymentState.success => 'Pago confirmado',
      PaymentState.error => 'No pudimos procesar el pago',
    },
    subtitle: '#${widget.orderId} · Pedido de combustible',
    child: switch (_state) {
      PaymentState.checkout => _checkout(context),
      PaymentState.processing => const _PaymentProgress(),
      PaymentState.pending => _Panel(
        child: Column(
          children: [
            const Icon(Icons.schedule, color: _blue, size: 48),
            const SizedBox(height: 14),
            const Text(
              'Pago registrado. La confirmación de la transacción está pendiente.',
            ),
            TextButton(
              onPressed: () => context.go('/orders/${widget.orderId}'),
              child: const Text('Ver pedido'),
            ),
          ],
        ),
      ),
      PaymentState.success => _paymentResult(context, true),
      PaymentState.error => _paymentResult(context, false),
    },
  );

  Widget _checkout(BuildContext context) => Column(
    children: [
      _OrderTotalCard(orderId: widget.orderId),
      const SizedBox(height: 14),
      const Align(
        alignment: Alignment.centerLeft,
        child: _SectionTitle('MÉTODO DE PAGO'),
      ),
      _Panel(
        child: Column(
          children: [
            RadioGroup<String>(
              groupValue: _method,
              onChanged: (value) {
                if (value != null) setState(() => _method = value);
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    value: 'Tarjeta corporativa',
                    title: Text('Tarjeta corporativa'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    value: 'Transferencia bancaria',
                    title: Text('Transferencia bancaria'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _PrimaryButton(label: 'Registrar pago', onPressed: _submitPayment),
      TextButton(
        onPressed: () => context.push('/orders/${widget.orderId}'),
        child: const Text('Revisar pedido'),
      ),
    ],
  );

  Widget _paymentResult(BuildContext context, bool success) => _Panel(
    color: success ? _greenSoft : _redSoft,
    child: Column(
      children: [
        Icon(
          success ? Icons.check_circle_outline : Icons.error_outline,
          color: success ? _green : _red,
          size: 52,
        ),
        const SizedBox(height: 10),
        Text(
          success
              ? 'Tu pago fue registrado correctamente.'
              : 'Verifica tus datos e intenta nuevamente.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        _PrimaryButton(
          label: success ? 'Ver pedido' : 'Intentar de nuevo',
          onPressed: success
              ? () => context.go('/orders/${widget.orderId}')
              : () => setState(() => _state = PaymentState.checkout),
        ),
      ],
    ),
  );
}

class _OrderTotalCard extends StatelessWidget {
  const _OrderTotalCard({required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) => _Panel(
    color: _blueSoft,
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.receipt_long_outlined, color: _blue),
      title: Text('Pedido #$orderId'),
      subtitle: const Text(
        'El importe se determina a partir del total del pedido. Registrar el pago no confirma el cobro.',
      ),
    ),
  );
}

class _PaymentProgress extends StatelessWidget {
  const _PaymentProgress();

  @override
  Widget build(BuildContext context) => _Panel(
    child: Column(
      children: [
        const CircularProgressIndicator(color: _blue),
        const SizedBox(height: 18),
        const Text(
          'Registrando pago...',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        const Text(
          'No cierres esta pantalla.',
          style: TextStyle(color: _muted),
        ),
      ],
    ),
  );
}
