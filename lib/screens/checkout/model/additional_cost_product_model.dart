class AdditionalCostProductModel {
  final String costName;
  final String taxName;
  final double amount;

  AdditionalCostProductModel({
    required this.costName,
    required this.taxName,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': costName,
      'charge_type': taxName,
      'amount': amount,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'const_name': costName,
      'tax_name': taxName,
      'amount': amount,
    };
  }
}
