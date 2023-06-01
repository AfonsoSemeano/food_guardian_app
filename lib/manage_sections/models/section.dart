import 'package:equatable/equatable.dart';

class Section extends Equatable {
  Section({required this.id, required this.name, required this.index});

  final String id;
  final String name;
  int index;

  @override
  List<Object?> get props => [id, name, index];
}
