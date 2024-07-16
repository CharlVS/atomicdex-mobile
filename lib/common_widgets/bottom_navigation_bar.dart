import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:komodo_dex/app_config/app_config.dart';
import 'package:komodo_dex/drawer/drawer_bloc.dart';
import 'package:komodo_dex/localizations.dart';
import 'package:komodo_dex/model/feed_provider.dart';
import 'package:komodo_dex/model/updates_provider.dart';
import 'package:komodo_dex/navigation/app_routes.dart';
import 'package:komodo_dex/utils/iterable_utils.dart';
import 'package:komodo_dex/utils/utils.dart';
import 'package:komodo_dex/widgets/build_red_dot.dart';
import 'package:provider/provider.dart';

// Copied from main.dart. See main.dart for commit history.
class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();

  static Set<String> tabPaths = {
    AppRoutes.legacy.home(),
    AppRoutes.portfolio.portfolio(),
    // AppRoutes.legacy.dex(),
    AppRoutes.legacy.orders(),
    AppRoutes.legacy.markets(),
    if (appConfig.isFeedEnabled) AppRoutes.legacy.feed(),
  };
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    // TODO: Refactor from legacy bloc
    final FeedProvider? feedProvider =
        appConfig.isFeedEnabled ? Provider.of<FeedProvider>(context) : null;
    final UpdatesProvider updatesProvider =
        Provider.of<UpdatesProvider>(context);

    return BottomNavigationBar(
      key: const Key('main-nav'),
      type: BottomNavigationBarType.fixed,
      onTap: (int index) => onTabTapped(index, context: context),
      currentIndex: _currentTabIndex(),
      elevation: 1,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              key: Key('main-nav-home'),
            ),
            // TODO: Localize
            label: 'Home'
            // label: AppLocalizations.of(context)!.home,
            ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.account_balance_wallet_rounded,
            key: Key('main-nav-portfolio'),
          ),
          label: AppLocalizations.of(context)!.portfolio,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.swap_vert, key: Key('main-nav-orders')),
          label: AppLocalizations.of(context)!.orders.toSentenceCase(),
        ),
        // BottomNavigationBarItem(
        //   icon: const Icon(
        //     Icons.show_chart,
        //     key: Key('main-nav-markets'),
        //   ),
        //   label: AppLocalizations.of(context)!.marketsTab,
        // ),
        if (appConfig.isFeedEnabled)
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.feedTab,
            icon: Badge.count(
              isLabelVisible: feedProvider?.hasNewItems ?? false,
              count: feedProvider?.unreadCount ?? 0,
              child: const Icon(
                Icons.library_books,
                key: Key('main-nav-feed'),
              ),
            ),
          ),
        BottomNavigationBarItem(
          icon: Stack(
            children: <Widget>[
              const Icon(Icons.dehaze, key: Key('main-nav-more')),
              if (updatesProvider.status != UpdateStatus.upToDate)
                buildRedDot(context),
            ],
          ),
          label: AppLocalizations.of(context)!.moreTab,
        ),
      ],
    );
  }

  int _currentTabIndex() {
    return tabIndexOf(
          context.currentBeamLocation.state.routeInformation.location ?? '',
        ) ??
        0;
  }

  void onTabTapped(int index, {required BuildContext context}) {
    final currentPath =
        context.currentBeamLocation.state.routeInformation.location;

    final didTapCurrentTab =
        currentPath == null ? false : tabIndexOf(currentPath) == index;

    if (didTapCurrentTab) {
      return;
    }

    final didTapDrawerTab = index == AppBottomNavigationBar.tabPaths.length;

    if (didTapDrawerTab) {
      context.read<DrawerBloc>().add(DrawerToggleRequested());

      return;
    }
    context.beamToNamed(AppBottomNavigationBar.tabPaths.elementAt(index));
  }

  int? tabIndexOf(String path) {
    return AppBottomNavigationBar.tabPaths.toList().indexOfOrNull(path);
  }
}
