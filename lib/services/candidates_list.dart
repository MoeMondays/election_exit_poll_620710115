class CandidatesList {
  final int number;
  final String title;
  final String firstName;
  final String lastName;

  CandidatesList({
    required this.number,
    required this.title,
    required this.firstName,
    required this.lastName,
  });

  factory CandidatesList.fromJson(Map<String, dynamic> json) {
    return CandidatesList(
      number: json['number'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  @override
  String toString() {
    return 'number: $number, title: $title, firstName: $firstName, lastName: $lastName';
  }
}