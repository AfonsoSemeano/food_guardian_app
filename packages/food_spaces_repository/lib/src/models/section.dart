import 'package:equatable/equatable.dart';

class Section extends Equatable {
  const Section({required this.name, required this.index});
  final String name;
  final int index;

  @override
  List<Object?> get props => [name, index];
}
