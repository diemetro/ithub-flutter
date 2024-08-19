import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shopping_list_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/shopping_list.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditShoppingView extends StatefulWidget {
  final ShoppingList shoppingList;

  EditShoppingView({required this.shoppingList});

  @override
  _EditShoppingViewState createState() => _EditShoppingViewState();
}

class _EditShoppingViewState extends State<EditShoppingView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.shoppingList.title;
    _descriptionController.text = widget.shoppingList.description;
    _notesController.text = widget.shoppingList.notes;
    _image = widget.shoppingList.image;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
      return Center(child: Text('Please log in to edit shopping lists.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Shopping List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Notes'),
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
                final updatedList = ShoppingList(
                  id: widget.shoppingList.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  notes: _notesController.text,
                  isFavorite: widget.shoppingList.isFavorite,
                  userId: user.id,
                  image: _image,
                );
                shoppingListViewModel.updateShoppingList(updatedList);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
