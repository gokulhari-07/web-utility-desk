import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.value,
    required this.dotColor,
  });

  final String label;
  final String value;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0x2AFFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: const TextStyle(
              color: Color(0xFFF8F8F4),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFFCF8), Color(0xFFF8F3EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD6CAB8), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x17273431),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[accent, accent.withAlpha(170)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: accent.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: accent, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: GoogleFonts.sora(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E2A2F),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Color(0xFF575146),
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF1D4250),
        disabledBackgroundColor: const Color(0xFF9AA9B0),
        foregroundColor: Colors.white,
        disabledForegroundColor: const Color(0xFFECECEC),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label),
    );
  }
}

class TinyTag extends StatelessWidget {
  const TinyTag({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final String clipped = text.length > 30
        ? '${text.substring(0, 30)}...'
        : text;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE4EEF0),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFBFD1D4)),
      ),
      child: Text(
        clipped,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF2A3840),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class InlineOutput extends StatelessWidget {
  const InlineOutput({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EBDF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8CCBB)),
      ),
      child: Text(
        text.isEmpty ? '-' : text,
        style: const TextStyle(
          fontSize: 13,
          height: 1.35,
          color: Color(0xFF2D2A25),
        ),
      ),
    );
  }
}

class SupportChip extends StatelessWidget {
  const SupportChip({super.key, required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: enabled ? const Color(0x2E54D5A9) : const Color(0x30F38E7B),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: enabled ? const Color(0x8854D5A9) : const Color(0x88F38E7B),
        ),
      ),
      child: Text(
        '$label ${enabled ? "Ready" : "Unavailable"}',
        style: TextStyle(
          color: enabled ? const Color(0xFFE7FFF7) : const Color(0xFFFFE7E2),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
