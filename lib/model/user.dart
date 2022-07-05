//Aida Mumin
//CSC 4360 - Umoja
//July 4, 2022
//Streams of Thoughts

class User {
  final String id;
  final String name;
  final String bio;
  final DateTime? date;

  User({required this.id, required this.name, required this.bio, this.date});

  factory User.fromJson(String id, Map<String, dynamic> data){
    return User(id: id, name: data["Name"], bio: data["Bio"]);
  }

  Map<String,dynamic> toJSON(){
    return{
      "name" : name,
      "bio" : bio,
      "date" : date
    };
  }
}