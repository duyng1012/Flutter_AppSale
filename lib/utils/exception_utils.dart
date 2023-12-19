class ExceptionUtils {

  static String getErrorMessage(Map<String, dynamic> json) {
    // Example: {cod: 404, message: city not found}
    return json["message"] ??= "";
  }
}