import 'dart:convert';
import 'package:sampleproject/models/SoruModel.dart';

class SinavModel {
  int id;
  String sinavAdi;
  String bitisTarihi;
  List<SoruModel> sorular;

  SinavModel({
    this.id,
    this.sinavAdi,
    this.bitisTarihi,
    this.sorular,
  });

  factory SinavModel.fromMap(Map map) {
    var sorularList = List.from(json.decode(map['sorular']))
        .map((soru) => SoruModel.fromMap(soru))
        .toList();
    SinavModel s = SinavModel(
      id: map['id'],
      sinavAdi: map['sinavAdi'],
      bitisTarihi: map['bitisTarihi'],
      sorular: sorularList,
    );
    print(s);
    return s;
  }

  Map<String, dynamic> toMap() {
    List<Map> _sorular = this.sorular.map((s) => s.toMap()).toList();
    return {
      "sinavAdi": this.sinavAdi != null ? this.sinavAdi : '',
      "bitisTarihi": this.bitisTarihi != null ? this.bitisTarihi : '',
      "sorular": json.encode(_sorular),
    };
  }
}
