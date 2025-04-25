import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/HomePage/Presentation/Bloc/home_event.dart';
import 'package:glitchx_admin/features/HomePage/Presentation/Bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialChoiceChips()) {
    on<SelectedChoiceEvent>((event, emit) {
      emit(SelectedChoiceState(selectedChoice: event.choice));
    });
  }
}
