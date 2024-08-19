import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/shopping_list_viewmodel.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context);
    final user = authViewModel.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Профиль'),
        ),
        body: Center(
          child: Text('Пожалуйста, войдите, чтобы просмотреть детали профиля.'),
        ),
      );
    }

    final userId = user.id;
    final totalTasks = shoppingListViewModel.getTaskCount(userId);
    final completedTasks = shoppingListViewModel.getCompletedTaskCount(userId);
    final inProgressTasks = shoppingListViewModel.getInProgressTaskCount(userId);
    final favoriteTasks = shoppingListViewModel.getFavoriteTaskCount(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text('Email: ${user.email}'),
            Text('ID: ${user.id}'),
            SizedBox(height: 20),
            Text('Общее количество покупок: $totalTasks'),
            Text('Совершенные покупки: $completedTasks'),
            Text('Запланированные покупки: $inProgressTasks'),
            Text('Избранные покупки: $favoriteTasks'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showLogoutConfirmDialog(context);
              },
              child: Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтверждение выхода'),
        content: Text('Вы уверены, что хотите выйти из профиля?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Закрыть диалог
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
              authViewModel.logout(); // Выполнить выход
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Перенаправить на главный экран
            },
            child: Text('Выйти'),
          ),
        ],
      ),
    );
  }
}
