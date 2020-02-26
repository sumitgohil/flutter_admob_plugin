import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AdmobAdEvent {
  loaded,
  failedToLoad,
  clicked,
  impression,
  opened,
  leftApplication,
  closed,
  completed,
  rewarded,
  started,
}


class FlutterAdmobPlugin {
  static const MethodChannel _channel =
      const MethodChannel('admob');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get showAlertDialog async {
    await _channel.invokeMethod('showAlertDialog');
  }
  
  static Future<String> initAdmob(String appId) async{
    await _channel.invokeMapMethod("initAdmob", appId);
  }
}

class AdmobBanner extends StatefulWidget {
  final String adUnitId;
  final AdmobBannerSize adSize;
  final void Function(AdmobBannerController) onBannerCreated;
  final void Function(AdmobAdEvent, Map<String, dynamic>) listener;

  AdmobBanner({
    Key key,
    @required this.adUnitId,
    @required this.adSize,
    this.listener,
    this.onBannerCreated
  }) : super(key: key);

  @override
  _AdmobBannerState createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {

  AdmobBannerController _controller;

  @override
  void dispose() {
    super.dispose();
  }


  void _onPlatformViewCreated(int id) {
    _controller = AdmobBannerController(id, widget.listener);

    if (widget.onBannerCreated != null) {
      widget.onBannerCreated(_controller);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
          width: widget.adSize.width >= 0
              ? widget.adSize.width.toDouble()
              : double.infinity,
          height: widget.adSize.height >= 0
              ? widget.adSize.height.toDouble()
              : double.infinity,
          child: AndroidView(
            viewType: 'admob/banner',
            creationParams: <String, dynamic>{
              "adUnitId": widget.adUnitId,
              "adSize": widget.adSize.toMap,
            },
            creationParamsCodec: StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
          width: widget.adSize.width.toDouble(),
          height: widget.adSize.height.toDouble(),
          child: UiKitView(
            viewType: 'admob/banner',
            creationParams: <String, dynamic>{
              "adUnitId": widget.adUnitId,
              "adSize": widget.adSize.toMap,
            },
            creationParamsCodec: StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          ));
    }
  }
}

class AdmobBannerSize {
  final int width, height;
  final String name;

  static const AdmobBannerSize BANNER =
  AdmobBannerSize(width: 320, height: 50, name: 'BANNER');
  static const AdmobBannerSize LARGE_BANNER =
  AdmobBannerSize(width: 320, height: 100, name: 'LARGE_BANNER');
  static const AdmobBannerSize MEDIUM_RECTANGLE =
  AdmobBannerSize(width: 300, height: 250, name: 'MEDIUM_RECTANGLE');
  static const AdmobBannerSize FULL_BANNER =
  AdmobBannerSize(width: 468, height: 60, name: 'FULL_BANNER');
  static const AdmobBannerSize LEADERBOARD =
  AdmobBannerSize(width: 728, height: 90, name: 'LEADERBOARD');
  static const AdmobBannerSize SMART_BANNER =
  AdmobBannerSize(width: -1, height: -2, name: 'SMART_BANNER');

  const AdmobBannerSize({
    @required this.width,
    @required this.height,
    this.name,
  });

  Map<String, dynamic> get toMap => <String, dynamic>{
    'width': width,
    'height': height,
    'name': name,
  };
}



///////// ADMOB Interstitial
class AdmobInterstitial extends AdmobEventHandler {
  static const MethodChannel _channel =
  const MethodChannel('admob/interstitial');

  int id;
  MethodChannel _adChannel;
  final String adUnitId;
  final void Function(AdmobAdEvent, Map<String, dynamic>) listener;

  AdmobInterstitial({
    @required this.adUnitId,
    this.listener,
  }) : super(listener) {
    id = hashCode;
    if (listener != null) {
      _adChannel = MethodChannel('admob/interstitial_$id');
      _adChannel.setMethodCallHandler(handleEvent);
    }
  }

  Future<bool> get isLoaded async {
    final bool result =
    await _channel.invokeMethod('isLoaded', <String, dynamic>{
      'id': id,
    });
    return result;
  }

  void load() async {
    await _channel.invokeMethod('load', <String, dynamic>{
      'id': id,
      'adUnitId': adUnitId,
    });

    if (listener != null) {
      _channel.invokeMethod('setListener', <String, dynamic>{
        'id': id,
      });
    }
  }

  void show() async {
    if (await isLoaded == true) {
      _channel.invokeMethod('show', <String, dynamic>{
        'id': id,
      });
    }
  }

  void dispose() async {
    await _channel.invokeMethod('dispose', <String, dynamic>{
      'id': id,
    });
  }
}


//////////////// ADMOB EVENTS
abstract class AdmobEventHandler {
  final Function(AdmobAdEvent, Map<String, dynamic>) _listener;

  AdmobEventHandler(Function(AdmobAdEvent, Map<String, dynamic>) listener) : _listener = listener;

  Future<dynamic> handleEvent(MethodCall call) async {
    switch (call.method) {
      case 'loaded':
        _listener(AdmobAdEvent.loaded, null);
        break;
      case 'failedToLoad':
        _listener(AdmobAdEvent.failedToLoad, Map<String, dynamic>.from(call.arguments));
        break;
      case 'clicked':
        _listener(AdmobAdEvent.clicked, null);
        break;
      case 'impression':
        _listener(AdmobAdEvent.impression, null);
        break;
      case 'opened':
        _listener(AdmobAdEvent.opened, null);
        break;
      case 'leftApplication':
        _listener(AdmobAdEvent.leftApplication, null);
        break;
      case 'closed':
        _listener(AdmobAdEvent.closed, null);
        break;
      case 'completed':
        _listener(AdmobAdEvent.completed, null);
        break;
      case 'rewarded':
        _listener(AdmobAdEvent.rewarded, Map<String, dynamic>.from(call.arguments));
        break;
      case 'started':
        _listener(AdmobAdEvent.started, null);
        break;
    }

    return null;
  }
}

class AdmobBannerController extends AdmobEventHandler {
  final MethodChannel _channel;

  AdmobBannerController(int id, Function(AdmobAdEvent, Map<String, dynamic>) listener)
      : _channel = MethodChannel('admob/banner_$id'),
        super(listener) {
    if (listener != null) {
      _channel.setMethodCallHandler(handleEvent);
      _channel.invokeMethod('setListener');
    }
  }

  void dispose() {
    _channel.invokeMethod('dispose');
  }
}

