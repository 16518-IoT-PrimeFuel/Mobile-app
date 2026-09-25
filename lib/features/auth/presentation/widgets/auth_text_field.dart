import 'package:flutter/material.dart';

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
    this.largeText = false,
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
  final bool largeText;

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
        ? Color(0xFFEF4444)
        : active
        ? Color(0xFF1E40AF)
        : Color(0xFFE2E8F0);
    final iconColor = hasError || active
        ? (hasError ? Color(0xFFEF4444) : Color(0xFF1E40AF))
        : Color(0xFF94A3B8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            color: hasError ? Color(0xFFEF4444) : Color(0xFF4A5568),
            fontSize: widget.largeText ? 15.95 : 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 46,
          decoration: BoxDecoration(
            color: active ? Colors.white : Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            autocorrect: false,
            enableSuggestions: !widget.obscureText,
            style: TextStyle(
              color: Color(0xFF1A202C),
              fontSize: widget.largeText ? 20.3 : 14,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: Color(0xFF1E40AF),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: widget.largeText ? 20.3 : 14,
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
                        color: Color(0xFF94A3B8),
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
                color: Color(0xFFEF4444),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: widget.largeText ? 15.225 : 10.5,
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
