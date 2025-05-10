import 'package:bharat_nxt/Screens/LikedArticles/LikedArticles_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/HomePage_Model.dart';
import '../DetailsPage/DetailsPage.dart';



class LikedArticles extends StatefulWidget {
  const LikedArticles({super.key});

  @override
  State<LikedArticles> createState() => _LikedArticlesState();
}

class _LikedArticlesState extends State<LikedArticles> {
  LikedArticlesBloc _likedArticlesBloc = LikedArticlesBloc();
  List<HomePageModel> posts = [];

  @override
  void initState() {
    super.initState();
    _likedArticlesBloc = LikedArticlesBloc()..add(LikedArticlesLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(_) => _likedArticlesBloc,
      child: BlocConsumer<LikedArticlesBloc, LikedArticlesState>(
          builder: (context,state){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text('Liked Articles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              body: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 1), () {
                      _likedArticlesBloc.add(LikedArticlesRefreshEvent());
                    });
                  },
              child: PostList(context))
            );
          },
          listener: (context, state) {
            if (state is LikedArticlesLoadingState) {
              CircularProgressIndicator(color: Colors.blueAccent,);
            }
            if (state is LikedArticlesLoadedState) {
              posts = state.posts;
            }
          }
      ),
    );
  }

  Widget PostList(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          child: ListTile(
            title: Text(
              posts[index].title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            subtitle: Text(
              posts[index].body,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detailspage(id: posts[index].id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
