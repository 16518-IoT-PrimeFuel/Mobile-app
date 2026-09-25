part of 'dispatch_pages.dart';

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({required this.vehicle});
  final _Vehicle vehicle;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('¿Eliminar vehículo?'),
    content: Text(
      '${vehicle.plate} será removido de tu flota. Los pedidos históricos con esta placa se mantienen.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        style: FilledButton.styleFrom(
          backgroundColor: _red,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const StadiumBorder(),
        ),
        child: const Text('Sí, eliminar'),
      ),
    ],
  );
}

class _Vehicle {
  const _Vehicle(
    this.plate,
    this.brand,
    this.type,
    this.capacity,
    this.next,
    this.status,
  );
  final String plate, brand, type, capacity, next, status;
  int get capacityLiters =>
      int.parse(capacity.replaceAll('.', '').replaceAll(',', ''));
}

const _vehicles = [
  _Vehicle(
    'TK-4421',
    'Freightliner M2 106',
    'Cisterna 20k',
    '20.000',
    'Sin agenda',
    'DISPONIBLE',
  ),
  _Vehicle(
    'TK-3812',
    'International DuraStar',
    'Cisterna 15k',
    '15.000',
    'Hoy 14:30 · ORD-4818',
    'EN DESPACHO',
  ),
  _Vehicle(
    'TK-2214',
    'Kenworth T370',
    'Cisterna 12k',
    '12.000',
    'Mañana 08:00',
    'DISPONIBLE',
  ),
  _Vehicle(
    'TK-5501',
    'Peterbilt 337',
    'Cisterna 18k',
    '18.000',
    'Sin agenda',
    'DISPONIBLE',
  ),
  _Vehicle(
    'TK-4102',
    'Volvo FMX',
    'Cisterna 20k',
    '20.000',
    'Mantenimiento',
    'MANTENIMIENTO',
  ),
  _Vehicle(
    'TK-3308',
    'Scania P410',
    'Cisterna 30k',
    '30.000',
    'Fuera de servicio',
    'FUERA',
  ),
];

class _Driver {
  const _Driver(
    this.initials,
    this.name,
    this.dni,
    this.license,
    this.status, [
    this.assignment,
  ]);
  final String initials, name, dni, license, status;
  final String? assignment;
}

const _driversData = [
  _Driver('JR', 'Juan Ramírez', '48-291-772', 'A-2 · 2028', 'DISPONIBLE'),
  _Driver(
    'MO',
    'Miguel Ortega',
    '52-104-889',
    'A-2 · 2027',
    'ASIGNADO',
    'ORD-4818 · Hoy 14:30',
  ),
  _Driver('CM', 'Carlos Mendoza', '39-720-114', 'A-3 · 2029', 'DISPONIBLE'),
  _Driver('RS', 'Roberto Salinas', '81-688-402', 'A-2 · 2028', 'DISPONIBLE'),
  _Driver('LÁ', 'Luis Ávila', '44-556-201', 'A-2 · 2026', 'INACTIVO'),
];
