# FullTank Mobile — identidad visual y dirección UI

Este documento es la referencia visual de la aplicación móvil FullTank. Las imágenes recibidas muestran un producto B2B operativo: combustible, inventario, pedidos, pagos, entregas y reportes. La interfaz debe sentirse confiable y rápida para una persona que toma decisiones operativas desde el teléfono.

La implementación actual integra las stories públicas, autenticación, pedidos, inventario, despachos, reportes y cuenta. Las pantallas operativas usan mocks desacoplados de los contratos de dominio; los adaptadores para `FullTankApi` están preparados para activar la conexión real sin cambiar la UI.

## 1. Lectura del patrón visual

### Dirección general

- **Producto:** consola operativa móvil, no una red social ni una landing page.
- **Personalidad:** técnica, precisa, segura y humana.
- **Sensación:** control inmediato sobre una operación que normalmente ocurre por llamadas, mensajes y hojas de cálculo.
- **Composición:** pantallas densas pero respirables; cada bloque responde una pregunta concreta.
- **Jerarquía:** estado primero, contexto después, acción principal al final.
- **Presentación:** las referencias usan tableros editoriales con fondo marfil, retícula y títulos en cursiva. Eso sirve para documentar el sistema; la app real usa una superficie blanca limpia dentro del dispositivo.

### Lo que se repite en las referencias

1. Encabezado corto con volver, título, subtítulo y una acción secundaria.
2. Tarjeta de contexto del pedido con número, cliente/proveedor, combustible, cantidad y total.
3. Chips de estado pequeños, de alto contraste y semánticos.
4. Una acción primaria fija o muy visible en la zona inferior.
5. Estados explícitos: default, loading, success, empty y error.
6. Timeline vertical para procesos logísticos.
7. Filtros horizontales y búsquedas rápidas para listas.
8. Tarjetas con bordes suaves, separación clara y sombras casi imperceptibles.
9. Iconos lineales, simples y funcionales; el color comunica el estado, no decora.
10. Microcopy breve: una frase para explicar el estado y una acción para resolverlo.

## 2. Sistema visual

### Color

| Token | Hex | Uso |
|---|---|---|
| `canvas` | `#F5F3EF` | Fondo editorial de documentación y superficies externas. |
| `surface` | `#FFFFFF` | Tarjetas y contenido principal de la app. |
| `ink` | `#20242B` | Títulos, cifras y acciones de máxima importancia. |
| `muted` | `#73777F` | Subtítulos, metadatos y ayuda contextual. |
| `line` | `#E5E7EB` | Divisores, bordes y skeletons. |
| `primary` | `#FF9800` | CTA principal, acciones de operación y energía. |
| `primary-dark` | `#E57F00` | Estado presionado o énfasis de CTA. |
| `info` | `#356AE6` | Aprobado, información y tracking. |
| `success` | `#16B981` | Confirmado, disponible y completado. |
| `warning` | `#F59E0B` | Pendiente, atención y próximos vencimientos. |
| `danger` | `#EF4444` | Error, crítico, bloqueo y rechazo. |
| `lavender` | `#EEF1FF` | Fondo auxiliar para información y estados suaves. |

Reglas:

- El naranja queda reservado para la acción que mueve el flujo.
- Nunca usar rojo solo como decoración.
- Los estados deben tener texto e icono además de color.
- El fondo de la pantalla no compite con las tarjetas blancas.
- No usar gradientes como recurso general de marca.

### Tipografía

La app usa una sans-serif legible y compacta, equivalente a **Inter**, **Manrope** o la sans nativa disponible. La documentación puede usar una serif/sans cursiva para títulos editoriales, pero esa expresión no debe entrar en los controles operativos.

| Nivel | Tamaño aproximado | Peso | Uso |
|---|---:|---:|---|
| Display | 30–34 px | 700–800 | Mensaje principal de Home o estado vacío. |
| H1 | 24–28 px | 700–800 | Título de pantalla. |
| H2 | 18–20 px | 700 | Sección y nombre de tarjeta. |
| Body | 14–16 px | 400–500 | Contenido y descripción. |
| Caption | 10–12 px | 600–700 | Estado, metadata y etiquetas. |
| Numeric | 24–32 px | 800 | Cantidad, total o capacidad. |

Las cifras operativas deben dominar visualmente a sus etiquetas. No usar mayúsculas largas para párrafos.

### Espaciado y forma

- Base de espaciado: múltiplos de 4 px.
- Padding horizontal de pantalla: 20–24 px.
- Separación estándar entre bloques: 16 px.
- Separación de sección: 24–32 px.
- Radio de tarjeta grande: 20–24 px.
- Radio de campo y botón: 12–16 px.
- Radio de chip: completamente redondo.
- Bordes de 1 px solo cuando ayudan a separar superficies.
- Sombras: suaves, amplias y de baja opacidad; no usar sombras negras duras.

## 3. Componentes base

### App shell

- Superficie blanca con navegación inferior o encabezado contextual.
- Safe area respetada.
- Barra inferior con cuatro destinos: Inicio, Pedidos, Precios y Perfil.
- La navegación activa usa el color primario y un indicador visible.
- La cápsula negra superior presente en las referencias es el hardware del mockup, no un componente obligatorio de la app.

### Header

- Botón volver circular o cuadrado suave.
- Título de una línea y subtítulo de contexto.
- Acción secundaria a la derecha: búsqueda, filtros, menú o refrescar.
- Nunca esconder el estado actual en un menú.

### Cards

