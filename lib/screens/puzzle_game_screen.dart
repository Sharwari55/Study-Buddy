import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import '../theme/app_theme.dart';

class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  final List<String> _emojis = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
  ];
  
  late List<String> _cards;
  late List<bool> _cardFlipped;
  late List<bool> _cardMatched;
  
  int _previousIndex = -1;
  bool _flipProcessing = false;
  int _moves = 0;
  int _matches = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _cards = [];
    _cards.addAll(_emojis);
    _cards.addAll(_emojis); // duplicate for matching pairs
    _cards.shuffle(Random());
    
    _cardFlipped = List<bool>.filled(_cards.length, false);
    _cardMatched = List<bool>.filled(_cards.length, false);
    
    _previousIndex = -1;
    _flipProcessing = false;
    _moves = 0;
    _matches = 0;
  }

  void _onCardTap(int index) {
    if (_flipProcessing || _cardFlipped[index] || _cardMatched[index]) return;

    setState(() {
      _cardFlipped[index] = true;
    });

    if (_previousIndex == -1) {
      _previousIndex = index;
    } else {
      _moves++;
      _flipProcessing = true;
      
      if (_cards[_previousIndex] == _cards[index]) {
        // Match found!
        setState(() {
          _cardMatched[_previousIndex] = true;
          _cardMatched[index] = true;
        });
        _matches++;
        _previousIndex = -1;
        _flipProcessing = false;
        
        if (_matches == _emojis.length) {
          _showWinDialog();
        }
      } else {
        // No match, flip back after a delay
        Timer(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _cardFlipped[_previousIndex] = false;
              _cardFlipped[index] = false;
            });
            _previousIndex = -1;
            _flipProcessing = false;
          }
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                'You Won!',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: AppTheme.bgDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Great memory! You finished in $_moves moves.',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color(0xFF636E72),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // go back to rewards screen
                    },
                    child: Text(
                      'Back',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.mintGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _initGame();
                      });
                    },
                    child: Text(
                      'Play Again',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '🧩 Puzzle World',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: AppTheme.bgDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.bananaYellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Moves: $_moves',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Game Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _cardMatched[index]
                            ? Colors.transparent
                            : _cardFlipped[index]
                                ? Colors.white
                                : AppTheme.turquoise,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _cardMatched[index]
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          _cardFlipped[index] || _cardMatched[index]
                              ? _cards[index]
                              : '?',
                          style: TextStyle(
                            fontSize: 32,
                            color: _cardFlipped[index]
                                ? Colors.black
                                : Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
