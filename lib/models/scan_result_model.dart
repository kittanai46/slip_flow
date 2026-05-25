class ScannedTextBlock {
  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;

  ScannedTextBlock({
    required this.text,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom,
    };
  }

  factory ScannedTextBlock.fromJson(Map<String, dynamic> json) {
    return ScannedTextBlock(
      text: json['text'] as String,
      left: (json['left'] as num).toDouble(),
      top: (json['top'] as num).toDouble(),
      right: (json['right'] as num).toDouble(),
      bottom: (json['bottom'] as num).toDouble(),
    );
  }
}

class ScanResult {
  final String? storeName;
  final double? amount;
  final DateTime? date;
  final String? transactionId;
  final String rawText;
  final bool isSuccessful;
  final List<ScannedTextBlock> textBlocks;

  ScanResult({
    this.storeName,
    this.amount,
    this.date,
    this.transactionId,
    required this.rawText,
    required this.isSuccessful,
    this.textBlocks = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'amount': amount,
      'date': date?.toIso8601String(),
      'transactionId': transactionId,
      'rawText': rawText,
      'isSuccessful': isSuccessful,
      'textBlocks': textBlocks.map((b) => b.toJson()).toList(),
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    final blocksJson = json['textBlocks'] as List<dynamic>?;
    final blocks = blocksJson != null
        ? List<ScannedTextBlock>.from(
            blocksJson.map((b) => ScannedTextBlock.fromJson(b as Map<String, dynamic>)))
        : <ScannedTextBlock>[];

    return ScanResult(
      storeName: json['storeName'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      transactionId: json['transactionId'] as String?,
      rawText: json['rawText'] as String,
      isSuccessful: json['isSuccessful'] as bool,
      textBlocks: blocks,
    );
  }
}
