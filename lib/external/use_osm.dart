import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:maptilerwithosmplugin/external/osm_hook.dart';

/// [useMapIsReady]
///
/// the function will call [MapIsReadyHook]
void useMapIsReady({
  required MapController controller,
  required Future<void> Function() mapIsReady,
}) {
  return use(
    MapIsReadyHook(
      mapIsReady: mapIsReady,
      controller: controller,
    ),
  );
}

/// [useMapController]
///
/// the function will call [MapControllerHook] to initialize [MapController]
/// return [MapController] that will passe  to [OSMFlutter]
MapController useMapController({
  UserTrackingOption? userTrackingOption,
  GeoPoint? initPosition,
  BoundingBox? areaLimit = const BoundingBox.world(),
  CustomTile? tile,
}) {
  assert(
    (userTrackingOption != null) ^ (initPosition != null),
    'userTrackingOption and initPosition can not be null at the same time',
  );
  return use(
    MapControllerHook(
      userTrackingOption: userTrackingOption,
      initPosition: initPosition,
      areaLimit: areaLimit,
      tile: tile,

    ),
  );
}

/// [useMapListener]
///
/// this hook to provide map callbacks for get single tap or,region changed,
/// etc..
void useMapListener({
  required MapController controller,
  Future<void> Function(GeoPoint)? onSingleTap,
  Future<void> Function(GeoPoint)? onLongTap,
  Future<void> Function(Region)? onRegionChanged,
  Future<void> Function(RoadInfo)? onRoadTap,
}) {
  return use(
    MapListenerHook(
      controller: controller,
      onSingleTap: onSingleTap,
      onLongTap: onLongTap,
      onRegionChanged: onRegionChanged,
      onRoadTap: onRoadTap,
    ),
  );
}
