class Movie {
  String name;
  String description;

  Movie({this.name, this.description});

  factory Movie.fromJson(Map<String, dynamic> map) {
    return Movie(name: map['name'], description: map['description']);
  }
}
