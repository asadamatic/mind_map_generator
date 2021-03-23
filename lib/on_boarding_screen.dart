import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

class OnboardingScreen extends StatefulWidget {
  final Function selectScreen;
  OnboardingScreen({this.selectScreen});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Stack(
        children: [
          PageView(
            children: [],
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 50.0),
                padding: EdgeInsets.only(
                  bottom:
                      3, // This can be the space you need betweeb text and underline
                ),
                child: Text(
                  "SMART MATTER INC",
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.headline5.fontSize,
                  ),
                ),
              )),
          Container(
            margin: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NumberStepper(
                    activeStep: activeStep,
                    onStepReached: (index) {
                      setState(() {
                        activeStep = index;
                      });
                    },
                    enableNextPreviousButtons: false,
                    stepColor: Colors.white,
                    activeStepColor: Colors.lightBlueAccent,
                    lineColor: Colors.black,
                    activeStepBorderColor: Colors.lightBlueAccent,
                    stepReachedAnimationEffect: Curves.easeIn,
                    activeStepBorderWidth: 0.0,
                    numbers: [
                      1,
                      2,
                      3,
                    ]),
                SizedBox(
                  height: 25.0,
                ),
                ElevatedButton.icon(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0)))),
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      if (activeStep < 2) {
                        setState(() {
                          activeStep = activeStep + 1;
                        });
                      } else {
                        widget.selectScreen();
                      }
                    },
                    label: Text('Next'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
