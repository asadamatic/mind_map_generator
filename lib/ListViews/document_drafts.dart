import 'package:flutter/material.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/draft_Images_notifier.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/mind_map_images_notifier.dart';
import 'package:mind_map_generator/CustomElements/draft_card.dart';
import 'package:provider/provider.dart';

class DraftsListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final mindMapDocIds =
        Provider.of<MindMapImagesNotifier>(context).mindMapDocIds;
    return ChangeNotifierProvider.value(
      value: DraftImagesNotifier(),
      builder: (buildContext, child) {
        final isSelected = Provider.of<DraftImagesNotifier>(buildContext)
            .selectedDraftIndexes
            .isNotEmpty;
        return GestureDetector(
            onTap: () {
              Provider.of<DraftImagesNotifier>(buildContext, listen: false)
                  .removeAllSelectedIndexes();
            },
            child: WillPopScope(
              onWillPop: () async{
                if (isSelected) {
                  Provider.of<DraftImagesNotifier>(buildContext,
                      listen: false)
                      .removeAllSelectedIndexes();
                  return false;
                } else {
                  return true;
                }
              },
              child: Scaffold(
                  appBar: AppBar(
                    title: Text('Drafts'),

                    actions: [
                      if (isSelected)
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              Provider.of<DraftImagesNotifier>(buildContext,
                                      listen: false)
                                  .deleteAllSelected();
                            })
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Consumer<DraftImagesNotifier>(
                      builder: (context, value, child) {
                        if (value != null) {
                          return ListView.builder(
                              itemCount: value.draftDocuments?.length ?? 0,
                              itemBuilder: (context, index) {
                                if (mindMapDocIds
                                    .contains(value.draftDocuments[index].docId)) {
                                  return SizedBox();
                                }
                                return DraftCard(
                                  documentImage: value.draftDocuments[index],
                                  draftIndex: index,
                                );
                              });
                        }
                        return Center();
                      },
                    ),
                  )),
            ));
      },
    );
  }
}
