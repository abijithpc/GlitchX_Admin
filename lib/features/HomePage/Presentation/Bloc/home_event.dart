abstract class HomeEvent {}

class SelectedChoiceEvent extends HomeEvent {
  final String choice;

  SelectedChoiceEvent({required this.choice});
}
