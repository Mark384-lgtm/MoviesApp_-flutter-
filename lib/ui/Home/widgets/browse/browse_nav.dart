import 'package:flutter/material.dart';
import 'package:movies/core/resources/ColorManager.dart';
import 'package:movies/core/resources/StringManger.dart';
import 'package:movies/ui/Home/widgets/browse/widgets/TabViewItem.dart';

import '../../../../core/remote/network/ApiManger.dart';
import '../../../../data/model/MoviesDetailsResponse/Movie.dart';

class BrowseNav extends StatefulWidget {
  const BrowseNav({super.key});

  @override
  State<BrowseNav> createState() => _BrowseNavState();
}

class _BrowseNavState extends State<BrowseNav>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String queryTerm = StringsManager.action;
  int selectedIndex = 0;

  final List<String> _tabTitles = [
    StringsManager.action,
    StringsManager.comedy,
    StringsManager.crime,
    StringsManager.history,
    StringsManager.horror,
    StringsManager.romance,
    StringsManager.drama,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabTitles.length,
      vsync: this,
      initialIndex: selectedIndex,
    );

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        selectedIndex = _tabController.index;
        queryTerm = _tabTitles[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>?>(
      future: ApiManger.getListMovies(query_term: queryTerm),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading movies: ${snapshot.error}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        List<Movie>? movies = snapshot.data;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 350;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: 16,
              ),
              child: Column(
                children: [
                  // TabBar with explicit controller
                  SizedBox(
                    height: isSmallScreen ? 40 : 48,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      unselectedLabelColor: Colors.white,
                      labelColor: ColorManager.yellow,
                      indicatorColor: ColorManager.yellow,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerHeight: 0,
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      tabs: _tabTitles
                          .map((title) => _buildTab(title))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TabBarView with explicit controller
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        _tabTitles.length,
                        (index) => TabViewItem(movies),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTab(String text) {
    return Tab(child: Text(text, style: const TextStyle(fontSize: 14)));
  }
}
