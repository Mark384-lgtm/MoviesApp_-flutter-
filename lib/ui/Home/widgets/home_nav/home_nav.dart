import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/ui/Home/widgets/home_nav/widgets/CategoryWidget.dart';
import 'package:movies/ui/Home/widgets/home_nav/widgets/MovieItem.dart';


import '../../../../core/remote/network/ApiManger.dart';
import '../../../../core/resources/AssetsManager.dart';
import '../../../../core/resources/ColorManager.dart';
import '../../../../core/resources/StringManger.dart';
import '../../../../data/model/MoviesDetailsResponse/Movie.dart';

class home_nav extends StatefulWidget {
  @override
  State<home_nav> createState() => _home_navState();
}

class _home_navState extends State<home_nav> {
  late PageController _pageController;
  late PageController _bgpageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(viewportFraction: 0.6);
    _bgpageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiManger.getListMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        List<Movie>? movies_list = snapshot.data;
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 645,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemBuilder: (context, index) {
                          return Image.network(
                            height: double.infinity,
                            movies_list[index].backgroundImageOriginal!,
                            fit: BoxFit.fitHeight,
                          );
                        },
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: movies_list!.length,
                        controller: _bgpageController,
                        scrollDirection: Axis.horizontal,
                      ),
                      Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorManager.screen_background.withOpacity(0.2),
                              ColorManager.screen_background.withOpacity(0.4),
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
                          Center(
                            child: Image.asset(AssetsManager.Avilable_now),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 351,
                            child: PageView.builder(
                              onPageChanged: (value) {
                                _bgpageController.animateToPage(
                                  value,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: movies_list!.length,
                              itemBuilder: (context, index) {
                                return AnimatedBuilder(
                                  animation: _pageController,
                                  builder: (context, child) {
                                    double value = 1.0;

                                    if (_pageController
                                        .position
                                        .haveDimensions) {
                                      value = (_pageController.page! - index)
                                          .abs();
                                      value = 1 - (value * 0.3).clamp(0.0, 0.3);
                                    }

                                    return Center(
                                      child: Transform.scale(
                                        scale: value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: MovieItem(
                                    movie: movies_list[index],
                                  ),
                                );
                              },
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
                Categorywidget(category: StringsManager.action),
                SizedBox(height: 16,),
                Categorywidget(category: StringsManager.comedy),
                SizedBox(height: 16,),
                Categorywidget(category: StringsManager.crime),
                SizedBox(height: 16,),
                Categorywidget(category: StringsManager.history),
                SizedBox(height: 16,),
                Categorywidget(category: StringsManager.horror),
                SizedBox(height: 16,),
                Categorywidget(category: StringsManager.romance),
                SizedBox(height: 16,),
                Categorywidget(category: StringsManager.drama),
                SizedBox(height: 16,),
              ],
            ),
          ),
        );
      },
    );

  }
}
