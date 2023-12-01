class OnboardingSlide {
  late String title;
  late String desc;
  late String image;

  OnboardingSlide({
    required this.title,
    required this.desc,
    required this.image,
  });
}

List<OnboardingSlide> onboardingSlides = [
  OnboardingSlide(
    image: "https://i.imgur.com/fouEGXf.png",
    title: "Discover Great Deals",
    desc: "Explore exclusive vouchers from your favorite brands",
  ),
  OnboardingSlide(
    image: "https://i.imgur.com/RN448hD.png",
    title: "Exchange Vouchers",
    desc: "Swap your unused vouchers for what you really want",
  ),
  OnboardingSlide(
    image: "https://i.imgur.com/hx7Yk79.png",
    title: "Easy Redemption",
    desc: "Redeem vouchers hassle-free using your smartphone",
  ),
];
