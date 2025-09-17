class Guardian {
  String name;
  String relation;
  String address;

  Guardian({
    required this.name,
    required this.relation,
    required this.address,
  });

  // Convert ke Map (snake_case tetap sama karena nama sederhana)
  Map<String, dynamic> toJson() => {
        'name': name,
        'relation': relation,
        'address': address,
      };

  // Factory untuk parsing dari JSON
  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
        name: json['name'],
        relation: json['relation'],
        address: json['address'],
      );
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

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        jalan: json['jalan'],
        rt: json['rt'],
        rw: json['rw'],
        dusun: json['dusun'],
        desa: json['desa'],
        kecamatan: json['kecamatan'],
        kabupaten: json['kabupaten'],
        provinsi: json['provinsi'],
        kodePos: json['kodePos'],
      );
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

  // toJson pakai snake_case agar sesuai DB
  Map<String, dynamic> toJson() => {
        'id': id,
        'nisn': nisn,
        'nama': nama,
        'jenis_kelamin': jenisKelamin,
        'agama': agama,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir.toIso8601String(),
        'no_telp': noTelp,
        'nik': nik,
        'alamat': alamat.toJson(),
        'guardians': guardians.map((g) => g.toJson()).toList(),
      };

  // fromJson juga pakai snake_case
  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        nisn: json['nisn'],
        nama: json['nama'],
        jenisKelamin: json['jenis_kelamin'],
        agama: json['agama'],
        tempatLahir: json['tempat_lahir'],
        tanggalLahir: DateTime.parse(json['tanggal_lahir']),
        noTelp: json['no_telp'],
        nik: json['nik'],
        alamat: Address.fromJson(json['alamat']),
        guardians: (json['guardians'] as List<dynamic>)
            .map((g) => Guardian.fromJson(g as Map<String, dynamic>))
            .toList(),
      );
}