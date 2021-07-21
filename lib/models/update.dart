class AppVersion {
  final String link;
  final String version;
  final String about;
  final String siteLink;
  final String imagePath;

  AppVersion(
      {this.link, this.version, this.about, this.imagePath, this.siteLink});

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      link: json['link'],
      version: json['version'],
      about: json['about'],
      siteLink: json['siteLink'],
      imagePath: json['image_path'],
    );
  }
}
