import 'package:flutter/cupertino.dart';

import '../../../../../data/model/MoviesDetailsResponse/Movie.dart';
import '../../home_nav/widgets/MovieItem.dart';

class TabViewItem extends StatelessWidget {

  List<Movie>? movies;

  TabViewItem(this.movies);
  @override
  Widget build(BuildContext context) {
   return  GridView.builder(
     itemCount: movies?.length ?? 0,
     gridDelegate:
     SliverGridDelegateWithFixedCrossAxisCount(
       childAspectRatio: 0.7,
       mainAxisSpacing: 8,
       crossAxisSpacing: 16,
       crossAxisCount: 2,
     ),
     itemBuilder: (context, index) {
       return MovieItem(movie: movies![index]);
     },
   );
  }

}
