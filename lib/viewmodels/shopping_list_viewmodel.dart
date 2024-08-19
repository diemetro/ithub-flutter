import 'package:flutter/foundation.dart';
import '../models/shopping_list.dart';

class ShoppingListViewModel extends ChangeNotifier {
  List<ShoppingList> _shoppingLists = [
    ShoppingList(id: '1', title: 'Купить Цемент', description: 'Купить 5 мешков цемента для фундамента', notes: '', isFavorite: false, userId:'', isCompleted: false),
    ShoppingList(id: '2', title: 'Посчитать количество блоков', description: 'Посчитать количество блоков для фундамента', notes: '', isFavorite: false, userId:'', isCompleted: false),
    ShoppingList(id: '3', title: 'Написать отчет', description: 'Написать отчет по закупкам', notes: '',isFavorite: true, userId:'', isCompleted: false),
  ];

  List<ShoppingList> get shoppingLists => _shoppingLists;

  List<ShoppingList> getUserShoppingLists(String userId) {
    return _shoppingLists.where((list) => list.userId == userId).toList();
  }

  int getTaskCount(String userId) {
    return getUserShoppingLists(userId).length;
  }

  int getCompletedTaskCount(String userId) {
    return getUserShoppingLists(userId).where((list) => list.isCompleted).length;
  }

  int getInProgressTaskCount(String userId) {
    return getUserShoppingLists(userId).where((list) => !list.isCompleted).length;
  }

  int getFavoriteTaskCount(String userId) {
    return getUserShoppingLists(userId).where((list) => list.isFavorite).length;
  }

  void toggleCompletion(String id) {
    final index = _shoppingLists.indexWhere((item) => item.id == id);
    if (index != -1) {
      _shoppingLists[index].isCompleted = !_shoppingLists[index].isCompleted;
      notifyListeners();
    }
  }

  void addShoppingList(ShoppingList shoppingList) {
    _shoppingLists.add(shoppingList);
    notifyListeners();
  }

  void updateShoppingList(ShoppingList shoppingList) {
    final index = _shoppingLists.indexWhere((list) => list.id == shoppingList.id);
    if (index != -1) {
      _shoppingLists[index] = shoppingList;
      notifyListeners();
    }
  }

  void deleteShoppingList(String id) {
    _shoppingLists.removeWhere((list) => list.id == id);
    notifyListeners();
  }
}
