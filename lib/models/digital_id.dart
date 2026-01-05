class DigitalID {
  final String fullName;
  final String fin;
  final String dob;
  final String gender;
  final String issueDate;
  final String expiryDate;
  final String photo; // URL or Base64

  DigitalID({
    required this.fullName,
    required this.fin,
    required this.dob,
    required this.gender,
    required this.issueDate,
    required this.expiryDate,
    required this.photo,
  });
}
