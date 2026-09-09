part of 'recover_page.dart';

class _RecoverHero extends StatelessWidget {
  const _RecoverHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/hero-tanks.jpg', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x551A202C), Color(0xAA1A202C), Colors.white],
                stops: [0, 0.7, 1],
              ),
            ),
          ),
          Positioned(
            top: 54,
            left: 24,
            child: Row(
              children: [
                _DarkBackButton(onPressed: () => context.pop()),
                const SizedBox(width: 14),
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/fulltank-logo.png',
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecoveryPill extends StatelessWidget {
  const _RecoveryPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'RECUPERACIÓN SEGURA',
        style: TextStyle(
          color: Color(0xFF1E40AF),
          fontSize: 15.225,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _InboxInfoCard extends StatelessWidget {
  const _InboxInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFFDBEAFE),
        border: Border.all(color: Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF1E40AF)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 16.675,
                  height: 1.45,
                ),
                children: [
                  TextSpan(
                    text: 'Revisa tu bandeja\n',
                    style: TextStyle(
                      color: Color(0xFF1E40AF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: 'El enlace expira en '),
                  TextSpan(
                    text: '15 minutos',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: '. Si no aparece, revisa tu carpeta de spam.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.help_outline,
              size: 19,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Necesitas ayuda?',
                  style: TextStyle(
                    color: Color(0xFF4A5568),
                    fontSize: 15.95,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Contactar soporte 24/7',
                  style: TextStyle(
                    color: Color(0xFF1A202C),
                    fontSize: 18.85,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, size: 18, color: Color(0xFF1A202C)),
        ],
      ),
    );
  }
}
