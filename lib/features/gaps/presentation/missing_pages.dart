import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/fulltank_bottom_navigation.dart';

const _ink = Color(0xFF1A202C);
const _muted = Color(0xFF4A5568);
const _line = Color(0xFFE2E8F0);
const _blue = Color(0xFF1E40AF);
const _blueSoft = Color(0xFFEFF4FF);
const _green = Color(0xFF0F9B91);
const _greenSoft = Color(0xFFEAFBF8);
const _orange = Color(0xFFFF8A0A);
const _orangeSoft = Color(0xFFFFF4E9);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFEF2F2);

class MissingPageShell extends StatelessWidget {
  const MissingPageShell({
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.bottomNav,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  final int? bottomNav;

  @override
  Widget build(BuildContext context) {
    final showBack =
        GoRouter.maybeOf(context)?.canPop() ?? Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showBack)
                    IconButton(
                      onPressed: context.pop,
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Volver',
                      visualDensity: VisualDensity.compact,
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 33.35,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.4,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 19.575,
                              height: 1.5,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ...actions,
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNav == null
          ? null
          : FullTankBottomNav(active: bottomNav!),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.color = Colors.white});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: Material(color: Colors.transparent, child: child),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: _muted,
        fontSize: 15.95,
        fontWeight: FontWeight.w800,
        letterSpacing: .6,
      ),
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _blue,
        minimumSize: const Size.fromHeight(52),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 20.3, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    ),
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.label, this.color, this.background);
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 14.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _ink,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: _orange,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.local_gas_station, size: 42, color: _ink),
          ),
          const SizedBox(height: 16),
          const Text(
            'FullTank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 43.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Energía que mueve tu operación',
            style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 19.575),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => context.go('/login'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF64748B)),
              minimumSize: const Size.fromHeight(52),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontSize: 20.3),
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    ),
  );
}

enum SignupRole { requester, provider }

class SignupPage extends StatefulWidget {
  const SignupPage({required this.role, super.key});
  final SignupRole role;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _accepted = false;
  bool _submitted = false;

