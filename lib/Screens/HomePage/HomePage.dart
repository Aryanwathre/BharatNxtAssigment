import 'package:bharat_nxt/Screens/DetailsPage/DetailsPage.dart';
import 'package:bharat_nxt/Screens/LikedArticles/LikedArticles.dart';
import 'package:bharat_nxt/constants/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/HomePage_Model.dart';
import 'HomePage_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageBloc _homePageBloc = HomePageBloc();
  List<HomePageModel> posts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _homePageBloc = HomePageBloc()..add(HomePageLoadEvent());

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _homePageBloc,
      child: BlocConsumer<HomePageBloc, HomePageState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                actions: [
                  IconButton(
                    icon: const Icon(
                        Icons.favorite,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LikedArticles()));
                    },
                  ),
                ],
                title: const Text(
                  'Bharat Nxt',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(80),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            hintText: "Search by Medicine...",
                            border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),

                        ),
                        onChanged: ((searchQuery){
                          if (searchQuery.length >= 3 || searchQuery.isEmpty) {
                            _homePageBloc..add(HomePageSearchEvent(searchText: searchQuery));
                          }else {
                            setState(() {
                              searchQuery = _searchController.text;
                            });
                          }
                        }),
                      ),
                    ),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1), () {
                    _homePageBloc.add(HomePageRefreshEvent());
                  });
                },
                child:
                (posts.isNotEmpty)
                    ? PostList(context)
                    : Container(),

              ),
            );
          },
          listener: (context, state) {
            if (state is HomePageLoadingState) {
              CircularProgressIndicator(color: Colors.blueAccent);
            }
            if (state is HomePageLoadedState) {
              posts = state.posts;
            }

            if (state is HomePageSearchState){
              posts = state.posts;
            }
          },
      )
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
