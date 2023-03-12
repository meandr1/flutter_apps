class Place {
  String name;
  String formattedAddress;
  String lat;
  String lon;

  Place(this.name, this.formattedAddress, this.lat, this.lon);

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        json['address_components'][0]['short_name'],
        json['formatted_address'],
        json['geometry']['location']['lat'].toString(),
        json['geometry']['location']['lng'].toString());
  }

  @override
  String toString() {
    return '$name; $formattedAddress; $lat; $lon';
  }

  static Place? fromString(String? strOfInstance) {
    if (strOfInstance != null) {
      final splitted = strOfInstance.split('; ');
      return Place(splitted[0], splitted[1], splitted[2], splitted[3]);
    }
    return null;
  }
}
