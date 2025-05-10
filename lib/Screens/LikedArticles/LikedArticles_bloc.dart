import 'dart:convert';

import 'package:bharat_nxt/constants/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/HomePage_Model.dart';



class LikedArticlesBloc extends Bloc<LikedArticlesEvent, LikedArticlesState> {

  LikedArticlesBloc() : super(LikedArticlesInitialState()) {
    on<LikedArticlesLoadEvent>((event, emit) async {
      try {
        emit(LikedArticlesLoadingState());

        final prefs = await SharedPreferences.getInstance();
        final likedJsonList = prefs.getStringList('liked_articles') ?? [];

        List<HomePageModel> likedArticles = likedJsonList
            .map((jsonStr) => HomePageModel.fromJson(jsonDecode(jsonStr)))
            .toList();

        emit(LikedArticlesLoadedState(posts: likedArticles));
      } catch (e) {
        emit(LikedArticlesErrorState(error: e.toString()));
      }
    });
  }
}


//Event

abstract class LikedArticlesEvent {}

class LikedArticlesLoadEvent extends LikedArticlesEvent {}

class LikedArticlesRefreshEvent extends LikedArticlesEvent {}

//State

abstract class LikedArticlesState {}

class LikedArticlesInitialState extends LikedArticlesState {}

class LikedArticlesLoadingState extends LikedArticlesState {}

class LikedArticlesLoadedState extends LikedArticlesState {
  List<HomePageModel> posts;
  LikedArticlesLoadedState({required this.posts });
}

class LikedArticlesErrorState extends LikedArticlesState {
  final String error;

  LikedArticlesErrorState({required this.error});
}