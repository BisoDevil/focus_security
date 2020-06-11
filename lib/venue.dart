// To parse this JSON data, do
//
//     final venue = venueFromJson(jsonString);

import 'dart:convert';

Venue venueFromJson(String str) => Venue.fromJson(json.decode(str));

String venueToJson(Venue data) => json.encode(data.toJson());

class Venue {
  String id;
  String name;
  DateTime date;
  String file;
  double fare;
  String note;

  Venue({this.id, this.name, this.date, this.file, this.fare, this.note});

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        name: json["name"] == null ? null : json["name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        file: json["file"] == null ? null : json["file"],
        fare: json["fare"] == null ? null : json["farse"],
        note: json["note"] == null ? null : json["note"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "date": date == null ? null : date.toIso8601String(),
        "file": file == null ? null : file,
        "farse": fare == null ? null : fare,
        "note": note == null ? null : note,
        "id": id == null ? null : id,
      };
}