  @override
  void dispose() {
    for (final controller in [_company, _name, _email, _phone, _password]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.role == SignupRole.provider
        ? 'Registra tu empresa proveedora'
        : 'Crea tu cuenta empresarial';
    if (_submitted) {
      return MissingPageShell(
        title: 'Solicitud enviada',
        child: _Panel(
          color: _greenSoft,
          child: Column(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                color: _green,
                size: 48,
              ),
              const SizedBox(height: 10),
              const Text(
                'Revisaremos tus datos y te avisaremos por correo cuando tu cuenta esté lista.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              _PrimaryButton(
                label: 'Volver al inicio de sesión',
                onPressed: () => context.go('/login'),
              ),
            ],
          ),
        ),
      );
    }
    return MissingPageShell(
      title: title,
      subtitle: 'Completa la información para comenzar',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Panel(
              child: Column(
                children: [
                  _FormField(label: 'Empresa', controller: _company),
                  _FormField(label: 'Nombre completo', controller: _name),
                  _FormField(
                    label: 'Correo corporativo',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value != null && value.contains('@')
                        ? null
                        : 'Ingresa un correo válido',
                  ),
                  _FormField(
                    label: 'Teléfono',
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                  ),
                  _FormField(
                    label: 'Contraseña',
                    controller: _password,
                    obscureText: true,
                    validator: (value) => value != null && value.length >= 8
                        ? null
                        : 'Usa al menos 8 caracteres',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _accepted,
              onChanged: (value) => setState(() => _accepted = value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Acepto los términos y la política de privacidad',
              ),
            ),
            _PrimaryButton(label: 'Enviar solicitud', onPressed: _submit),
            Center(
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Ya tengo una cuenta'),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => context.go(
                  widget.role == SignupRole.provider
                      ? '/signup/requester'
                      : '/signup/provider',
                ),
                child: Text(
                  widget.role == SignupRole.provider
                      ? '¿Solicitas combustible? Regístrate como cliente'
                      : '¿Provees combustible? Regístrate como proveedor',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Acepta los términos para continuar.')),
      );
      return;
    }
    if (valid) {
      setState(() => _submitted = true);
    }
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator:
          validator ??
          (value) => value == null || value.trim().isEmpty
              ? 'Este campo es obligatorio'
              : null,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

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

class ProviderOrdersPage extends StatelessWidget {
  const ProviderOrdersPage({super.key});

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Pedidos por atender',
    subtitle: '2 solicitudes requieren una decisión',
    bottomNav: 1,
    child: Column(
      children: [
        _ProviderOrderCard(
          id: 'FT-2098',
          customer: 'AgroNorte',
          detail: '12,000 L · Diésel B5 · entrega hoy',
          status: 'Pendiente',
          color: _orange,
          onTap: () => context.push('/provider/orders/FT-2098'),
        ),
        const SizedBox(height: 10),
        _ProviderOrderCard(
          id: 'FT-2091',
          customer: 'Transportes Delta',
          detail: '8,000 L · Gasolina regular · 3:00 PM',
          status: 'Aprobado',
          color: _green,
          onTap: () => context.push('/provider/orders/FT-2091/dispatch'),
        ),
        const SizedBox(height: 16),
        _PrimaryButton(
          label: 'Ver historial de ventas',
          onPressed: () => context.push('/reports/sales'),
        ),
      ],
    ),
  );
}

class _ProviderOrderCard extends StatelessWidget {
  const _ProviderOrderCard({
    required this.id,
    required this.customer,
    required this.detail,
    required this.status,
    required this.color,
    required this.onTap,
  });
  final String id;
  final String customer;
  final String detail;
  final String status;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '#$id',
                style: const TextStyle(
                  color: _blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _StatusChip(status, color, color.withAlpha(28)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            customer,
            style: const TextStyle(
              fontSize: 23.2,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          Text(detail, style: const TextStyle(color: _muted)),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text(
                'Abrir detalle',
                style: TextStyle(color: _blue, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 16, color: _blue),
            ],
          ),
        ],
      ),
    ),
  );
}

class ProviderOrderDetailPage extends StatelessWidget {
  const ProviderOrderDetailPage({required this.orderId, super.key});
  final String orderId;

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Pedido #$orderId',
    subtitle: 'Revisión de solicitud',
    child: Column(
      children: [
        const _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AgroNorte S.A.',
                style: TextStyle(
                  fontSize: 26.1,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              SizedBox(height: 6),
              Text('Diésel B5 · 12,000 L'),
              Text(
                'Entrega: Av. Industrial 442 · 8 sep, 10:00 AM',
                style: TextStyle(color: _muted),
              ),
              Divider(height: 24, color: _line),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total'),
                  Text(
                    'S/ 42,600',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _PrimaryButton(
          label: 'Aprobar pedido',
          onPressed: () =>
              _message(context, 'Pedido aprobado. Ahora asigna el despacho.'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => context.push('/provider/orders/$orderId/reject'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: const StadiumBorder(),
            foregroundColor: _red,
          ),
          child: const Text('Rechazar pedido'),
        ),
      ],
    ),
  );
}

class ProviderOrderActionPage extends StatefulWidget {
  const ProviderOrderActionPage({
    required this.orderId,
    required this.action,
    super.key,
  });
  final String orderId;
  final String action;

  @override
  State<ProviderOrderActionPage> createState() =>
      _ProviderOrderActionPageState();
}

class _ProviderOrderActionPageState extends State<ProviderOrderActionPage> {
  final _note = TextEditingController();
  bool _done = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReject = widget.action == 'reject';
    final isClose = widget.action == 'close';
    final title = switch (widget.action) {
      'dispatch' => 'Asignar despacho',
      'close' => 'Cerrar pedido',
      _ => 'Rechazar pedido',
    };
    if (_done) {
      return MissingPageShell(
        title: 'Acción completada',
        child: _Panel(
          color: _greenSoft,
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: _green, size: 48),
              const SizedBox(height: 10),
              Text(
                'El pedido #${widget.orderId} fue actualizado.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              _PrimaryButton(
                label: 'Volver a pedidos',
                onPressed: () => context.go('/provider/orders'),
              ),
            ],
          ),
        ),
      );
    }
    return MissingPageShell(
      title: title,
      subtitle: '#${widget.orderId}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.action == 'dispatch') ...[
            const _SectionTitle('VEHÍCULO DISPONIBLE'),
            _Panel(
              child: RadioGroup<String>(
                groupValue: 'TRK-044',
                onChanged: (_) {},
                child: const RadioListTile<String>(
                  value: 'TRK-044',
                  contentPadding: EdgeInsets.zero,
                  title: Text('TRK-044 · Transportes Delta'),
                  subtitle: Text('Cisterna 15,000 L · disponible'),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _Panel(
            child: TextField(
              controller: _note,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: isReject
                    ? 'Motivo del rechazo'
                    : isClose
                    ? 'Nota de cierre'
                    : 'Indicaciones para despacho',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _PrimaryButton(
            label: isReject
                ? 'Confirmar rechazo'
                : isClose
                ? 'Cerrar pedido'
                : 'Asignar y notificar',
            onPressed: () => setState(() => _done = true),
          ),
        ],
      ),
    );
  }
}

class SupportHelpPage extends StatelessWidget {
  const SupportHelpPage({super.key});

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Centro de ayuda',
    subtitle: 'Encuentra una respuesta o contáctanos',
    bottomNav: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          readOnly: true,
          onTap: () => context.push('/orders/search'),
          decoration: InputDecoration(
            hintText: '¿Qué necesitas resolver?',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.arrow_forward),
            filled: true,
            fillColor: _blueSoft,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _SectionTitle('PREGUNTAS FRECUENTES'),
        _FaqTile(
          question: '¿Cómo creo un pedido?',
          answer:
              'Ve a Pedidos y pulsa el botón + para seleccionar producto, cantidad y fecha.',
        ),
        _FaqTile(
          question: '¿Cómo consulto el estado de mi entrega?',
          answer:
              'Abre el pedido desde Mis pedidos para ver el seguimiento y el despacho asignado.',
        ),
        _FaqTile(
          question: '¿Qué métodos de pago aceptan?',
          answer:
              'Puedes pagar con tarjeta corporativa o transferencia bancaria.',
        ),
        const SizedBox(height: 12),
        _PrimaryButton(
          label: 'Contactar soporte',
          onPressed: () => context.push('/support/contact'),
        ),
      ],
    ),
  );
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 7),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(11),
      side: const BorderSide(color: _line),
    ),
    child: ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Text(answer, style: const TextStyle(color: _muted)),
        ),
      ],
    ),
  );
}

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _message = TextEditingController();
  String _topic = 'Pedido';
  bool _sent = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Contactar soporte',
    subtitle: 'Respondemos normalmente en menos de 2 horas',
    child: _sent
        ? _Panel(
            color: _greenSoft,
            child: Column(
              children: [
                const Icon(Icons.mark_email_read, color: _green, size: 48),
                const SizedBox(height: 10),
                const Text(
                  'Ticket enviado. Te contactaremos por correo.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                _PrimaryButton(
                  label: 'Volver al centro de ayuda',
                  onPressed: () => context.go('/support/help'),
                ),
              ],
            ),
          )
        : Column(
            children: [
              _Panel(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _topic,
                      decoration: InputDecoration(
                        labelText: 'Tema',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Pedido',
                          child: Text('Pedido'),
                        ),
                        DropdownMenuItem(value: 'Pago', child: Text('Pago')),
                        DropdownMenuItem(
                          value: 'Cuenta',
                          child: Text('Cuenta'),
                        ),
                      ],
                      onChanged: (value) => setState(() => _topic = value!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _message,
                      maxLines: 6,
                      decoration: InputDecoration(
                        labelText: 'Cuéntanos qué pasó',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _PrimaryButton(
                label: 'Enviar ticket',
                onPressed: () {
                  if (_message.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Describe el problema para continuar.'),
                      ),
                    );
                    return;
                  }
                  setState(() => _sent = true);
                },
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

class NotificationsCenterPage extends StatefulWidget {
  const NotificationsCenterPage({super.key});
  @override
  State<NotificationsCenterPage> createState() =>
      _NotificationsCenterPageState();
}

class _NotificationsCenterPageState extends State<NotificationsCenterPage> {
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
        for (var i = 0; i < _items.length; i++)
          _NotificationTile(
            item: _items[i],
            onTap: () => setState(() {
              final item = _items[i];
              _items[i] = (
                title: item.title,
                detail: item.detail,
                icon: item.icon,
                read: true,
              );
            }),
          ),
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

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});
  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Clientes',
    subtitle: '24 cuentas activas',
    actions: [
      IconButton(
        onPressed: () => context.push('/customers/new'),
        icon: const Icon(Icons.add),
        tooltip: 'Agregar cliente',
      ),
    ],
    bottomNav: 4,
    child: Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Buscar cliente',
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        ),
        const SizedBox(height: 12),
        _CustomerTile(
          name: 'AgroNorte S.A.',
          detail: 'Monterrey · 8 pedidos este mes',
          initials: 'AN',
          onTap: () => context.push('/customers/agronorte'),
        ),
        _CustomerTile(
          name: 'Transportes Delta',
          detail: 'CDMX · 5 pedidos este mes',
          initials: 'TD',
          onTap: () => context.push('/customers/delta'),
        ),
        _CustomerTile(
          name: 'Cementos B',
          detail: 'Puebla · 3 pedidos este mes',
          initials: 'CB',
          onTap: () => context.push('/customers/cementos'),
        ),
      ],
    ),
  );
}

