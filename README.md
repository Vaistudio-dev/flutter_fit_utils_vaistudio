A flutter package that contains pre-built utilities for VaiStudio apps. Ranges from extensions, to configs, to providers
and more.

## Features

This package offers:
- Extensions for various classes and purposes, such as easier manipulation for dates, durations and strings.
- A module to easily manage the current build version and compare it to the latest available build.
- A module to easily manage in-app subscriptions
- A module to incorporate Firebase messaging with a single line of code.
- Some pre-made configuration classes:
    - Developper confiflg
    - UI config
- A service to use local notifications.

## Getting started

- [Configure your machine to use a private repo](https://medium.com/@sivadevd01/using-a-private-git-repo-as-a-dependency-in-flutter-7b8429c7c566)
- Go inside your pubspec.yaml file
- Add this line under the dependencies:
```
flutter_fit_utils_vaistudio:
    git:
      url: https://github.com/s0punk/flutter_fit_utils_vaistudio.git
```
- Get dependencies
```
flutter pub get
```

## Usage

### Pre-built configurations
- Developper configuration
A small configuration to get the list of registered developpers and check if the current user is part of the developper team.

```dart
final DeveloperConfig devConfig = DeveloperConfig();
devConfig.read();

if (devConfig.isDevelopper()) {
    ...
}
```

- UI configuration
A configuration related to an app's UI. Gets things like app strings, app bar settings and max loading tries.

```dart
final UIConfig uiConfig = UIConfig();
uiConfig.read();

uiConfig.getString("app_title");
```

### Extensions
Multiple extensions are available for various purposes:
- Color
- DateTime
- double
- Duration
- String

Check the source code to learn about the available methods.

### FCM Provider
The FCM provider facilitates the usage of Firebase Messaging. To use it:
- Don't forget to add the provider inside your Widget Tree
```dart
ChangeNotifierProvider<FCMProvider>(create: (_) => FCMProvider())
```
- Initiliaze it by calling initialize()

### Build Module
The build module can check the current build running on the user's device and compare it to the latest available build. Then, it can suggest or force the user to update the app based on the minimal required build. To use it:
- Don't forget to add the provider inside your Widget Tree
```dart
ChangeNotifierProvider<BuildProvider>(create: (_) => BuildProvider())
```
- Put an UpdateHandler inside your Widget Tree.
- Read the build configuration
```dart
BuildConfig buildConfig = BuildConfig();
buildConfig.read();
```
- And initialize the build provider
```dart
buildConfig.getCurrentVersion(context.build);
```

### Subscriptions with RevenueCat
This module can manage subscriptions and the entitlement status of a user with a RevenueCat project. Works with Google Play and the App Store. To use it:
- Don't forget to add the provider inside your Widget Tree
```dart
ChangeNotifierProvider<SubscriptionProvider>(create: (_) => SubscriptionProvider(
    entitlementId: "app_entitlement_id_here",
    appleApiKey: "apple_api_key_here",
    googleApiKey: "google_api_key_here",
    onUserSubscribedSuccessfully: () { // optionnal
        ...
    },
    onUserRestorePurchaseSuccessfully: () { // optionnal
        ...
    },
))
```
- Initiliaze it by calling initialize()

You can also use the pre-buil Paywall to let the user see the available plans and subscribe.

### Notification Service
This service is a wrapper around flutter_local_notifications. It can:
- Ask the user permission to send notifications
- Send basic notifications
- Schedule notifications for later
- Send notifications with a coutdown

## Additional information

Feel free to [give any feedback](https://github.com/s0punk/flutter_fit_utils_vaistudio/issues) ! This package is also open to contributions.
