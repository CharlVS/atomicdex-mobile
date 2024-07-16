import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/accounts/models/account.dart';
import 'package:komodo_dex/screens/portfolio/activate/select_coins_page.dart';
import 'package:komodo_dex/utils/utils.dart';

class HomeAccountRow extends StatelessWidget {
  const HomeAccountRow({required this.account, super.key});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            key: const ValueKey('portfolio-account-switcher-avatar'),
            radius: 16,
            foregroundImage: account.avatarImageProvider,
            backgroundColor: account.themeColor,
            child:
                account.avatar == null ? null : Text(account.name.initials(2)),
          ),
          const SizedBox(width: 8),
          Text(
            account.name,
            key: const ValueKey('portfolio-account-switcher-account-id'),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Spacer(),
          SizedBox.square(
            dimension: 32,
            child: IconButton.filled(
              iconSize: 20,
              padding: EdgeInsets.zero,
              onPressed: () => _goToCoinActivationScreen(context),
              icon: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

  void _goToCoinActivationScreen(BuildContext context) {
    // Show SelectCoinsPage() in a bottom sheet
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => SelectCoinsPage(),
      ),
    );
  }
}
