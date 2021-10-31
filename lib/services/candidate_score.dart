class CandidatesScore {
  final int number;
  final String title;
  final String firstName;
  final String lastName;
  final int score;

  CandidatesScore({
    required this.number,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.score,
  });

  factory CandidatesScore.fromJson(Map<String, dynamic> json) {
    return CandidatesScore(
      number: json['number'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      score: json['score'],
    );
  }

  @override
  String toString() {
    return 'number: $number, title: $title, firstName: $firstName, lastName: $lastName';
  }
}