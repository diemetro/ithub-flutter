import 'dart:convert';
import 'dart:io';

class ShoppingList {
  String id;
  String title;
  String description;
  String notes;
  bool isFavorite;
  String userId;
  bool isCompleted;
  final File? image;

  ShoppingList({
    required this.id,
    required this.title,
    required this.description,
    required this.notes,
    this.isFavorite = false,
    required this.userId,
    this.isCompleted = false,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'notes': notes,
      'isFavorite': isFavorite,
      'userId': userId,
      'isCompleted': isCompleted,
      'image': image != null ? base64Encode(image!.readAsBytesSync()) : null, // Преобразование изображения в base64
    };
  }

  static ShoppingList fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      notes: json['notes'],
      isFavorite: json['isFavorite'],
      userId: json['userId'],
      isCompleted: json['isCompleted'],
      image: json['image'] != null ? File.fromRawPath(base64Decode(json['image'])) : null, // Преобразование base64 обратно в файл
    );
  }
}
