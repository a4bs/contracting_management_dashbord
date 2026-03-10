class AppApi {
  static const String login = 'login';
  static OwnerApi ownerApi = OwnerApi();
}

class OwnerApi {
  String get fullReport => '/owner-reports/full-report';
}
