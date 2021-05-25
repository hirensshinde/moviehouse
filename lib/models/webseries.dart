class WebSeries {
  int id;
  String title;
  int categoryId;
  String genreId;
  String poster;
  int featured;
  String description;
  List season;

  WebSeries(
      {this.id,
      this.title,
      this.categoryId,
      this.genreId,
      this.poster,
      this.featured,
      this.description,
      this.season});

  // factory WebSeries.fromJson(Map<String, dynamic> json) {

  // }
  factory WebSeries.fromJson(Map<String, dynamic> json) {
    return WebSeries(
        id: json['id'],
        title: json['name'],
        description: json['description'],
        poster: json['image'],
        // downloadLink: json['url'],
        // downloadCount: json['download'],
        featured: json['featured'],
        categoryId: json['category_id'],
        genreId: json['genere_id'],
        season: json['season']);
  }
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
