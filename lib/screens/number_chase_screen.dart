import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class NumberChaseScreen extends StatefulWidget {
  const NumberChaseScreen({super.key});

  @override
  State<NumberChaseScreen> createState() => _NumberChaseScreenState();
}

class _NumberChaseScreenState extends State<NumberChaseScreen> {
  final int _targetNumber = 20;
  int _currentExpected = 1;
  late List<int> _numbers;
  late DateTime _startTime;
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isPlaying = false;
  bool _won = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _currentExpected = 1;
    _elapsedSeconds = 0;
    _won = false;
    _numbers = List.generate(_targetNumber, (index) => index + 1)..shuffle();
    _isPlaying = true;
    _startTime = DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onNumberTap(int number) {
    if (!_isPlaying || _won) return;

    if (number == _currentExpected) {
      setState(() {
        _currentExpected++;
        if (_currentExpected > _targetNumber) {
          _winGame();
        }
      });
    } else {
      // Wrong number tapped, maybe add a small time penalty or just shake
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Find number $_currentExpected!', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
          backgroundColor: AppTheme.watermelonRed,
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _winGame() {
    _timer?.cancel();
    setState(() {
      _won = true;
      _isPlaying = false;
    });

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
              const Text('⏱️', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                'Speedy!',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: AppTheme.bgDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You chased all numbers in $_elapsedSeconds seconds!',
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
                      Navigator.pop(context); // back to rewards
                    },
                    child: Text('Back', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.peachOrange,
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
                    child: Text('Try Again', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
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
                      '🔢 Number Chase',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: AppTheme.bgDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.mintGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_elapsedSeconds s',
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
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                _won ? 'Great Job!' : 'Find number: $_currentExpected',
                style: GoogleFonts.quicksand(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _won ? AppTheme.mintGreen : AppTheme.watermelonRed,
                ),
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
                  childAspectRatio: 1.0,
                ),
                itemCount: _numbers.length,
                itemBuilder: (context, index) {
                  final number = _numbers[index];
                  final isFound = number < _currentExpected;
                  return GestureDetector(
                    onTap: () => _onNumberTap(number),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: isFound
                            ? LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade400])
                            : const LinearGradient(colors: [AppTheme.peachOrange, AppTheme.bananaYellow]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isFound
                            ? []
                            : [
                                BoxShadow(
                                  color: AppTheme.peachOrange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: GoogleFonts.quicksand(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: isFound ? Colors.grey.shade500 : Colors.white,
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
