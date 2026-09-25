part of 'missing_pages.dart';

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
