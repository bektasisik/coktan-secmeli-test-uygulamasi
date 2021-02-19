import 'package:flutter/material.dart';
import 'package:sampleproject/helpers/sql_sinav_helper.dart';
import 'package:sampleproject/models/SecenekModel.dart';
import 'package:sampleproject/models/SinavModel.dart';
import 'package:sampleproject/models/SoruModel.dart';

class SinavEditPage extends StatefulWidget {
  final SinavModel sinav;

  const SinavEditPage({Key key, this.sinav}) : super(key: key);
  @override
  _SinavEditPageState createState() => _SinavEditPageState();
}

class _SinavEditPageState extends State<SinavEditPage> {
  SinavProvider sinavProvider = new SinavProvider();
  SinavModel sinavModel = new SinavModel(sorular: List<SoruModel>());
  bool updated = false;

  @override
  void initState() {
    if (widget.sinav != null) {
      this.sinavModel = widget.sinav;
    }
    super.initState();
  }

  void saveSinav() {
    if (widget.sinav == null) {

      this.sinavProvider.open().then((_) {
        this.sinavProvider.add(this.sinavModel).then((sinav) {
          Navigator.of(context).pop(true);
        });
      });
    } else {

      this.sinavProvider.open().then((_) {
        this.sinavProvider.update(this.sinavModel).then((_) {
          updated = true;
          Navigator.of(context).pop(true);
        });
      });
    }
  }

  void soruSil(int index) {
    setState(() {
      sinavModel.sorular.removeAt(index);
    });
  }


  Widget renderSeceneklerArea(List<SecenekModel> secenekler) {
    return Column(
      children: [
        Card(
          child: Column(
            children: secenekler != null
                ? List.generate(secenekler.length, (int i) {
                    return CheckboxListTile(
                      secondary: InkWell(
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          child: Icon(Icons.delete),
                        ),
                        onTap: () {
                          setState(() {
                            secenekler.removeAt(i);
                          });
                        },
                      ),
                      title: TextFormField(
                        decoration:
                            InputDecoration(hintText: 'Şık Değerini Giriniz'),
                        initialValue: secenekler[i].deger != ''
                            ? secenekler[i].deger
                            : '',
                        onChanged: (val) {
                          secenekler[i].deger = val;
                        },
                      ),
                      value: secenekler[i].secildi,
                      onChanged: (val) {
                        setState(() {
                          secenekler[i].secildi = val;
                        });
                      },
                    );
                  }).toList()
                : Text('Şık Ekleyin'),
          ),
        ),
        FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Icon(Icons.add), Text('Şık Ekle')],
          ),
          onPressed: () {
            setState(() {
              secenekler.add(new SecenekModel(deger: '', secildi: false));
            });
          },
        ),
      ],
    );
  }


  Widget renderSorular() {
    return Column(
      children: List.generate(sinavModel.sorular.length, (i) {
        return Card(
          child: ExpansionTile(
            title: Text(sinavModel.sorular[i].soru != null
                ? sinavModel.sorular[i].soru
                : 'Sorunuzu Yazınız'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration:
                            InputDecoration(hintText: 'Sorunuzu Yazınız'),
                        initialValue: sinavModel.sorular[i].soru != null
                            ? sinavModel.sorular[i].soru
                            : '',
                        onChanged: (val) {
                          setState(() {
                            sinavModel.sorular[i].soru = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 50.0,
                      child: FlatButton(
                        child: Icon(Icons.delete),
                        onPressed: () {
                          this.soruSil(i);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              renderSeceneklerArea(sinavModel.sorular[i].secenekler),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.sinav != null ? widget.sinav.sinavAdi : 'Sınav Ekle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Sınav Adı',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Sınav Adını Giriniz'),
                  initialValue: this.sinavModel.sinavAdi != null
                      ? this.sinavModel.sinavAdi
                      : '',
                  onChanged: (val) {
                    setState(() {
                      this.sinavModel.sinavAdi = val;
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Sorular',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
              renderSorular(),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('Soru Ekle'),
                  onPressed: () {
                    setState(() {
                      this.sinavModel.sorular.add(new SoruModel(
                            secenekler: new List<SecenekModel>(),
                          ));
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MaterialButton(
        child: Text('Kaydet'),
        minWidth: double.maxFinite,
        height: 50.0,
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          if (this.sinavModel.sinavAdi != null &&
              this.sinavModel.sinavAdi != "") {
            saveSinav();
          } else {
            print("BOŞ BIRAKMA");
          }
        },
      ),
    );
  }
}
