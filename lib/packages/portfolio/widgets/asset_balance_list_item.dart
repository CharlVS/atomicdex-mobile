import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance.dart';

//TODO: Add balance management to SDK
class AssetBalanceListItem extends StatelessWidget {
  const AssetBalanceListItem({required this.balance, super.key});

  final AssetBalance balance;

  // bool get _isCrypto => balance.converted is Crypto;
  bool get _isCrypto => true;

  @override
  Widget build(BuildContext context) {
    // final hasIcon = balance.converted
    return Placeholder(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Text('AssetBalanceListItem widget placeholder'),
        ),
      ),
    );
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: balance.converted.symbol.hasIcon
            ? Image(
                image: balance.converted.symbol.icon!.getImageProvider(),
              )
            : null,
      ),
      title: Text(balance.converted.symbol.longFormat),
      subtitle: Text(balance.primary.format()),
      trailing: Text(
        balance.converted.format(),
        style: TextStyle(
          color: _isCrypto ? Colors.green : Colors.black,
        ),
      ),
    );
  }
}
