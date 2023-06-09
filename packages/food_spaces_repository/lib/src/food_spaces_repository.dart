import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

class FoodSpacesRepository {
  FoodSpacesRepository({
    CacheClient? cacheClient,
  }) : _cacheClient = cacheClient ?? CacheClient() {
    _foodSpaceStreamController = StreamController<FoodSpace?>.broadcast();
  }

  final CacheClient _cacheClient;
  late StreamController<FoodSpace?> _foodSpaceStreamController;
  String? _loggedUserId;

  Stream<FoodSpace?> get foodSpaceStream => _foodSpaceStreamController.stream;

  Future<void> deleteItem(Item item, FoodSpace? currentFoodSpace) async {
    if (currentFoodSpace != null) {
      try {
        if (item.image != null) {
          final storageRef = FirebaseStorage.instance.refFromURL(item.image!);
          await storageRef.delete();
        }
        await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(currentFoodSpace.id)
            .collection('items')
            .doc(item.id)
            .delete();
      } catch (_) {
        throw FoodSpacesRepositoryFailure();
      }
    }
  }

  Future<void> changeItemQuantity(
      Item item, int newQuantity, FoodSpace? currentFoodSpace) async {
    if (currentFoodSpace != null) {
      try {
        await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(currentFoodSpace.id)
            .collection('items')
            .doc(item.id)
            .update({
          'quantity': newQuantity,
        });
      } catch (e) {
        throw FoodSpacesRepositoryFailure();
      }
    }
  }

  // Future<List<Item>> fetchFirstItems(
  //     Section? section, FoodSpace? currentFoodSpace) async {
  //   if (currentFoodSpace != null) {
  //     try {
  //       final firstItemsSnapshots = (await FirebaseFirestore.instance
  //               .collection('foodSpaces')
  //               .doc(currentFoodSpace.id)
  //               .collection('items')
  //               .where('section', isEqualTo: section?.id)
  //               .orderBy('expirationDate')
  //               .limit(15)
  //               .get())
  //           .docs;
  //       final firstItems = firstItemsSnapshots.map((itemSnapshot) {
  //         return Item(
  //             id: itemSnapshot.id,
  //             name: itemSnapshot['name'],
  //             quantity: itemSnapshot['quantity']);
  //       }).toList();
  //       return firstItems;
  //     } catch (_) {
  //       throw FoodSpacesRepositoryFailure();
  //     }
  //   }
  //   throw FoodSpacesRepositoryFailure();
  // }

  Future<List<Item>> fetchMoreItems({
    required Section? section,
    required Item? lastItem,
    required FoodSpace? currentFoodSpace,
  }) async {
    if (currentFoodSpace != null) {
      final ref = FirebaseFirestore.instance
          .collection('foodSpaces')
          .doc(currentFoodSpace.id)
          .collection('items')
          .where('section', isEqualTo: section?.id)
          .orderBy('expirationDate', descending: true);
      List<QueryDocumentSnapshot<Map<String, dynamic>>> itemsSnapshot;
      if (lastItem == null) {
        itemsSnapshot = (await ref.limit(15).get()).docs;
      } else {
        itemsSnapshot = (await ref
                .startAfterDocument(lastItem.itemSnapshot!)
                .limit(15)
                .get())
            .docs;
      }
      final firstItems = itemsSnapshot.mapIndexed((index, itemSnapshot) {
        final item = Item(
            id: itemSnapshot.id,
            name: itemSnapshot['name'],
            expirationDate:
                (itemSnapshot['expirationDate'] as Timestamp?)?.toDate(),
            image: itemSnapshot['image'],
            section: Section(
                id: section?.id ?? '',
                name: section?.name ?? '',
                index: section?.index ?? -1),
            quantity: itemSnapshot['quantity']);
        if (index == 14) {
          item.itemSnapshot = itemSnapshot;
        }
        return item;
      }).toList();
      return firstItems;
    }
    return [];
  }

