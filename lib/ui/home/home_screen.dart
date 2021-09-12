import 'package:catalog_films/bloc/home/home_bloc.dart';
import 'package:catalog_films/widgets/card_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  final controller = ScrollController();
  int page = 1;
  late HomeBloc bloc;
  bool showCloseBtn = false;

  @override
  void initState() {
    bloc = BlocProvider.of<HomeBloc>(context);
    controller.addListener(onScroll);
    super.initState();
  }

  void onScroll() {
    if (bloc.state is LoadedState == false) return;
    print("line 28");
    if (!controller.hasClients) return;
    final double maxHeight = controller.position.maxScrollExtent;
    final double currentHeight = controller.offset;
    if (currentHeight >= maxHeight * 0.9) {
      bloc.add(
        NextPageEvent(
          page: ++page,
          isLoading: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(
                      Icons.search,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (value) {
                          print(value);
                          if (value.isNotEmpty) {
                            setState(() {
                              showCloseBtn = true;
                              Future.delayed(Duration(seconds: 1), () {
                                bloc.add(SearchMovieEvent(value));
                              });
                            });
                          } else {
                            setState(() {
                              showCloseBtn = false;
                            });
                            Future.delayed(Duration(seconds: 1), () {
                              bloc.add(GetRequest());
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Поиск по названию фильма",
                          border: InputBorder.none,
                          suffixIcon: showCloseBtn
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    bloc.add(GetRequest());
                                    showCloseBtn = false;
                                    FocusScope.of(context).unfocus();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                  ),
                                )
                              : SizedBox(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is LoadedState) {
                    return buildMovies(state, favList: state.favList);
                  }
                  if (state is LoadingState) {
                    return buildMovies(state);
                  }
                  if (state is ResultSearchState) {
                    print("line 117");
                    return ListView.builder(
                      itemCount: state.movie.results.length,
                      itemBuilder: (context, index) => CardMovie(
                          movies: state.movie.results,
                          index: index,
                          favList: state.favList),
                    );
                  }
                  if (state is NotResultSearchState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 100,
                        ),
                        SizedBox(height: 25),
                        Text(
                          'По запросу "${state.message}" ничего не найдено',
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildMovies(var state, {List? favList}) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              bloc.add(GetRequest());
            },
            child: ListView.builder(
              controller: controller,
              itemCount: state.movie.results.length,
              itemBuilder: (context, index) => CardMovie(
                  movies: state.movie.results, index: index, favList: favList!),
            ),
          ),
        ),
        Container(
          height: state.isLoading ? 40.0 : 0,
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
