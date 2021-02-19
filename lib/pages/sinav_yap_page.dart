import 'package:flutter/material.dart';
import 'package:sampleproject/helpers/sql_sinav_helper.dart';
import 'package:sampleproject/models/SecenekModel.dart';
import 'package:sampleproject/models/SinavModel.dart';
import 'package:sampleproject/models/SoruModel.dart';

class SinavYapPage extends StatefulWidget {
  final int sinavId;
  const SinavYapPage(this.sinavId, {Key key}) : super(key: key);
  @override
  _SinavYapPageState createState() => _SinavYapPageState();
}

class _SinavYapPageState extends State<SinavYapPage> {
  SinavProvider sinavProvider = new SinavProvider();
  SinavModel sinavModel = new SinavModel(sorular: List<SoruModel>());
  bool isLoad = false;
  List<SoruModel> cevaplar = new List<SoruModel>();
  bool endExam = false;
  int allAnswerCount = 0;

  @override
  void initState() {
    this.loadSinav();
    super.initState();
  }

  void loadSinav() {
    setState(() {
      isLoad = false;
    });
  
    this.sinavProvider.open().then((_) {
      this.sinavProvider.getOne(widget.sinavId).then((sinav) {
        if (sinav.sorular != null && sinav.sorular.length > 0) {
          sinav.sorular.forEach((soru) {
            List<SecenekModel> _secenekler = new List<SecenekModel>();
            soru.secenekler.forEach((c) {
              _secenekler
                  .add(new SecenekModel(deger: c.deger, secildi: c.secildi));
            });
            SoruModel _soru = new SoruModel(
              sira: soru.sira,
              puan: soru.puan,
              soru: soru.soru,
              secenekler: _secenekler,
            );
            cevaplar.add(_soru);

          });
        }
        setState(() {
          this.sinavModel = sinav;
        
          this.sinavModel.sorular.forEach((s) {
            s.secenekler.forEach((e) => e.secildi = false);
          });
          isLoad = true;
        });
      }).catchError((err) {
        print(err);
        setState(() {
          isLoad = true;
        });
      });
    });
  }

  
  Widget renderSeceneklerArea(List<SecenekModel> secenekler) {
    return Column(
      children: [
        Column(
          children: secenekler != null
              ? secenekler
                  .map(
                    (c) => CheckboxListTile(
                      title: Text(c.deger.toString()),
                      value: c.secildi,
                      onChanged: (val) {
                        setState(() {
                          c.secildi = val;
                        });
                      },
                    ),
                  )
                  .toList()
              : Text('Şık Ekleyin'),
        ),
      ],
    );
  }

  Widget renderSoruItem(SoruModel soru) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(soru.soru != null ? soru.soru : 'Sorunuzu Yazınız'),
        children: [
          renderSeceneklerArea(soru.secenekler),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(isLoad ? this.sinavModel.sinavAdi : widget.sinavId.toString()),
      ),
      body: isLoad
          ? endExam 
              ? // Sınav Sonucu
              Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Toplam",
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        this.cevaplar.length.toString(),
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "sorudan",
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        this.allAnswerCount.toString(),
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "doğru yaptınız !",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                )
              :
              // Sınav Soruları
              SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Column(
                          children: this
                              .sinavModel
                              .sorular
                              .map((s) => renderSoruItem(s))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: endExam
          ? SizedBox()
          : MaterialButton(
              child: Text('Bitir'),
              minWidth: double.maxFinite,
              height: 50.0,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                puanHesapla();
              },
            ),
    );
  }

  void puanHesapla() {
    for (var i = 0; i < this.cevaplar.length; i++) {
      int answer = 0;

      for (var s = 0; s < this.cevaplar[i].secenekler.length; s++) {
        if (this.cevaplar[i].secenekler[s].secildi ==
            this.sinavModel.sorular[i].secenekler[s].secildi) {
          answer++;
        }
      }

      if (answer == this.cevaplar[i].secenekler.length) {
        this.allAnswerCount++;
      }
    }

    setState(() {
      endExam = true;
    });
  }
}
