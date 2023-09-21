class Member {
  bool selected = false;
  String name, idNumber, telephoneNumber;

  Member({
    required this.name,
    required this.idNumber,
    required this.telephoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'idNumber': idNumber,
      'telephoneNumber': telephoneNumber,
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      idNumber: json['idNumber'],
      telephoneNumber: json['telephoneNumber'],
    );
  }
}
