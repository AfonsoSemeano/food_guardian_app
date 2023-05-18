import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class FoodSpacesRepository {
  FoodSpacesRepository(
      {CacheClient? cacheClient,
      required AuthenticationRepository authenticationRepository})
      : _cacheClient = cacheClient ?? CacheClient(),
        _authenticationRepository = authenticationRepository {
    _foodSpaceStreamController = StreamController<FoodSpace?>.broadcast();
  }

  final CacheClient _cacheClient;
  late StreamController<FoodSpace?> _foodSpaceStreamController;
  final AuthenticationRepository _authenticationRepository;

  Stream<FoodSpace?> get foodSpaceStream => _foodSpaceStreamController.stream;

  Future<void> getAllSections(String userOwnerId) async {
    await FirebaseFirestore.instance.collection('foodSpaces');
  }

  Future<void> storeSections(List<Section> newSections) async {
    FoodSpace? newestFoodSpace = await foodSpaceStream.last;
    if (newestFoodSpace != null) {
      _foodSpaceStreamController
          .add(newestFoodSpace.copyWith(sections: newSections));
      try {
        await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(newestFoodSpace.id)
            .update({
          'sections': newSections
              .map((s) => {'name': s.name, 'index': s.index})
              .toList(),
        });
      } catch (e) {
        _foodSpaceStreamController
            .add(newestFoodSpace.copyWith(sections: newestFoodSpace.sections));
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
      final loggedUserId = (await _authenticationRepository.user.last).id;
      if (data['ownerId'] == loggedUserId) {
        return _buildFoodSpaceOnRawData(element.id, data);
      }
    }
    throw FoodSpacesRepositoryFailure(
        'The user doesn\'t have a food space! Make you sure you created one before calling this method.');
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
