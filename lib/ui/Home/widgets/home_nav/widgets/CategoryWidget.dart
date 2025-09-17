import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show TextButton, Theme, CircularProgressIndicator, Colors;



import '../../../../../core/remote/network/ApiManger.dart';
import '../../../../../data/model/MoviesDetailsResponse/Movie.dart';
import 'MovieItem.dart';

class Categorywidget extends StatelessWidget {
  String category;

  Categorywidget({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "see more ->",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: ApiManger.getListMovies(genre: category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            List<Movie> movieslist = snapshot.data!;
            return SizedBox(
              height: 200,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(width: 16);
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return MovieItem(
                  movie: movieslist[index],
                  );
                },
                itemCount: movieslist.length,
              ),
            );
          },
        ),
      ],
    );
  }
}

/* SizedBox(
          height: 200,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(width: 16);
            },
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return MovieItem(imgPath: movies_list[index].mediumCoverImage!);
            },
            itemCount: movies_list.length,
          ),
        ),*/
