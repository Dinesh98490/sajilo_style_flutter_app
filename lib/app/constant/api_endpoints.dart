class ApiEndpoints {
  ApiEndpoints._();

    // time
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);


  // For iOS Simulator
  // static const String serverAddress = "http://localhost:5050";
  static const String serverAddress = "http://10.0.2.2:5050";

    // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/auth";

    // authentications
  static const String login = "/login";
  static const String register = "/register";
  static const String getProducts="$serverAddress/api/admin/product";







}