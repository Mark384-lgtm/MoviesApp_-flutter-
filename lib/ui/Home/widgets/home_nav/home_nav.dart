import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/resources/AssetsManager.dart';
import 'package:movies_app/core/resources/ColorManager.dart';
import 'package:movies_app/ui/Home/widgets/home_nav/widgets/MovieItem.dart';

class home_nav extends StatefulWidget {
  @override
  State<home_nav> createState() => _home_navState();
}

class _home_navState extends State<home_nav> {
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(viewportFraction: 0.7);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 645,
              child: Stack(
                children: [
                  Image.asset(AssetsManager.filmPoster, fit: BoxFit.cover),
                  Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.screen_background.withOpacity(0.6),
                          ColorManager.screen_background.withOpacity(0.8),
                          ColorManager.screen_background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Center(child: Image.asset(AssetsManager.Avilable_now)),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 351,
                        child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return MovieItem(imgPath: AssetsManager.filmImg);
                          },
                          itemCount: 10,
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Image.asset(
                          AssetsManager.watch_now,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "see more ->",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(width: 16);
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return MovieItem(imgPath: AssetsManager.filmImg);
                },
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
