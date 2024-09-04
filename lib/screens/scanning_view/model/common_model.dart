import 'package:express/screens/scanning_view/model/products_model.dart';
import 'package:express/utils/global_constant.dart';

class CommonProductModel {
  String? id;
  String? sku;
  String? skuId;
  String? skuImage;
  String? skuImageChange;
  int? skuQty;
  double? price;
  double? unitPrice;
  int? quantity;
  String? barcodeIds;
  String? skuName;
  double? amount;
  String? costName;
  String? texName;
  ProductType productType;

  CommonProductModel({
    this.id,
    this.skuId,
    this.barcodeIds,
    this.price,
    this.unitPrice,
    this.quantity,
    this.skuQty,
    this.skuImage,
    this.sku,
    this.skuImageChange,
    this.skuName,
    this.amount,
    this.costName,
    this.texName,
    required this.productType,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "skuId": skuId,
      "barcodeIds": barcodeIds,
      "price": price,
      "unitPrice": unitPrice,
      "quantity": quantity,
      "skuQty": skuQty,
      "skuImage": skuImage,
      "sku": sku,
      "skuImageChange": skuImageChange,
      "skuName": skuName,
      "texName" : texName,
      "costName" : costName,
      "amount" : amount,
      "productType" : productType.name,
    };
  }
}
