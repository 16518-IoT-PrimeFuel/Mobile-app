part of 'recover_page.dart';

class _DarkBackButton extends StatelessWidget {
  const _DarkBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _BackButtonShell(
      onPressed: onPressed,
      backgroundColor: const Color(0x2BFFFFFF),
      borderColor: const Color(0x40FFFFFF),
      iconColor: Colors.white,
    );
  }
}

class _LightBackButton extends StatelessWidget {
  const _LightBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _BackButtonShell(
      onPressed: onPressed,
      backgroundColor: Color(0xFFF3F4F6),
      borderColor: Colors.transparent,
      iconColor: Color(0xFF1A202C),
    );
  }
}

class _BackButtonShell extends StatelessWidget {
  const _BackButtonShell({
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        tooltip: 'Volver',
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor),
          ),
        ),
        icon: Icon(Icons.arrow_back, size: 19, color: iconColor),
      ),
    );
  }
}

class _SentEnvelope extends StatelessWidget {
  const _SentEnvelope();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 76,
      child: CustomPaint(
        painter: _DashedCirclePainter(),
        child: Center(
          child: Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFECFDF5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.email_outlined,
              size: 31,
              color: Color(0xFF10B981),
            ),
          ),
        ),
      ),
    );
  }
}

class _SentCopy extends StatelessWidget {
  const _SentCopy({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          color: Color(0xFF4A5568),
          fontSize: 17.4,
          height: 1.5,
        ),
        children: [
          const TextSpan(text: 'Enviamos las instrucciones a '),
          TextSpan(
            text: email,
            style: const TextStyle(
              color: Color(0xFF1A202C),
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: '. El enlace expira\nen 15 minutos.'),
        ],
      ),
    );
  }
}

class _SentEmailCard extends StatelessWidget {
  const _SentEmailCard({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
              Icons.mail_outline,
              size: 18,
              color: Color(0xFF1E40AF),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ENVIADO A',
                  style: TextStyle(
                    color: Color(0xFF4A5568),
                    fontSize: 13.775,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    color: Color(0xFF1A202C),
                    fontSize: 17.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              '• ENVIADO',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 13.775,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
