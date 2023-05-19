import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class FoodSpacesRepository {
  FoodSpacesRepository({
    CacheClient? cacheClient,
    required String? loggedUserId,
  })  : _cacheClient = cacheClient ?? CacheClient(),
        _loggedUserId = loggedUserId {
    _foodSpaceStreamController = StreamController<FoodSpace?>.broadcast();
  }

  final CacheClient _cacheClient;
  late StreamController<FoodSpace?> _foodSpaceStreamController;
  final String? _loggedUserId;

  Stream<FoodSpace?> get foodSpaceStream => _foodSpaceStreamController.stream;

  Future<void> getAllSections(String userOwnerId) async {
    await FirebaseFirestore.instance.collection('foodSpaces');
  }

  Future<void> storeSections(
      List<Section> newSections, FoodSpace? currentFoodSpace) async {
    if (currentFoodSpace != null) {
      _foodSpaceStreamController
          .add(currentFoodSpace.copyWith(sections: newSections));
      try {
        await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(currentFoodSpace.id)
            .update({
          'sections': newSections
              .map((s) => {'name': s.name, 'index': s.index})
              .toList(),
        });
      } catch (e) {
        _foodSpaceStreamController.add(
            currentFoodSpace.copyWith(sections: currentFoodSpace.sections));
        throw FoodSpacesRepositoryFailure();
      }
    }
  }

  Future<FoodSpace> _fetchFoodSpace(String foodSpaceId) async {
    if (foodSpaceId.isNotEmpty) {
      final foodSpaceFirebase = await FirebaseFirestore.instance
          .collection('foodSpaces')
          .doc(foodSpaceId)
          .get();

      if (foodSpaceFirebase.exists) {
        final foodSpaceData = foodSpaceFirebase.data()!;
        return _buildFoodSpaceOnRawData(foodSpaceFirebase.id, foodSpaceData);
      }
    }
    return await getDefaultFoodSpace();
  }

  Future<FoodSpace> getDefaultFoodSpace() async {
    final foodSpacesCollectionSnap =
        await FirebaseFirestore.instance.collection('foodSpaces').get();
    FoodSpace? foundSpace;
    for (final element in foodSpacesCollectionSnap.docs) {
      final data = element.data();
      final loggedUserId = _loggedUserId;
      if (data['ownerId'] == loggedUserId) {
        return _buildFoodSpaceOnRawData(element.id, data);
      }
    }
    throw FoodSpacesRepositoryFailure(
        'The user doesn\'t have a food space! Make you sure you created one before calling this method.');
  }

  FoodSpace _buildFoodSpaceOnRawData(
      String foodSpaceId, Map<String, dynamic> data) {
    final List<Map<String, dynamic>> rawSections =
        (data['sections'] as List<dynamic>).cast<Map<String, dynamic>>();
    final sections = rawSections
        .map((s) => Section(name: s['name'], index: s['index']))
        .toList();
    final List<Map<String, dynamic>> rawItems =
        (data['items'] as List<dynamic>).cast<Map<String, dynamic>>();
    final items = rawItems.map((i) => Item()).toList();
    return FoodSpace(
      id: foodSpaceId,
      userOwnerId: data['ownerId'],
      allItems: items,
      joinedUsersIds: (data['joinedUsers'] as List<dynamic>).cast<String>(),
      sections: sections,
    );
  }

  Future<void> saveFoodSpaceId(String foodSpaceId) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('currentFoodSpaceId', foodSpaceId);

    final foundFoodspace = await _fetchFoodSpace(foodSpaceId);
    _cacheClient.write(key: 'currentFoodSpace', value: foundFoodspace);

    _foodSpaceStreamController.add(foundFoodspace);
  }

  Future<FoodSpace?> fetchFoodSpace() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final foundString = await sharedPreferences.getString('currentFoodSpaceId');
    FoodSpace foundFoodspace;
    if (foundString != null) {
      foundFoodspace = await _fetchFoodSpace(foundString);
    } else {
      foundFoodspace = await _fetchFoodSpace('');
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

class FoodSpacesRepositoryFactory {
  static FoodSpacesRepository createRepository(String? loggedUserId) {
    return FoodSpacesRepository(loggedUserId: loggedUserId);
  }
}
