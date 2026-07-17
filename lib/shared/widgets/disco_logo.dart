import 'package:flutter/material.dart';

import '../../core/constants/disco_info.dart';

class DiscoLogo extends StatelessWidget {
  const DiscoLogo({
    super.key,
    required this.disco,
    this.size = 56,
    this.selected = false,
  });

  final DiscoInfo disco;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? const Color(0xFF1A1D24) : Colors.white,
        border: Border.all(
          color: selected
              ? scheme.primary
              : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08)),
          width: selected ? 2.5 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(size * 0.12),
          child: Image.asset(
            disco.assetLogo,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                disco.logoUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, _, __) => Icon(
                  Icons.electrical_services_rounded,
                  size: size * 0.42,
                  color: scheme.primary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
