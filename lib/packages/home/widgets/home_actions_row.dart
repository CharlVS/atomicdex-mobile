import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:komodo_dex/common_widgets/input/aligned_icon_button.dart';
import 'package:komodo_dex/localizations.dart';
import 'package:komodo_dex/navigation/app_routes.dart';
import 'package:komodo_dex/utils/utils.dart';

class HomeActionsRow extends StatelessWidget {
  const HomeActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlignedIconButton(
            icon: Icon(Icons.call_made),
            label: Text(AppLocalizations.of(context)!.send.toSentenceCase()),
            onPressed: () {},
          ),
          SizedBox(width: 16),
          //

          AlignedIconButton(
            icon: Icon(Icons.swap_horiz),
            label: Text(AppLocalizations.of(context)!.swap.toSentenceCase()),
            onPressed: () => context.beamToNamed(
              AppRoutes.legacy.dex(),
              beamBackOnPop: true,
            ),
          ),
          SizedBox(width: 16),
          //

          AlignedIconButton(
            icon: Icon(Icons.call_received),
            label: Text(AppLocalizations.of(context)!.receive.toSentenceCase()),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
