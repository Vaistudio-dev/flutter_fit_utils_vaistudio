import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../config/index.dart';

/// Provider for subscription and subscription logic for the App Store and Google Play, with RevenueCat.
class SubscriptionProvider extends ChangeNotifier {
  /// Entitlement Id in the Revenue Cat project.
  final String entitlementId;

  /// App Store API key in the Revenue Cat project.
  final String appleApiKey;

  /// Google Play API key in the Revenue Cat project.
  final String googleApiKey;

  bool _initialized = false;

  bool _isEntitlementActive = devConfig.isDevelopper();

  /// Returns [true] if the pro subscription is active for the user.
  bool get isEntitlementActive => _isEntitlementActive;

  /// Current subscription offering of the app.
  Offering? offering;

  /// List of the available subscriptions.
  /// The key is the number of billing in a year.
  List<MapEntry<int, Package>> packages = [];

  /// Returns [true] if confetti should be shown.
  /// Confetti are used when a user subscribes.
  bool showConfetti = false;

  /// Called when a user successfully subscribed.
  final Function()? onUserSubscribedSuccessfully;

  /// Called when a user successfully restores a previous purchase.
  final Function()? onUserRestorePurchaseSuccessfully;

  /// Execute when a user is trying to access a feature behind the paywall.
  final Function(BuildContext)? onRestrictedAccess;

  /// Creates a new instance of [SubscriptionProvider].
  SubscriptionProvider({
    required this.entitlementId,
    required this.appleApiKey,
    required this.googleApiKey,
    this.onUserSubscribedSuccessfully,
    this.onUserRestorePurchaseSuccessfully,
    this.onRestrictedAccess,
  });

  /// Initializes the subscriptions and fetches the current offering.
  Future<void> initialize() async {
    if (_initialized) return;

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(googleApiKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(appleApiKey);
    }

    if (configuration != null) {
      await Purchases.configure(
          configuration..appUserID = FirebaseAuth.instance.currentUser!.uid);
    }

    try {
      offering = (await Purchases.getOfferings()).current!;
    } on PlatformException {
      // No offering available. Should never happen in prod.
      if (kDebugMode) {
        print("ERROR: NO OFFERINGS AVAILABLE");
      }
    }

    _getPackages();
    _isEntitlementActive =
        await checkEntitlementStatus() || devConfig.isDevelopper();

    _initialized = true;
  }

  /// Destroys the instance.
  void destroy() {
    _initialized = false;
    offering = null;
    packages.clear();
  }

  /// Adds available packages inside [packages], based on the number of billing in a year.
  void _getPackages() {
    if (offering == null) {
      return;
    }

    if (offering!.lifetime != null) {
      packages.add(MapEntry(1, offering!.lifetime!));
    }

    if (offering!.annual != null) {
      packages.add(MapEntry(1, offering!.annual!));
    }

    if (offering!.sixMonth != null) {
      packages.add(MapEntry(2, offering!.sixMonth!));
    }

    if (offering!.threeMonth != null) {
      packages.add(MapEntry(4, offering!.threeMonth!));
    }

    if (offering!.twoMonth != null) {
      packages.add(MapEntry(6, offering!.twoMonth!));
    }

    if (offering!.monthly != null) {
      packages.add(MapEntry(12, offering!.monthly!));
    }

    if (offering!.weekly != null) {
      packages.add(MapEntry(52, offering!.weekly!));
    }
  }

  /// Calculates the discount of a package, based on the package with the most billing in a year.
  int calculatePackageDiscount(Package package) {
    if (package == packages.last.value) {
      return 0;
    }

    final double totalPriceForSmallestSub =
        packages.last.value.storeProduct.price * packages.last.key;
    final double packageTotalPrice = package.storeProduct.price *
        packages.firstWhere((element) => element.value == package).key;

    return ((totalPriceForSmallestSub - packageTotalPrice) * 100) ~/
        totalPriceForSmallestSub;
  }

  /// Returns [true] if the entitlement status is active for the user.
  Future<bool> checkEntitlementStatus() async {
    try {
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Buys a subscription for the user.
  /// Returns a [String] with an error code.
  /// If the subscription is successful or canceled, returns an empty [String].
  Future<String> buySubscription(Package package) async {
    try {
      final CustomerInfo customerInfo =
          await Purchases.purchasePackage(package);
      final bool isPro =
          customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
      if (!isPro) {
        return "errorPurchase";
      }
    } on PlatformException catch (e) {
      final PurchasesErrorCode errorCode = PurchasesErrorHelper.getErrorCode(e);

      // Purchase error.
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        return "errorPurchase";
      }

      // Purchase successful or canceled.
      return "";
    }

    _isEntitlementActive = true;
    showConfetti = true;
    notifyListeners();

    onUserSubscribedSuccessfully!();
    return "";
  }

  /// Restores the purchase of a user.
  /// Returns [true] if the restore is successful.
  Future<bool> restorePurchase() async {
    try {
      final CustomerInfo restoredInfo = await Purchases.restorePurchases();

      final bool isPro =
          restoredInfo.entitlements.all[entitlementId]?.isActive ?? false;
      if (!isPro) {
        return false;
      }
    } on PlatformException {
      return false;
    }

    _isEntitlementActive = true;
    onUserRestorePurchaseSuccessfully!();
    return true;
  }
}

/// Extension de la classe [Package].
extension PackageExtension on Package {
  /// Indique si un abonnement possède un essai gratuit.
  bool hasFreeTrial() => storeProduct.introductoryPrice?.price == 0;

  /// Retourne le prix de l'abonnement et sa durée.
  /// Ex. 54,99$ /an.
  String getPricePerPeriod() =>
      "${storeProduct.priceString.replaceAll(r"$", "")}/${getString("${packageType.name}_short")}";
}
