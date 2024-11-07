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
    image: "assets/images/slid1.png",
    title: "Discover Great Deals",
    desc: "Explore the use voucher for l store discount, coupons, gift & share",
  ),
  OnboardingSlide(
    image: "assets/images/slid2.png",
    title: "Utility",
    desc: "International Airtime & Data, Cable Tv subscription",
  ),
  OnboardingSlide(
    image: "assets/images/slid3.png",
    title: "Bill Payments",
    desc:
        "A high value Event Ticketing engine await you for your music concert, professional meetings and more",
  ),
];
