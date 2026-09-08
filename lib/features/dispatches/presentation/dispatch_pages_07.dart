part of 'dispatch_pages.dart';

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 8)),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _DispatchShell extends StatelessWidget {
  const _DispatchShell({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.child,
    this.action,
  });
  final String title, subtitle;
  final VoidCallback onBack;
  final Widget child;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 11, 16, 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Volver',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, size: 19),
              style: IconButton.styleFrom(
                backgroundColor: _panel,
                fixedSize: const Size(34, 34),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.3,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(color: _muted, fontSize: 8.5),
                    ),
                ],
              ),
            ),
            if (action != null) action!,
          ],
        ),
        const SizedBox(height: 12),
        Expanded(child: SingleChildScrollView(child: child)),
      ],
    ),
  );
}

class _DispatchMenu extends StatelessWidget {
  const _DispatchMenu();
  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: 'Más opciones de despachos',
    onSelected: (value) => context.push(value),
    icon: const Icon(Icons.more_horiz, size: 19),
    itemBuilder: (context) => const [
      PopupMenuItem(
        value: '/dispatches/fleet',
        child: Text('Gestión de flota'),
      ),
      PopupMenuItem(value: '/dispatches/drivers', child: Text('Conductores')),
      PopupMenuItem(
        value: '/dispatches/assign',
        child: Text('Asignar recursos'),
      ),
    ],
  );
}

class _OrangeButton extends StatelessWidget {
  const _OrangeButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _orange,
        disabledBackgroundColor: _panel,
        foregroundColor: Colors.white,
        disabledForegroundColor: _subtle,
        minimumSize: const Size.fromHeight(36),
        shape: const StadiumBorder(),
        elevation: 2,
        textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
      ),
      child: Text(label),
    ),
  );
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text, {this.trailing});
  final String text;
  final String? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _muted,
              fontSize: 7,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null)
          Text(trailing!, style: const TextStyle(color: _subtle, fontSize: 7)),
      ],
    ),
  );
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.value,
    required this.icon,
    this.suffix,
  });
  final String label, value;
  final IconData icon;
  final String? suffix;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FormLabel(label),
      TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 15, color: _subtle),
          suffixText: suffix,
          filled: true,
          fillColor: _panel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
        ),
      ),
    ],
  );
}

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
