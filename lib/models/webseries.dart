class WebSeries {
  int id;
  String title;
  int categoryId;
  String genreId;
  String poster;
  String banner;
  String type;
  dynamic ratings;
  int featured;
  int year;
  String description;
  List season;
  List genres;
  List language;

  WebSeries(
      {this.id,
      this.title,
      this.categoryId,
      this.genreId,
      this.poster,
      this.banner,
      this.type,
      this.ratings,
      this.year,
      this.featured,
      this.description,
      this.genres,
      this.language,
      this.season});

  // factory WebSeries.fromJson(Map<String, dynamic> json) {

  // }
  factory WebSeries.fromJson(Map<String, dynamic> json) {
    return WebSeries(
      id: json['id'],
      title: json['name'],
      description: json['description'],
      poster: json['image'],
      banner: json['banner_image'] ??
          'https://via.placeholder.com/600x350.png?text=No+Preview+available',
      // downloadLink: json['url'],
      // downloadCount: json['download'],
      featured: json['featured'],
      ratings: json['rating'],
      year: json['year'],
      type: json['type'],
      categoryId: json['category_id'],
      genreId: json['genere_id'],
      season: json['season'],
      genres: json['genere_name'],
      language: json['language_name'] ?? ['No Language'],
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
        "featured": featured,
        "category_id": categoryId,
        "type": type,
        "genere_id": genreId == null ? null : genreId,
        "season": season == null
            ? null
            : List<dynamic>.from(season.map((x) => x.toJson())),
      };
}

class Season {
  int id;
  int webSeriesId;
  String seasonName;
  List parts;

  Season({this.id, this.webSeriesId, this.seasonName, this.parts});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      webSeriesId: json['web_series_id'],
      seasonName: json['name'],
      parts: json['part'],
    );
  }
}

class Part {
  int id;
  int seasonId;
  String partName;
  String downloadLink;

  Part({this.id, this.seasonId, this.partName, this.downloadLink});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['id'],
      seasonId: json['web_series_season_id'],
      partName: json['name'],
      downloadLink: json['link'],
    );
  }
}
