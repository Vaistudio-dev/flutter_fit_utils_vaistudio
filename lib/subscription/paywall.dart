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

  String getSubscribeButtonText() {
    if (context.subscriptionProvider.packages.firstWhere((element) => element.value.identifier == selectedPackageIdentifier).value.hasFreeTrial()) {
      return getString("startFreeTrial");
    }

    return getString("subscribeNow");
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: FitTheme.of(context)?.pageMargin,
                        child: Column(
                          children: [
                            if (widget.imagePath != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Image.asset(
                                  widget.imagePath!,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            FitText.headline(getString("subscriptionHeadline")),
                            const SizedBox(height: 12),
                            for (final String feature in widget.proFeatures)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: FitTextIcon(
                                  icon: Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
                                  text: FitText.body(getString(feature)),
                                ),
                              ),
                            const SizedBox(height: 12),
                            if (context.watchSubscriptionProvider.offering != null)
                              FitRadioCards(
                                selectedIndex: context.subscriptionProvider.packages.indexWhere((element) => element.value.identifier == selectedPackageIdentifier),
                                options: [
                                  for (final package in context.watchSubscriptionProvider.packages.map((e) => e.value))
                                    (getString(package.packageType.name), "${getString("full_access_for")}\$${package.getPricePerPeriod()}"),
                                ],
                                onSelectionChanged: (index) {
                                  setState(() {
                                    selectedPackageIdentifier = context.subscriptionProvider.packages[index].value.identifier;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      FitButton(
                        onTap: () async {
                          final String result = await context.subscriptionProvider.buySubscription(context.subscriptionProvider.packages.firstWhere((element) => element.value.identifier == selectedPackageIdentifier).value);

                          if (result.isNotEmpty) {
                            showMsg(getString(result));
                          }
                        },
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        width: double.infinity,
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FitText.button(
                              getSubscribeButtonText(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (context.subscriptionProvider.packages.firstWhere((element) => element.value.identifier == selectedPackageIdentifier).value.hasFreeTrial())
                              FitText.button(
                                getString("subscription_intro_offer", placeholders: {"PRICE": context.subscriptionProvider.packages.firstWhere((element) => element.value.identifier == selectedPackageIdentifier).value.getPricePerPeriod()}),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
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
                ],
              ),
            ),
          );
        }
    );
  }
}
