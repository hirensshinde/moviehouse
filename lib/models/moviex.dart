class Movie {
  final int id;
  final String title;
  final String description;
  final String poster;
  final int year;
  final String downloadLink;
  final int downloadCount;
  final int featured;
  final int categoryId;
  final List genreId;
  final List genreList;

  Movie(
      {this.id,
      this.title,
      this.description,
      this.poster,
      this.downloadLink,
      this.downloadCount,
      this.year,
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
      featured: json['featured'],
      categoryId: json['category_id'],
      genreId: json['generes_id'],
      genreList: json['genere_name'],
    );
  }
}
