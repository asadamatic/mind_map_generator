import 'package:flutter/material.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/mind_map_images_notifier.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/server_config_notifier.dart';
import 'package:mind_map_generator/CustomElements/mind_map_card.dart';
import 'package:mind_map_generator/ListViews/document_drafts.dart';

import 'package:mind_map_generator/ListViews/document_images_grid_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MindMapsListScreen extends StatelessWidget {
  TextEditingController hostEditingController;
  TextEditingController portEditingController;

  @override
  Widget build(BuildContext context) {
    final isSelected = Provider.of<MindMapImagesNotifier>(context)
        .selectedMindMapIndexes
        .isNotEmpty;

    hostEditingController = TextEditingController(
        text: Provider.of<ServerConfigNotifier>(context).host);

    portEditingController = TextEditingController(
        text: Provider.of<ServerConfigNotifier>(context).port);
    return GestureDetector(
      onTap: () {
        Provider.of<MindMapImagesNotifier>(context, listen: false)
            .removeAllSelectedIndexes();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (isSelected) {
            Provider.of<MindMapImagesNotifier>(context, listen: false)
                .removeAllSelectedIndexes();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mind Maps'),
            leading: isSelected
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Provider.of<MindMapImagesNotifier>(context, listen: false)
                          .removeAllSelectedIndexes();
                    })
                : IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                child: Container(
                                  height: 200.0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 12.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Server Config',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: hostEditingController,
                                      ),
                                      TextFormField(
                                        controller: portEditingController,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        textStyle: MaterialStateProperty
                                                            .all(TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white)),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                    )),
                                              ),
                                              Spacer(flex: 1),
                                              Expanded(
                                                flex: 5,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                        shape: MaterialStateProperty
                                                            .all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        textStyle: MaterialStateProperty
                                                            .all(TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Colors.white)),
                                                    onPressed: () {
                                                      Provider.of<ServerConfigNotifier>(
                                                              context,
                                                              listen: false)
                                                          .setServerConfigValues(
                                                              hostEditingController
                                                                  .text
                                                                  .trim(),
                                                              portEditingController
                                                                  .text
                                                                  .trim());
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Text('Done'),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    }),
            actions: isSelected
                ? [
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<MindMapImagesNotifier>(context,
                                  listen: false)
                              .deleteAllSelected();
                          // Provider.of<MindMapImagesNotifier>(context,
                          //         listen: false)
                          //     .removeAllSelectedIndexes();
                        })
                  ]
                : [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        child: Text(
                          'Drafts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DraftsListScreen()));
                        },
                      ),
                    )
                  ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<MindMapImagesNotifier>(
                    builder: (context, value, child) {
                      if (value != null) {
                        return ListView.builder(
                            itemCount: value.mindMaps?.length ?? 0,
                            itemBuilder: (context, index) {
                              return MindMapCard(
                                mindMap: value.mindMaps[index],
                                imageIndex: index,
                              );
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.camera_alt,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DocumentImagesGridScreen(
                            imageScreenActions: ImageScreenActions.newDocument,
                          )));
            },
          ),
        ),
      ),
    );
  }
}
