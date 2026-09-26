part of 'missing_pages.dart';

enum PaymentState { checkout, processing, success, error }

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
      final api = widget.api ?? FullTankApi(ApiClient());
      final created = await api.createPayment({
        'orderId': orderId,
        'companyId': 1,
        'amount': 42600,
        'paymentMethod': switch (_method) {
          'Transferencia bancaria' => 'BANK_TRANSFER',
          _ => 'CREDIT_CARD',
        },
      });
      if (created is! Map)
        throw const FormatException('Invalid payment response');
      final paymentId = _intValue(created['id'] ?? created['paymentId']);
      if (paymentId == null) throw const FormatException('Missing payment id');
      await api.completePayment(
        paymentId,
        'MOBILE-${DateTime.now().millisecondsSinceEpoch}',
      );
      if (mounted) setState(() => _state = PaymentState.success);
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
      PaymentState.success => 'Pago confirmado',
      PaymentState.error => 'No pudimos procesar el pago',
    },
    subtitle: '#${widget.orderId} · Pedido de combustible',
    child: switch (_state) {
      PaymentState.checkout => _checkout(context),
      PaymentState.processing => const _PaymentProgress(),
      PaymentState.success => _paymentResult(context, true),
      PaymentState.error => _paymentResult(context, false),
    },
  );

  Widget _checkout(BuildContext context) => Column(
    children: [
      const _OrderTotalCard(),
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
                    subtitle: Text('•••• 4242 · vence 08/28'),
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
      _PrimaryButton(label: 'Pagar S/ 42,600', onPressed: _submitPayment),
      TextButton(
        onPressed: () => context.push('/orders/FT-88421'),
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
              ? () => context.go('/orders/FT-88421')
              : () => setState(() => _state = PaymentState.checkout),
        ),
      ],
    ),
  );
}

class _OrderTotalCard extends StatelessWidget {
  const _OrderTotalCard();

  @override
  Widget build(BuildContext context) => _Panel(
    color: _blueSoft,
    child: const Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.local_shipping_outlined, color: _blue),
          ),
          title: Text('Diésel B5'),
          subtitle: Text('12,000 L · Entrega 8 sep'),
        ),
        Divider(color: _line),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
            Text(
              'S/ 42,600',
              style: TextStyle(
                fontSize: 29.0,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
          ],
        ),
      ],
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
          'Conectando con tu banco...',
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
