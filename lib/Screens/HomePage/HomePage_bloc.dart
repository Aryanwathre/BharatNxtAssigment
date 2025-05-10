import 'package:bharat_nxt/constants/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/HomePage_Model.dart';


class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  ApiService apiService = ApiService();
  HomePageBloc() : super(HomePageInitialState()) {

    on<HomePageLoadEvent>((event, emit) async {
      emit(HomePageLoadingState());
      await apiService.fetchPosts().then( (value) {
        List<HomePageModel> posts = [];
        if(value.isNotEmpty) {
          posts = List<HomePageModel>.from(value.map((e) => HomePageModel.fromJson(e)));
          emit(HomePageLoadedState( posts: posts));
        } else {
          emit(HomePageErrorState(error: "No Data Found"));
        }
      });
    });

    on<HomePageSearchEvent>((event, emit) async {
      emit(HomePageLoadingState());
      await apiService.fetchPosts().then( (value) {
        List<HomePageModel> posts = [];
        if(value.isNotEmpty) {
          posts = List<HomePageModel>.from(value.map((e) => HomePageModel.fromJson(e)));
          List<HomePageModel> filteredPosts = posts.where((post) => post.title.contains(event.searchText) || post.body.contains(event.searchText)).toList();
          emit(HomePageLoadedState(posts: filteredPosts));
        } else {
          emit(HomePageErrorState(error: "No Data Found"));
        }
      });
    });
  }
}

abstract class HomePageEvent {}


class HomePageLoadEvent extends HomePageEvent {}

class HomePageRefreshEvent extends HomePageEvent {}

class HomePageSearchEvent extends HomePageEvent {
  String searchText;
  HomePageSearchEvent({required this.searchText});
}


abstract class HomePageState {}

class HomePageInitialState extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageLoadedState extends HomePageState {
  List<HomePageModel> posts;
  HomePageLoadedState({required this.posts});
}

class HomePageErrorState extends HomePageState {
  String error;
  HomePageErrorState({required this.error});
}

class HomePageSearchState extends HomePageState {
  List<HomePageModel> posts;
  HomePageSearchState({required this.posts});
}

