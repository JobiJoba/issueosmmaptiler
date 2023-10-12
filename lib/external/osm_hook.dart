import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

/// [MapControllerHook]
///
/// this controller hook is to illustrate statefull widget for hooks
/// where the [MapController] will be initialized
class MapControllerHook extends Hook<MapController> {
  const MapControllerHook({
    this.userTrackingOption,
    this.initPosition,
    this.areaLimit,
    this.tile,
  });
  final UserTrackingOption? userTrackingOption;
  final GeoPoint? initPosition;
  final BoundingBox? areaLimit;
  final CustomTile? tile;

  @override
  HookState<MapController, Hook<MapController>> createState() =>
      _MapControllerHookState();
}

class _MapControllerHookState
    extends HookState<MapController, MapControllerHook> {
  late MapController _controller;

  @override
  void initHook() {
    super.initHook();
    if (hook.tile == null) {
      _controller = MapController(
        initMapWithUserPosition: hook.userTrackingOption,
        initPosition: hook.initPosition,
        areaLimit: hook.areaLimit,
      );
    } else if (hook.tile != null) {
      _controller = MapController.customLayer(
        initMapWithUserPosition: hook.userTrackingOption,
        initPosition: hook.initPosition,
        areaLimit: hook.areaLimit,
        customTile: hook.tile!,
      );
    }
  }

  @override
  MapController build(BuildContext context) {
    return _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}

typedef MapIsReady = Future<void> Function();

/// [MapIsReadyHook]
///
/// this hook is to replace MapIsReady for hook state
/// where you can put your logic after the map is ready to use
class MapIsReadyHook extends Hook<MapIsReady> {
  const MapIsReadyHook({
    required this.mapIsReady,
    required this.controller,
  });
  final MapIsReady mapIsReady;
  final MapController controller;

  @override
  HookState<MapIsReady, Hook<MapIsReady>> createState() =>
      _MapIsReadyHookState();
}

class _MapIsReadyHookState extends HookState<MapIsReady, MapIsReadyHook>
    with OSMMixinObserver {
  late MapController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = hook.controller;
    _controller.addObserver(this);
  }

  @override
  MapIsReady build(BuildContext context) {
    return hook.mapIsReady;
  }

  @override
  void dispose() {}

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) await hook.mapIsReady();
  }
}

/// [MapListenerHook]
///
/// this controller hook is to illustrate statefull widget for hooks
/// where the [MapController] will be initialized
class MapListenerHook extends Hook<void> {
  const MapListenerHook({
    required this.controller,
    this.onSingleTap,
    this.onLongTap,
    this.onRegionChanged,
    this.onRoadTap,
  });
  final MapController controller;
  final Future<void> Function(GeoPoint)? onSingleTap;
  final Future<void> Function(GeoPoint)? onLongTap;
  final Future<void> Function(Region)? onRegionChanged;
  final Future<void> Function(RoadInfo)? onRoadTap;

  @override
  HookState<void, Hook<void>> createState() => _MapListenerHookState();
}

class _MapListenerHookState extends HookState<void, MapListenerHook>
    with OSMMixinObserver {
  @override
  void initHook() {
    super.initHook();
    hook.controller.addObserver(this);
  }

  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    hook.controller.removeObserver(this);
  }

  @override
  Future<void> mapIsReady(bool isReady) async {}

  @override
  Future<void> onSingleTap(GeoPoint position) async {
    super.onSingleTap(position);
    if (hook.onSingleTap != null) {
      await hook.onSingleTap!(position);
    }
  }

  @override
  void onLongTap(GeoPoint position) {
    super.onLongTap(position);
    final onLongTap = hook.onLongTap;
    if (onLongTap != null) {
      onLongTap(position);
    }
  }

  @override
  void onRegionChanged(Region region) {
    super.onRegionChanged(region);
    final onRegionChanged = hook.onRegionChanged;
    if (onRegionChanged != null) {
      onRegionChanged(region);
    }
  }

  @override
  void onRoadTap(RoadInfo road) {
    super.onRoadTap(road);
    final onRoadTap = hook.onRoadTap;
    if (onRoadTap != null) {
      onRoadTap(road);
    }
  }
}
