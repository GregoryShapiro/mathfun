import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'sum_master_game.dart';
import '../widgets/language_selector.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t.mainMenuTitle),
        backgroundColor: Colors.purple.shade200,
        foregroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      backgroundColor: Colors.lightBlue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.chooseGame,
              style: const TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                shadows: [
                  Shadow(color: Colors.purple, blurRadius: 15, offset: Offset(0, 0))
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.pink.shade300,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SumMasterGame()),
                );
              },
              child: Text('${t.sumMasterTitle} 🧮'),
            ),
            const SizedBox(height: 20),
            // Place for future games
          ],
        ),
      ),
    );
  }
}
