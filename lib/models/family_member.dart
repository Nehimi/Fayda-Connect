class FamilyMember {
  final String id;
  final String name;
  final String relationship;
  final String fin;
  final String? photo;

  FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    required this.fin,
    this.photo,
  });
}
