import 'package:flutter/material.dart';
import 'recording_screen.dart';

class TestSelectionScreen extends StatelessWidget {
  const TestSelectionScreen({Key? key}) : super(key: key);

  final List<TestData> tests = const [
    TestData(
      name: 'Vertical Jump',
      description: 'Measure your maximum vertical leap height',
      icon: Icons.arrow_upward,
      color: Color(0xFF4CAF50),
      duration: '30 seconds',
    ),
    TestData(
      name: 'Shuttle Run',
      description: 'Test your agility and speed over short distances',
      icon: Icons.directions_run,
      color: Color(0xFF2196F3),
      duration: '2 minutes',
    ),
    TestData(
      name: 'Sit-ups',
      description: 'Measure core strength and endurance',
      icon: Icons.fitness_center,
      color: Color(0xFFFF9800),
      duration: '1 minute',
    ),
    TestData(
      name: 'Push-ups',
      description: 'Test upper body strength and endurance',
      icon: Icons.trending_up,
      color: Color(0xFFE91E63),
      duration: '1 minute',
    ),
    TestData(
      name: 'Endurance Run',
      description: 'Cardiovascular fitness assessment',
      icon: Icons.timer,
      color: Color(0xFF9C27B0),
      duration: '12 minutes',
    ),
    TestData(
      name: 'Flexibility Test',
      description: 'Range of motion and flexibility assessment',
      icon: Icons.accessibility,
      color: Color(0xFF00BCD4),
      duration: '5 minutes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildTestGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Assessment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Choose a fitness test to begin',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.8,
        ),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          return _buildTestCard(context, tests[index]);
        },
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, TestData test) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordingScreen(testData: test),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: test.color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: test.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  test.icon,
                  size: 30,
                  color: test.color,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                test.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: test.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                test.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: test.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  test.duration,
                  style: TextStyle(
                    fontSize: 10,
                    color: test.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestData {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String duration;

  const TestData({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.duration,
  });
}
