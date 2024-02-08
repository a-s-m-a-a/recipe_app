import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/viewModel/ads_provider.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({super.key});

  @override
  State<AdsWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  @override
  void initState() {
    Provider.of<AdsProvider>(context, listen: false).getAds();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<AdsProvider>(context, listen: false).disposeCarousel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
        builder: (context, adsProvider, _) => adsProvider.adsList == null
            ? const CircularProgressIndicator()
            : (adsProvider.adsList?.isEmpty) ?? false
                ? const Text("No data Found")
                : Column(
                    children: [
                      CarouselSlider(
                        carouselController: adsProvider.carouselController,
                        options: CarouselOptions(
                            autoPlay: true,
                            height: 100.0,
                            viewportFraction: .75,
                            enlargeCenterPage: true,
                            enlargeFactor: .3,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, _) {
                              adsProvider.onPageChanged(index);
                            }),
                        items: adsProvider.adsList!.map((ad) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(ad.image!),
                                fit: BoxFit.fitWidth,
                              )),
                              child: Text(
                                ad.title.toString(),
                                style: const TextStyle(fontSize: 16.0),
                              ));
                        }).toList(),
                      ),
                      // Positioned.fill(
                      //   child: Row(
                      //     children: [
                      //       IconButton(
                      //           onPressed: () => adsProvider.onPressArrowLift(),
                      //           icon: const Icon(Icons.arrow_back)),
                      //       const Spacer(),
                      //       IconButton(
                      //         onPressed: () => adsProvider.onPressArrowRight(),
                      //         icon: const Icon(Icons.arrow_forward),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      DotsIndicator(
                        dotsCount: adsProvider.adsList!.length,
                        position: adsProvider.sliderIndex,
                        onTap: (position) => adsProvider.onDotTapped(position),
                        decorator: DotsDecorator(
                          size: const Size.square(9.0),
                          activeSize: const Size(18.0, 9.0),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ],
                  ));
  }
}
