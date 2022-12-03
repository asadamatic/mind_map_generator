import 'package:flutter/material.dart';
import 'package:mind_map_generator/one_time_screen_wrapper.dart';
import 'package:mind_map_generator/splash_screen.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: Future.delayed(Duration(milliseconds: 2000)),
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
