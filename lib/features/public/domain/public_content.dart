enum PublicSection { about, howItWorks, benefits, testimonials, plans }

class PublicContent {
  const PublicContent({
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String title;
  final String subtitle;
  final List<PublicItem> items;
}

class PublicItem {
  const PublicItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final String icon;
  final String title;
  final String description;
}

const publicContent = <PublicSection, PublicContent>{
  PublicSection.about: PublicContent(
    title: 'Combustible sin fricción',
    subtitle: 'FullTank conecta empresas y proveedores para operar mejor.',
    items: [
      PublicItem(
        icon: '⛽',
        title: 'Una sola operación',
        description:
            'Solicita, valida y sigue cada pedido desde un mismo lugar.',
      ),
      PublicItem(
        icon: '✓',
        title: 'Proveedores verificados',
        description: 'Trabaja con información clara y relaciones confiables.',
      ),
    ],
  ),
  PublicSection.howItWorks: PublicContent(
    title: 'Así funciona FullTank',
    subtitle: 'Pedir → seguir → recibir, con visibilidad en cada paso.',
    items: [
      PublicItem(
        icon: '1',
        title: 'Solicita combustible',
        description: 'Define producto, cantidad, ubicación y fecha requerida.',
      ),
      PublicItem(
        icon: '2',
        title: 'Sigue el pedido',
        description: 'Consulta aprobación, despacho y estado de entrega.',
      ),
      PublicItem(
        icon: '3',
        title: 'Recibe con control',
        description: 'Confirma la entrega y conserva el historial operativo.',
      ),
    ],
  ),
  PublicSection.benefits: PublicContent(
    title: 'Operación más simple',
    subtitle: 'Menos seguimiento manual. Más control para tu equipo.',
    items: [
      PublicItem(
        icon: '✓',
        title: 'Visibilidad total',
        description: 'Estados, fechas y responsables siempre disponibles.',
      ),
      PublicItem(
        icon: '⚡',
        title: 'Decisiones rápidas',
        description: 'La información importante aparece cuando la necesitas.',
      ),
      PublicItem(
        icon: '⌁',
        title: 'Escala con orden',
        description: 'Centraliza proveedores, pedidos y entregas.',
      ),
    ],
  ),
  PublicSection.testimonials: PublicContent(
    title: 'Lo que dicen nuestros clientes',
    subtitle:
        'Resultados reales representados con datos mock mientras llega el contenido final.',
    items: [
      PublicItem(
        icon: '“',
        title: 'Mariana López · Logística Norte',
        description:
            '“Ahora sabemos dónde está cada pedido sin perseguir mensajes.”',
      ),
      PublicItem(
        icon: '“',
        title: 'Carlos Méndez · PetroAndes',
        description:
            '“La operación de combustible dejó de depender de hojas sueltas.”',
      ),
    ],
  ),
  PublicSection.plans: PublicContent(
    title: 'Planes para cada operación',
    subtitle: 'Empieza con claridad y escala cuando tu operación lo necesite.',
    items: [
      PublicItem(
        icon: '01',
        title: 'Starter · Gratis',
        description: 'Pedidos básicos, seguimiento y un equipo operativo.',
      ),
      PublicItem(
        icon: '02',
        title: 'Growth · S/ 299/mes',
        description: 'Reportes, historial ampliado y más proveedores.',
      ),
      PublicItem(
        icon: '03',
        title: 'Enterprise · A medida',
        description: 'Soporte y operación adaptada a tu empresa.',
      ),
    ],
  ),
};
