import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

import '../components/custom_text_field.dart';
import '../models/movie_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = true;
  List<Movie> movies = [];
  List<Movie> filteredMovies = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true; // Start loading
      });
      //http://www.omdbapi.com/?s=movies&page=1&apikey=2feb4f58&plot=full
      //key:2feb4f58
      Response response = await get(
        Uri.parse(
          "http://www.omdbapi.com/?s=movies&page=1&apikey={YOUR_API_KEY}&plot=full",
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey("Search")) {
          List fetchedMovies = data["Search"];

          setState(() {
            movies = fetchedMovies.map((json) => Movie.fromJson(json)).toList();
            isLoading = false; // Finish loading
          });
        } else {
          debugPrint("No 'Search' key in response data");
          isLoading = false; // Finish loading
        }
      } else {
        debugPrint("Error");
        isLoading = false; // Finish loading
      }
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false; // Finish loading
    }
  }

  TextEditingController controller = TextEditingController();
  void onchange(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredMovies = movies;
        isSearching = false; // Stop searching
      });
    } else {
      setState(() {
        filteredMovies = movies
            .where((movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        isSearching = true; // Start searching
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 21, 70),
      body: SafeArea(
        child: Column(
          children: [
            CustomTextField(
              text: "Enter a movie name",
              onchange: onchange,
            ),
            isLoading
                ? const SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 50.0,
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredMovies.length,
                      itemBuilder: (BuildContext context, int index) {
                        final movie = filteredMovies[index];
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      movie.poster,
                                      width: 60,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              movie.title.length > 28
                                                  ? "${movie.title.substring(0, 28)}..."
                                                  : movie.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              movie.year,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  movie.type,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
                  ),
            isSearching
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Container(), // Display a loading indicator when searching
          ],
        ),
      ),
    );
  }
}
