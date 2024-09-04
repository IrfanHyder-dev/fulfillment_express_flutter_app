const double hMargin = 15;
const double vMargin = 15;
const vatPercent = 15;
bool backgroundApp = false;

final String baseUrl="https://staging.fulfillment.vip/";
final String socketUrl="wss://staging.fulfillment.vip/cable";
// final String socketUrl = "wss://fulfillment.vip/cable";
// final String baseUrl = "https://fulfillment.vip/";

List<int> successCodes = [200, 201, 202, 204];

enum ProductType {
  looseSkuProduct,
  additionalCost,
  barcodeProduct,
}

bool isGoogleLogin = false;
