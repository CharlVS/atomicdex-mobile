// To parse this JSON data, do
//
//     final recentSwaps = recentSwapsFromJson(jsonString);

import 'package:komodo_dex/model/transaction_data.dart';

class RecentSwaps {
  RecentSwaps({
    this.result,
  });

  factory RecentSwaps.fromJson(Map<String, dynamic> json) => RecentSwaps(
        result: Result.fromJson(json['result']) ?? Result(),
      );

  Result result;

  Map<String, dynamic> get toJson => <String, dynamic>{
        'result': result.toJson ?? Result().toJson,
      };
}

class Result {
  Result({
    this.fromUuid,
    this.limit,
    this.skipped,
    this.swaps,
    this.total,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        fromUuid: json['from_uuid'],
        limit: json['limit'] ?? 0,
        skipped: json['skipped'] ?? 0,
        swaps: json['swaps'] == null
            ? null
            : List<MmSwap>.from(
                json['swaps'].map((dynamic x) => MmSwap.fromJson(x))),
        total: json['total'] ?? 0,
      );

  String fromUuid;
  int limit;
  int skipped;
  List<MmSwap> swaps;
  int total;

  Map<String, dynamic> get toJson => <String, dynamic>{
        'from_uuid': fromUuid,
        'limit': limit ?? 0,
        'skipped': skipped ?? 0,
        'swaps': swaps == null
            ? null
            : List<dynamic>.from(swaps.map<dynamic>((MmSwap x) => x.toJson)),
        'total': total ?? 0,
      };
}

/// MM swap data,
/// https://developers.atomicdex.io/basic-docs/atomicdex/atomicdex-api.html#my-swap-status
class MmSwap {
  MmSwap(
      {this.errorEvents,
      this.events,
      this.myInfo,
      this.successEvents,
      this.type,
      this.uuid,
      this.recoverable,
      this.gui,
      this.mmMersion});

  factory MmSwap.fromJson(Map<String, dynamic> json) => MmSwap(
      errorEvents: List<String>.from(
              json['error_events'].map<dynamic>((dynamic x) => x)) ??
          <String>[],
      events: List<SwapEL>.from(
              json['events'].map((dynamic x) => SwapEL.fromJson(x))) ??
          <SwapEL>[],
      myInfo:
          json['my_info'] == null ? null : SwapMyInfo.fromJson(json['my_info']),
      successEvents: List<String>.from(
              json['success_events'].map<dynamic>((dynamic x) => x)) ??
          <String>[],
      type: json['type'] ?? '',
      uuid: json['uuid'] ?? '',
      recoverable: json['recoverable'] ?? false,
      gui: json['gui'],
      mmMersion: json['mm_version']);

  /// if at least 1 of the events happens, the swap is considered a failure
  List<String> errorEvents;

  /// events that occurred during the swap
  List<SwapEL> events;

  /// this object maps event data to make displaying swap data in a GUI simpler (my_coin, my_amount, etc.)
  SwapMyInfo myInfo;

  /// the contents are listed in the order in which they should occur in the events array
  List<String> successEvents;

  /// whether the node acted as a market Maker or Taker
  String type;
  String uuid;

  /// whether the swap can be recovered using the recover_funds_of_swap API command.
  /// MM does not record the state regarding whether the swap was recovered or not.
  /// MM allows as many calls to the recover_funds_of_swap method as necessary, in case of errors
  bool recoverable;

  String gui, mmMersion;

  Map<String, dynamic> get toJson => <String, dynamic>{
        'error_events':
            List<dynamic>.from(errorEvents.map<dynamic>((dynamic x) => x)) ??
                <String>[],
        'events': events.map((e) => e.toJson).toList(),
        'my_info': myInfo ?? SwapMyInfo(),
        'success_events':
            List<dynamic>.from(successEvents.map<dynamic>((dynamic x) => x)) ??
                <String>[],
        'type': type ?? '',
        'uuid': uuid ?? '',
        'recoverable': recoverable ?? false,
        'gui': gui,
        'mm_version': mmMersion
      };
}

/// First layer of swap events serialization.
class SwapEL {
  SwapEL({
    this.event,
    this.timestamp,
  });

