
import 'package:flutter/material.dart';
import 'package:mind_map_generator/ListViews/mind_maps_list_screen.dart';
import 'package:mind_map_generator/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneTimeScreenWrapper extends StatefulWidget {

  @override
  _OneTimeScreenWrapperState createState() => _OneTimeScreenWrapperState();
}

class _OneTimeScreenWrapperState extends State<OneTimeScreenWrapper> {

  void selectScreen() async{

    setState(() {
      setVisitingValue();
    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: getVisitingValue(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

        if (snapshot.hasData){

          if (snapshot.data == true){

            return MindMapsListScreen();
          }else{

            return OnboardingScreen(selectScreen: selectScreen,);
          }
        }else{

          return Scaffold();
        }
      },
    );
  }
}

Future<bool> getVisitingValue() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('visitWelcomeScreenValue') ?? false;
}

setVisitingValue() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('visitWelcomeScreenValue', true);
}