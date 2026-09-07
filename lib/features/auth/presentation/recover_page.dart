import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/fulltank_theme.dart';
import 'widgets/auth_buttons.dart';
import 'widgets/auth_text_field.dart';

enum _RecoverStage { form, sent, notFound }

class RecoverPage extends StatefulWidget {
  const RecoverPage({super.key});

  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  final _emailController = TextEditingController();
  _RecoverStage _stage = _RecoverStage.form;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sent = _stage == _RecoverStage.sent;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: sent ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: sent ? _buildSentState(context) : _buildFormState(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormState(BuildContext context) {
    final errorText = switch (_stage) {
      _RecoverStage.notFound => 'No encontramos ninguna cuenta con este email',
      _ => !_submitted
          ? null
          : _emailController.text.trim().isEmpty
              ? 'Ingresa tu email corporativo'
              : !_isValidEmail(_emailController.text.trim())
                  ? 'Ingresa un email válido'
                  : null,
    };

    return Column(
      children: [
        const _RecoverHero(),
        Transform.translate(
          offset: const Offset(0, -8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RecoveryPill(),
                const SizedBox(height: 10),
                const Text(
                  'Recuperar contraseña',
                  style: TextStyle(
                    color: FullTankColors.navy,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa tu email corporativo para recibir instrucciones de recuperación.',
                  style: TextStyle(
                    color: FullTankColors.inkMid,
                    fontSize: 13.5,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 22),
                AuthTextField(
                  label: 'Email corporativo',
                  controller: _emailController,
                  hintText: 'tu@empresa.com',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  errorText: errorText,
                  onChanged: (_) {
                    if (_stage != _RecoverStage.form || _submitted) {
                      setState(() {
                        _stage = _RecoverStage.form;
                        _submitted = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 14),
                const _InboxInfoCard(),
                const SizedBox(height: 8),
                PrimaryAuthButton(
                  label: 'Enviar enlace de recuperación',
                  onPressed: _submit,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: FullTankColors.blue,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('← Volver a iniciar sesión'),
                  ),
                ),
                const SizedBox(height: 4),
                const _SupportCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        children: [
          Row(
            children: [
              _LightBackButton(onPressed: () => context.pop()),
              const SizedBox(width: 14),
              Image.asset(
                'assets/fulltank-logo.png',
                height: 22,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 72),
          const _SentEnvelope(),
          const SizedBox(height: 24),
          const Text(
            'Revisa tu bandeja',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: FullTankColors.navy,
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          _SentCopy(email: _emailController.text.trim()),
          const SizedBox(height: 22),
          _SentEmailCard(email: _emailController.text.trim()),
          const SizedBox(height: 16),
          PrimaryAuthButton(
            label: 'Abrir mi correo',
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: FullTankColors.blue,
              minimumSize: const Size(double.infinity, 44),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Reenviar en 60s'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final email = _emailController.text.trim();
    setState(() => _submitted = true);
    if (email.isEmpty || !_isValidEmail(email)) return;

    setState(() {
      _stage = email.toLowerCase() == 'noexiste@empresa.com'
          ? _RecoverStage.notFound
          : _RecoverStage.sent;
    });
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
}

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
                colors: [
                  Color(0x551A202C),
                  Color(0xAA1A202C),
                  Colors.white,
                ],
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
        color: FullTankColors.blueSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'RECUPERACIÓN SEGURA',
        style: TextStyle(
          color: FullTankColors.blue,
          fontSize: 10.5,
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
        color: FullTankColors.info,
        border: Border.all(color: FullTankColors.infoBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: FullTankColors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: FullTankColors.navyMid,
                  fontSize: 11.5,
                  height: 1.45,
                ),
                children: [
                  TextSpan(
                    text: 'Revisa tu bandeja\n',
                    style: TextStyle(
                      color: FullTankColors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: 'El enlace expira en '),
                  TextSpan(
                    text: '15 minutos',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: '. Si no aparece, revisa tu carpeta de spam.',
                  ),
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
        color: FullTankColors.card,
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
              color: FullTankColors.navy,
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
                    color: FullTankColors.inkMid,
                    fontSize: 11,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Contactar soporte 24/7',
                  style: TextStyle(
                    color: FullTankColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, size: 18, color: FullTankColors.navy),
        ],
      ),
    );
  }
}

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
      backgroundColor: FullTankColors.card,
      borderColor: Colors.transparent,
      iconColor: FullTankColors.navy,
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
          color: FullTankColors.inkMid,
          fontSize: 12,
          height: 1.5,
        ),
        children: [
          const TextSpan(text: 'Enviamos las instrucciones a '),
          TextSpan(
            text: email,
            style: const TextStyle(
              color: FullTankColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(
            text: '. El enlace expira\nen 15 minutos.',
          ),
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
        color: FullTankColors.card,
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
              color: FullTankColors.blue,
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
                    color: FullTankColors.inkMid,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    color: FullTankColors.navy,
                    fontSize: 12,
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
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6EE7B7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 4;
    const segment = 0.22;
    const gap = 0.11;
    for (var start = 0.0; start < 6.283; start += segment + gap) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        segment,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
