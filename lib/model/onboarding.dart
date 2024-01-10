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
    title: "Discover Great Ways",
    desc: "To share love with friends, family and loved once",
  ),
  OnboardingSlide(
    image: "assets/images/slid2.png",
    title: "A Gift Of Vouchers",
    desc: "Will always put smiles in a friends face",
  ),
  OnboardingSlide(
    image: "assets/images/slid3.png",
    title: "It's Just A Click",
    desc: "Redeem vouchers hassle-free using your smartphone",
  ),
];
