part of 'order_pages.dart';

class _DetailTable extends StatelessWidget {
  const _DetailTable({required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;
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
        Text(
          title,
          style: const TextStyle(
            color: _subtle,
            fontSize: 7,
            fontWeight: FontWeight.w800,
            letterSpacing: .3,
          ),
        ),
        const SizedBox(height: 7),
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(height: 12, color: _line),
          Row(
            children: [
              Expanded(
                child: Text(
                  rows[i].$1,
                  style: const TextStyle(color: _muted, fontSize: 8),
                ),
              ),
              Expanded(
                child: Text(
                  rows[i].$2,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}
