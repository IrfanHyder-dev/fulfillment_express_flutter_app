import 'dart:convert';

BarcodeModel barcodeModelFromJson(String str) => BarcodeModel.fromJson(json.decode(str));

String barcodeModelToJson(BarcodeModel data) => json.encode(data.toJson());

class BarcodeModel {
  String? barcodeFor;
  String? id;
  String? code;
  List<dynamic>? itemIds;
  dynamic locationId;
  List<dynamic>? orderIds;
  bool? scanned;
  dynamic stealthCode;
  dynamic userId;

  BarcodeModel({
    this.barcodeFor,
    this.id,
    this.code,
    this.itemIds,
    this.locationId,
    this.orderIds,
    this.scanned,
    this.stealthCode,
    this.userId,
  });

  factory BarcodeModel.fromJson(Map<String, dynamic> json) => BarcodeModel(
    barcodeFor: json["BarcodeFor"],
    id: json["_id"],
    code: json["code"],
    itemIds: json["item_ids"] == null ? [] : List<dynamic>.from(json["item_ids"]!.map((x) => x)),
    locationId: json["location_id"],
    orderIds: json["order_ids"] == null ? [] : List<dynamic>.from(json["order_ids"]!.map((x) => x)),
    scanned: json["scanned"],
    stealthCode: json["stealth_code"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "BarcodeFor": barcodeFor,
    "_id": id,
    "code": code,
    "item_ids": itemIds == null ? [] : List<dynamic>.from(itemIds!.map((x) => x)),
    "location_id": locationId,
    "order_ids": orderIds == null ? [] : List<dynamic>.from(orderIds!.map((x) => x)),
    "scanned": scanned,
    "stealth_code": stealthCode,
    "user_id": userId,
  };
}
