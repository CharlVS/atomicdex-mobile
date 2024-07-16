//TODO? Belongs in SDK?
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

class AssetBalance<T extends ValueMixin> {
  const AssetBalance({
    required this.converted,
    required this.primary,
  });

  final T converted;

  final T primary;
}
