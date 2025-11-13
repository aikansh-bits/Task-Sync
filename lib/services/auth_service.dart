import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  /// Sign up a new user
  Future<String?> signUpUser(String email, String password) async {
    final user = ParseUser(email, password, email);
    final response = await user.signUp();
    if (response.success) {
      return null; // success
    } else {
      return response.error?.message;
    }
  }

  /// Log in existing user
  Future<String?> loginUser(String email, String password) async {
    final user = ParseUser(email, password, null);
    final response = await user.login();
    if (response.success) {
      return null;
    } else {
      return response.error?.message;
    }
  }

  /// Log out current user
  Future<void> logoutUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    await user?.logout();
  }

  /// Check if a user is logged in
  Future<bool> isUserLoggedIn() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    return user != null;
  }

  /// Get current user email
  Future<String?> getCurrentUserEmail() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    return user?.get<String>('email');
  }
}
