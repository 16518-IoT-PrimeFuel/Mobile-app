part of 'missing_pages.dart';

enum PaymentState { checkout, processing, success, error }

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    this.orderId = 'FT-88421',
    this.initialState = PaymentState.checkout,
    super.key,
  });
  final String orderId;
  final PaymentState initialState;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late PaymentState _state = widget.initialState;
  String _method = 'Tarjeta corporativa';

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
      _PrimaryButton(
        label: 'Pagar S/ 42,600',
        onPressed: () => setState(() => _state = PaymentState.processing),
      ),
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
        const SizedBox(height: 18),
        _PrimaryButton(
          label: 'Simular resultado exitoso',
          onPressed: () => context.go('/orders/FT-88421/payment?state=success'),
        ),
      ],
    ),
  );
}
