import 'dart:convert';

import 'package:bharat_nxt/Model/HomePage_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DetailsPage_bloc.dart';



class Detailspage extends StatefulWidget {
  final int id;
  const Detailspage({super.key, required this.id});

  @override
  State<Detailspage> createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  DetailsPageBloc _detailspageBloc = DetailsPageBloc();
  HomePageModel posts = HomePageModel.object();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _detailspageBloc = DetailsPageBloc()..add(DetailsPageLoadEvent(id: widget.id));
    checkIfLiked(widget.id.toString());
  }

  Future<void> checkIfLiked(String articleId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedJsonList = prefs.getStringList('liked_articles') ?? [];

    List<HomePageModel> likedArticles = likedJsonList.map((jsonStr) {
      try {
        return HomePageModel.fromJson(jsonDecode(jsonStr));
      } catch (e) {

        return null;
      }
    }).whereType<HomePageModel>().toList();

    setState(() {
      isLiked = likedArticles.any((article) => article.id.toString() == articleId);
    });
  }



  Future<void> toggleLike(HomePageModel article) async {
    final prefs = await SharedPreferences.getInstance();
    final likedJsonList = prefs.getStringList('liked_articles') ?? [];

    List<HomePageModel> likedArticles = likedJsonList.map((jsonStr) {
      try {
        return HomePageModel.fromJson(jsonDecode(jsonStr));
      } catch (e) {

        return null;
      }
    }).whereType<HomePageModel>().toList();

    final isAlreadyLiked = likedArticles.any((a) => a.id == article.id);

    setState(() {
      if (isAlreadyLiked) {
        likedArticles.removeWhere((a) => a.id == article.id);
        isLiked = false;
      } else {
        likedArticles.add(article);
        isLiked = true;
      }
    });

    final updatedJsonList =
    likedArticles.map((a) => jsonEncode(a.toJson())).toList();

    await prefs.setStringList('liked_articles', updatedJsonList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_)=> _detailspageBloc,
      child: BlocConsumer<DetailsPageBloc, DetailsPageState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                toggleLike(posts);
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.white,
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Details Page',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.blueAccent,
            ),
            body: Container(
              padding: const EdgeInsets.all(8),
              child: state is DetailsPageLoadedState
                  ? Column(
                children: [
                  Text(
                    posts.title,
                    style: TextStyle(
                        fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    posts.body,
                    style: TextStyle(
                        fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              )
                  : const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          );
        },
        listener: (context, state) {
          if (state is DetailsPageLoadingState) {
            CircularProgressIndicator(color: Colors.blueAccent,);
          }
          if (state is DetailsPageLoadedState) {
            posts = state.posts!;
          }
        },
      ),
    );
  }
}
