import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../data/challenges_data.dart';
import '../models/challenge.dart';
import '../models/game_stats.dart';
import '../services/storage_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Challenge> challenges;
  Challenge? currentChallenge;
  GameStats gameStats = GameStats();
  bool isHusbandTurn = true;
  String currentPlayer = 'Husband';
  int roundNumber = 1;

  @override
  void initState() {
    super.initState();
    challenges = List.from(romanticChallenges)..shuffle();
    _loadStats();
    _getNextChallenge();
  }

  Future<void> _loadStats() async {
    gameStats = await StorageService.loadStats();
    setState(() {});
  }

  void _getNextChallenge() {
    if (challenges.isEmpty) {
      _showGameOverDialog();
      return;
    }

    setState(() {
      currentChallenge = challenges.removeAt(0);
      currentPlayer = isHusbandTurn ? 'Husband' : 'Wife';
    });
  }

  void _acceptChallenge() {
    if (currentChallenge != null) {
      gameStats.addPoints(currentChallenge!.points, isHusbandTurn);
      _saveStats();

      setState(() {
        isHusbandTurn = !isHusbandTurn;
        roundNumber++;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        _getNextChallenge();
      });
    }
  }

  void _skipChallenge() {
    setState(() {
      isHusbandTurn = !isHusbandTurn;
      roundNumber++;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      _getNextChallenge();
    });
  }

  Future<void> _saveStats() async {
    gameStats.incrementGames();
    await StorageService.saveStats(gameStats);
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          '🎉 Game Over!',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Final Scores',
              style: GoogleFonts.poppins(
                color: Colors.pink.shade200,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '👨',
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${gameStats.husbandPoints}',
                      style: GoogleFonts.poppins(
                        color: Colors.blue.shade300,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '👩',
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${gameStats.wifePoints}',
                      style: GoogleFonts.poppins(
                        color: Colors.pink.shade300,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              gameStats.husbandPoints > gameStats.wifePoints
                  ? '👨 Husband Wins!'
                  : gameStats.wifePoints > gameStats.husbandPoints
                      ? '👩 Wife Wins!'
                      : "It's a Tie! 💕",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Back to Home', style: TextStyle(color: Colors.pink)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: Text('Play Again', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      challenges = List.from(romanticChallenges)..shuffle();
      gameStats = GameStats();
      isHusbandTurn = true;
      roundNumber = 1;
    });
    _getNextChallenge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.shade900,
              Colors.pink.shade900,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Round $roundNumber',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${challenges.length} left',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Scores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildScoreCard(
                      '👨 Husband',
                      gameStats.husbandPoints,
                      isHusbandTurn,
                    ),
                    _buildScoreCard(
                      '👩 Wife',
                      gameStats.wifePoints,
                      !isHusbandTurn,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Challenge Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildChallengeCard(),
                ),
              ),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _skipChallenge,
                        icon: Icon(Icons.skip_next),
                        label: Text('Skip'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade700,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _acceptChallenge,
                        icon: Icon(Icons.check_circle),
                        label: Text('Done'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(String player, int points, bool isActive) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            player,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$points',
            style: GoogleFonts.poppins(
              color: Colors.amber.shade300,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard() {
    if (currentChallenge == null) {
      return Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final difficultyColor = currentChallenge!.difficulty == 'light'
        ? Colors.green
        : currentChallenge!.difficulty == 'medium'
            ? Colors.amber
            : Colors.red;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Difficulty Badge
          Chip(
            label: Text(
              currentChallenge!.difficulty.toUpperCase(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: difficultyColor.withOpacity(0.7),
          ),
          // Type Badge
          Chip(
            label: Text(
              currentChallenge!.type.toUpperCase(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: currentChallenge!.type == 'truth'
                ? Colors.blue.withOpacity(0.7)
                : Colors.pink.withOpacity(0.7),
          ),
          // Question
          Text(
            currentChallenge!.question,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Points
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '+${currentChallenge!.points} Points',
              style: GoogleFonts.poppins(
                color: Colors.amber.shade300,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
