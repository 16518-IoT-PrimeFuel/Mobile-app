part of 'dispatch_pages.dart';

class _InfoNotice extends StatelessWidget {
  const _InfoNotice({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _blueSoft,
      border: Border.all(color: const Color(0xFFCAD8FF)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline, color: _blue, size: 16),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: _muted, fontSize: 8, height: 1.35),
          ),
        ),
      ],
    ),
  );
}

class _DuplicateNotice extends StatelessWidget {
  const _DuplicateNotice({
    required this.title,
    required this.message,
    required this.action,
    this.onPressed,
  });
  final String title, message, action;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _amberSoft,
      border: Border.all(color: const Color(0xFFFDE4A7)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.warning_amber_rounded, color: _amber, size: 18),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                message,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 7.5,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Text(
                  action,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatusTag extends StatelessWidget {
  const _StatusTag(this.label, {required this.color, this.soft});
  final String label;
  final Color color;
  final Color? soft;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration: BoxDecoration(
      color: soft ?? color.withAlpha(22),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 6.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => Container(
    height: 24,
    decoration: BoxDecoration(
      color: _line,
      borderRadius: BorderRadius.circular(99),
    ),
  );
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();
  @override
  Widget build(BuildContext context) => Container(
    height: 88,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const _Skeleton(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [_Skeleton(), SizedBox(height: 7), _Skeleton()],
          ),
        ),
      ],
    ),
  );
}

class _EmptyDispatchState extends StatelessWidget {
  const _EmptyDispatchState({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title, message;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 44),
      Container(
        width: 62,
        height: 62,
        decoration: const BoxDecoration(color: _panel, shape: BoxShape.circle),
        child: Icon(icon, color: _subtle, size: 30),
      ),
      const SizedBox(height: 15),
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _ink,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: _muted, fontSize: 9, height: 1.45),
      ),
    ],
  );
}
