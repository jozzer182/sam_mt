import 'dart:convert';

class PeopleModel {
  List<PeopleBSingle> people = [];

  @override
  String toString() => 'PeopleB(people: $people)';
}

class PeopleBSingle {
  String name;
  String email;
  String mobilePhone;
  PeopleBSingle({
    required this.name,
    required this.email,
    required this.mobilePhone,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'mobilePhone': mobilePhone};
  }

  factory PeopleBSingle.fromMap(Map<String, dynamic> map) {
    return PeopleBSingle(
      name: map['name'].toString(),
      email: map['email'].toString(),
      mobilePhone: map['mobilePhone'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PeopleBSingle.fromJson(String source) =>
      PeopleBSingle.fromMap(json.decode(source));

  List<String> toList() {
    return [name, email, mobilePhone];
  }

  @override
  String toString() =>
      'PeopleBSingle(name: $name, email: $email, mobilePhone: $mobilePhone)';
}
