enum AppEnvironment { development, production }

class AppConfig {
  static late final AppEnvironment environment;

  static void init(AppEnvironment env) {
    environment = env;
  }

  static String get baseUrl {
    switch (environment) {
      case AppEnvironment.production:
        return "https://placeholder.com/api";
      case AppEnvironment.development:
        return "http://localhost:3000";
    }
  }

  static Duration get requestTimeout => const Duration(seconds: 10);
}
