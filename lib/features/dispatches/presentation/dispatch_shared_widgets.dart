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
        Text(label, style: const TextStyle(color: _muted, fontSize: 11.6)),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 11.6,
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
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
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
                fixedSize: const Size(44, 44),
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
                      fontSize: 26.1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.3,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(color: _muted, fontSize: 14.5),
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
        minimumSize: const Size.fromHeight(52),
        shape: const StadiumBorder(),
        elevation: 2,
        textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
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
              fontSize: 10.15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(color: _subtle, fontSize: 10.15),
          ),
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
