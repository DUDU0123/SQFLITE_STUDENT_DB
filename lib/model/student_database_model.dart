class StudentDataBaseModel {
  int? id;
  String? name;
  String? age;
  String? place;
  String? standard;
  String? profileImage;
  

  fromMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['age'] = age;
    mapping['place'] = place;
    mapping['standard'] = standard;
    mapping['profileimage'] = profileImage;
    return mapping;
  }
}
