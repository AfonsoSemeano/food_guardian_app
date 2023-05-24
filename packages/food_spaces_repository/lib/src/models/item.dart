import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

class Item extends Equatable {
  const Item({
    this.image,
    required this.name,
    this.expirationDate,
    this.section,
    required this.quantity,
  });

  final File? image;
  final String name;
  final DateTime? expirationDate;
  final Section? section;
  final int quantity;

  @override
  List<Object?> get props => [name, expirationDate, section, quantity];
}
