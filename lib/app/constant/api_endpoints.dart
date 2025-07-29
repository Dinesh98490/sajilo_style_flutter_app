class ApiEndpoints {
  ApiEndpoints._();

    // time
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);


  // For iOS Simulator
  // // static const String serverAddress = "http://localhost:5050";
  // static const String serverAddress = "http://192.168.1.78:5050";
  static const String serverAddress = "http://10.0.2.2:5050";

    // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/auth";

    // authentications
  static const String login = "/login";
  static const String register = "/register";
  static const String updateProfile="$serverAddress/api/auth/me";
  static const String changePassword="$serverAddress/api/auth/change-password";
  static const String getProducts="$serverAddress/api/admin/product";
  static const String getme="$baseUrl/me";
  static const String addorgetcart="$serverAddress/api/customer/cart";
  static const String getcart="$serverAddress/api/customer/cart";
  static const String deletecart="$serverAddress/api/customer/cart";
  static const String updatecart="$serverAddress/api/customer/cart";
  static const String getorders="$serverAddress/api/admin/order";
  static const String createPayment="$serverAddress/api/customer/payment";
  static const String getPayment="$serverAddress/api/customer/payment";

  // static const String getProducts="$serverAddress/api/admin/product";







}