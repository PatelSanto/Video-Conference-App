import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_conference_app/Test/Home.dart';
import 'package:video_conference_app/services/auth_services.dart';
import 'package:video_conference_app/utils/utils.dart';

void main() {
  setup().then((_) {
    runApp(ProviderScope(child: MyApp()));
  });
}

Future<void> setup() async {
  await setupFirebase();
  await registerServices();
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  final AuthService _authService = GetIt.instance.get<AuthService>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: MeetingScreen(),
      // home: _authService.checkLogin(),
    );
  }
}
