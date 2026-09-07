# Cobertura de user stories

## Pantallas implementadas

| Story / epic | Pantalla o flujo | Datos actuales |
|---|---|---|
| US-01 | Home | Mock |
| US-02 | About Us | Estático |
| US-03 | How it works | Estático |
| US-36 | Benefits | Estático |
| US-37 | Testimonios | Mock |
| US-38 | Planes y precios | Estático |
| US-39 | Cambio de idioma | Estado local ES/EN |
| US-05 | Registrar nuevo pedido | Mock |
| US-06 | Estado y tracking | Mock |
| US-09 | Historial | Mock |
| US-10 | Pedidos pendientes | Mock |
| US-43 | Detalle de pedido | Mock |
| US-46 | Inventario y editar producto | Mock |
| US-08 | Registrar pago | Mock |
| US-11 | Aprobar pedido | Mock |
| US-12 | Marcar como despachado | Mock |
| US-13 | Cerrar pedido | Mock |
| US-14 | Reportes de ventas | Mock |
| US-42 | Rechazar pedido | Mock |
| EP09 | Perfil de usuario | Mock |
| EP10 | Soporte y contacto | Estático/mock |
| EP11 | Búsqueda y filtros | Mock |
| EP12 | Notificaciones | Mock |

## Módulo de integración

`lib/data/api_client.dart` contiene el cliente HTTP sin dependencia externa. Usa `API_BASE_URL` y añade `Authorization: Bearer <token>` cuando existe un token.

`lib/data/fulltank_api.dart` cubre:

- autenticación, usuarios y compañías;
- solicitudes y órdenes;
- productos, stock y equipos;
- pagos;
- entregas, vehículos y conductores;
- calificaciones;
- notificaciones;
- analítica de comprador y proveedor.

Las pantallas siguen usando mock data en esta entrega. El siguiente paso de integración sustituye el repository/mock provider por `FullTankApi`; no requiere cambiar la estructura visual.

## Arquitectura actual

```text
main.dart
  └── app.dart
       ├── viewmodels/
       ├── features/home/
       ├── features/orders/
       ├── features/inventory/
       ├── features/account/
       ├── widgets/
       ├── models/
       └── data/
```

`main.dart` solo arranca la aplicación. Cada feature contiene sus pantallas, los ViewModels contienen estado mutable y `data/` contiene mocks y acceso HTTP. Las pantallas no importan el cliente HTTP directamente.

## Pendientes técnicos explícitos

- Persistir JWT de forma segura en almacenamiento nativo.
- Inyectar `FullTankApi` en ViewModels.
- Reemplazar cada mock repository por llamadas reales y mapear errores HTTP a estados de UI.
- Añadir tests widget y de contrato cuando las dependencias de Flutter estén disponibles en el entorno.
