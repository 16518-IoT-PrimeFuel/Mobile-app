part of 'dispatch_pages.dart';

class DispatchAssignmentPage extends StatefulWidget {
  const DispatchAssignmentPage({
    this.initialState = AssignmentState.order,
    super.key,
  });
  final AssignmentState initialState;
  @override
  State<DispatchAssignmentPage> createState() => _DispatchAssignmentPageState();
}

class _DispatchAssignmentPageState extends State<DispatchAssignmentPage> {
  late AssignmentState _state = widget.initialState;
  var _vehicle = 0;
  var _driver = 0;
  @override
  Widget build(BuildContext context) {
    final success = _state == AssignmentState.success;
    return withFullTankUiScale(
      context,
      Scaffold(
        body: SafeArea(
          child: _DispatchShell(
            title: success
                ? 'Despacho asignado'
                : _state == AssignmentState.confirm ||
                      _state == AssignmentState.conflict
                ? 'Confirmar asignación'
                : 'Asignar recursos',
            subtitle: success
                ? ''
                : _state == AssignmentState.order
                ? 'Vehículo y conductor'
                : 'Revisa y asigna',
            onBack: () => context.pop(),
            child: success
                ? const _AssignmentSuccess()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_state != AssignmentState.conflict)
                        _AssignmentStepper(state: _state),
                      const SizedBox(height: 13),
                      if (_state == AssignmentState.conflict)
                        _AssignmentConflict(
                          onChange: () =>
                              setState(() => _state = AssignmentState.vehicle),
                        )
                      else
                        _assignmentBody(),
                      const SizedBox(height: 14),
                      if (_state != AssignmentState.conflict)
                        _assignmentAction(),
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: const FullTankBottomNav(active: 2),
      ),
    );
  }

  Widget _assignmentBody() => switch (_state) {
    AssignmentState.order => _ChoiceList(
      title: 'SELECCIONA UN PEDIDO APROBADO',
      helper: '3 pedidos listos para asignación',
      children: const [
        _OrderChoice(
          selected: true,
          title: '#ORD-4820 · Cliente B · 8,500 L',
          detail: 'Gasolina Magna · Entrega hoy 15:00',
        ),
        _OrderChoice(
          title: '#ORD-4819 · Cliente C · 15,000 L',
          detail: 'Diésel Premium · Entrega hoy 17:00',
        ),
        _OrderChoice(
          title: '#ORD-4816 · Cliente F · 20,000 L',
          detail: 'Diésel · Entrega mañana 09:00',
        ),
      ],
    ),
    AssignmentState.vehicle => _ChoiceList(
      title: 'VEHÍCULOS DISPONIBLES',
      helper: '3 compatibles · 8,500 L',
      children: [
        _SelectableChoice(
          selected: _vehicle == 0,
          title: 'TK-4421',
          detail: 'Freightliner M2 106 · Cisterna 20k',
          icon: Icons.local_shipping_outlined,
          onTap: () => setState(() => _vehicle = 0),
        ),
        _SelectableChoice(
          selected: _vehicle == 1,
          title: 'TK-2214',
          detail: 'Kenworth T370 · Cisterna 12k',
          icon: Icons.local_shipping_outlined,
          onTap: () => setState(() => _vehicle = 1),
        ),
        _SelectableChoice(
          selected: _vehicle == 2,
          title: 'TK-5501',
          detail: 'Peterbilt 337 · Cisterna 18k',
          icon: Icons.local_shipping_outlined,
          onTap: () => setState(() => _vehicle = 2),
        ),
      ],
    ),
    AssignmentState.driver => _ChoiceList(
      title: 'CONDUCTORES DISPONIBLES',
      helper: '3 habilitados',
      children: [
        _SelectableChoice(
          selected: _driver == 0,
          title: 'Juan Ramírez',
          detail: 'DNI · 48-291-772 · Lic · A-2 · 2028',
          icon: Icons.person_outline,
          onTap: () => setState(() => _driver = 0),
        ),
        _SelectableChoice(
          selected: _driver == 1,
          title: 'Carlos Mendoza',
          detail: 'DNI · 39-720-114 · Lic · A-3 · 2029',
          icon: Icons.person_outline,
          onTap: () => setState(() => _driver = 1),
        ),
        _SelectableChoice(
          selected: _driver == 2,
          title: 'Roberto Salinas',
          detail: 'DNI · 81-688-402 · Lic · A-2 · 2028',
          icon: Icons.person_outline,
          onTap: () => setState(() => _driver = 2),
        ),
      ],
    ),
    AssignmentState.confirm => _AssignmentSummary(
      vehicle: _vehicle,
      driver: _driver,
    ),
    AssignmentState.conflict ||
    AssignmentState.success => const SizedBox.shrink(),
  };

  Widget _assignmentAction() => _state == AssignmentState.confirm
      ? Column(
          children: [
            const _InfoNotice(
              message:
                  'Sin conflictos detectados. Todos los recursos están disponibles para el horario solicitado.',
            ),
            const SizedBox(height: 10),
            _OrangeButton(
              label: 'Asignar recursos',
              onPressed: () => setState(
                () => _state = _vehicle == 0 && _driver == 0
                    ? AssignmentState.conflict
                    : AssignmentState.success,
              ),
            ),
          ],
        )
      : _OrangeButton(
          label: 'Continuar  →',
          onPressed: () => setState(
            () => _state = switch (_state) {
              AssignmentState.order => AssignmentState.vehicle,
              AssignmentState.vehicle => AssignmentState.driver,
              _ => AssignmentState.confirm,
            },
          ),
        );
}

class _AssignmentStepper extends StatelessWidget {
  const _AssignmentStepper({required this.state});
  final AssignmentState state;
  @override
  Widget build(BuildContext context) {
    final current = [
      AssignmentState.order,
      AssignmentState.vehicle,
      AssignmentState.driver,
      AssignmentState.confirm,
    ].indexOf(state);
    return Row(
      children: ['PEDIDO', 'VEHÍCULO', 'CONDUCTOR', 'CONFIRMAR']
          .asMap()
          .entries
          .map((entry) {
            final done = entry.key < current;
            final active = entry.key == current;
            return Expanded(
              child: Column(
                children: [
                  Container(
                    width: 19,
                    height: 19,
                    decoration: BoxDecoration(
                      color: done || active
                          ? (active ? _blue : _green)
                          : _panel,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: done
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                        : Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              color: active ? Colors.white : _subtle,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.value,
                    style: TextStyle(
                      color: active ? _blue : _subtle,
                      fontSize: 6,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(),
    );
  }
}
