import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:komodo_dex/common_widgets/bottom_navbar_scaffold.dart';
import 'package:komodo_dex/packages/portfolio/pages/portfolio_page.dart';

class PortfolioLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/portfolio'];

  String portfolio() => '/portfolio';

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: const ValueKey('portfolio-location-portfolio'),
        type: BeamPageType.noTransition,
        child: BottomNavbarScaffold(
          // title: Text('Portfolio'),
          body: PortfolioPage(),
        ),
      ),
    ];
  }
}
