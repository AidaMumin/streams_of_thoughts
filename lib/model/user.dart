//Aida Mumin
//CSC 4360 - Umoja
//June 29, 2022
//Streams of Thoughts

class User {
  final String name;
  final String bio;
  final DateTime? date;

  User({required this.name, required this.bio, this.date});
  factory User.fromJson(Map<String,dynamic> data){
    return User(name: data["name"], bio: data["bio"]);
  }

  Map<String,dynamic> toJSON(){
    return{
      "name" : name,
      "bio" : bio,
      "date" : date
    };
  }
}