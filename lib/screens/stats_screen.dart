import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_stats.dart';
import '../services/storage_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<GameStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = StorageService.loadStats();
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
          child: FutureBuilder<GameStats>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final stats = snapshot.data!;
              final winner = stats.husbandPoints > stats.wifePoints
                  ? 'Husband'
                  : stats.wifePoints > stats.husbandPoints
                      ? 'Wife'
                      : 'Tie';

              return SingleChildScrollView(
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
                            'Statistics',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                    ),
                    // Overall Stats
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Overall Statistics',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem('Games', '${stats.totalGames}'),
                                _buildStatItem('Total Points', '${stats.totalPoints}'),
                                _buildStatItem('Challenges', '${stats.challengesCompleted}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Individual Scores
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Individual Scores',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildPlayerScoreCard(
                                  '👨 Husband',
                                  stats.husbandPoints,
                                  Colors.blue.shade400,
                                ),
                                _buildPlayerScoreCard(
                                  '👩 Wife',
                                  stats.wifePoints,
                                  Colors.pink.shade400,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  winner == 'Tie'
                                      ? "💕 It's a Perfect Tie! 💕"
                                      : '👑 $winner is Leading! 👑',
                                  style: GoogleFonts.poppins(
                                    color: Colors.amber.shade300,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Achievements
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Achievements',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            if (stats.totalGames == 0)
                              Text(
                                'No games played yet. Start playing!',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              )
                            else
                              _buildAchievementsList(stats),
                          ],
                        ),
                      ),
                    ),
                    // Clear Data Button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: Colors.grey.shade900,
                              title: Text(
                                'Clear Statistics?',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              content: Text(
                                'This action cannot be undone.',
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await StorageService.clearAllData();
                                    Navigator.pop(context);
                                    setState(() {
                                      _statsFuture = StorageService.loadStats();
                                    });
                                  },
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Clear All Statistics',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.amber.shade300,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerScoreCard(String name, int points, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$points',
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList(GameStats stats) {
    final achievements = <String>[];

    if (stats.totalGames >= 1) achievements.add('🎮 First Game');
    if (stats.totalGames >= 5) achievements.add('🔥 5 Games Played');
    if (stats.totalGames >= 10) achievements.add('⭐ 10 Games Played');
    if (stats.totalPoints >= 100) achievements.add('💯 100 Points');
    if (stats.totalPoints >= 500) achievements.add('🏆 500 Points');
    if (stats.husbandPoints > stats.wifePoints) achievements.add('👨 Husband Leader');
    if (stats.wifePoints > stats.husbandPoints) achievements.add('👩 Wife Leader');
    if (stats.husbandPoints == stats.wifePoints && stats.totalGames > 0) achievements.add('💕 Perfect Balance');

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: achievements
          .map(
            (achievement) => Chip(
              label: Text(
                achievement,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.amber.withOpacity(0.5),
            ),
          )
          .toList(),
    );
  }
}
