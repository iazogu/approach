import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _usersKey = 'all_users';

  // Get current logged-in user
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
    return null;
  }

  // Save current user to local storage
  Future<void> _saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Get all users from local storage
  Future<List<User>> _getAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      if (usersJson != null) {
        final List<dynamic> usersList = jsonDecode(usersJson);
        return usersList.map((json) => User.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting all users: $e');
    }
    return [];
  }

  // Save all users to local storage
  Future<void> _saveAllUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((user) => user.toJson()).toList();
    await prefs.setString(_usersKey, jsonEncode(usersJson));
  }

  // Sign up new user
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required int age,
    required String bio,
  }) async {
    try {
      // Check if user already exists
      final users = await _getAllUsers();
      if (users.any((user) => user.email == email)) {
        throw Exception('User with this email already exists');
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        password: password, // In production, hash this!
        name: name,
        age: age,
        bio: bio,
        createdAt: DateTime.now(),
      );

      // Save to users list
      users.add(newUser);
      await _saveAllUsers(users);

      // Set as current user
      await _saveCurrentUser(newUser);

      return newUser;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Sign in existing user
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final users = await _getAllUsers();
      final user = users.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Invalid email or password'),
      );

      await _saveCurrentUser(user);
      return user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign out current user
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Update user profile
  Future<User?> updateProfile(User updatedUser) async {
    try {
      final users = await _getAllUsers();
      final index = users.indexWhere((user) => user.id == updatedUser.id);
      if (index != -1) {
        users[index] = updatedUser;
        await _saveAllUsers(users);
        await _saveCurrentUser(updatedUser);
        return updatedUser;
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
    return null;
  }
}