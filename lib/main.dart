import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:maptilerwithosmplugin/external/use_osm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = useMapController(
      initPosition: GeoPoint(latitude: 51.4981858, longitude: -0.13044559),
      tile: CustomTile(
        urlsServers: [
          TileURLs(
            url: 'https://api.maptiler.com/maps/backdrop/{z}/{x}/{y}',
          ),
        ],
        tileExtension: 'png',
        sourceName: 'backdrop',
        keyApi: const MapEntry('apiKey', 'yourkey'),
        // keyApi: const MapEntry('apiKey', 'yourKey'),
        // keyApi: const MapEntry('key', 'yourKey'),
      ),
    );

    useMapIsReady(
      controller: controller,
      mapIsReady: () async {},
    );

    return Scaffold(
      body: OSMFlutter(
        mapIsLoading: const Center(child: CircularProgressIndicator()),
        controller: controller,
        osmOption: const OSMOption(
          zoomOption: ZoomOption(
            initZoom: 18,
          ),
        ),
      ),
    );
  }
}
