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
    this.status, {
    this.id = 0,
  });
  final int id;
  final String plate, brand, type, capacity, next, status;
  int get capacityLiters =>
      int.parse(capacity.replaceAll('.', '').replaceAll(',', ''));
}
