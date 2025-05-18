class Config {
  static final Config _instance = Config._internal();
  factory Config() => _instance;
  Config._internal();

  bool isSplashShowed = false;
  AccountType accountType = AccountType.employee;
}

enum AccountType { employee, candidate }