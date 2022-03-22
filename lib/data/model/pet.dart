class Pet{
  final int id;
  final String name;
  final String IDDivace;

  Pet(this.id, this.name, this.IDDivace);

  Pet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        IDDivace = json['IDDivace'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'IDDivace': IDDivace,
  };
}