import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:equatable/equatable.dart';

enum Gender { male, female, nonBinary, none }

extension GenderExtension on Gender {
  String get name {
    return toString().split('.').last;
  }
}

class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.birthdayDate,
    this.gender,
  });

  final String id;
  final String? email;
  final String? name;
  final DateTime? birthdayDate;
  final Gender? gender;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, email, name, birthdayDate, gender];

  static User fromSnapshotAndFirebaseUser(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      firebase_auth.User firebaseUser) {
    final data = snapshot.data();
    if (data == null) {
      return User.empty;
    }
    final newUser = User(
      id: snapshot.id,
      email: firebaseUser.email,
      name: data['name']?.toString(),
      birthdayDate: (data['birthdayDate'] as Timestamp?)?.toDate(),
      gender: _findGender(data['gender']?.toString()),
    );
    return newUser;
  }

  static Gender _findGender(String? name) {
    if (Gender.male.name == name) {
      return Gender.male;
    } else if (Gender.female.name == name) {
      return Gender.female;
    } else if (Gender.nonBinary.name == name) {
      return Gender.nonBinary;
    } else {
      return Gender.none;
    }
  }
}
