import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fit_utils_ui/flutter_fit_utils_ui.dart';
import 'package:flutter_fit_utils_vaistudio/flutter_fit_utils_vaistudio.dart';
import 'package:url_launcher/url_launcher.dart';

/// Paywall générique.
class Paywall extends StatefulWidget {
  /// Indique s'il faut afficher un bouton pour passer cette page.
  final bool skippable;

  /// Liste des avantages à utiliser la version pro,
  final List<String> proFeatures;

  /// Liens vers la privacy policy.
  final String privacyPolicyLink;

  /// Liens vers les termes et conditions.
  final String tosLink;

  /// Path à fournir pour afficher une image.
  final String? imagePath;

  /// Paywall générique.
  const Paywall({
    super.key,
    required this.proFeatures,
    required this.privacyPolicyLink,
    required this.tosLink,
    this.skippable = false,
    this.imagePath,
  });

  @override
  State<Paywall> createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  String selectedPackageIdentifier = "";

  @override
  void initState() {
    super.initState();
    if (context.subscriptionProvider.packages.isNotEmpty) {
      selectedPackageIdentifier = context.subscriptionProvider.packages.first.value.identifier;
    }
  }

  Future<void> showMsg(String message) async {
    showOkAlertDialog(
      context: context,
      title: getString("errorOccurred"),
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.subscriptionProvider.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const FitLoadingIndicator();
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: widget.skippable,
          ),
          body: SafeArea(
            child: Column(
              children: [
                if (widget.imagePath != null)
                  Image.asset(
                    widget.imagePath!,
                    width: MediaQuery.of(context).size.width,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: FitTheme.of(context)?.pageMargin,
                      child: Column(
                        children: [
                          FitText.headline(getString("subscriptionHeadline")),
                          for (final String feature in widget.proFeatures)
                            FitTextIcon(
                              icon: const Icon(Icons.check, size: 18),
                              text: FitText.body(
                                getString(feature),
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          if (context.watchSubscriptionProvider.offering != null)
                            for (final package in context.watchSubscriptionProvider.packages.map((e) => e.value))
                              FitSelectableCard(
                                title: getString(package.packageType.name),
                                description: "${getString("full_access_for")}\$${package.getPricePerPeriod()}",
                                selected: selectedPackageIdentifier == package.identifier,
                                onTap: () {
                                  setState(() {
                                    selectedPackageIdentifier = package.identifier;
                                  });
                                },
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final bool result = await context.subscriptionProvider.restorePurchase();

                          if (result) {
                            showMsg(getString("restoreCompleted"));
                          }
                          else {
                            showMsg(getString("errorRestore"));
                          }
                        },
                        child: FitText.body(
                          getString("restore"),
                        ),
                      ),
                      const Text("  •  "),
                      GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(widget.tosLink));
                        },
                        child: FitText.body(getString("terms")),
                      ),
                      const Text("  •  "),
                      GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(widget.privacyPolicyLink));
                        },
                        child: FitText.body(getString("privacy")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
