import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:movies/core/resources/StringManger.dart';
import 'package:movies/ui/Home/widgets/browse/widgets/TabViewItem.dart';

import '../../../../core/remote/network/ApiManger.dart';
import '../../../../data/model/MoviesDetailsResponse/Movie.dart';

class browse_nav extends StatefulWidget {
  @override
  State<browse_nav> createState() => _browse_navState();
}

class _browse_navState extends State<browse_nav> {
  String query_term = StringsManager.action;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("query term: ${query_term}");
    return FutureBuilder(
      future: ApiManger.getListMovies(query_term: query_term),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        List<Movie>? movies = snapshot.data;
        return DefaultTabController(
          initialIndex: selectedIndex,
          length: 6,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
              child: Column(
                children: [
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                    onTap: (query) {
                      setState(() {
                        switch (query) {
                          case 0:
                            query_term = StringsManager.action;
                            selectedIndex = 0;
                            break;
                          case 1:
                            query_term = StringsManager.comedy;
                            selectedIndex = 1;
                            break;
                          case 2:
                            query_term = StringsManager.crime;
                            selectedIndex = 2;
                            break;
                          case 3:
                            query_term = StringsManager.history;
                            selectedIndex = 3;
                            break;
                          case 4:
                            query_term = StringsManager.horror;
                            selectedIndex = 4;
                            break;
                          case 5:
                            query_term = StringsManager.romance;
                            selectedIndex = 5;
                            break;
                        }
                      });
                    },
                    isScrollable: true,
                    tabs: [
                      Tab(text: StringsManager.action),
                      Tab(text: StringsManager.comedy),
                      Tab(text: StringsManager.crime),
                      Tab(text: StringsManager.history),
                      Tab(text: StringsManager.horror),
                      Tab(text: StringsManager.romance),
                    ],
                  ),
                  SizedBox(height: 12.28),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        TabViewItem(movies),
                        TabViewItem(movies),
                        TabViewItem(movies),
                        TabViewItem(movies),
                        TabViewItem(movies),
                        TabViewItem(movies),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
