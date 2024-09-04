import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  int? success;
  String? message;
  Data? data;

  OrderModel({
    this.success,
    this.message,
    this.data,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Order? order;

  Data({
    this.order,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    order: json["order"] == null ? null : Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "order": order?.toJson(),
  };
}

class Order {
  String? id;
  String? userId;
  List<String>? itemIds;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? orderNo;
  List<Item>? items;

  Order({
    this.id,
    this.userId,
    this.itemIds,
    this.updatedAt,
    this.createdAt,
    this.orderNo,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["_id"],
    userId: json["user_id"],
    itemIds: json["item_ids"] == null ? [] : List<String>.from(json["item_ids"]!.map((x) => x)),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    orderNo: json["order_no"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "item_ids": itemIds == null ? [] : List<dynamic>.from(itemIds!.map((x) => x)),
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "order_no": orderNo,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  bool? isFav;
  String? itemQty;
  String? itemStatus;
  String? itemStatusTime;
  String? locationFirst;
  dynamic locationLast;
  String? macroValue;
  String? id;
  List<String>? barcodeIds;
  dynamic codeAddedTime;
  String? createdBy;
  String? createdDate;
  List<dynamic>? favouriteUsers;
  dynamic latitude;
  dynamic locationId;
  dynamic longitude;
  dynamic macroDef;
  List<dynamic>? notInRangeBarcodeIds;
  List<String>? shopOrderIds;
  String? skuId;
  String? vendorId;
  bool? verified;
  dynamic verifyTime;

  Item({
    this.isFav,
    this.itemQty,
    this.itemStatus,
    this.itemStatusTime,
    this.locationFirst,
    this.locationLast,
    this.macroValue,
    this.id,
    this.barcodeIds,
    this.codeAddedTime,
    this.createdBy,
    this.createdDate,
    this.favouriteUsers,
    this.latitude,
    this.locationId,
    this.longitude,
    this.macroDef,
    this.notInRangeBarcodeIds,
    this.shopOrderIds,
    this.skuId,
    this.vendorId,
    this.verified,
    this.verifyTime,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    isFav: json["IsFav"],
    itemQty: json["ItemQty"],
    itemStatus: json["ItemStatus"],
    itemStatusTime: json["ItemStatusTime"],
    locationFirst: json["LocationFirst"],
    locationLast: json["LocationLast"],
    macroValue: json["MacroValue"],
    id: json["_id"],
    barcodeIds: json["barcode_ids"] == null ? [] : List<String>.from(json["barcode_ids"]!.map((x) => x)),
    codeAddedTime: json["code_added_time"],
    createdBy: json["created_by"],
    createdDate: json["created_date"],
    favouriteUsers: json["favourite_users"] == null ? [] : List<dynamic>.from(json["favourite_users"]!.map((x) => x)),
    latitude: json["latitude"],
    locationId: json["location_id"],
    longitude: json["longitude"],
    macroDef: json["macro_def"],
    notInRangeBarcodeIds: json["not_in_range_barcode_ids"] == null ? [] : List<dynamic>.from(json["not_in_range_barcode_ids"]!.map((x) => x)),
    shopOrderIds: json["shop_order_ids"] == null ? [] : List<String>.from(json["shop_order_ids"]!.map((x) => x)),
    skuId: json["sku_id"],
    vendorId: json["vendor_id"],
    verified: json["verified"],
    verifyTime: json["verify_time"],
  );

  Map<String, dynamic> toJson() => {
    "IsFav": isFav,
    "ItemQty": itemQty,
    "ItemStatus": itemStatus,
    "ItemStatusTime": itemStatusTime,
    "LocationFirst": locationFirst,
    "LocationLast": locationLast,
    "MacroValue": macroValue,
    "_id": id,
    "barcode_ids": barcodeIds == null ? [] : List<dynamic>.from(barcodeIds!.map((x) => x)),
    "code_added_time": codeAddedTime,
    "created_by": createdBy,
    "created_date": createdDate,
    "favourite_users": favouriteUsers == null ? [] : List<dynamic>.from(favouriteUsers!.map((x) => x)),
    "latitude": latitude,
    "location_id": locationId,
    "longitude": longitude,
    "macro_def": macroDef,
    "not_in_range_barcode_ids": notInRangeBarcodeIds == null ? [] : List<dynamic>.from(notInRangeBarcodeIds!.map((x) => x)),
    "shop_order_ids": shopOrderIds == null ? [] : List<dynamic>.from(shopOrderIds!.map((x) => x)),
    "sku_id": skuId,
    "vendor_id": vendorId,
    "verified": verified,
    "verify_time": verifyTime,
  };
}
