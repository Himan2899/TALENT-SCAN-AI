import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header - LEADERBOARD in green bold caps
              Text(
                'LEADERBOARD',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle
              Text(
                'Compete and climb the ranks! Check out the leaderboard to see who\'s leading the pack in the community.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              // Leaderboard List
              Expanded(
                child: ListView(
                  children: [
                    _buildLeaderboardItem(
                      rank: '#1',
                      name: 'ATHLETE A',
                      score: '950',
                      icon: Icons.sports_soccer,
                      iconColor: const Color(0xFF8BC34A),
                      medalIcon: Icons.emoji_events,
                      medalColor: const Color(0xFFFFC107),
                      isGradient: true,
                      gradientColors: [const Color(0xFF6A4C93), const Color(0xFF3E7CB1)],
                      textColor: Colors.white,
                      rankColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboardItem(
                      rank: '#2',
                      name: 'ATHLETE C',
                      score: '870',
                      icon: Icons.sports_tennis,
                      iconColor: const Color(0xFF4CAF50),
                      medalIcon: Icons.circle,
                      medalColor: const Color(0xFF8D6E63),
                      hasBorder: true,
                      borderColor: const Color(0xFF3F51B5),
                      textColor: Colors.black87,
                      rankColor: const Color(0xFF3F51B5),
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboardItem(
                      rank: '#3',
                      name: 'ATHLETE C',
                      score: '850',
                      icon: Icons.sports_basketball,
                      iconColor: const Color(0xFF9C27B0),
                      medalIcon: Icons.circle,
                      medalColor: const Color(0xFFBF360C),
                      hasBorder: true,
                      borderColor: const Color(0xFF9C27B0),
                      textColor: Colors.black87,
                      rankColor: const Color(0xFF9C27B0),
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboardItem(
                      rank: '#4',
                      name: 'ATHLETE D',
                      score: '810',
                      icon: Icons.sports_basketball,
                      iconColor: const Color(0xFFFF5722),
                      textColor: Colors.black87,
                      rankColor: Colors.black87,
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboardItem(
                      rank: '#5',
                      name: 'ATHLETE E',
                      score: '760',
                      icon: Icons.sports_soccer,
                      iconColor: const Color(0xFFE91E63),
                      textColor: Colors.black87,
                      rankColor: Colors.black87,
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboardItem(
                      rank: '#6',
                      name: 'ATHLETE F',
                      score: '730',
                      icon: Icons.sports_football,
                      iconColor: const Color(0xFFFF9800),
                      textColor: Colors.black87,
                      rankColor: Colors.black87,
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

  Widget _buildLeaderboardItem({
    required String rank,
    required String name,
    required String score,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color rankColor,
    IconData? medalIcon,
    Color? medalColor,
    bool isGradient = false,
    List<Color>? gradientColors,
    bool hasBorder = false,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: isGradient && gradientColors != null
            ? LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isGradient ? null : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: hasBorder && borderColor != null
            ? Border.all(color: borderColor, width: 2)
            : null,
        boxShadow: isGradient
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isGradient ? Colors.white.withOpacity(0.2) : Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                rank,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Athlete Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          // Athlete Name
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          // Medal and Score
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (medalIcon != null)
                Icon(
                  medalIcon,
                  color: medalColor ?? Colors.grey,
                  size: 24,
                ),
              const SizedBox(width: 8),
              Text(
                score,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
