// To parse this JSON data, do
//
//     final looseSkusProductModel = looseSkusProductModelFromJson(jsonString);

import 'dart:convert';

LooseSkusProductModel looseSkusProductModelFromJson(String str) => LooseSkusProductModel.fromJson(json.decode(str));

String looseSkusProductModelToJson(LooseSkusProductModel data) => json.encode(data.toJson());

class LooseSkusProductModel {
  int? success;
  String? message;
  List<LooseSkus>? looseSkus;

  LooseSkusProductModel({
    this.success,
    this.message,
    this.looseSkus,
  });

  factory LooseSkusProductModel.fromJson(Map<String, dynamic> json) => LooseSkusProductModel(
    success: json["success"],
    message: json["message"],
    looseSkus: json["loose_skus"] == null ? [] : List<LooseSkus>.from(json["loose_skus"]!.map((x) => LooseSkus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "loose_skus": looseSkus == null ? [] : List<dynamic>.from(looseSkus!.map((x) => x.toJson())),
  };
}

class LooseSkus {
  String? id;
  String? looseSkusVendorId;
  String? sku;
  String? skuName;
  String? skuImage;
  String? skuType;
  List<dynamic>? skuSubstitute;
  String? skuLastSync;
  String? skuLoose;
  bool? synced;
  bool? boxed;
  dynamic macroDefinition;
  String? skuImageChange;
  String? skuZeroInfo;
  Size? size;
  String? vendorId;
  String? weight;
  List<String>? keywords;
  String? comment;
  int? skuQty;
  double? price;
  List<String>? shopOrderIds;

  LooseSkus({
    this.id,
    this.looseSkusVendorId,
    this.sku,
    this.skuName,
    this.skuImage,
    this.skuType,
    this.skuSubstitute,
    this.skuLastSync,
    this.skuLoose,
    this.synced,
    this.boxed,
    this.macroDefinition,
    this.skuImageChange,
    this.skuZeroInfo,
    this.size,
    this.vendorId,
    this.weight,
    this.keywords,
    this.comment,
    this.skuQty,
    this.price,
    this.shopOrderIds,
  });

  factory LooseSkus.fromJson(Map<String, dynamic> json) => LooseSkus(
    id: json["_id"],
    looseSkusVendorId: json["vendor_id"],
    sku: json["SKU"],
    skuName: json["SKUName"],
    skuImage: json["SKUImage"],
    skuType: json["SKUType"],
    skuSubstitute: json["SKUSubstitute"] == null ? [] : List<dynamic>.from(json["SKUSubstitute"]!.map((x) => x)),
    skuLastSync: json["SKULastSync"],
    skuLoose: json["SKULoose"],
    synced: json["synced"],
    boxed: json["Boxed"],
    macroDefinition: json["MacroDefinition"],
    skuImageChange: json["SKUImageChange"],
    skuZeroInfo: json["SKUZeroInfo"],
    size: json["Size"] == null ? null : Size.fromJson(json["Size"]),
    vendorId: json["VendorID"],
    weight: json["Weight"],
    keywords: json["_keywords"] == null ? [] : List<String>.from(json["_keywords"]!.map((x) => x)),
    comment: json["comment"],
    skuQty: json["SKUQty"],
    price: json["price"],
    shopOrderIds: json["shop_order_ids"] == null ? [] : List<String>.from(json["shop_order_ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "vendor_id": looseSkusVendorId,
    "SKU": sku,
    "SKUName": skuName,
    "SKUImage": skuImage,
    "SKUType": skuType,
    "SKUSubstitute": skuSubstitute == null ? [] : List<dynamic>.from(skuSubstitute!.map((x) => x)),
    "SKULastSync": skuLastSync,
    "SKULoose": skuLoose,
    "synced": synced,
    "Boxed": boxed,
    "MacroDefinition": macroDefinition,
    "SKUImageChange": skuImageChange,
    "SKUZeroInfo": skuZeroInfo,
    "Size": size?.toJson(),
    "VendorID": vendorId,
    "Weight": weight,
    "_keywords": keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
    "comment": comment,
    "SKUQty": skuQty,
    "price": price,
    "shop_order_ids": shopOrderIds == null ? [] : List<dynamic>.from(shopOrderIds!.map((x) => x)),
  };
}

class Size {
  String? height;
  String? width;
  String? length;

  Size({
    this.height,
    this.width,
    this.length,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
    height: json["height"],
    width: json["width"],
    length: json["length"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "width": width,
    "length": length,
  };
}
