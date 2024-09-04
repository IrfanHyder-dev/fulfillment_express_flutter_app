import 'dart:convert';

ProductsModel productsModelFromJson(String str) =>
    ProductsModel.fromJson(json.decode(str));

String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
  int success;
  String message;
  Data? data;

  ProductsModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        success: json["success"] ?? 0,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Item item;

  Data({
    required this.item,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        item: Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "item": item.toJson(),
      };
}

class Item {
  String id;
  List<dynamic> favouriteUsers;
  bool isFav;
  String macroValue;
  String itemStatus;
  String locationId;
  String vendorId;
  String skuId;
  List<String> barcodeIds;
  DateTime createdDate;
  String itemStatusTime;
  String locationFirst;
  bool verified;
  dynamic locationLast;
  String createdBy;
  String itemQty;
  double price;
  String barcode;
  ItemSku itemSku;

  Item({
    required this.id,
    required this.favouriteUsers,
    required this.isFav,
    required this.macroValue,
    required this.itemStatus,
    required this.locationId,
    required this.vendorId,
    required this.skuId,
    required this.barcodeIds,
    required this.createdDate,
    required this.itemStatusTime,
    required this.locationFirst,
    required this.verified,
    required this.locationLast,
    required this.createdBy,
    required this.itemQty,
    required this.price,
    required this.barcode,
    required this.itemSku,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"] ?? "",
        favouriteUsers:
            List<dynamic>.from(json["favourite_users"].map((x) => x)),
        isFav: json["IsFav"] ?? false,
        macroValue: json["MacroValue"] ?? "",
        itemStatus: json["ItemStatus"] ?? "",
        locationId: json["location_id"] ?? "",
        vendorId: json["vendor_id"] ?? "",
        skuId: json["sku_id"] ?? "",
        barcodeIds: List<String>.from(json["barcode_ids"].map((x) => x)),
        createdDate: DateTime.parse(json["created_date"]),
        itemStatusTime: json["ItemStatusTime"] ?? "",
        locationFirst: json["LocationFirst"] ?? "",
        verified: json["verified"] ?? false,
        locationLast: json["LocationLast"],
        createdBy: json["created_by"] ?? "",
        itemQty: json["ItemQty"] ?? "",
        barcode: json["barcode"] ?? "",
        price: double.parse(json["price"].toString()) ?? 0.0,
        itemSku: ItemSku.fromJson(json["item_sku"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "favourite_users": List<dynamic>.from(favouriteUsers.map((x) => x)),
        "IsFav": isFav,
        "MacroValue": macroValue,
        "ItemStatus": itemStatus,
        "location_id": locationId,
        "vendor_id": vendorId,
        "sku_id": skuId,
        "barcode_ids": List<dynamic>.from(barcodeIds.map((x) => x)),
        "created_date": createdDate.toIso8601String(),
        "ItemStatusTime": itemStatusTime,
        "LocationFirst": locationFirst,
        "verified": verified,
        "LocationLast": locationLast,
        "created_by": createdBy,
        "ItemQty": itemQty,
        "price": price,
        "barcode": barcode,
        "item_sku": itemSku.toJson(),
      };
}

class ItemSku {
  bool boxed;
  dynamic macroDefinition;
  String sku;
  String skuImage;
  String skuImageChange;
  dynamic skuImageChangeContentType;
  dynamic skuImageChangeFileName;
  dynamic skuImageChangeFileSize;
  dynamic skuImageChangeFingerprint;
  dynamic skuImageChangeUpdatedAt;
  String skuLastSync;
  dynamic skuLoose;
  String skuName;
  dynamic skuQty;
  dynamic skuSubstitute;
  String skuType;
  String skuZeroInfo;
  Size? size;
  String vendorId;
  String weight;
  String id;
  List<String> keywords;
  String comment;
  dynamic pdfDocumentContentType;
  dynamic pdfDocumentFileName;
  dynamic pdfDocumentFileSize;
  dynamic pdfDocumentFingerprint;
  dynamic pdfDocumentUpdatedAt;
  bool synced;
  String itemSkuVendorId;

  ItemSku({
    required this.boxed,
    required this.macroDefinition,
    required this.sku,
    required this.skuImage,
    required this.skuImageChange,
    required this.skuImageChangeContentType,
    required this.skuImageChangeFileName,
    required this.skuImageChangeFileSize,
    required this.skuImageChangeFingerprint,
    required this.skuImageChangeUpdatedAt,
    required this.skuLastSync,
    required this.skuLoose,
    required this.skuName,
    required this.skuQty,
    required this.skuSubstitute,
    required this.skuType,
    required this.skuZeroInfo,
    required this.size,
    required this.vendorId,
    required this.weight,
    required this.id,
    required this.keywords,
    required this.comment,
    required this.pdfDocumentContentType,
    required this.pdfDocumentFileName,
    required this.pdfDocumentFileSize,
    required this.pdfDocumentFingerprint,
    required this.pdfDocumentUpdatedAt,
    required this.synced,
    required this.itemSkuVendorId,
  });

  factory ItemSku.fromJson(Map<String, dynamic> json) => ItemSku(
        boxed: json["B??" "oxed"] ?? false,
        macroDefinition: json["MacroDefinition"] ?? "",
        sku: json["SKU"] ?? "",
        skuImage: json["SKUImage"] ?? "",
        skuImageChange: json["SKUImageChange"] ?? "",
        skuImageChangeContentType: json["SKUImageChange_content_type"],
        skuImageChangeFileName: json["SKUImageChange_file_name"],
        skuImageChangeFileSize: json["SKUImageChange_file_size"],
        skuImageChangeFingerprint: json["SKUImageChange_fingerprint"],
        skuImageChangeUpdatedAt: json["SKUImageChange_updated_at"],
        skuLastSync: json["SKULastSync"] ?? "",
        skuLoose: json["SKULoose"],
        skuName: json["SKUName"] ?? "",
        skuQty: json["SKUQty"],
        skuSubstitute: json["SKUSubstitute"],
        skuType: json["SKUType"] ?? "",
        skuZeroInfo: json["SKUZeroInfo"] ?? "",
        size: Size.fromJson(json["Size"]),
        vendorId: json["VendorID"] ?? "",
        weight: json["Weight"] ?? "",
        id: json["_id"] ?? "",
        keywords: List<String>.from(json["_keywords"].map((x) => x)),
        comment: json["comment"] ?? "",
        pdfDocumentContentType: json["pdf_document_content_type"],
        pdfDocumentFileName: json["pdf_document_file_name"],
        pdfDocumentFileSize: json["pdf_document_file_size"],
        pdfDocumentFingerprint: json["pdf_document_fingerprint"],
        pdfDocumentUpdatedAt: json["pdf_document_updated_at"],
        synced: json["synced"],
        itemSkuVendorId: json["vendor_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Boxed": boxed,
        "MacroDefinition": macroDefinition,
        "SKU": sku,
        "SKUImage": skuImage,
        "SKUImageChange": skuImageChange,
        "SKUImageChange_content_type": skuImageChangeContentType,
        "SKUImageChange_file_name": skuImageChangeFileName,
        "SKUImageChange_file_size": skuImageChangeFileSize,
        "SKUImageChange_fingerprint": skuImageChangeFingerprint,
        "SKUImageChange_updated_at": skuImageChangeUpdatedAt,
        "SKULastSync": skuLastSync,
        "SKULoose": skuLoose,
        "SKUName": skuName,
        "SKUQty": skuQty,
        "SKUSubstitute": skuSubstitute,
        "SKUType": skuType,
        "SKUZeroInfo": skuZeroInfo,
        "Size": size?.toJson(),
        "VendorID": vendorId,
        "Weight": weight,
        "_id": id,
        "_keywords": List<dynamic>.from(keywords.map((x) => x)),
        "comment": comment,
        "pdf_document_content_type": pdfDocumentContentType,
        "pdf_document_file_name": pdfDocumentFileName,
        "pdf_document_file_size": pdfDocumentFileSize,
        "pdf_document_fingerprint": pdfDocumentFingerprint,
        "pdf_document_updated_at": pdfDocumentUpdatedAt,
        "synced": synced,
        "vendor_id": itemSkuVendorId,
      };
}

class Size {
  Size();

  factory Size.fromJson(Map<String, dynamic> json) => Size();

  Map<String, dynamic> toJson() => {};
}
