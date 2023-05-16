import 'package:food_spaces_repository/food_spaces_repository.dart';

class FoodSpace {
  const FoodSpace({
    required this.userOwnerId,
    required this.allItems,
    required this.joinedUsersIds,
    required this.sections,
  });

  final String userOwnerId;
  final List<Item> allItems;
  final List<String> joinedUsersIds;
  final List<Section> sections;
}
