import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage("assets/img/slider_vidrio_1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage("assets/img/slider_vidrio_2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage("assets/img/slider_vidrio_3.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
          options: CarouselOptions(
            autoPlay: true,
            height: 120,
            scrollDirection: Axis.horizontal,
            autoPlayAnimationDuration: const Duration(seconds: 2),
          ),
        ),
      ],
    );
  }
}
