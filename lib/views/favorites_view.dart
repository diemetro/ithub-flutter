import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shopping_list_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/shopping_list.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    if (user == null) {
      return Center(child: Text('Please log in to view your favorite shopping lists.'));
    }

    final userFavorites = shoppingListViewModel.getUserShoppingLists(user.id)
        .where((list) => list.isFavorite)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: ListView.builder(
        itemCount: userFavorites.length,
        itemBuilder: (context, index) {
          final shoppingList = userFavorites[index];
          return ListTile(
            leading: shoppingList.image != null
                ? Image.file(shoppingList.image!, width: 50, height: 50, fit: BoxFit.cover)
                : Checkbox(
                    value: shoppingList.isCompleted,
                    onChanged: (bool? value) {
                      shoppingListViewModel.toggleCompletion(shoppingList.id);
                    },
                  ),
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
            trailing: IconButton(
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
                    image: shoppingList.image, // Передаем изображение
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
