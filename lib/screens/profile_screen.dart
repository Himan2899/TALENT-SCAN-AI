import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final int tests;
  final int rank;
  final double score;
  final Map<String, String> personalBests;

  const ProfileScreen({
    Key? key,
    this.name = 'Athlete Name',
    this.email = 'athlete@example.com',
    this.tests = 24,
    this.rank = 4,
    this.score = 85.0,
    this.personalBests = const {
      'Vertical Jump': '45 cm',
      'Shuttle Run': '12,5 sec',
      'Sit-ups': '35 reps',
      'Push-ups': '28 reps',
    },
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7DD3FC), Color(0xFFBAE6FD)], // Light blue gradient
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            
            // Avatar with lime gradient
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFBEF264), Color(0xFF84CC16)], // Lime gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.person, size: 65, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            
            // Name
            Text(
              name,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            
            // Email
            Text(
              email,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(tests.toString(), 'Tests'),
                  _buildStatItem('#$rank', 'Rank'),
                  _buildStatItem('${score.toInt()}%', 'Score'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Curved bottom container
            Expanded(
              child: ClipPath(
                clipper: _CurvedNotchClipper(),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFE2F4F6), // Light blue-gray
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Bests Section
                      Text(
                        'Personal Bests',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Personal Bests List
                      ...personalBests.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              Text(
                                entry.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      
                      const SizedBox(height: 35),
                      
                      // Achievements Section
                      Text(
                        'Achievements',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Achievement Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _AchievementBadge(
                            icon: Icons.emoji_events,
                            label: 'First Test',
                            backgroundColor: Color(0xFFF97316), // Orange
                          ),
                          _AchievementBadge(
                            icon: Icons.local_fire_department,
                            label: '10 Day Streak',
                            backgroundColor: Color(0xFF3B82F6), // Blue
                          ),
                          _AchievementBadge(
                            icon: Icons.star,
                            label: 'High Score',
                            backgroundColor: Color(0xFFFBBF24), // Yellow
                          ),
                          _AchievementBadge(
                            icon: Icons.trending_up,
                            label: 'Improvement',
                            backgroundColor: Color(0xFF0EA5E9), // Light Blue
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const _AchievementBadge({
    Key? key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 35,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CurvedNotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Start from top-left
    path.moveTo(0, 0);
    
    // Draw to the start of the notch
    path.lineTo(size.width * 0.35, 0);
    
    // Create the curved notch at the top center
    path.quadraticBezierTo(
      size.width * 0.5, // Control point X (center)
      50, // Control point Y (depth of notch)
      size.width * 0.65, // End point X
      0, // End point Y
    );
    
    // Continue to top-right
    path.lineTo(size.width, 0);
    
    // Draw the right side
    path.lineTo(size.width, size.height);
    
    // Draw the bottom
    path.lineTo(0, size.height);
    
    // Close the path
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
