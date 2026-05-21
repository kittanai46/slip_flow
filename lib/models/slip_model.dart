class Slip {
  final String id;
  final String imagePath;
  final String storeName;
  final double amount;
  final DateTime date;
  final String category;
  final String notes;
  final DateTime createdAt;

  Slip({
    required this.id,
    required this.imagePath,
    required this.storeName,
    required this.amount,
    required this.date,
    required this.category,
    required this.notes,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'storeName': storeName,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Slip.fromJson(Map<String, dynamic> json) {
    return Slip(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      storeName: json['storeName'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Copy with
  Slip copyWith({
    String? id,
    String? imagePath,
    String? storeName,
    double? amount,
    DateTime? date,
    String? category,
    String? notes,
    DateTime? createdAt,
  }) {
    return Slip(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      storeName: storeName ?? this.storeName,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
