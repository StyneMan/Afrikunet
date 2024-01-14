class GiftCard {
  final String bgImage;
  final String status;
  final String logo;
  final int unit;
  final String code;
  final String type;
  final String? event;

  GiftCard({
    required this.unit,
    required this.bgImage,
    required this.code,
    this.event,
    required this.logo,
    required this.status,
    required this.type,
  });
}

List<GiftCard> tempGiftCards = [
  GiftCard(
      unit: 4,
      bgImage: "assets/images/giftcard_bg.png",
      code: "XDT12IUNWpo1HN",
      logo: "giftcard_wedding.svg",
      status: "used",
      type: "blue",
      event: "Happy marriage"),
  GiftCard(
    unit: 4,
    bgImage: "assets/images/giftcard_bg.png",
    code: "XDT12IUNWpo1HN",
    logo: "giftcard_birthday.svg",
    status: "used",
    type: "white",
  ),
  GiftCard(
    unit: 4,
    bgImage: "assets/images/giftcard_bg.png",
    code: "XDT12IUNWpo1HN",
    logo: "giftcard_wedding.svg",
    status: "used",
    type: "white",
  ),
  GiftCard(
    unit: 4,
    bgImage: "assets/images/giftcard_bg.png",
    code: "XDT12IUNWpo1HN",
    logo: "giftcard_birthday.svg",
    status: "used",
    type: "blue",
  ),
];
