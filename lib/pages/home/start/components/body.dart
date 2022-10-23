import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_config/entities/app_entity.dart';
import 'package:flutter_firebase_config/pages/home/webview/components/body.dart';

import 'package:flutter_firebase_config/utilities/utility.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isLoading = false;
  final utility = Utility();
  final dataNotifier = DataValueNotifier();
  bool hasInternetConnection = false;

  Future<void> _initConfig() async {
    try {
      hasInternetConnection = await InternetConnectionChecker().hasConnection;
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        // cache refresh time
        fetchTimeout: const Duration(seconds: 1),
        // a fetch will wait up to 10 seconds before timing out
        minimumFetchInterval: const Duration(seconds: 10),
      ));

      await _syncData();

      setState(() {
        _isLoading = true;
      });

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    _initConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: InternetConnectionChecker().hasConnection,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data!) {
          return Scaffold(
              body: _isLoading
                  ? SafeArea(
                      child: ValueListenableBuilder(
                          valueListenable: dataNotifier,
                          builder: (context, AppEntity? value, child) {
                            return WebViewExample(url: value!.link);
                          }),
                    )
                  : const Center(child: CircularProgressIndicator()));
        }
        return Text('no internet');
      },
    );
  }

  Future<void> _syncData() async {
    try {
      final rs = _remoteConfig.getString('app');
      dataNotifier.value = await utility.parseJsonConfig(rs);
    } catch (e) {
      debugPrint('$e');
    }
  }
}

class DataValueNotifier extends ValueNotifier<AppEntity?> {
  DataValueNotifier() : super(null);
}
