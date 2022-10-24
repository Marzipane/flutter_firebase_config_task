import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_config/entities/app_entity.dart';
import 'package:flutter_firebase_config/pages/home/webview/components/body.dart';
import 'package:flutter_firebase_config/utilities/utility.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../notifiers/data_value_notifier.dart';
import '../../../../utilities/url_validator.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isLoading = true;
  final utility = Utility();
  final dataNotifier = DataValueNotifier();

  @override
  void initState() {
    _initConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get internet connection state
    return FutureBuilder<bool>(
      future: InternetConnectionChecker().hasConnection,
      initialData: false,
      builder: (context, snapshot) {
        return Scaffold(
          body: (() {
            // if connection is established
            if (snapshot.data!) {
              if (_isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SafeArea(
                child: ValueListenableBuilder(
                    valueListenable: dataNotifier,
                    builder: (context, AppEntity? value, child) {
                      // if url from json is valid
                      if (hasValidUrl(value!.link)) {
                        return WebViewRoot(url: value.link);
                      }
                      // otherwise, display stub-site
                      else {
                        return const WebViewRoot(
                          url:
                              'https://ru.wikipedia.org/wiki/%D0%A1%D0%B0%D0%B9%D1%82-%D0%B7%D0%B0%D0%B3%D0%BB%D1%83%D1%88%D0%BA%D0%B0',
                        );
                      }
                    }),
              );
            }
            // otherwise, if there is no interne
            else {
              return const Center(
                child: Text('Internet Connection error'),
              );
            }
          })(),
        );
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

  Future<void> _initConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        // cache refresh time
        fetchTimeout: const Duration(seconds: 1),
        // a fetch will wait up to 10 seconds before timing out
        minimumFetchInterval: const Duration(seconds: 10),
      ));

      await _syncData();

      setState(() {
        _isLoading = false;
      });

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}


