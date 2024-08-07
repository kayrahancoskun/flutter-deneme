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
  String? isim = "";
  String? soyisim = "";
  int? yas = 0;
  String _imagePath = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? vkikayit = prefs.getDouble('vki');
    double? sukayit = prefs.getDouble('su');
    isim = prefs.getString('isim');
    soyisim = prefs.getString('soyisim');
    yas = prefs.getInt('yas');

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              //! Kullanıcıdan veri alma işlemleri için kullanılır.
              //! Kayıt ol, giriş yap sayfalarında sık sık karşımıza çıkar.
              TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                onChanged: (String deger) {
                  isim = deger;
                  print('TextFieldden gelen değer onChanged isim: $deger');
                },
                cursorColor: Colors.black,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Adınız',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.text,
                onChanged: (String deger) {
                  soyisim = deger;
                  print('TextFieldden gelen değer onChanged soyisim: $deger');
                },
                cursorColor: Colors.black,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Soyadınız',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (String deger) {
                  yas = int.tryParse(deger);
                  print('TextFieldden gelen değer onChanged yas: $deger');
                },
                cursorColor: Colors.black,
                maxLines: 1,
                maxLength: 3,
                decoration: InputDecoration(
                  hintText: 'Yaşınız',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

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
              SizedBox(height: 16),
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
              Text('Vücut Kitle Endeksiniz:' + vki.toStringAsFixed(2)),
              Text('Günlük Su İhtiyacınız:' + su_ihtiyac.toStringAsFixed(2)),
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
    if (vki < 1) {
      return "images/elmali_turta4.png";
    }
    if (vki < 18.5) {
      return "images/zayif.png";
    } else if (vki >= 18.5 && vki < 24.9) {
      return "images/normal.png";
    } else if (vki >= 25 && vki < 29.9) {
      return "images/kilolu.png";
    } else {
      return "images/obEZZ.png";
    }
  }

  void _setImageBasedOnVki(double vki) {
    setState(() {
      if (vki < 18.5) {
        _imagePath = "images/zayif.png";
      } else if (vki >= 18.5 && vki < 24.9) {
        _imagePath = "images/normal.png";
      } else if (vki >= 25 && vki < 29.9) {
        _imagePath = "images/kilolu.png";
      } else {
        _imagePath = "images/obEZZ.png";
      }
    });
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isim', isim ?? '');
    print('isim kaydedildi.');

    prefs.setString('soyisim', soyisim ?? '');
    print('soyad kaydedildi.');

    prefs.setInt('yas', yas ?? 0);
    print('yas kaydedildi.');

    prefs.setInt('boy', boy ?? 0);
    print('boy kaydedildi.');

    prefs.setInt('kilo', kilo ?? 0);
    print('kilo kaydedildi.');

    // Double değer kaydetme
    prefs.setDouble('vki', vki);
    print('vki kaydedildi.');
    prefs.setDouble('su', su_ihtiyac);
    print('su kaydedildi.');
    prefs.setDouble('icilen_su', 0.0);
    print('icilen_su kaydedildi.');

    DateTime now = DateTime.now();
    prefs.setString('tarih', now.toString());

    void resetDailyData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime now = DateTime.now();
      DateTime lastReset = DateTime.tryParse(prefs.getString('last_reset')!) ??
          now.subtract(Duration(days: 1));

      if (lastReset.day != now.day) {
        // Günlük sıfırlama işlemleri
        prefs.setInt('su_icildi', 0); // Örneğin su içme sayacı
        prefs.setBool(
            'exceeded_limit_today', false); // Günlük limit aşım kontrolü

        // Son sıfırlama tarihini güncelle
        await prefs.setString('last_reset', now.toIso8601String());
        print(lastReset);
        saveData();
      }
    }
  }
}
