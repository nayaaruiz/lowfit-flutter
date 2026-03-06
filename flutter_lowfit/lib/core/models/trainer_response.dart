class Trainer {
  final int id;
  final String name;
  final String surname;
  final String photo;

  Trainer({
    required this.id,
    required this.name,
    required this.surname,
    required this.photo,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      photo: json['photo'] as String,
    );
  }
}