import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodSpacesRepository {
  FoodSpacesRepository({CacheClient? cacheClient})
      : _cacheClient = cacheClient ?? CacheClient();

  final CacheClient _cacheClient;

  Future<void> getAllSections(String userOwnerId) async {
    await FirebaseFirestore.instance.collection('foodSpaces');
  }

  Future<void> saveFoodSpaceId(String foodSpaceId) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('currentFoodSpaceId', foodSpaceId);

    _cacheClient.write(key: 'currentFoodSpaceId', value: foodSpaceId);
  }

  Future<String?> getFoodSpaceId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final foundString = sharedPreferences.getString('currentFoodSpaceId');

    _cacheClient.write<String>(
        key: 'currentFoodSpaceId', value: foundString ?? '');
    return foundString;
  }

  Future<void> createDefaultFoodSpace(String userOwnerId) async {
    try {
      final foodSpacesRef = FirebaseFirestore.instance.collection('foodSpaces');
      final newFoodSpaceRef = foodSpacesRef.doc();

      await newFoodSpaceRef.set({
        'ownerId': userOwnerId,
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
