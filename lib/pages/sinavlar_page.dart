import 'package:flutter/material.dart';
import 'package:sampleproject/helpers/sql_sinav_helper.dart';
import 'package:sampleproject/models/SinavModel.dart';
import 'package:sampleproject/pages/sinav_edit_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sampleproject/pages/sinav_yap_page.dart';

class SinavlarPage extends StatefulWidget {
  @override
  _SinavlarPageState createState() => _SinavlarPageState();
}

class _SinavlarPageState extends State<SinavlarPage> {
  List<SinavModel> sinavlar;
  SinavProvider sinavProvider = new SinavProvider();

  @override
  void initState() {
    super.initState();
    this.loadSinavlar();
  }

  void loadSinavlar() async {
    sinavlar = new List<SinavModel>();
    await sinavProvider.open();
    sinavProvider.getAll().then((val) {
      if (val.length > 0)
        setState(() {
          this.sinavlar = val;
        });
      else
        this.sinavlar = new List<SinavModel>();
    });
  }

  void addSinav() {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => SinavEditPage(),
    ))
        .then((d) {
      if (d == true) {
        this.loadSinavlar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sınavlar"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addSinav();
            },
          ),
        ],
      ),
      body: sinavlar != null
          ? sinavlar.length > 0
              ? ListView(
                  children: sinavlar.map((s) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        title: Text(s.sinavAdi),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SinavYapPage(s.id),
                            ),
                          );
                        },
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Düzenle',
                          color: Colors.black45,
                          icon: Icons.edit,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SinavEditPage(sinav: s),
                              ),
                            );
                          },
                        ),
                        IconSlideAction(
                          caption: 'Sil',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            this.sinavProvider.delete(s.id).then((_) {
                              this.loadSinavlar(); 
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                )
              : Center(child: Text('Henüz Boş'))
          : Center(child: Text('Bekleyiniz...')),
    );
  }
}
