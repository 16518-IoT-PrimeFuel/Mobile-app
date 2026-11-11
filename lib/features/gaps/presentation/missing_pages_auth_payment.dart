part of 'missing_pages.dart';

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
              side: const BorderSide(color: FullTankColors.muted),
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

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
