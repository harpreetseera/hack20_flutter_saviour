class Location {
  final double lat;
  final double long;

  Location({this.lat, this.long});

  Location.fromJson(Map<String, dynamic> json)
      : this.lat = json['lat'],
        this.long = json['long'];

  Map toJson() => {
        "lat": this.lat,
        "long": this.long,
      };
}
