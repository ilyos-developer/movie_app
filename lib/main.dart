import 'package:catalog_films/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home/home_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Films',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      home: BlocProvider<HomeBloc>(
        create: (context) => HomeBloc()..add(GetRequest()),
        child: HomeScreen(),
      ),
    );
  }
}