class CustomerFormPage extends StatefulWidget {
  const CustomerFormPage({this.customerId, super.key});
  final String? customerId;

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: widget.customerId == null ? '' : 'AgroNorte S.A.',
  );
  late final _email = TextEditingController(
    text: widget.customerId == null ? '' : 'operaciones@cliente.com',
  );
  late final _phone = TextEditingController(
    text: widget.customerId == null ? '' : '+51 999 888 777',
  );

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: widget.customerId == null ? 'Agregar cliente' : 'Editar cliente',
    subtitle: 'Información de contacto y operación',
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          _Panel(
            child: Column(
              children: [
                _FormField(label: 'Empresa', controller: _name),
                _FormField(
                  label: 'Correo de operaciones',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : 'Ingresa un correo válido',
                ),
                _FormField(
                  label: 'Teléfono',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _PrimaryButton(
            label: widget.customerId == null
                ? 'Guardar cliente'
                : 'Guardar cambios',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _message(context, 'Cliente guardado correctamente.');
              }
            },
          ),
        ],
      ),
    ),
  );
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({
    required this.name,
    required this.detail,
    required this.initials,
    required this.onTap,
  });
  final String name;
  final String detail;
  final String initials;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(vertical: 5),
    leading: CircleAvatar(
      backgroundColor: _blueSoft,
      child: Text(
        initials,
        style: const TextStyle(color: _blue, fontWeight: FontWeight.w800),
      ),
    ),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text(detail, style: const TextStyle(color: _muted)),
    trailing: const Icon(Icons.chevron_right),
  );
}

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({required this.customerId, super.key});
  final String customerId;
  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Detalle de cliente',
    subtitle: customerId == 'delta'
        ? 'Transportes Delta'
        : customerId == 'cementos'
        ? 'Cementos B'
        : 'AgroNorte S.A.',
    actions: [
      IconButton(
        onPressed: () => context.push('/customers/$customerId/edit'),
        icon: const Icon(Icons.edit_outlined),
        tooltip: 'Editar',
      ),
    ],
    child: Column(
      children: [
        const _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contacto principal', style: TextStyle(color: _muted)),
              SizedBox(height: 5),
              Text(
                'operaciones@cliente.com',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              Text('Pedidos últimos 30 días', style: TextStyle(color: _muted)),
              SizedBox(height: 5),
              Text(
                '8 pedidos · 32,000 L',
                style: TextStyle(fontSize: 26.1, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _PrimaryButton(
          label: 'Crear pedido para este cliente',
          onPressed: () => context.push('/orders/new'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _message(context, 'Cliente archivado.'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: const StadiumBorder(),
            foregroundColor: _red,
          ),
          child: const Text('Archivar cliente'),
        ),
      ],
    ),
  );
}

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
