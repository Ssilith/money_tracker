class NetworkService {
  static String getApiUrl() {
    const ip =
        String.fromEnvironment('API_IP', defaultValue: 'default_ip_here');
    return "http://$ip:8080";
  }
}
