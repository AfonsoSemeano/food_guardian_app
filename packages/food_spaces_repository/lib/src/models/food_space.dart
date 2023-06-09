import 'package:equatable/equatable.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';

class FoodSpace extends Equatable {
  const FoodSpace({
    required this.id,
    required this.userOwnerId,
    required this.allItems,
    required this.joinedUsersIds,
    required this.sections,
  });

  final String id;
  final String userOwnerId;
  final List<Item> allItems;
  final List<String> joinedUsersIds;
  final List<Section> sections;

  @override
  List<Object?> get props =>
      [id, userOwnerId, allItems, joinedUsersIds, sections];

  FoodSpace copyWith({
    String? id,
    String? userOwnerId,
    List<Item>? allItems,
    List<String>? joinedUsersIds,
    List<Section>? sections,
  }) {
    return FoodSpace(
        id: id ?? this.id,
        userOwnerId: userOwnerId ?? this.userOwnerId,
        allItems: allItems ?? this.allItems,
        joinedUsersIds: joinedUsersIds ?? this.joinedUsersIds,
        sections: sections ?? this.sections);
  }
}
