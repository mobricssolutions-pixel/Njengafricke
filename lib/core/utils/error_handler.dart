import 'dart:io';
import 'package:appwrite/appwrite.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    // No internet
    if (error is SocketException) {
      return "No internet connection.\nPlease check your internet settings and try again.";
    }

    // Appwrite exceptions
    if (error is AppwriteException) {
      final message = (error.message ?? "").toLowerCase();

      if (message.contains("socket") ||
          message.contains("failed host lookup") ||
          message.contains("connection") ||
          message.contains("network") ||
          message.contains("timed out")) {
        return "No internet connection.\nPlease check your internet settings and try again.";
      }

      switch (error.code) {
        case 401:
          return "Your session has expired. Please sign in again.";

        case 403:
          return "You don't have permission to perform this action.";

        case 404:
          return "Requested information was not found.";

        case 409:
          return "This record already exists.";

        case 429:
          return "Too many requests. Please wait a moment and try again.";

        case 500:
          return "Server error. Please try again later.";

        default:
          return error.message ?? "Something went wrong.";
      }
    }

    return "Something went wrong. Please try again.";
  }
}