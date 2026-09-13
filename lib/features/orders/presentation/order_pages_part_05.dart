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
                  'Checking availability',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Verifying supplier fleet · route ETA · fuel stock',
                  style: TextStyle(color: _muted, fontSize: 7),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const _FieldCaption(label: 'FUEL TYPE'),
      const SizedBox(height: 6),
      const _LoadingGrid(),
      const SizedBox(height: 12),
      const _FieldCaption(label: 'ASSOCIATED TANK'),
      const SizedBox(height: 6),
      const _LoadingBlock(height: 52),
      const SizedBox(height: 12),
      const _FieldCaption(label: 'VALIDATING SUPPLIER'),
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
  const _SuccessDetails({required this.order});
  final Order? order;
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORDER NUMBER',
                    style: TextStyle(
                      color: _subtle,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '#${order?.id ?? ''}',
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
              child: Text(
                '• ${order == null ? 'Pendiente' : _orderStatusLabel(order!.status)}',
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
            '▧ Copy ID',
            style: TextStyle(color: _muted, fontSize: 7),
          ),
        ),
        const Divider(height: 14, color: _line),
        _SuccessRow(label: 'Fuel type', value: order?.fuel ?? ''),
        _SuccessRow(
          label: 'Quantity',
          value: '${order?.quantity.toStringAsFixed(0) ?? ''} L',
        ),
        _SuccessRow(label: 'Delivery', value: order?.deliveryAddress ?? ''),
        _SuccessRow(
          label: 'Estimated',
          value: 'S/ ${order?.total.toStringAsFixed(2) ?? '0.00'}',
        ),
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
