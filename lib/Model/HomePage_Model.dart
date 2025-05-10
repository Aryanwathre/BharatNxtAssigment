
class HomePageModel{
  int userId;
  int id;
  String title;
  String body;

  HomePageModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) {
    return HomePageModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  factory HomePageModel.object(){
    return HomePageModel(
      userId: 0,
      id: 0,
      title: '',
      body: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}