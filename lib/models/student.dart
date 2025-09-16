class Guardian {
  String name;
  String relation;
  String address;
  Guardian({required this.name, required this.relation, required this.address});

  Map<String, dynamic> toJson() => {
        'name': name,
        'relation': relation,
        'address': address,
      };
}

class Address {
  String jalan;
  String rt;
  String rw;
  String dusun;
  String desa;
  String kecamatan;
  String kabupaten;
  String provinsi;
  String kodePos;

  Address({
    required this.jalan,
    required this.rt,
    required this.rw,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
  });

  Map<String, dynamic> toJson() => {
        'jalan': jalan,
        'rt': rt,
        'rw': rw,
        'dusun': dusun,
        'desa': desa,
        'kecamatan': kecamatan,
        'kabupaten': kabupaten,
        'provinsi': provinsi,
        'kodePos': kodePos,
      };
}

class Student {
  String id; // unique in-memory id
  String nisn;
  String nama;
  String jenisKelamin;
  String agama;
  String tempatLahir;
  DateTime tanggalLahir;
  String noTelp;
  String nik;
  Address alamat;
  List<Guardian> guardians;

  Student({
    required this.id,
    required this.nisn,
    required this.nama,
    required this.jenisKelamin,
    required this.agama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.noTelp,
    required this.nik,
    required this.alamat,
    required this.guardians,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nisn': nisn,
        'nama': nama,
        'jenisKelamin': jenisKelamin,
        'agama': agama,
        'tempatLahir': tempatLahir,
        'tanggalLahir': tanggalLahir.toIso8601String(),
        'noTelp': noTelp,
        'nik': nik,
        'alamat': alamat.toJson(),
        'guardians': guardians.map((g) => g.toJson()).toList(),
      };
}
