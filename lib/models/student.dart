class Guardian {
  String? id; // Tambahkan id untuk UUID dari tabel guardians
  String studentId; // Tambahkan studentId untuk relasi
  String name;
  String relation;
  String address;

  Guardian({
    this.id,
    required this.studentId,
    required this.name,
    required this.relation,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'name': name,
        'relation': relation,
        'address': address,
      };

  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
        id: json['id'],
        studentId: json['student_id'],
        name: json['name'],
        relation: json['relation'],
        address: json['address'],
      );
}

class Student {
  String id;
  String nisn;
  String nama;
  String jenisKelamin;
  String agama;
  String tempatLahir;
  DateTime tanggalLahir;
  String noTelp;
  String nik;
  String jalan;
  String rt;
  String rw;
  String dusun;
  String desa;
  String kecamatan;
  String kabupaten;
  String provinsi;
  String kodePos;

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
        'id': id,
        'nisn': nisn,
        'nama': nama,
        'jenis_kelamin': jenisKelamin,
        'agama': agama,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir.toIso8601String(),
        'no_telp': noTelp,
        'nik': nik,
        'jalan': jalan,
        'rt': rt,
        'rw': rw,
        'dusun': dusun,
        'desa': desa,
        'kecamatan': kecamatan,
        'kabupaten': kabupaten,
        'provinsi': provinsi,
        'kode_pos': kodePos,
      };

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
        jalan: json['jalan'],
        rt: json['rt'],
        rw: json['rw'],
        dusun: json['dusun'],
        desa: json['desa'],
        kecamatan: json['kecamatan'],
        kabupaten: json['kabupaten'],
        provinsi: json['provinsi'],
        kodePos: json['kode_pos'],
      );
}