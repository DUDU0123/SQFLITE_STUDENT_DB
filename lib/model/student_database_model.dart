import 'dart:typed_data';

class StudentDataBaseModel {
  int? id;
  String? name;
  String? age;
  String? place;
  String? standard;
  Uint8List? profileimage;
  StudentDataBaseModel({
    this.id,
    this.name,
    this.age,
    this.place,
    this.standard,
    this.profileimage,
  });
  

  fromMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['age'] = age;
    mapping['place'] = place;
    mapping['standard'] = standard;
    mapping['profileimage'] = profileimage;
    return mapping;
  }
}
