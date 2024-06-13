import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fit_utils_vaistudio/internet_handler/network_alert.dart';

/// Widget that shows it's child only when an internet connection is available. Otherwise,
/// it shows an indicator that no internet is available.
/// The content is changed as soon as there is a change with the availables connections.
class InternetHandler extends StatelessWidget {
  /// Widget to display when a connection is available.
  final Widget child;

  /// Widget to display when there is no connections available.
  final Widget onNoConnection;

  /// Creates a new [InternetHandler].
  const InternetHandler({
    super.key,
    required this.child,
    this.onNoConnection = const NetworkAlert(),
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.requireData.contains(ConnectivityResult.none)) {
          return onNoConnection;
        }

        return child;
      }
    );
  }
}