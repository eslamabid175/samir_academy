class AppConstants {
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String coursesCollection = 'courses';
  static const String modulesCollection = 'modules';
  static const String lessonsCollection = 'lessons';
  static const String booksCollection = 'books';
  static const String bookmarksCollection = 'bookmarks';
  static const String notesCollection = 'notes';
  static const String quizzesCollection = 'quizzes';
  static const String questionsCollection = 'questions';
  static const String resultsCollection = 'results';
  static const String profilesCollection = 'profiles';
  static const String achievementsCollection = 'achievements';
  static const String notificationsCollection = 'notifications';
  
  // Firebase Storage Paths
  static const String coursesImagesPath = 'courses/images';
  static const String booksFilesPath = 'books/files';
  static const String profileImagesPath = 'profiles/images';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 12.0;
  static const double largePadding = 24.0;
  static const double defaultElevation = 4.0;
  
  // Error Messages
  static const String networkErrorMessage = 'No internet connection. Please check your network settings.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String authErrorMessage = 'Authentication error. Please login again.';
  static const String unknownErrorMessage = 'An unknown error occurred. Please try again.';
  
  // Success Messages
  static const String loginSuccessMessage = 'You have successfully logged in!';
  static const String registerSuccessMessage = 'Your account has been created successfully!';
  static const String logoutSuccessMessage = 'You have been logged out successfully!';
  static const String bookmarkAddedMessage = 'Bookmark added successfully!';
  static const String noteAddedMessage = 'Note added successfully!';
  static const String quizSubmittedMessage = 'Quiz submitted successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';
  
  // Default Timeout Duration
  static const int timeoutDuration = 30; // in seconds
}
