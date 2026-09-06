import 'package:flutter/material.dart';

import '../../../../core/theme/fulltank_theme.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.onToggleObscure,
    this.onChanged,
    this.errorText,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final active = _focusNode.hasFocus;
    final borderColor = hasError
        ? FullTankColors.danger
        : active
            ? FullTankColors.blue
            : FullTankColors.line;
    final iconColor = hasError || active
        ? (hasError ? FullTankColors.danger : FullTankColors.blue)
        : FullTankColors.inkSoft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            color: hasError ? FullTankColors.danger : FullTankColors.inkMid,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 46,
          decoration: BoxDecoration(
            color: active ? Colors.white : FullTankColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: active || hasError ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            autocorrect: false,
            enableSuggestions: !widget.obscureText,
            style: const TextStyle(
              color: FullTankColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: FullTankColors.blue,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: FullTankColors.inkSoft,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(widget.icon, size: 18, color: iconColor),
              suffixIcon: widget.onToggleObscure == null
                  ? null
                  : IconButton(
                      tooltip: widget.obscureText
                          ? 'Mostrar contraseña'
                          : 'Ocultar contraseña',
                      onPressed: widget.onToggleObscure,
                      icon: Icon(
                        widget.obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: FullTankColors.inkSoft,
                      ),
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
              isDense: true,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(
                Icons.cancel_outlined,
                size: 14,
                color: FullTankColors.danger,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: const TextStyle(
                    color: FullTankColors.danger,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
