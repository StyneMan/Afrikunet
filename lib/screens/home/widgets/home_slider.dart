import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/model/home/home_slide.dart';
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
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(sliderData.bgImage),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 4.0,
                      right: 4.0,
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 21.0,
                          left: 8.0,
                          bottom: 10.0,
                          right: 8.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: SizedBox(
                          width: 126,
                          child: Expanded(
                            child: TextSmall(
                              text: sliderData.title,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                width: _current == i ? 24 : 10,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _current == i
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
          ],
        )
      ],
    );
  }
}
