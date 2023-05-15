part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState(this.tabIndex);

  final int tabIndex;

  HomeState copyWith({
    int? tabIndex,
  }) {
    return HomeState(tabIndex ?? this.tabIndex);
  }

  @override
  List<Object> get props => [tabIndex];
}
