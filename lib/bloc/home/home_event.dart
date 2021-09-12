part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetRequest extends HomeEvent {}

class NextPageEvent extends HomeEvent {
  int page;
  bool isLoading;

  NextPageEvent({required this.page, required this.isLoading});
}

class SearchMovieEvent extends HomeEvent {
  String name;

  SearchMovieEvent(this.name);
}

class AddFavorite extends HomeEvent {
  final int id;

  AddFavorite(this.id);
}
