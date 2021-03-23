import 'package:flutter/material.dart';
import 'package:mind_map_generator/one_time_screen_wrapper.dart';
import 'package:mind_map_generator/splash_screen.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  void selectScreen() async{

  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: Future.delayed(Duration(milliseconds: 1200)),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

        if (snapshot.connectionState == ConnectionState.waiting){


            return SplashScreen();

        }else{

          return OneTimeScreenWrapper();
        }
      },
    );
  }
}
