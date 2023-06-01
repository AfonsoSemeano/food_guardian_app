import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

class Item extends Equatable {
  Item({
    required this.id,
    this.image,
    required this.name,
    this.expirationDate,
    this.section,
    required this.quantity,
  });

  final String id;
  final String? image;
  final String name;
  final DateTime? expirationDate;
  final Section? section;
  final int quantity;
  QueryDocumentSnapshot<Map<String, dynamic>>? itemSnapshot;

  @override
  List<Object?> get props =>
      [id, image, name, expirationDate, section, quantity];
}
