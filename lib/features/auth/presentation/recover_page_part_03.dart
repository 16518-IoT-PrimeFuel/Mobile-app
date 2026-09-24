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
