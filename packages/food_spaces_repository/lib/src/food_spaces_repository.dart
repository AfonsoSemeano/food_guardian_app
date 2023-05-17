import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class FoodSpacesRepository {
  FoodSpacesRepository({CacheClient? cacheClient})
      : _cacheClient = cacheClient ?? CacheClient() {
    _foodSpaceStreamController = StreamController<FoodSpace?>.broadcast();
  }

  final CacheClient _cacheClient;
  late StreamController<FoodSpace?> _foodSpaceStreamController;

  Stream<FoodSpace?> get foodSpaceStream => _foodSpaceStreamController.stream;

  Future<void> getAllSections(String userOwnerId) async {
    await FirebaseFirestore.instance.collection('foodSpaces');
  }

  Future<FoodSpace> _fetchFoodSpace(
      String foodSpaceId, String loggedUserId) async {
    final foodSpaceFirebase = await FirebaseFirestore.instance
        .collection('foodSpaces')
        .doc(foodSpaceId)
        .get();

    if (foodSpaceFirebase.exists) {
      final foodSpaceData = foodSpaceFirebase.data()!;
      return _buildFoodSpaceOnRawData(foodSpaceFirebase.id, foodSpaceData);
    } else {
      final foodSpacesCollectionSnap =
          await FirebaseFirestore.instance.collection('foodSpaces').get();
      FoodSpace? foundSpace;
      for (final element in foodSpacesCollectionSnap.docs) {
        final data = element.data();
        if (data['ownerId'] == loggedUserId) {
          return _buildFoodSpaceOnRawData(element.id, data);
        }
      }
      throw FoodSpacesRepositoryFailure(
          'The user doesn\'t have a food space! Make you sure you created one before calling this method.');
    }
  }

  FoodSpace _buildFoodSpaceOnRawData(
      String foodSpaceId, Map<String, dynamic> data) {
    final List<Map<String, dynamic>> rawSections = data['sections'];
    final sections = rawSections
        .map((s) => Section(name: s['name'], index: s['index']))
        .toList();
    final List<Map<String, dynamic>> rawItems = data['items'];
    final items = rawItems.map((i) => Item()).toList();
    return FoodSpace(
      id: foodSpaceId,
      userOwnerId: data['ownerId'],
      allItems: items,
      joinedUsersIds: data['joinedUsers'],
      sections: sections,
    );
  }

  Future<void> saveFoodSpaceId(String foodSpaceId, String? loggedUserId) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('currentFoodSpaceId', foodSpaceId);

    if (loggedUserId == null || loggedUserId.isEmpty) {
      _foodSpaceStreamController.add(null);
      _cacheClient.write(key: 'currentFoodSpace', value: '');
      return;
    }
    final foundFoodspace = await _fetchFoodSpace(foodSpaceId, loggedUserId);
    _cacheClient.write(key: 'currentFoodSpace', value: foundFoodspace);

    _foodSpaceStreamController.add(foundFoodspace);
  }

  Future<FoodSpace?> fetchFoodSpace(String loggedUserId) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final foundString = await sharedPreferences.getString('currentFoodSpaceId');
    FoodSpace foundFoodspace;
    if (foundString != null) {
      foundFoodspace = await _fetchFoodSpace(foundString, loggedUserId);
    } else {
      foundFoodspace = await _fetchFoodSpace('', loggedUserId);
    }
    _cacheClient.write(key: 'currentFoodSpaceId', value: foundFoodspace);
    _foodSpaceStreamController.add(foundFoodspace);

    return foundFoodspace;
  }

  Future<void> createDefaultFoodSpace(String loggedUserId) async {
    try {
      final foodSpacesRef = FirebaseFirestore.instance.collection('foodSpaces');
      final newFoodSpaceRef = foodSpacesRef.doc();

      await newFoodSpaceRef.set({
        'ownerId': loggedUserId,
        'items': [],
        'joinedUsers': [],
        'sections': [
          {'name': 'Fridge', 'index': 0},
          {'name': 'Freezer', 'index': 1},
          {'name': 'Pantry', 'index': 2},
          {'name': 'Spices', 'index': 3},
        ],
      });
    } on FirebaseException catch (_) {
      throw FoodSpacesRepositoryFailure();
    } catch (_) {
      throw FoodSpacesRepositoryFailure();
    }
  }
}

class FoodSpacesRepositoryFailure implements Exception {
  const FoodSpacesRepositoryFailure(
      [this.message = "An unknown error occurred."]);

  final String message;
}
