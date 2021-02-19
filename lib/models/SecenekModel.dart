class SecenekModel {
  String deger;
  bool secildi;

  SecenekModel({this.deger, this.secildi});

  factory SecenekModel.fromMap(Map map) => SecenekModel(
        deger: map['deger'],
        secildi: map['secildi'],
      );

  Map<String, dynamic> toMap() => {
        "deger": this.deger,
        "secildi": this.secildi,
      };
}
