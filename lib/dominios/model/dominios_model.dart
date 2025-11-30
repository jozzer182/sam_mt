class DomainList {
  List<Domain> list = [];
}

class Domain {
  String domain;
  Domain({required this.domain});
  factory Domain.fromMap(Map<String, dynamic> map) {
    // print('Domain.fromMap: $map');
    return Domain(
      domain: map['dominios'].toString(),
    );
  }

  @override
  String toString() {
    print('Domain.toString: $domain');
    return super.toString();
  }
}
