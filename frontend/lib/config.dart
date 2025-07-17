enum AppEnvironment { development, production }

class AppConfig {
  static late final AppEnvironment environment;

  static void init(AppEnvironment env) {
    environment = env;
  }

  static String get baseUrl {
    switch (environment) {
      case AppEnvironment.production:
        return "https://desmanche-connect-540750841500.southamerica-east1.run.app/v1/";
      case AppEnvironment.development:
        return "http://localhost:3000/v1/";
    }
  }

  static Duration get requestTimeout => const Duration(seconds: 10);
}
