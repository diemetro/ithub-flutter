import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shopping_list_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/shopping_list.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddShoppingView extends StatefulWidget {
  @override
  _AddShoppingViewState createState() => _AddShoppingViewState();
}

class _AddShoppingViewState extends State<AddShoppingView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _uuid = Uuid();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    if (user == null) {
      return Center(child: Text('Please log in to add shopping lists.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Обновить список покупок'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Заметки'),
            ),
            SizedBox(height: 20),
            _image != null
                ? Column(
                    children: [
                      Image.file(_image!, height: 200),
                      TextButton(
                        onPressed: _removeImage,
                        child: Text('Удалить изображение', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  )
                : Text('Изображение не выбрано'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Выбрать изображение'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newList = ShoppingList(
                  id: _uuid.v4(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  notes: _notesController.text,
                  userId: user.id,
                  image: _image,
                );
                shoppingListViewModel.addShoppingList(newList);
                Navigator.pop(context);
              },
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}
