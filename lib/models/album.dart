class Album {
  final String title;

  Album({
    this.title
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
    );
  }
}