  Future<void> updateItem(
      Item item, File? newImageFile, FoodSpace? currentFoodSpace) async {
    if (currentFoodSpace != null) {
      try {
        if (item.image != null) {
          final storageRef = FirebaseStorage.instance.refFromURL(item.image!);
          await storageRef.delete();
        }
        String? imageUrl;
        if (newImageFile != null) {
          final imageRef = FirebaseStorage.instance
              .ref()
              .child('products_image')
              .child(currentFoodSpace.id)
              .child('${Uuid().v4()}.jpg');
          await imageRef.putFile(newImageFile).whenComplete(() => null);
          imageUrl = await imageRef.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(currentFoodSpace.id)
            .collection('items')
            .doc(item.id)
            .update({
          'name': item.name,
          'expirationDate': item.expirationDate,
          'section': item.section?.id,
          'image': imageUrl,
          'quantity': item.quantity,
        });
      } catch (_) {
        print('EROR!');
      }
    }
  }

  Future<void> createItem(
      Item newItem, File? imageFile, FoodSpace? currentFoodSpace) async {
    if (currentFoodSpace != null) {
      try {
        String? imageUrl;
        if (imageFile != null) {
          final imageRef = FirebaseStorage.instance
              .ref()
              .child('products_image')
              .child(currentFoodSpace.id)
              .child('${Uuid().v4()}.jpg');
          await imageRef.putFile(imageFile).whenComplete(() => null);
          imageUrl = await imageRef.getDownloadURL();
        }
        String itemId = await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(currentFoodSpace.id)
            .collection('items')
            .doc()
            .id;
        await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(currentFoodSpace.id)
            .collection('items')
            .doc(itemId)
            .set({
          'name': newItem.name,
          'expirationDate': newItem.expirationDate,
          'section': newItem.section?.id,
          'image': imageUrl,
          'quantity': newItem.quantity,
        });
      } catch (_) {}
    }
  }

  Future<void> storeSections(
      List<Section> newSections, FoodSpace? currentFoodSpace) async {
    if (currentFoodSpace != null) {
      _foodSpaceStreamController.add(currentFoodSpace.copyWith(
          sections: newSections
              .map((e) => Section(id: e.id, name: e.name, index: e.index))
              .toList()));
      try {
        await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(currentFoodSpace.id)
            .update({
          'sections': newSections
              .map((s) => {'id': s.id, 'name': s.name, 'index': s.index})
              .toList(),
        });
      } catch (e) {
        _foodSpaceStreamController.add(
            currentFoodSpace.copyWith(sections: currentFoodSpace.sections));
        throw FoodSpacesRepositoryFailure();
      }
    }
  }

  Future<Section> addSection(
      Section newSection, FoodSpace? currentFoodSpace) async {
    if (currentFoodSpace != null) {
      try {
        final newId = Uuid().v4();
        final sectionWithId =
            Section(id: newId, name: newSection.name, index: newSection.index);
        _foodSpaceStreamController.add(currentFoodSpace
            .copyWith(sections: [...currentFoodSpace.sections, sectionWithId]));
        await FirebaseFirestore.instance
            .collection('foodSpaces')
            .doc(currentFoodSpace.id)
            .update({
          'sections': FieldValue.arrayUnion([
            {'id': newId, 'name': newSection.name, 'index': newSection.index}
          ])
        });
        return sectionWithId;
      } catch (_) {
        _foodSpaceStreamController.add(
            currentFoodSpace.copyWith(sections: currentFoodSpace.sections));
        throw FoodSpacesRepositoryFailure();
      }
    }
    throw FoodSpacesRepositoryFailure();
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
    // if there is no default foodSpace, create one.
    if (_loggedUserId != null && _loggedUserId!.isNotEmpty) {
      await createDefaultFoodSpace(_loggedUserId!);
      return getDefaultFoodSpace();
    }
    throw FoodSpacesRepositoryFailure(
        'The user doesn\'t have a food space! Make you sure you created one before calling this method.');
  }

  FoodSpace _buildFoodSpaceOnRawData(
      String foodSpaceId, Map<String, dynamic> data) {
    final List<Map<String, dynamic>> rawSections =
        (data['sections'] as List<dynamic>).cast<Map<String, dynamic>>();
    final sections = rawSections
        .map((s) => Section(id: s['id'], name: s['name'], index: s['index']))
        .toList();
    final List<Map<String, dynamic>> rawItems =
        (data['items'] as List<dynamic>).cast<Map<String, dynamic>>();
    // final items = rawItems.map((i) => Item()).toList();
    return FoodSpace(
      id: foodSpaceId,
      userOwnerId: data['ownerId'],
      allItems: [],
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
          {'id': Uuid().v4(), 'name': 'Fridge', 'index': 0},
          {'id': Uuid().v4(), 'name': 'Freezer', 'index': 1},
          {'id': Uuid().v4(), 'name': 'Pantry', 'index': 2},
          {'id': Uuid().v4(), 'name': 'Spices', 'index': 3},
        ],
      });
    } on FirebaseException catch (_) {
      throw FoodSpacesRepositoryFailure();
    } catch (_) {
      throw FoodSpacesRepositoryFailure();
    }
  }

  void setLoggedUserId(String loggedUserId) {
    this._loggedUserId = loggedUserId;
  }

  // Future<void> updateSectionName(String foodSpaceId, int index) {
  //   try {
  //     final foodSpaceFirebase = await FirebaseFirestore.instance
  //         .collection('foodSpaces')
  //         .doc(foodSpaceId)
  //         .update();
  //   } catch (e) {

  //   }
  // }
}

class FoodSpacesRepositoryFailure implements Exception {
  const FoodSpacesRepositoryFailure(
      [this.message = "An unknown error occurred."]);

  final String message;
}
