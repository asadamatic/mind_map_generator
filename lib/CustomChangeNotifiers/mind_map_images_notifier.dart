import 'package:flutter/cupertino.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/LocalDatabaseService/mind_map_database.dart';

class MindMapImagesNotifier extends ChangeNotifier {
  List<MindMap> _mindMaps = [];
  List<String> _mindMapDocIds = [];
  List<int> _selectedMindMapIndexes = [];

  int _mindMapIndex;
  int get mindMapIndex => _mindMapIndex;
  List<MindMap> get mindMaps => _mindMaps;
  List<String> get mindMapDocIds => _mindMapDocIds;
  List<int> get selectedMindMapIndexes => _selectedMindMapIndexes;

  set mindMaps(List<MindMap> newMindMap) {
    _mindMaps = newMindMap;
    notifyListeners();
  }

  set mindMapDocIds(List<String> newMindMapDocIds) {
    _mindMapDocIds = newMindMapDocIds;
    notifyListeners();
  }

  set selectedMindMapIndexes(List<int> newSelectedMindMaps) {
    _selectedMindMapIndexes = newSelectedMindMaps;
    notifyListeners();
  }
  set mindMapIndex(int newMindMapIndex){
    _mindMapIndex = newMindMapIndex;
    notifyListeners();
  }
  MindMapImagesNotifier() {
    loadValue();
  }

  Future<void> loadValue() async {
    mindMaps = await MindMapDatabaseNotifier().getMindMaps();
    mindMapDocIds = mindMaps.map((e) => e.docId).toList();
  }

  append(MindMap mindMap) {
    if (!_mindMapDocIds.contains(mindMap.docId)) {
      _mindMaps.add(mindMap);
      _mindMapDocIds.add(mindMap.docId);
      notifyListeners();
      MindMapDatabaseNotifier().insertMinMap(mindMap);
    }
  }

  updateMindMap(MindMap mindMap) {
    print(mindMapIndex);
    _mindMaps[mindMapIndex] = mindMap;
    notifyListeners();
    MindMapDatabaseNotifier().updateMinMap(mindMap);
  }

  deleteAllSelected() {
    for (int index in _selectedMindMapIndexes) {
      MindMapDatabaseNotifier().deleteMinMap(_mindMaps.elementAt(index).docId);
      _mindMaps.removeAt(index);
      _mindMapDocIds.removeAt(index);
    }
    removeAllSelectedIndexes();

    notifyListeners();
  }

  appendSelectedIndexes(int newSelectedIndex) {
    if (!_selectedMindMapIndexes.contains(newSelectedIndex)) {
      _selectedMindMapIndexes.add(newSelectedIndex);
      _selectedMindMapIndexes.sort();
      _selectedMindMapIndexes = _selectedMindMapIndexes.reversed.toList();
      notifyListeners();
    }
  }

  removeAllSelectedIndexes() {
    _selectedMindMapIndexes = [];
    notifyListeners();
  }

  removeAnIndexFromSelected(int removeIndex) {
    _selectedMindMapIndexes.remove(removeIndex);
    notifyListeners();
  }
}
