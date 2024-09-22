import 'package:flutter/material.dart';

/// Widgets that displays every color in a [ColorScheme] with it's identifier and hex value.
class ColorSchemeVisualizer extends StatelessWidget {
  /// Widgets that displays every color in a [ColorScheme] with it's identifier and hex value.
  const ColorSchemeVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme palette = Theme.of(context).colorScheme;

    final Map<String, Color> colors = {
      "Primary": palette.primary,
      "On Primary": palette.onPrimary,
      "Primary Container": palette.primaryContainer,
      "On Primary Container": palette.onPrimaryContainer,
      "Inverse Primary": palette.inversePrimary,
      "Secondary": palette.secondary,
      "On Secondary": palette.onSecondary,
      "Secondary Container": palette.secondaryContainer,
      "On Secondary Container": palette.onSecondaryContainer,
      "Tertiary": palette.tertiary,
      "On Tertiary": palette.onTertiary,
      "Tertiary Container": palette.tertiaryContainer,
      "On Tertiary Container": palette.onTertiaryContainer,
      "Error": palette.error,
      "On Error": palette.onError,
      "Error Container": palette.errorContainer,
      "On Error Container": palette.onErrorContainer,
      "Background": palette.background,
      "On Background": palette.onBackground,
      "Surface": palette.surface,
      "On Surface": palette.onSurface,
      "Surface Variant": palette.surfaceVariant,
      "On Surface Variant": palette.onSurfaceVariant,
      "Surface Tint": palette.surfaceTint,
      "Inverse Surface": palette.inverseSurface,
      "On Inverse Surface": palette.onInverseSurface,
      "Shadow": palette.shadow,
      "Outline": palette.outline,
      "Outline Variant": palette.outlineVariant,
      "Scrim": palette.scrim,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final color in colors.entries)
              Container(
                width: MediaQuery.of(context).size.width,
                height: 75,
                color: color.value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(color.key),
                      SelectableText(color.value.toString().replaceAll("Color(0xff", "").replaceAll(")", "").toUpperCase()),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}