import 'package:coincap/models/app_config.dart';
import 'package:coincap/pages/home_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  await dotenv.load();
  String baseUrl = dotenv.env['BASE_URL']!;
  String apiKey = dotenv.env['API_KEY']!;

  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(COIN_API_BASE_URL: baseUrl, COIN_API_KEY: apiKey),
  );
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinCap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromRGBO(54, 69, 79, 1),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
