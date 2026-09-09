part of 'order_pages.dart';

class _CreationLoading extends StatelessWidget {
  const _CreationLoading();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _blueSoft,
          border: Border.all(color: const Color(0xFFD6E3FF)),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            Container(
              width: 27,
              height: 27,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: _blue,
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comprobando disponibilidad',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Verificando flota · ETA de ruta · stock',
                  style: TextStyle(color: _muted, fontSize: 7),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const _FieldCaption(label: 'TIPO DE COMBUSTIBLE'),
      const SizedBox(height: 6),
      const _LoadingGrid(),
      const SizedBox(height: 12),
      const _FieldCaption(label: 'TANQUE ASOCIADO'),
      const SizedBox(height: 6),
      const _LoadingBlock(height: 52),
      const SizedBox(height: 12),
      const _FieldCaption(label: 'VALIDANDO PROVEEDOR'),
      const SizedBox(height: 6),
      const _LoadingBlock(height: 52),
    ],
  );
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();
  @override
  Widget build(BuildContext context) => GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    mainAxisSpacing: 6,
    crossAxisSpacing: 6,
    childAspectRatio: 2.25,
    children: [for (var i = 0; i < 4; i++) const _LoadingBlock(height: 41)],
  );
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({required this.height});
  final double height;
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(9),
    ),
    child: const SizedBox.shrink(),
  );
}

class _SuccessDetails extends StatelessWidget {
  const _SuccessDetails();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NÚMERO DE PEDIDO',
                    style: TextStyle(
                      color: _subtle,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '#FT-88421',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7DF),
                borderRadius: BorderRadius.all(Radius.circular(99)),
              ),
              child: const Text(
                '• Pendiente',
                style: TextStyle(
                  color: _orange,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            '▧ Copiar ID',
            style: TextStyle(color: _muted, fontSize: 7),
          ),
        ),
        const Divider(height: 14, color: _line),
        const _SuccessRow(label: 'Combustible', value: 'Diésel · ULSD B5'),
        const _SuccessRow(label: 'Cantidad', value: '6,000 L'),
        const _SuccessRow(label: 'Tanque', value: 'A-102 · Sector 4'),
        const _SuccessRow(label: 'Proveedor', value: 'Global Fuel Corp'),
        const _SuccessRow(label: 'Requerido', value: '5 sep, 08:00 – 12:00'),
        const _SuccessRow(label: 'Estimado', value: '\$9,274.80'),
      ],
    ),
  );
}

class _SuccessRow extends StatelessWidget {
  const _SuccessRow({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
