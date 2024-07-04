import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? boy = 0;
  int? kilo = 0;
  double vki = 0.0;
  double su_ihtiyac = 0.0;
  String _imagePath = "images/insan_vucudu.png";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? vkikayit = prefs.getDouble('vki');
    double? sukayit = prefs.getDouble('su');

    print('vki gelen: $vkikayit');
    print('su gelen: $sukayit');

    setState(() {
      vki = vkikayit ?? 0.0; // null check ve varsayılan değer ataması
      su_ihtiyac = sukayit ?? 0.0; // null check ve varsayılan değer ataması
    });

    print('bitti');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('AYARLAR'),
        ),
        body: Center(
          child: Column(
            children: [
              //! Kullanıcıdan veri alma işlemleri için kullanılır.
              //! Kayıt ol, giriş yap sayfalarında sık sık karşımıza çıkar.
              TextField(
                //! İlgili TextFieldin klavyesini otomatik olarak açar
                autofocus: true,
                //! Klavye türünü belirlememizi sağlar.
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (String deger) {
                  boy = int.tryParse(deger);
                  print(
                      'TextFieldden gelen değer onSubmitted boy: ' + '$deger');
                },
                //! İmleç rengini ayarlar.
                cursorColor: Colors.black,
                //! TextFieldin maksimum satır sayısını belirler.
                maxLines: 2,
                //! TextFieldin minimum satır sayısını belirler.
                minLines: 1,
                //! TextFieldin maksimum karakter sayısını belirler.
                maxLength: 3,
                decoration: InputDecoration(
                    //! TextField içerisine ipucu ekler.
                    hintText: 'Boyunuz',
                    border: OutlineInputBorder()),
              ),
              TextField(
                maxLength: 3,
                //! Filtreleme alanlarında kullanılabilir bir özellik.
                // onChanged: (String deger) {
                //   print('TextFieldden gelen değer onChanged: ' + '$deger');
                // },
                onChanged: (String deger) {
                  kilo = int.tryParse(deger);
                  setState(() {
                    kilo = int.tryParse(deger);
                  });
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(
                    //! TextField içerisine ipucu ekler.
                    hintText: 'Kilonuz',
                    border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  onPressed: () {
                    vkiHesapla();
                    gunluksuHesapla();
                    saveData();
                  },
                  child: Text('Hesapla')),
              Text('Vücut Kitle Endeksiniz:' + vki.toString()),
              Text('Günlük Su İhtiyacınız:' + su_ihtiyac.toString()),
              Image.asset(
                decideImage(),
                width: 500,
                height: 400,
              )
            ],
          ),
        ));
  }

  void vkiHesapla() {
    if (boy != null && kilo != null && boy! > 0 && kilo! > 0) {
      setState(() {
        vki = kilo! / ((boy! / 100) * (boy! / 100));
      });
    }
  }

  void gunluksuHesapla() {
    if (kilo != null && kilo! > 0) {
      setState(() {
        su_ihtiyac = kilo! * 0.033;
      });
    }
  }

  String decideImage() {
    if (vki < 18.5) {
      return "images/insan_vucudu.png";
    } else if (vki >= 18.5 && vki < 24.9) {
      return "images/normal_vucut.png";
    } else if (vki >= 25 && vki < 29.9) {
      return "images/hafif_obez.png";
    } else {
      return "images/obez.png";
    }
  }

  void _setImageBasedOnVki(double vki) {
    setState(() {
      if (vki < 18.5) {
        _imagePath = "images/insan_vucudu.png";
      } else if (vki >= 18.5 && vki < 24.9) {
        _imagePath = "images/normal_vucut.png";
      } else if (vki >= 25 && vki < 29.9) {
        _imagePath = "images/hafif_obez.png";
      } else {
        _imagePath = "images/obez.png";
      }
    });
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Double değer kaydetme
    prefs.setDouble('vki', vki);
    print('vki kaydedildi.');
    prefs.setDouble('su', su_ihtiyac);
    print('su kaydedildi.');
  }
}
