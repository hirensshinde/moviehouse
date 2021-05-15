class Movie {
  final int id;
  final String title;
  final String description;
  final String poster;
  final String downloadLink;
  final int downloadCount;
  final int featured;
  final int categoryId;
  final String genreId;

  Movie(
      {this.id,
      this.title,
      this.description,
      this.poster,
      this.downloadLink,
      this.downloadCount,
      this.featured,
      this.categoryId,
      this.genreId});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        title: json['name'],
        description: json['description'],
        poster: json['image'],
        downloadLink: json['url'],
        downloadCount: json['download'],
        featured: json['featured'],
        categoryId: json['category_id'],
        genreId: json['generes_id']);
  }
}
