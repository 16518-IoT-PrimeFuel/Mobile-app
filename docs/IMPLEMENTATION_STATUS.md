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
| US-05 | Registrar nuevo pedido | API provider, UI integrada |
| US-06 | Estado y tracking | API-backed order list/detail; tracking v2 pending UI |
| US-09 | Historial | API provider, UI integrada |
| US-10 | Pedidos pendientes | API provider, provider workflow pending |
| US-43 | Detalle de pedido | API-backed order detail |
| US-46 | Inventario y editar producto | API provider, product UI integrated; tanks/IoT mock |
| US-08 | Registrar pago | Mock |
| US-11 | Aprobar pedido | Mock |
| US-12 | Marcar como despachado | Mock |
| US-13 | Cerrar pedido | Mock |
| US-14 | Reportes de ventas | API provider, UI integrada |
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

Los providers de autenticación, pedidos, inventario, despachos y reportes usan
`FullTankApi` por defecto. Los mocks siguen disponibles por feature mediante
`--dart-define=USE_MOCK_<FEATURE>=true` para demos y pruebas visuales.

## Arquitectura actual

```text
main.dart
  └── app/
       ├── app_router.dart
       └── fulltank_app.dart
features/*/
  ├── application/       # Riverpod controllers/providers
  ├── domain/            # entidades y contratos
  ├── data/              # mocks y adaptadores API
  └── presentation/      # páginas y widgets
```

`main.dart` solo arranca la aplicación. Las pantallas no importan el cliente HTTP directamente. Los repositorios seleccionan mock o API mediante providers y exponen contratos de dominio. Pedidos, productos y reportes ya consumen sus controllers; flota se está conectando y pagos, aprobación, cierre, notificaciones e IoT requieren adapters/controllers específicos.

## Refactor aplicado

- Se integraron las ramas de operaciones: inventario, pedidos y despachos.
- Las pantallas grandes se dividieron en módulos de presentación pequeños.
- Se añadieron contratos, entidades, mocks, adaptadores API y providers para pedidos, inventario, despachos y reportes.
- Las stories públicas faltantes tienen contenido aislado y rutas `/about`, `/how-it-works`, `/benefits`, `/testimonials` y `/plans`.
- El modo API es predeterminado; las pantallas que todavía tienen datos locales
  deben migrarse progresivamente a sus controllers/providers.

## Pendientes de integración real

- Persistir JWT de forma segura en almacenamiento nativo.
- Conectar los ViewModels restantes a pagos, aprobación, cierre, notificaciones e IoT.
- Validar los nombres de campos de respuesta contra el backend desplegado.
- Configurar `API_BASE_URL` por entorno (`http://10.0.2.2:8080/api/v1` es el
  valor por defecto para el emulador Android).
- Mapear errores HTTP a estados de UI traducidos y accionables.
