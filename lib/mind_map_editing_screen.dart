import 'package:flutter/material.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/ImageViews/interactive_mind_map_view.dart';
import 'package:mind_map_generator/mind_map_generator_screen.dart';
import 'package:page_transition/page_transition.dart';

class MindMapEditingScreen extends StatefulWidget {
  final List<String> listOfData;
  String docId;
  final MindMap mindMap;
  MindMapEditingScreen({this.listOfData, this.docId, this.mindMap, Key key})
      : super(key: key);
  @override
  _MindMapEditingScreenState createState() => _MindMapEditingScreenState();
}

class _MindMapEditingScreenState extends State<MindMapEditingScreen> {
  List<TextEditingController> controllers;


  removeElementAtIndex(int index) {
    setState(() {
      widget.listOfData.removeAt(index);
      controllers.removeAt(index);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllers = [
      for (int index = 0; index < widget.listOfData.length; index++)
        index == 0
            ? TextEditingController(text: widget.listOfData[index].toString().trim())
            : TextEditingController(
            text: widget.listOfData[index].toString()?.split('+-')[1].trim())
    ];
  }

  @override
  Widget build(BuildContext context) {
    print(widget.listOfData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mind Map'),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: InteractiveMindMapView(
                      oldMindMap: widget.mindMap,
                    )));
          },
        ),
      ),
      body: ListView.builder(
          itemCount: controllers?.length ?? 0,
          itemBuilder: (buildContext, index) {
            return ListTile(
              title: TextFormField(
                controller: controllers[index],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: InputBorder.none,
                ),
                style: getTextStyle(widget.listOfData[index].toString()),

              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removeElementAtIndex(index);

                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          List<String> newlsit = [widget.listOfData[0]];
          for (int i = 1; i < widget.listOfData.length; i++) {
            newlsit.add(widget.listOfData[i].replaceRange(
                widget.listOfData[i].indexOf("+-"),
                widget.listOfData[i].length,
                "+-${controllers[i].text}"));
          }
          print(newlsit);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (buildContext) => MindMapGeneratorScreen(
                      mapScreenActions: MindMapGeneratorScreenActions.reCreate,
                      listOfData: newlsit,
                      docId: widget.docId)));
        },
      ),
    );
  }

  TextStyle getTextStyle(String data) {
    if (data.toString().split('+-')[0] == '') {
      return TextStyle( fontSize: 20.0);
    } else if (data.toString().split('+-')[0] == '+') {
      return TextStyle(fontSize: 19.0);
    } else if (data.toString().split('+-')[0] == '++') {
      return TextStyle( fontSize: 18.0);
    } else if (data.toString().split('+-')[0] == '+++') {
      return TextStyle(fontSize: 17.0);
    }else{
      return TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0);
    }

    return TextStyle();
  }
}
