import 'package:equatable/equatable.dart';

class Section extends Equatable {
  Section({required this.name, required this.index});

  final String name;
  int index;

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}
