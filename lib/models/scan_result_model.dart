class ScanResult {
  final String? storeName;
  final double? amount;
  final DateTime? date;
  final String? transactionId;
  final String rawText;
  final bool isSuccessful;

  ScanResult({
    this.storeName,
    this.amount,
    this.date,
    this.transactionId,
    required this.rawText,
    required this.isSuccessful,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'amount': amount,
      'date': date?.toIso8601String(),
      'transactionId': transactionId,
      'rawText': rawText,
      'isSuccessful': isSuccessful,
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      storeName: json['storeName'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      transactionId: json['transactionId'] as String?,
      rawText: json['rawText'] as String,
      isSuccessful: json['isSuccessful'] as bool,
    );
  }
}
