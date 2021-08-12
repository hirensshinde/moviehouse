class AdBanner {
  final int categoryId;
  final String image;
  final String link;
  final String button;
  final String title;

  AdBanner({this.categoryId, this.image, this.link, this.button, this.title});

  factory AdBanner.fromJson(Map<String, dynamic> json) {
    return AdBanner(
      categoryId: json['category_id'],
      image: json['file'],
      link: json['link'],
      button: json['button'],
      title: json['title'],
    );
  }
}