  factory SwapEL.fromJson(Map<String, dynamic> json) => SwapEL(
        event: SwapEEL.fromJson(json['event']),
        timestamp: json['timestamp'] ?? 0,
      );

  SwapEEL event;
  int timestamp;

  Map<String, dynamic> get toJson => <String, dynamic>{
        'event': event.toJson ?? SwapEEL().toJson,
        'timestamp': timestamp ?? 0,
      };
}

/// Second layer of swap events serialization.
class SwapEEL {
  SwapEEL({
    this.data,
    this.type,
  });

  factory SwapEEL.fromJson(Map<String, dynamic> json) => SwapEEL(
        data: json['data'] == null ? null : SwapEF.fromJson(json['data']),
        type: json['type'] ?? '',
      );

  SwapEF data;
  String type;

  Map<String, dynamic> get toJson => <String, dynamic>{
        'data': data == null ? null : data.toJson(),
        'type': type ?? '',
      };
}

/// Fields of a swap event,
/// https://developers.atomicdex.io/basic-docs/atomicdex/atomicdex-api.html#my-swap-status
class SwapEF {
  SwapEF(
      {this.lockDuration,
      this.makerAmount,
      this.makerCoin,
      this.makerCoinStartBlock,
      this.makerPaymentConfirmations,
      this.makerPaymentRequiresNota,
      this.makerPaymentLock,
      this.myPersistentPub,
      this.secret,
      this.startedAt,
      this.taker,
      this.takerAmount,
      this.takerCoin,
      this.takerCoinStartBlock,
      this.takerPaymentConfirmations,
      this.takerPaymentRequiresNota,
      this.uuid,
      this.takerPaymentLocktime,
      this.takerPubkey,
      this.blockHeight,
      this.coin,
      this.feeDetails,
      this.from,
      this.internalId,
      this.myBalanceChange,
      this.receivedByMe,
      this.spentByMe,
      this.timestamp,
      this.to,
      this.totalAmount,
      this.txHash,
      this.txHex,
      this.maker,
      this.makerPaymentWait,
      this.takerPaymentLock,
      this.makerPaymentLocktime,
      this.makerPubkey,
      this.secretHash,
      this.transaction,
      this.error});

