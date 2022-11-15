import 'package:flutter/material.dart';
import 'package:komodo_dex/localizations.dart';
import 'package:komodo_dex/model/coin.dart';
import 'package:komodo_dex/blocs/dialog_bloc.dart';
import 'package:komodo_dex/widgets/custom_simple_dialog.dart';

Future<void> showSuspendedDilog(BuildContext context,
    {@required Coin coin}) async {
  dialogBloc.dialog = showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return CustomSimpleDialog(
          title: Text(AppLocalizations.of(context).isUnavailable(coin.abbr)),
          children: [
            Text(AppLocalizations.of(context).weFailedToActivate(coin.abbr)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).close),
              ),
            ])
          ],
        );
      }).then((dynamic _) {
    dialogBloc.dialog = null;
  });
}