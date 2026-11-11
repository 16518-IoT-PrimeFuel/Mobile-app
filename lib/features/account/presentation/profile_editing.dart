part of 'account_page.dart';

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: last
        ? null
        : const BoxDecoration(
            border: Border(bottom: BorderSide(color: FullTankColors.border)),
          ),
    child: Row(
      children: [
        _AccountIconTile(icon: icon, color: FullTankColors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: _microLabel),
              Text(value, style: _contactValue),
            ],
          ),
        ),
      ],
    ),
  );
}

class _AccountStatusCard extends StatelessWidget {
  const _AccountStatusCard();

  @override
  Widget build(BuildContext context) => const _AccountPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ESTADO DE CUENTA', style: _microLabel),
            _StatusPill(
              label: 'AL CORRIENTE',
              color: FullTankColors.success,
              softColor: FullTankColors.successSoft,
            ),
          ],
        ),
        SizedBox(height: 11),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatusMetric(label: 'PLAN', value: 'Business'),
            _StatusMetric(label: 'MIEMBRO DESDE', value: 'Mar 2024'),
            _StatusMetric(label: 'SESIONES', value: '2 activas'),
          ],
        ),
      ],
    ),
  );
}

class _StatusMetric extends StatelessWidget {
  const _StatusMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: _microLabel),
      Text(value, style: _contactValue),
    ],
  );
}

class _EditProfile extends ConsumerStatefulWidget {
  const _EditProfile();

  @override
  ConsumerState<_EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<_EditProfile> {
  final _name = TextEditingController();
  final _ruc = TextEditingController();
  final _sector = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _description = TextEditingController();
  CompanyProfile? _profile;
  bool _loading = true;
  bool _saving = false;
  String? _loadError;
  String? _rucError;

  bool get _guest => isGuestSession(ref.read(authControllerProvider).session);

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _ruc,
      _sector,
      _address,
      _email,
      _phone,
      _description,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final session = ref.read(authControllerProvider).session;
    if (session == null || isGuestSession(session)) {
      setState(() => _loading = false);
      return;
    }
    final provider = session.roles.contains(providerRole);
    final id = provider ? session.providerId : session.companyId;
    if (id == null) {
      setState(() {
        _loading = false;
        _loadError = 'No se pudo cargar el perfil.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final profile = await ref
          .read(companyProfileRepositoryProvider)
          .load(provider: provider, id: id);
      if (!mounted) return;
      _name.text = profile.name;
      _ruc.text = profile.ruc;
      _sector.text = profile.sector;
      _address.text = profile.address;
      _email.text = profile.contactEmail;
      _phone.text = profile.phone;
      _description.text = profile.description;
      setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'No se pudo cargar el perfil.';
      });
    }
  }

  Future<void> _save() async {
    final profile = _profile;
    if (profile == null || _saving) return;
    if (!RegExp(r'^\d{11}$').hasMatch(_ruc.text.trim())) {
      setState(() => _rucError = 'El RUC debe tener 11 dígitos.');
      return;
    }
    setState(() {
      _rucError = null;
      _saving = true;
    });
    try {
      final saved = await ref
          .read(companyProfileRepositoryProvider)
          .save(
            profile.copyWith(
              name: _name.text.trim(),
              ruc: _ruc.text.trim(),
              sector: _sector.text.trim(),
              address: _address.text.trim(),
              contactEmail: _email.text.trim(),
              phone: _phone.text.trim(),
              description: _description.text.trim(),
            ),
          );
      if (!mounted) return;
      setState(() => _profile = saved);
      _showMessage(context, 'Perfil actualizado.');
    } catch (_) {
      if (mounted) _showMessage(context, 'No se pudo guardar el perfil.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AccountHeader(
          title: 'Editar perfil',
          subtitle: 'Actualiza los datos de tu empresa',
        ),
        const SizedBox(height: 16),
        if (_guest)
          const Text(
            'Vista previa: inicia sesión con una cuenta para editar los datos de tu empresa.',
            style: _smallText,
          )
        else if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (profile == null) ...[
          Text(_loadError ?? 'No se pudo cargar el perfil.'),
          TextButton(onPressed: _load, child: const Text('Reintentar')),
        ] else ...[
          _ProfileField(
            label: 'EMPRESA',
            icon: Icons.business_outlined,
            controller: _name,
          ),
          _ProfileField(
            label: 'RUC',
            icon: Icons.badge_outlined,
            controller: _ruc,
            keyboardType: TextInputType.number,
            errorText: _rucError,
          ),
          if (!profile.isProvider) ...[
            _ProfileField(
              label: 'SECTOR',
              icon: Icons.category_outlined,
              controller: _sector,
            ),
            _ProfileField(
              label: 'CORREO DE CONTACTO',
              icon: Icons.mail_outline,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
          _ProfileField(
            label: 'DIRECCIÓN',
            icon: Icons.place_outlined,
            controller: _address,
          ),
          _ProfileField(
            label: 'TELÉFONO',
            icon: Icons.phone_outlined,
            controller: _phone,
            keyboardType: TextInputType.phone,
          ),
          if (profile.isProvider)
            _ProfileField(
              label: 'DESCRIPCIÓN',
              icon: Icons.notes_outlined,
              controller: _description,
            ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: FullTankColors.primary,
                minimumSize: const Size.fromHeight(52),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: const StadiumBorder(),
              ),
              child: Text(_saving ? 'Guardando…' : 'Guardar cambios'),
            ),
          ),
        ],
        Center(
          child: TextButton(
            onPressed: () => context.pop(),
            child: const Text('Volver'),
          ),
        ),
      ],
    );
  }
}