  factory SwapEF.fromJson(Map<String, dynamic> json) => SwapEF(
      lockDuration: json['lock_duration'],
      makerAmount: json['maker_amount'] ?? '',
      makerCoin: json['maker_coin'] ?? '',
      makerCoinStartBlock: json['maker_coin_start_block'] ?? 0,
      makerPaymentConfirmations: json['maker_payment_confirmations'] ?? 0,
      makerPaymentRequiresNota: json['maker_payment_requires_nota'],
      makerPaymentLock: json['maker_payment_lock'] ?? 0,
      myPersistentPub: json['my_persistent_pub'] ?? '',
      secret: json['secret'] ?? '',
      startedAt: json['started_at'] ?? 0,
      taker: json['taker'] ?? '',
      takerAmount: json['taker_amount'] ?? '',
      takerCoin: json['taker_coin'] ?? '',
      takerCoinStartBlock: json['taker_coin_start_block'] ?? 0,
      takerPaymentConfirmations: json['taker_payment_confirmations'] ?? 0,
      takerPaymentRequiresNota: json['taker_payment_requires_nota'],
      uuid: json['uuid'] ?? '',
      takerPaymentLocktime: json['taker_payment_locktime'] ?? 0,
      takerPubkey: json['taker_pubkey'] ?? '',
      blockHeight: json['block_height'] ?? 0,
      coin: json['coin'] ?? '',
      feeDetails: json['fee_details'] == null
          ? null
          : FeeDetails.fromJson(json['fee_details']),
      from: json['from'] == null
          ? null
          : List<String>.from(json['from'].map((dynamic x) => x)),
      internalId: json['internal_id'] ?? '',
      myBalanceChange: json['my_balance_change'] ?? '',
      receivedByMe: json['received_by_me'] ?? '',
      spentByMe: json['spent_by_me'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      to: json['to'] == null
          ? null
          : List<String>.from(json['to'].map((dynamic x) => x)),
      totalAmount: json['total_amount'] ?? '',
      txHash: json['tx_hash'] ?? '',
      txHex: json['tx_hex'] ?? '',
      maker: json['maker'] ?? '',
      makerPaymentWait: json['maker_payment_wait'] ?? 0,
      takerPaymentLock: json['taker_payment_lock'] ?? 0,
      makerPaymentLocktime: json['maker_payment_locktime'] ?? 0,
      makerPubkey: json['maker_pubkey'] ?? '',
      secretHash: json['secret_hash'] ?? '',
      transaction: json['transaction'] == null
          ? null
          : Transaction.fromJson(json['transaction']),
      error: json['error'] ?? '');

  /// the lock duration of swap payments in seconds.
  /// The sender can refund the transaction when the lock duration is passed.
  /// The taker payment is locked for the lock duration.
  /// The maker payment is locked for lock duration * 2
  int lockDuration;
  String makerAmount;
  String makerCoin;
  int makerCoinStartBlock;
  int makerPaymentConfirmations;

  /// whether dPoW notarization is required for maker payment
  bool makerPaymentRequiresNota;
  int makerPaymentLock;
  String myPersistentPub;
  String secret;
  int startedAt;

  /// the p2p ID of taker node
  String taker;
  String takerAmount;
  String takerCoin;
  int takerCoinStartBlock;
  int takerPaymentConfirmations;

  /// whether dPoW notarization is required for taker payment
  bool takerPaymentRequiresNota;
  String uuid;
  int takerPaymentLocktime;
  String takerPubkey;
  int blockHeight;
  String coin;
  FeeDetails feeDetails;
  List<String> from;
  String internalId;
  String myBalanceChange;
  String receivedByMe;
  String spentByMe;
  int timestamp;
  List<String> to;
  String totalAmount;
  String txHash;
  String txHex;

  /// the p2p ID of maker node
  String maker;
  int makerPaymentWait;
  int takerPaymentLock;
  int makerPaymentLocktime;
  String makerPubkey;
  String secretHash;
  Transaction transaction;
  String error;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lock_duration': lockDuration ?? 0,
        'maker_amount': makerAmount ?? '',
        'maker_coin': makerCoin ?? '',
        'maker_coin_start_block': makerCoinStartBlock ?? 0,
        'maker_payment_confirmations': makerPaymentConfirmations ?? 0,
        'maker_payment_requires_nota': makerPaymentRequiresNota,
        'maker_payment_lock': makerPaymentLock ?? 0,
        'my_persistent_pub': myPersistentPub ?? '',
        'secret': secret ?? '',
        'started_at': startedAt ?? 0,
        'taker': taker ?? '',
        'taker_amount': takerAmount ?? '',
        'taker_coin': takerCoin ?? '',
        'taker_coin_start_block': takerCoinStartBlock ?? 0,
        'taker_payment_confirmations': takerPaymentConfirmations ?? 0,
        'taker_payment_requires_nota': takerPaymentRequiresNota,
        'uuid': uuid ?? '',
        'taker_payment_locktime': takerPaymentLocktime ?? 0,
        'taker_pubkey': takerPubkey ?? '',
        'block_height': blockHeight ?? 0,
        'coin': coin ?? '',
        'fee_details': feeDetails == null ? null : feeDetails.toJson(),
        'from': from == null
            ? null
            : List<dynamic>.from(from.map<dynamic>((String x) => x)),
        'internal_id': internalId ?? '',
        'my_balance_change': myBalanceChange ?? '',
        'received_by_me': receivedByMe ?? '',
        'spent_by_me': spentByMe ?? '',
        'timestamp': timestamp ?? 0,
        'to': to == null
            ? null
            : List<dynamic>.from(to.map<dynamic>((String x) => x)),
        'total_amount': totalAmount ?? '',
        'tx_hash': txHash ?? '',
        'tx_hex': txHex ?? '',
        'maker': maker ?? '',
        'maker_payment_wait': makerPaymentWait ?? 0,
        'taker_payment_lock': takerPaymentLock ?? 0,
        'maker_payment_locktime': makerPaymentLocktime ?? 0,
        'maker_pubkey': makerPubkey ?? '',
        'secret_hash': secretHash ?? '',
        'transaction': transaction == null ? null : transaction.toJson(),
        'error': error ?? ''
      };
}

class Transaction {
  Transaction({
    this.blockHeight,
    this.coin,
    this.feeDetails,
    this.from,
    this.internalId,
    this.myBalanceChange,
    this.receivedByMe,
    this.spentByMe,
    this.timestamp,
    this.to,
    this.totalAmount,
    this.txHash,
    this.txHex,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        blockHeight: json['block_height'] ?? 0,
        coin: json['coin'] ?? '',
        feeDetails: json['fee_details'] == null
            ? null
            : FeeDetails.fromJson(json['fee_details']),
        from: List<String>.from(json['from'].map<dynamic>((dynamic x) => x)) ??
            <String>[],
        internalId: json['internal_id'] ?? '',
        myBalanceChange: json['my_balance_change'] ?? '',
        receivedByMe: json['received_by_me'] ?? '',
        spentByMe: json['spent_by_me'] ?? '',
        timestamp: json['timestamp'] ?? 0,
        to: List<String>.from(json['to'].map<dynamic>((dynamic x) => x)) ??
            <String>[],
        totalAmount: json['total_amount'] ?? '',
        txHash: json['tx_hash'] ?? '',
        txHex: json['tx_hex'] ?? '',
      );

  int blockHeight;
  String coin;
  FeeDetails feeDetails;
  List<String> from;
  String internalId;
  String myBalanceChange;
  String receivedByMe;
  String spentByMe;
  int timestamp;
  List<String> to;
  String totalAmount;
  String txHash;
  String txHex;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'block_height': blockHeight ?? 0,
        'coin': coin ?? '',
        'fee_details': feeDetails == null ? null : feeDetails.toJson(),
        'from': List<dynamic>.from(from.map<dynamic>((dynamic x) => x)) ??
            <String>[],
        'internal_id': internalId ?? '',
        'my_balance_change': myBalanceChange ?? '',
        'received_by_me': receivedByMe ?? '',
        'spent_by_me': spentByMe ?? '',
        'timestamp': timestamp ?? 0,
        'to':
            List<dynamic>.from(to.map<dynamic>((dynamic x) => x)) ?? <String>[],
        'total_amount': totalAmount ?? '',
        'tx_hash': txHash ?? '',
        'tx_hex': txHex ?? '',
      };
}

class SwapMyInfo {
  SwapMyInfo({
    this.myAmount,
    this.myCoin,
    this.otherAmount,
    this.otherCoin,
    this.startedAt,
  });

  factory SwapMyInfo.fromJson(Map<String, dynamic> json) => SwapMyInfo(
        myAmount: json['my_amount'] ?? '',
        myCoin: json['my_coin'] ?? '',
        otherAmount: json['other_amount'] ?? '',
        otherCoin: json['other_coin'] ?? '',
        startedAt: json['started_at'] ?? 0,
      );

  String myAmount;
  String myCoin;
  String otherAmount;
  String otherCoin;
  int startedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'my_amount': myAmount ?? '',
        'my_coin': myCoin ?? '',
        'other_amount': otherAmount ?? '',
        'other_coin': otherCoin ?? '',
        'started_at': startedAt ?? 0,
      };
}
