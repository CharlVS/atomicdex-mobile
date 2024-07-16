import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

base class RouteObject<T extends Widget> {
  RouteObject.value({
    required List<String> pathPatterns,
    required T widget,
  })  : _widget = widget,
        _pathPatterns = pathPatterns,
        assert(pathPatterns.isNotEmpty),
        assert(pathPatterns.every((pattern) => pattern.startsWith('/')));

  final T? _widget;

  ValueKey get key => ValueKey(path());

  final List<String>? _pathPatterns;

  List<String> get pathPatterns => _pathPatterns ?? [];

  String Function() path() => throw UnimplementedError();

  bool doesMatch(String path) => pathPatterns.contains(path);

  T get widget => _widget ?? (throw UnimplementedError());

  RoutesBeamLocation get location => RoutesBeamLocation(
        routes: pathFunctions,
        routeInformation: _routeInformation,
      );

  Map<Pattern, dynamic Function(BuildContext, BeamState, Object?)>
      get pathFunctions => {
            // TODO:
          };

  RouteInformation get _routeInformation => throw UnimplementedError();
}
