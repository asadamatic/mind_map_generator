import 'package:flutter/material.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';

class DraftImagesNotifier extends ChangeNotifier {
  List<DocumentImage> _draftDocuments = [];
  List<DocumentImage> get draftDocuments => _draftDocuments;

  List<int> _selectedDraftIndexes = [];

  List<int> get selectedDraftIndexes => _selectedDraftIndexes;
  set draftDocuments(List<DocumentImage> newDraftDocument) {
    _draftDocuments = newDraftDocument;
    notifyListeners();
  }

  set selectedDraftIndexes(List<int> newSelectedMindMaps) {
    _selectedDraftIndexes = newSelectedMindMaps;
    notifyListeners();
  }

  appendDraft(DocumentImage documentImage) {
    if (!_draftDocuments.contains(documentImage)) {
      _draftDocuments.add(documentImage);
      notifyListeners();
    }
  }

  DraftImagesNotifier() {
    loadValue();
  }

  Future<void> loadValue() async {
    draftDocuments = await DocumentsDatabaseNotifier().getDistinctDocs();
  }

  deleteAllSelected() {
    for (int index in _selectedDraftIndexes) {
      DocumentsDatabaseNotifier()
          .deleteDocument(_draftDocuments.elementAt(index).docId);
      _draftDocuments.removeAt(index);
    }
    removeAllSelectedIndexes();

    notifyListeners();
  }

  appendSelectedIndexes(int newSelectedIndex) {
    if (!_selectedDraftIndexes.contains(newSelectedIndex)) {
      _selectedDraftIndexes.add(newSelectedIndex);
      _selectedDraftIndexes.sort();
      _selectedDraftIndexes = _selectedDraftIndexes.reversed.toList();
      notifyListeners();
    }
  }

  removeAllSelectedIndexes() {
    _selectedDraftIndexes = [];
    notifyListeners();
  }

  removeAnIndexFromSelected(int removeIndex) {
    _selectedDraftIndexes.remove(removeIndex);
    notifyListeners();
  }
}