Una card debe tener una sola responsabilidad. Estructura recomendada:

```text
[icono] título                         [status pill]
        metadato corto
        divider o espacio
        etiqueta       valor
        etiqueta       valor
        [acción secundaria] [CTA]
```

No anidar tarjetas dentro de tarjetas salvo que la jerarquía sea indispensable, como un pedido dentro de un dashboard.

### Buttons

- Primary: fondo naranja, texto oscuro o blanco según contraste, alto mínimo 48 px.
- Secondary: fondo claro o borde, para volver, soporte o acciones no destructivas.
- Destructive: rojo solo para rechazar, eliminar o confirmar una acción irreversible.
- El CTA debe usar verbo: `Solicitar combustible`, `Ver seguimiento`, `Reintentar`.
- Los botones de ancho completo se ubican al final del flujo, con suficiente espacio para el teclado y safe area.

### Status pills

| Estado | Color | Texto sugerido |
|---|---|---|
| Pendiente | `warning` | Pendiente |
| Aprobado | `info` | Aprobado |
| En tránsito / despachado | `primary` o `info` | En tránsito |
| Entregado | `success` | Entregado |
| Error / rechazado | `danger` | Error / Rechazado |

El pill no reemplaza el título del estado; solo permite escanearlo rápidamente.

### Timeline

- Línea vertical de 2 px.
- Paso completado: círculo con check y color de estado.
- Paso actual: círculo sólido y etiqueta de mayor peso.
- Paso futuro: círculo vacío gris.
- Cada paso incluye tiempo o ETA cuando exista.

### Formularios

- Una pregunta por campo.
- Labels persistentes; no depender únicamente del placeholder.
- Selector de combustible como cards seleccionables cuando haya pocas opciones.
- Errores inline junto al campo y un resumen arriba cuando haya varios.
- El CTA queda deshabilitado solo cuando la razón sea visible.
- Loading conserva el contexto y cambia el texto del CTA a una acción progresiva (`Validando...`).

## 4. Estados de UX obligatorios

Cada pantalla que consulte o envíe datos debe considerar:

- **Default:** contenido usable y CTA activo.
- **Loading:** skeleton o bloque de progreso, sin saltos de layout.
- **Success:** confirmación clara, identificador del pedido y siguiente acción.
- **Empty:** explicar por qué está vacío y ofrecer una acción para empezar.
- **Error:** explicar qué falló, si se puede reintentar y cómo contactar soporte.

No mostrar errores técnicos sin traducir (`500`, `socket exception`, nombres de clases). Los códigos pueden aparecer como metadata secundaria si ayudan a soporte.

## 5. Aplicación a las user stories de esta fase

| Story | Superficie | Patrón principal |
|---|---|---|
| US-01 | Home | Saludo, propuesta de valor, pedido en curso y accesos rápidos. |
| US-02 | About Us | Página editorial breve con propuesta de confianza. |
| US-03 | How it works | Secuencia visual de pedir, seguir y recibir. |
| US-36 | Benefits | Tres beneficios en cards o bloques con icono. |
| US-37 | Testimonios | Cards de testimonio con nombre, empresa y frase corta. |
| US-38 | Planes y precios | Cards comparables y CTA de registro. |
| US-39 | Cambio de idioma | Selector visible en Perfil/ajustes, con estado seleccionado. |
| US-05 | Registrar pedido | Formulario por secciones, estado loading/success/error y CTA inferior. |
| US-10 | Pedidos pendientes | Resumen de métricas, filtros y lista de pedidos. |
| US-06 | Estado del pedido | Lista y detalle con timeline logístico. |
| US-09 | Historial | Métricas, filtros, lista histórica y detalle. |
| US-43 | Detalle de pedido | Resumen, datos del pedido, pago y seguimiento. |
| US-46 | Gestión de inventario | Catálogo de combustibles, métricas de disponibilidad, filtros y edición de producto. |

## 6. Arquitectura Clean + MVVM

La UI debe depender de estados y comandos del ViewModel, no de HTTP ni de entidades del backend directamente. Cada feature sigue `presentation`, `application`, `domain` y `data`; los archivos de presentación se mantienen pequeños y los componentes visuales no conocen el cliente HTTP.

```text
View → ViewModel/Provider → Repository contract → Mock repository
                                             └── API repository → FullTankApi
```

- Las Views renderizan estado y emiten acciones.
- Los ViewModels controlan loading, success, empty y error.
- Los repositories exponen interfaces simples.
- El mock repository es la implementación inicial.
- La futura integración usará `/api/v1` y JWT sin rediseñar pantallas.
- El modo API se activa por variables `USE_MOCK_*`; por defecto permanece en mock.

## 7. Qué evitar

- Dashboards genéricos con demasiadas métricas sin acción.
- Gradientes, glassmorphism o sombras pesadas.
- Botones sin verbo o iconos sin label en acciones críticas.
- Texto gris claro con contraste insuficiente.
- Pantallas de loading que cambian la altura de los elementos.
- Copiar literalmente el marco del iPhone de las imágenes dentro de la app.
- Crear una abstracción o dependencia antes de que exista una necesidad real.

## 8. Criterio de terminado visual

Una pantalla está lista cuando:

1. Su acción principal se entiende en menos de cinco segundos.
2. El estado del pedido se puede identificar sin leer todo el contenido.
3. Los estados default, loading, success, empty y error tienen una salida clara cuando aplican.
4. Funciona con texto largo, tamaño de fuente aumentado y ancho móvil normal.
5. Tiene prueba o criterio verificable en este documento.
