class Dflcl {
  List<DflclSingle> list = [];
  Dflcl();
}

class DflclSingle {
  String id = '';
  String df;
  String lcl;
  String actualizado;

  DflclSingle({required this.df, required this.lcl, required this.actualizado});

  factory DflclSingle.fromMap(Map<String, dynamic> map) {
    return DflclSingle(
      df: map['df'].toString(),
      lcl: map['lcl'].toString(),
      actualizado: map['actualizado'].toString(),
    )..id = map['id'].toString();
  }

  Map<String, dynamic> toMap() {
    return {'df': df, 'lcl': lcl, 'actualizado': actualizado, 'id': id};
  }

  DflclSingle copyWith({String? df, String? lcl, String? actualizado}) {
    return DflclSingle(
      df: df ?? this.df,
      lcl: lcl ?? this.lcl,
      actualizado: actualizado ?? this.actualizado,
    )..id = this.id;
  }
}
