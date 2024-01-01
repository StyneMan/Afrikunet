import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/model/home-slide/home_slide.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({Key? key}) : super(key: key);

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 210,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (int page, _) {
              setState(() {
                _current = page;
              });
              // _selectedSlider.value = page;
            },
          ),
          items: homeSlideList.map((sliderData) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(sliderData.bgImage),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSmall(
                        text: sliderData.title,
                        color: Colors.white,
                      )
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < homeSlideList.length; i++)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      _current == i ? Constants.primaryColor : Colors.black54,
                ),
              ),
          ],
        )
      ],
    );
  }
}
