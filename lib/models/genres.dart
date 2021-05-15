class Genre {
  int id;
  String genre;

  Genre({
    this.id,
    this.genre,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      genre: json['name'],
    );
  }
}
