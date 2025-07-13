class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final int age;
  final String bio;
  final List<String> photoUrls;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.bio,
    this.photoUrls = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'age': age,
      'bio': bio,
      'photoUrls': photoUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      age: json['age'],
      bio: json['bio'],
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    int? age,
    String? bio,
    List<String>? photoUrls,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}