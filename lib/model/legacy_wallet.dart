import 'dart:convert';

List<LegacyWallet> walletFromJson(String str) => List<LegacyWallet>.from(
    json.decode(str).map((dynamic x) => LegacyWallet.fromJson(x)));

String walletToJson(List<LegacyWallet> data) => json
    .encode(List<dynamic>.from(data.map<dynamic>((dynamic x) => x.toJson())));

class LegacyWallet {
  LegacyWallet({
    required this.name,
    required this.id,
  });

  factory LegacyWallet.fromJson(Map<String, dynamic> json) => LegacyWallet(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
      );

  String? name;
  String? id;
  bool? isFastEncryption;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id ?? '',
        'name': name ?? '',
      };
}
