import 'package:flutter/material.dart';

import '../flutter_fit_utils_vaistudio.dart';

/// Widget qui gère les mises à jour de l'application.
class UpdateHandler extends StatelessWidget {
  /// Widget à afficher.
  final Widget child;

  /// Widget à afficher dans le cas où une mise à jour est optionnel.
  final Widget? onOptionnalUpdate;

  /// Widget à afficher dans le cas où une mise à jour est obligatoire.
  final Widget? onMandatoryUpdate;

  /// Widget qui gère les mises à jour de l'application.
  const UpdateHandler({super.key, required this.child, this.onMandatoryUpdate, this.onOptionnalUpdate});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (context.watchBuild.appUpdateStatus == UpdateStatus.optionnal && onOptionnalUpdate != null) {
          return onMandatoryUpdate!;
        }

        if (context.watchBuild.appUpdateStatus == UpdateStatus.mandatory && onMandatoryUpdate != null) {
          return onMandatoryUpdate!;
        }

        return child;
      },
    );
  }
}