import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'controllers/atividades_controller.dart';
import 'repositories/atividade_estudo_repository.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final atividadesBox = await Hive.openBox<dynamic>(
    HiveAtividadeEstudoRepository.boxName,
  );

  runApp(MeuApp(repository: HiveAtividadeEstudoRepository(atividadesBox)));
}

class MeuApp extends StatelessWidget {
  final AtividadeEstudoRepository repository;

  const MeuApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return AtividadesController(repository: repository)
          ..carregarAtividades();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Agenda de Estudos',
        theme: ThemeData(
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F766E),
            primary: const Color(0xFF0F3D5E),
            secondary: const Color(0xFF0F766E),
            tertiary: const Color(0xFFF2B84B),
            surface: Colors.white,
            onSurface: const Color(0xFF172033),
          ),
          scaffoldBackgroundColor: const Color(0xFFF3F6F8),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F3D5E),
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F3D5E),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              side: const BorderSide(color: Color(0xFFD7DEE6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD7DEE6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: const Color(0xFF172033),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
