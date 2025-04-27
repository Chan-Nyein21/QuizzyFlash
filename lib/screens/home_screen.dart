import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _confirmSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Sign Out"),
            content: const Text("Are you sure you want to sign out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Sign Out"),
              ),
            ],
          ),
    );

    if (shouldSignOut == true) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.school, size: 30),
            SizedBox(width: 8),
            Text("QuizzyFlash"),
          ],
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sign Out",
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Boost your brain power!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose a mode to get started.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            ElevatedButton.icon(
              icon: const Icon(Icons.style, color: Colors.white),
              label: const Text(
                "Flashcard Mode",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pushNamed(context, '/flashcards'),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.quiz, color: Colors.white),
              label: const Text(
                "Quiz Mode",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pushNamed(context, '/topic'),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.today, color: Colors.white),
              label: const Text(
                "Daily Quiz",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pushNamed(context, '/daily'),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.leaderboard, color: Colors.white),
              label: const Text(
                "Leaderboard",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.bookmark, color: Colors.white),
              label: const Text(
                "Favorites",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pushNamed(context, '/favorites'),
            ),

            const Spacer(),

            const Text(
              "Offline. No sign-in. Just fun learning!",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
