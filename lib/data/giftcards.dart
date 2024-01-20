class Card {
  final String bgImage;
  final String status;
  final String logo;
  final int unit;
  final String code;
  final String type;
  final String? event;
  final String cardType;

  Card({
    required this.unit,
    required this.bgImage,
    required this.code,
    this.event,
    required this.logo,
    required this.status,
    required this.type,
    required this.cardType,
  });
}

List<Card> tempMyCards = [
  Card(
    unit: 4,
    bgImage: "assets/images/giftcard_bg.png",
    code: "XDT1IUNo1HN",
    logo: "giftcard_wedding.svg",
    status: "used",
    type: "blue",
    cardType: "voucher",
    event: "Happy marriage",
  ),
  Card(
    unit: 4,
    bgImage: "assets/images/giftcard_bg.png",
    code: "XDT12IUNWpHN",
    logo: "giftcard_birthday.svg",
    status: "used",
    type: "white",
    cardType: "gift card",
  ),
  Card(
    unit: 4,
    bgImage: "assets/images/giftcard_bg.png",
    code: "XDT12IUo1HN",
    logo: "giftcard_wedding.svg",
    status: "used",
    type: "white",
    cardType: "voucher",
  ),
  Card(
    unit: 4,
    bgImage: "assets/images/giftcard_bg.png",
    code: "XDT12IUNHN",
    logo: "giftcard_birthday.svg",
    status: "used",
    type: "blue",
    cardType: "gift card",
  ),
];
