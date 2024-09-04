class SkuProductCheckOut {
  final String id;
  final int quantity;

  SkuProductCheckOut({required this.id, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'id': id, 'quantity': quantity};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
}
