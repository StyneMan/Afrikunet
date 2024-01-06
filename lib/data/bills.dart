class Bills {
  String icon;
  String title;
  List<BillNetwork>? networks;

  Bills({
    required this.icon,
    required this.title,
    this.networks,
  });
}

class BillNetwork {
  String logo;
  String name;
  List<NetworkPackages>? packages;

  BillNetwork({
    required this.logo,
    required this.name,
    this.packages,
  });
}

class NetworkPackages {
  double amount;
  String name;
  String description;

  NetworkPackages({
    required this.amount,
    required this.name,
    required this.description,
  });
}

List<Bills> tempBills = [
  Bills(
    icon: "cable_tv.svg",
    title: "Cable TV",
    networks: [
      BillNetwork(
        logo: "gotv.svg",
        name: "GoTv",
        packages: [
          NetworkPackages(
            amount: 3450,
            name: "Gotv smallie",
            description: "Gotv smallie for NGN 3450",
          ),
          NetworkPackages(
            amount: 3950,
            name: "Gotv Jinja Bouquet",
            description: "Gotv smallie for NGN 3950",
          ),
          NetworkPackages(
            amount: 5700,
            name: "Gotv max",
            description: "Gotv max for NGN 5700",
          ),
          NetworkPackages(
            amount: 7600,
            name: "Gotv supa",
            description: "Gotv supa for NGN 7600",
          ),
          NetworkPackages(
            amount: 12500,
            name: "Gotv supa plus",
            description: "Gotv supa plus for NGN 12500",
          ),
        ],
      ),
      BillNetwork(
        logo: "dstv.svg",
        name: "DSTV",
        packages: [
          NetworkPackages(
            amount: 3450,
            name: "Gotv smallie",
            description: "Gotv smallie for NGN 3450",
          ),
          NetworkPackages(
            amount: 3450,
            name: "Gotv smallie",
            description: "Gotv smallie for NGN 3450",
          ),
        ],
      ),
    ],
  ),
  Bills(
    icon: "electricity.svg",
    title: "Electricity Bill",
    networks: [
      BillNetwork(logo: "aedc.png", name: "AEDC (Abuja Electiricty)"),
      BillNetwork(logo: "ikedc.png", name: "IKEDC (Ikeja Electricity)"),
      BillNetwork(logo: "phed.png", name: "PHED (Port Harcourt Electricity)"),
      BillNetwork(logo: "kedco.png", name: "KEDCO (Kaduna Electricity)"),
    ],
  ),
  Bills(icon: "water.svg", title: "Water Bill"),
];
