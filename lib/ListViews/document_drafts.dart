
import 'package:flutter/material.dart';
import 'package:mind_map_generator/CustomElements/draft_card.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:provider/provider.dart';

class DraftsListScreen extends StatefulWidget {
  @override
  _DraftsListScreenState createState() => _DraftsListScreenState();
}

class _DraftsListScreenState extends State<DraftsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drafts'),
      ),
      body:
          Consumer<DocumentsDatabaseNotifier>(builder: (context, value, child) {
        return FutureBuilder<List<DocumentImage>>(
          future: value.getDistinctDocs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return DraftCard(documentImage: snapshot.data[index],);
                  });
            }
            return CircularProgressIndicator();
          },
        );
      }),
    );
  }
}
