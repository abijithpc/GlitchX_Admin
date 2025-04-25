abstract class HomeState {}

class InitialChoiceChips extends HomeState {}

class SelectedChoiceState extends HomeState {
  final String selectedChoice;

  SelectedChoiceState({required this.selectedChoice});
}

