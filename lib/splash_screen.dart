import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {

  final Function selectScreen;
  SplashScreen({Key key, this.selectScreen}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(),
              Image(
                alignment: Alignment.center,
                image: AssetImage('assets/splashlogo.png'),
                height: 100.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 35.0),
                child: Text(
                  'SMART MATTER INC',
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Theme.of(context).primaryColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
