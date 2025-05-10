
import 'package:bharat_nxt/Model/HomePage_Model.dart';
import 'package:bharat_nxt/constants/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class DetailsPageBloc extends Bloc<DetailsPageEvent, DetailsPageState> {
  ApiService apiService = ApiService();
  DetailsPageBloc() : super(DetailsPageInitialState()) {
    on<DetailsPageLoadEvent>((event, emit) async {
      emit(DetailsPageLoadingState());
      await apiService.getPostById(event.id).then( (value) {
        HomePageModel? posts = HomePageModel.object();
        if (value != null) {
          posts = HomePageModel.fromJson(value);
          emit(DetailsPageLoadedState( posts: posts));
        } else {
          emit(DetailsPageInitialState());
        }
      });
    });
  }
}


// Event

abstract class DetailsPageEvent {}

class DetailsPageLoadEvent extends DetailsPageEvent {
  int id;
  DetailsPageLoadEvent({required this.id});
}

class DetailsPageRefreshEvent extends DetailsPageEvent {}

// State

abstract class DetailsPageState {}

class DetailsPageInitialState extends DetailsPageState {}

class DetailsPageLoadingState extends DetailsPageState {}

class DetailsPageLoadedState extends DetailsPageState {
  HomePageModel? posts;
  DetailsPageLoadedState({this.posts});
}