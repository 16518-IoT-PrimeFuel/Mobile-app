# FullTank Mobile — especificaciones ejecutables

Este archivo es la fuente de verdad para trabajar con `/goal`. Cada objetivo debe implementar una story completa, validar sus criterios y actualizar `docs/IMPLEMENTATION_STATUS.md`.

## Flujo `/goal`

1. Seleccionar una story no bloqueada.
2. Leer su criterio de aceptación.
3. Implementar UI, estado y datos mock o API según la columna de fuente.
4. Verificar navegación, estados y accesibilidad básica.
5. Ejecutar formato, análisis y tests disponibles.
6. Marcar la story como completa solo cuando todos sus criterios estén cumplidos.

## Stories independientes

### US-01 — Home

- Muestra saludo, fecha, propuesta de valor y pedido en curso.
- Incluye CTA `Registrar nuevo pedido`.
- Incluye accesos a pedir combustible y ver tracking.
- El pedido en curso abre su detalle.

### US-02 — About Us

- Explica qué es FullTank y su propuesta B2B.
- Mantiene jerarquía editorial, beneficios y testimonios.

### US-03 — How it works

- Comunica el flujo pedir → seguir → recibir.
- Explica proveedores verificados y visibilidad de entrega.

### US-36 — Benefits

- Presenta proveedores verificados, visibilidad total y operación simple.
- Cada beneficio tiene icono, título y descripción.

### US-37 — Testimonios

- Muestra al menos dos testimonios mock.
- Cada testimonio incluye nombre, empresa y cita.
- Los datos están aislados para sustituirse por contenido real.

### US-38 — Planes y precios

- Muestra planes comparables con precio, beneficios y CTA.
- El CTA no simula una compra real; queda preparado para registro futuro.

### US-39 — Cambio de idioma

- Muestra el idioma actual en Perfil.
- Permite alternar ES/EN en estado local.
- La traducción completa queda separada como siguiente objetivo.

## Stories con mock data

### US-05 — Registrar pedido

- Permite seleccionar combustible, ingresar cantidad, ubicación y fecha.
- Valida visualmente el contexto antes de crear el pedido.
- Tiene CTA `Crear pedido` y confirmación mock.
- El futuro repository reemplaza la confirmación mock por `POST /api/v1/fuel-orders` o `POST /api/v1/fuel-requests`.

### US-06 — Consultar estado

- Muestra lista de pedidos y estado visible.
- El detalle incluye timeline: pendiente, aprobado, en tránsito y entregado.
- Incluye ETA, actualización y contacto de soporte.

### US-09 — Historial

- Lista pedidos históricos.
- Permite filtrar por estado.
- Cada resultado abre detalle.

### US-10 — Pedidos pendientes

- Muestra métricas de pendientes, aprobados e ingresos.
- Incluye filtros y cards operativas.
- Mantiene estados vacíos y error como extensiones del mismo flujo.

### US-43 — Detalle de pedido

- Muestra código, combustible, cantidad, proveedor, total, dirección y entrega.
- Incluye estado y tracking.

### US-46 — Gestión de inventario

- Muestra catálogo de productos.
- Muestra métricas de disponibles, bajo stock e inactivos.
- Filtra por disponibilidad.
- Abre edición de nombre, tipo, precio y disponibilidad.
- La integración futura usará `/api/v1/fuel-products` y `/update-stock`.

## Stories operativas

### US-08 — Registrar información de pago

- Captura operación, banco, fecha y monto.
- Muestra validación de coincidencia.
- Futuro endpoint: `POST /api/v1/payments` y `POST /api/v1/payments/{id}/complete`.

### US-11 — Aprobar pedido

- Muestra resumen del pedido y validaciones de pago.
- Permite aprobar o informar error.
- La respuesta mock prepara la transición a despacho.

### US-12 — Marcar como despachado

- Muestra pedido aprobado, vehículo y conductor.
- Permite marcar despacho y muestra confirmación.
- Futuro endpoint: `POST /api/v1/deliveries/{id}/dispatch`.

### US-13 — Cerrar pedido

- Muestra entrega confirmada y validación del cliente.
- Permite confirmar cierre.
- Futuro endpoint: `POST /api/v1/deliveries/{id}/complete`.

### US-14 — Reportes de ventas

- Muestra ventas, litros y serie semanal.
- Permite generar reporte mock.
- Futuro endpoint: `/api/v1/analytics/providers/{providerId}`.

### US-42 — Rechazar pedido

- Permite escoger motivo.
- Muestra confirmación y notificación mock.
- Futuro endpoint: `POST /api/v1/fuel-requests/{id}/reject`.

## Epics complementarios

### EP09 — Perfil

- Muestra identidad, empresa y accesos a funciones.
- Incluye idioma, soporte y cierre de sesión visual.

### EP10 — Soporte

- Muestra disponibilidad, preguntas frecuentes, email y teléfono.

### EP11 — Búsqueda y filtrado

- Busca por código o proveedor.
- Muestra resultados y estado vacío.

### EP12 — Notificaciones

- Lista notificaciones de aprobación, despacho y alertas.
- Permite marcar como leídas visualmente.
- Futuro endpoint: `/api/v1/notifications/user/{userId}`.

## Regla de integración

La UI puede usar mocks durante el desarrollo visual, pero ninguna pantalla debe acoplarse al mock. La migración se hace reemplazando el repository por `FullTankApi`, manteniendo intactos los componentes visuales y los criterios de aceptación.
