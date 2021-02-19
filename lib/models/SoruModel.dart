import 'dart:convert';

import 'package:sampleproject/models/SecenekModel.dart';

class SoruModel {
  String soru;
  List<SecenekModel> secenekler;
  String puan;
  String sira;

  SoruModel({
    this.soru,
    this.secenekler,
    this.puan,
    this.sira,
  });

  factory SoruModel.fromMap(Map map) {
    var seceneklerList = List.from(json.decode(map['secenekler']))
        .map((s) => SecenekModel.fromMap(s))
        .toList();
    return SoruModel(
      soru: map['soru'],
      secenekler: seceneklerList,
      puan: map['puan'],
      sira: map['sira'],
    );
  }

  Map<String, dynamic> toMap() {
    List<Map> _secenekler = this.secenekler.map((s) => s.toMap()).toList();
    return {
      "soru": this.soru != null ? this.soru.toString() : '',
      "secenekler": json.encode(_secenekler).toString(),
      "puan": this.puan != null ? this.puan : '',
      "sira": this.sira != null ? this.sira : '',
    };
  }
}