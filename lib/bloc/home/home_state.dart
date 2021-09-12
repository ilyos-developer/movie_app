part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LoadingState extends HomeState {
  final Movie movie;
  bool isLoading;

  LoadingState({required this.movie, required this.isLoading});
}

class LoadedState extends HomeState {
  final Movie movie;
  bool isLoading;
  List favList;
  LoadedState({required this.movie, required this.isLoading, required this.favList});
}

class ResultSearchState extends HomeState {
  final Movie movie;

  ResultSearchState(this.movie);
}

class NotResultSearchState extends HomeState {
  final String message;

  NotResultSearchState(this.message);
}
