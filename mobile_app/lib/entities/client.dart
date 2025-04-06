class Client {
  final int? id;
  final String lastName;
  final String firstName;
  final String email;

  Client({
    this.id,
    required this.lastName,
    required this.firstName,
    required this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
    };
  }
}
