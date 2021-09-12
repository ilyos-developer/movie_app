import 'package:catalog_films/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Icon(
          Icons.close,
          size: 80,
          color: Colors.red,
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Проверьте соединение с интернетом и попробуйте еще раз',
            style: TextStyle(color: Colors.grey[300], fontSize: 18),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            print("asd");
            BlocProvider.of<HomeBloc>(context).add(GetRequest());
          },
          child: Icon(
            Icons.refresh,
            size: 100,
          ),
        ),
        SizedBox(height: 100),
      ],
    );
  }
}
