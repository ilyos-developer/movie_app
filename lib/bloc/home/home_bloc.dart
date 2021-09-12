import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:catalog_films/models/movie.dart';
import 'package:catalog_films/repository/api_client.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Movie movies;
  static const FAV_KEY = "favoriteId";
  List favIdList = [];

  HomeBloc() : super(HomeInitial()) {
    _prefs.then((value) {
      String? id = value.getString(FAV_KEY);
      if (id != null && id.isNotEmpty) {
        favIdList = jsonDecode(id);
        print(favIdList);
      }
    });
  }

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetRequest) {
      try {
        movies = await ApiClient().getMovies();
        yield LoadedState(movie: movies, isLoading: false, favList: favIdList);
      } catch (e) {
        print("bloc: $e");
      }
    }
    if (event is NextPageEvent) {
      yield LoadingState(movie: movies, isLoading: event.isLoading);
      try {
        (await ApiClient().getMovies(page: event.page))
            .results
            .forEach((element) => movies.results.add(element));
        yield LoadedState(movie: movies, isLoading: false, favList: favIdList);
      } catch (e) {
        print(e);
      }
    }
    if (event is SearchMovieEvent) {
      yield HomeInitial();
      try {
        movies = await ApiClient().searchMovie(event.name);
        if (movies.results.isNotEmpty) {
          yield ResultSearchState(movies);
        } else {
          yield NotResultSearchState(event.name);
        }
      } catch (e) {
        yield NotResultSearchState(event.name);
      }
    }
    if (event is AddFavorite) {
      if (!favIdList.contains(event.id.toString())) {
        favIdList.add(event.id.toString());
      } else {
        favIdList.remove(event.id.toString());
      }
      (await _prefs).setString(FAV_KEY, jsonEncode(this.favIdList));
      print(favIdList);

      yield LoadedState(movie: movies, isLoading: false, favList: favIdList);
    }
  }
}
