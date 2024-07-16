import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:komodo_dex/common_widgets/bottom_navbar_scaffold.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/home'];

  String home() => '/home';

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: const ValueKey('home-location-home'),
        type: BeamPageType.noTransition,
        child: BottomNavbarScaffold(body: const Placeholder()),
      ),
    ];
  }
}
