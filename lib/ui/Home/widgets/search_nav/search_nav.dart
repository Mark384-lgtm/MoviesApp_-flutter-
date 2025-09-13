import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/remote/network/ApiManger.dart';
import 'package:movies_app/data/model/MoviesDetailsResponse/Movie.dart';
import 'package:movies_app/ui/Home/widgets/home_nav/widgets/MovieItem.dart';
import 'package:movies_app/ui/Home/widgets/search_nav/widgets/SearchField.dart';

class search_nav extends StatefulWidget {
  String? query_term;
  @override
  State<search_nav> createState() => _search_navState();
}

class _search_navState extends State<search_nav> {
  @override

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiManger.getListMovies(query_term: widget.query_term),
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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
            child: Column(
              children: [
                SearchField(get_QueryTerm,widget.query_term),
                SizedBox(height: 12.28),
                Expanded(
                  child: GridView.builder(
                    itemCount: movies?.length ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 16,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                       return MovieItem(movie: movies![index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void get_QueryTerm(String? term) {
    setState(() {
      widget.query_term = term;
    });
  }
}
