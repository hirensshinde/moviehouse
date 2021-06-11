class Banners {
  int id;
  String banner;

  Banners({this.id, this.banner});

  factory Banners.fromJson(Map<String, dynamic> json) {
    return Banners(id: json['id'], banner: json['image']);
  }
}
