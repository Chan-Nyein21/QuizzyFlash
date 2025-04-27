import 'package:final_exam_app/screens/auth_screen.dart';
import 'package:final_exam_app/screens/daily_quiz_screen.dart';
import 'package:final_exam_app/screens/favorites_screen.dart';
import 'package:final_exam_app/screens/leaderboard_screen.dart';
import 'package:final_exam_app/screens/home_screen.dart';
import 'package:final_exam_app/screens/flashcard_screen.dart';
import 'package:final_exam_app/screens/quiz_screen.dart';
import 'package:final_exam_app/screens/topic_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart'; // This comes from `flutterfire configure`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(QuizzyFlashApp());
}

class QuizzyFlashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizzyFlash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      // 🔐 Show AuthScreen if user not signed in
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.hasData ? const HomeScreen() : const AuthScreen();
        },
      ),
      routes: {
        '/topic': (context) => TopicScreen(),
        '/flashcards': (context) => FlashcardScreen(),
        '/quiz': (context) => QuizScreen(),
        '/leaderboard': (context) => LeaderboardScreen(),
        '/daily': (context) => const DailyQuizScreen(),
        '/favorites': (context) => FavoritesScreen(),
      },
    );
  }
}
