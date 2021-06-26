class Movie {
  final int id;
  final String title;
  final String description;
  final String poster;
  final int year;
  final dynamic ratings;
  final String type;
  final String downloadLink;
  final int downloadCount;
  final int featured;
  final int categoryId;
  final String genreId;
  final List<dynamic> genreList;
  final List<dynamic> language;
  final String banner;

  Movie(
      {this.id,
      this.title,
      this.description,
      this.poster,
      this.downloadLink,
      this.downloadCount,
      this.language,
      this.year,
      this.ratings,
      this.banner,
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
      banner: json['banner_image'] ??
          'https://via.placeholder.com/600x350.png?text=No+Preview+available',
      ratings: json['rating'],
      year: json['year'],
      type: json['type'],
      language: json['language_name'] ?? ['No Language'],
      featured: json['featured'],
      categoryId: json['category_id'],
      genreId: json['generes_id'],
      genreList: json['genere_name'] ?? ['No Genre'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": title,
        "rating": ratings == null ? null : ratings,
        "year": year,
        "language": language,
        "description": description == null ? null : description,
        "image": poster,
        "url": downloadLink == null ? null : downloadLink,
        "featured": featured,
        "category_id": categoryId,
        "type": type,
        "genere_id": genreId == null ? null : genreId,
      };
}
