class AppUser {
  static int? userId;  // Static variable to hold the userId
  static String? username; // Optionally hold the username as well

  // Static setter to set the userId and username globally
  static void setUserId(int id, {String? name}) {
    userId = id;
    username = name;
  }

  // Static getter to retrieve the userId
  static int? getUserId() {
    return userId;
  }

  // Static getter to retrieve the username
  static String? getUsername() {
    return username;
  }

  // Static method to reset user data (for logging out, etc.)
  static void resetUserData() {
    userId = null;
    username = null;
  }

  // Optional: Check if user is logged in (i.e., if userId is not null)
  static bool isLoggedIn() {
    return userId != null;
  }
}
