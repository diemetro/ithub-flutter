import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shopping_list_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/shopping_list.dart';
import 'edit_shopping_view.dart';

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    if (user == null) {
      return Center(child: Text('Please log in to view your shopping lists.'));
    }

    final userShoppingLists = shoppingListViewModel.getUserShoppingLists(user.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Lists'),
      ),
      body: ListView.builder(
        itemCount: userShoppingLists.length,
        itemBuilder: (context, index) {
          final shoppingList = userShoppingLists[index];
          return ListTile(
            leading: shoppingList.image != null
                ? Image.file(
                    shoppingList.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  )
                : Icon(Icons.image, color: Colors.grey),
            title: Text(
              shoppingList.title,
              style: TextStyle(
                decoration: shoppingList.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              shoppingList.description,
              style: TextStyle(
                decoration: shoppingList.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip (
                message: shoppingList.isFavorite ? 'Удалить из избранного' : 'Добавить в избранное',
                child: IconButton(
                  icon: Icon(
                    shoppingList.isFavorite ? Icons.star : Icons.star_border,
                  ),
                  onPressed: () {
                    shoppingListViewModel.updateShoppingList(
                      ShoppingList(
                        id: shoppingList.id,
                        title: shoppingList.title,
                        description: shoppingList.description,
                        notes: shoppingList.notes,
                        isFavorite: !shoppingList.isFavorite,
                        userId: shoppingList.userId,
                        isCompleted: shoppingList.isCompleted,
                        image: shoppingList.image,
                      ),
                    );
                  },
                ),
                ),
                Tooltip (
                message: 'Редактировать покупку',
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditShoppingView(shoppingList: shoppingList),
                      ),
                    );
                  },
                ),
                ),
                Tooltip (
                message: 'Удалить покупку',
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, shoppingList.id, shoppingListViewModel);
                  },
                ),
                ),
                Tooltip (
                message: shoppingList.isCompleted ? 'Планировать покупку' : 'Завершить покупку',
                child: Checkbox(
                  value: shoppingList.isCompleted,
                  onChanged: (bool? value) {
                    shoppingListViewModel.toggleCompletion(shoppingList.id);
                  },
                ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String id, ShoppingListViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить задачу'),
        content: Text('Вы уверены, что хотите удалить эту задачу?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              viewModel.deleteShoppingList(id);
              Navigator.of(context).pop();
            },
            child: Text('Удалить'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Отмена'),
          ),
        ],
      ),
    );
  }
}
