import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  final Function selectScreen;
  OnboardingScreen({Key key, this.selectScreen}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white, systemOverlayStyle: SystemUiOverlayStyle.dark,
          )),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Spacer(),
              Expanded(
                flex: 7,
                child: PageView(
                  allowImplicitScrolling: true,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  pageSnapping: true,
                  controller: pageController,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image(
                              image:
                                  AssetImage('assets/highlighted_document.png'),
                              height: 300.0,
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'HIGHLIGHT DOCUMENTS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Highlight Your documents according to the guidelines.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            )
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/scan_docs.png'),
                              height: 300.0,
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'SCAN DOCUMENTS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Scan Your documents using built-in camera.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            )
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/mind_map.png'),
                              height: 300.0,
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'View Mind Map',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Get an auto-generated mind-map of Your docs.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Indicator(
                    positionIndex: 0,
                    currentPage: currentPage,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Indicator(
                    positionIndex: 1,
                    currentPage: currentPage,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Indicator(
                    positionIndex: 2,
                    currentPage: currentPage,
                  ),
                ],
              ),
              Spacer()
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: currentPage > 0 ? true : false,
                child: TextButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Theme.of(context).primaryColor, fontSize: 18.0)),
                    ),
                    onPressed: () {
                      if (currentPage != 0) {
                        pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text('Previous'),
                    )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(color: Theme.of(context).primaryColor, fontSize: 18.0)),
                  ),
                  onPressed: () {
                    if (currentPage == 2) {
                      widget.selectScreen();
                    } else {
                      pageController.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(currentPage < 2 ? 'Next' : 'Get Started',),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(color: Theme.of(context).primaryColor, fontSize: 18.0)),
                  ),
                  onPressed: () {
                    widget.selectScreen();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text('Skip'),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final int positionIndex, currentPage;
  const Indicator({this.currentPage, this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 10,
      width: currentPage == positionIndex ? 22 : 10,
      decoration: BoxDecoration(
          color: positionIndex == currentPage
              ? Theme.of(context).primaryColor
              : Color(0xff01286a).withOpacity(.3),
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
