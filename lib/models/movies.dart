class Movie {
  final int id;
  final String title;
  final String description;
  final String poster;
  final int year;
  final String type;
  final String downloadLink;
  final int downloadCount;
  final int featured;
  final int categoryId;
  final String genreId;
  final List<dynamic> genreList;
  final List<dynamic> language;

  Movie(
      {this.id,
      this.title,
      this.description,
      this.poster,
      this.downloadLink,
      this.downloadCount,
      this.language,
      this.year,
      this.type,
      this.featured,
      this.categoryId,
      this.genreId,
      this.genreList});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['name'],
      description: json['description'],
      poster: json['image'],
      downloadLink: json['url'],
      downloadCount: json['download'],
      year: json['year'],
      type: json['type'],
      language: json['language_name'],
      featured: json['featured'],
      categoryId: json['category_id'],
      genreId: json['generes_id'],
      genreList: json['genere_name'],
    );
  }
}
