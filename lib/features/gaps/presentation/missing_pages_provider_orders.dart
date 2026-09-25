part of 'missing_pages.dart';

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
