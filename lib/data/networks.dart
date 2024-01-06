class Network {
  int id;
  String name;
  String icon;
  List<NetworkProduct>? products;

  Network({
    required this.id,
    required this.name,
    required this.icon,
    this.products,
  });
}

class NetworkProduct {
  String name;
  double? amount;
  double? discountAmount;
  String discountPercent;
  String description;

  NetworkProduct({
    required this.amount,
    required this.description,
    required this.discountAmount,
    required this.discountPercent,
    required this.name,
  });
}

List<Network> networksData = [
  Network(
    id: 1,
    name: "MTN",
    icon: "assets/images/mtn.svg",
    products: [
      NetworkProduct(
        amount: 750,
        description: "750 Data",
        discountAmount: 0,
        discountPercent: "0%",
        name: "MTN 500MB - 2 Weeks",
      ),
      NetworkProduct(
        amount: 1200,
        description: "MTN 1GB - 1 Month Data subscription",
        discountAmount: 0,
        discountPercent: "0%",
        name: "MTN 1GB - 1 Month",
      ),
      NetworkProduct(
        amount: 1600,
        description: "MTN 1.5GB - 1 Month Data subscription",
        discountAmount: 0,
        discountPercent: "0%",
        name: "MTN 1.5GB - 1 Month",
      ),
      NetworkProduct(
        amount: 1900,
        description: "MTN 2GB - 1 Month Data subscription",
        discountAmount: 0,
        discountPercent: "0%",
        name: "MTN 2GB - 1 Month",
      ),
    ],
  ),
  Network(
    id: 2,
    name: "Glo",
    icon: "assets/images/glo.svg",
    products: [
      NetworkProduct(
        amount: 1000,
        description: "GLO 1GB - 1 Month Data subscription",
        discountAmount: 0,
        discountPercent: "0%",
        name: "GLO 1GB - 1 Month",
      ),
      NetworkProduct(
        amount: 1500,
        description: "GLO 2GB - 1 Month Data subscription",
        discountAmount: 0,
        discountPercent: "0%",
        name: "GLO 2GB - 1 Month",
      ),
      NetworkProduct(
        amount: 2000,
        description: "GLO 3GB - 1 Month Data subscription",
        discountAmount: 0,
        discountPercent: "0%",
        name: "GLO 3GB - 1 Month",
      ),
    ],
  ),
  Network(
    id: 3,
    name: "Airtel",
    icon: "assets/images/airtel.svg",
    products: [
      NetworkProduct(
        amount: 1000,
        description: "1000 1GB Airtel Data. The smartphone network",
        discountAmount: 0,
        discountPercent: "0%",
        name: "Airtel 1GB",
      ),
      NetworkProduct(
        amount: 1500,
        description: "1500 1.8GB Airtel Data. The smartphone network",
        discountAmount: 0,
        discountPercent: "0%",
        name: "Airtel 1.8GB",
      ),
    ],
  ),
  Network(
    id: 4,
    name: "9Mobile",
    icon: "assets/images/9mobile.svg",
    products: [
      NetworkProduct(
        amount: 1000,
        description: "1000 1GB 9mobile Data.",
        discountAmount: 0,
        discountPercent: "0%",
        name: "9mobile 1GB",
      ),
      NetworkProduct(
        amount: 1500,
        description: "1500 1.8GB 9mobile Data.",
        discountAmount: 0,
        discountPercent: "0%",
        name: "9mobile 1.8GB",
      ),
      NetworkProduct(
        amount: 2000,
        description: "2000 2.5GB 9mobile Data.",
        discountAmount: 0,
        discountPercent: "0%",
        name: "9mobile 2.5GB - 1 month",
      ),
    ],
  ),
];

List<Network> networksAirtime = [
  Network(
    id: 1,
    name: "MTN",
    icon: "mtn.png",
  ),
  Network(
    id: 2,
    name: "Glo",
    icon: "glo.png",
  ),
  Network(
    id: 3,
    name: "Airtel",
    icon: "airtel.png",
  ),
  Network(
    id: 4,
    name: "9Mobile",
    icon: "9mobile.png",
  ),
];
