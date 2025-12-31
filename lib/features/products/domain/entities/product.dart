import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String location;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFeatured;
  final Map<String, dynamic>? specifications;
  
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.location,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isFeatured = false,
    this.specifications,
  });
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    category,
    location,
    imageUrl,
    createdAt,
    updatedAt,
    isFeatured,
    specifications,
  ];
  
  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? location,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFeatured,
    Map<String, dynamic>? specifications,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFeatured: isFeatured ?? this.isFeatured,
      specifications: specifications ?? this.specifications,
    );
  }
}
