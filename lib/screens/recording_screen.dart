import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'ai_analysis_screen.dart';
import 'test_selection_screen.dart';

class RecordingScreen extends StatefulWidget {
  final TestData testData;

  const RecordingScreen({Key? key, required this.testData}) : super(key: key);

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _isAnalyzing = false;
  int _countdown = 3;
  Timer? _timer;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  late AnimationController _pulseController;
  late AnimationController _analyzeController;
  late AnimationController _mlOverlayController;
  
  // Instructions and popup states
  List<String> _instructions = [];
  int _currentInstructionIndex = 0;
  bool _showInstruction = false;
  
  // ML Detection points for stick figure
  List<Offset> _jointPositions = [];
  bool _showMLOverlay = false;
  bool _isFullBodyDetected = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupInstructions();
    _generateMockJoints();
    // Show initial instruction after a short delay
    Timer(const Duration(seconds: 1), _showInstructionPopup);
  }

  void _initializeControllers() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _analyzeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _mlOverlayController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  void _setupInstructions() {
    switch (widget.testData.name) {
      case 'Vertical Jump':
        _instructions = [
          'Position yourself in the center of the camera view',
          'Stand with feet shoulder-width apart',
          'Keep your full body visible in the frame',
          'Prepare for vertical jump motion',
          'Jump as high as you can when recording starts'
        ];
        break;
      case 'Shuttle Run':
        _instructions = [
          'Position yourself sideways to the camera',
          'Ensure you have 10 meters of clear space',
          'Mark your start and end points',
          'Stay within the camera frame during the run',
          'Get ready to start your shuttle run'
        ];
        break;
      default:
        _instructions = [
          'Position yourself in the center of the camera view',
          'Keep your full body visible',
          'Ensure good lighting conditions',
          'Prepare for your exercise',
          'Get ready to begin'
        ];
    }
  }

  void _generateMockJoints() {
    // Generate larger stick figure joint positions (frozen, no movement)
    final center = Offset(200, 350); // Moved down and centered
    
    _jointPositions = [
      center + const Offset(0, -120), // Head (bigger spacing)
      center + const Offset(0, -80),  // Neck
      center + const Offset(-50, -50), // Left shoulder (wider)
      center + const Offset(50, -50),  // Right shoulder
      center,                          // Center torso
      center + const Offset(-60, 30),  // Left elbow (wider)
      center + const Offset(60, 30),   // Right elbow
      center + const Offset(-80, 90),  // Left hand (wider)
      center + const Offset(80, 90),   // Right hand
      center + const Offset(-30, 100), // Left hip (wider)
      center + const Offset(30, 100),  // Right hip
      center + const Offset(-35, 180), // Left knee (longer legs)
      center + const Offset(35, 180),  // Right knee
      center + const Offset(-40, 260), // Left ankle (longer legs)
      center + const Offset(40, 260),  // Right ankle
    ];
  }

  void _showInstructionPopup() {
    if (_currentInstructionIndex < _instructions.length) {
      setState(() {
        _showInstruction = true;
      });

      Timer(const Duration(seconds: 3), () {
        setState(() {
          _showInstruction = false;
          _currentInstructionIndex++;
        });

        if (_currentInstructionIndex < _instructions.length) {
          Timer(const Duration(milliseconds: 500), _showInstructionPopup);
        } else {
          // All instructions shown, enable ML overlay
          setState(() {
            _showMLOverlay = true;
            _isFullBodyDetected = true;
          });
        }
      });
    }
  }

  void _startRecording() {
    setState(() {
      _countdown = 3;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown == 0) {
        timer.cancel();
        _beginRecording();
      }
    });
  }

  void _beginRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
      _showMLOverlay = true;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });

      // Auto stop after 30 seconds for demo
      if (_recordingSeconds >= 30) {
        _stopRecording();
      }
    });

    // Start mock ML detection (but keep it frozen)
    _startMLDetectionAnimations();
  }

  void _startMLDetectionAnimations() {
    // REMOVED: Animation timer that was moving joints
    // The stick figure is now static and frozen
    
    // Optional: You can add a one-time detection success animation
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isFullBodyDetected = true; // Trigger detection success
        });
      }
    });
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    
    setState(() {
      _isRecording = false;
      _isAnalyzing = true;
      _showMLOverlay = false;
    });

    _analyzeController.forward();

    // Simulate AI analysis
    Timer(const Duration(seconds: 3), () {
      _navigateToResults();
    });
  }

  void _navigateToResults() {
    // Generate mock AI results
    final random = Random();
    final results = AIAnalysisResult(
      testName: widget.testData.name,
      overallScore: 75 + random.nextInt(20),
      performanceMetrics: _generateMockMetrics(),
      improvements: _generateMockImprovements(),
      chartData: _generateMockChartData(),
      detailedAnalysis: {
        'notes': 'Analysis completed successfully.',
        'strengths': 'Excellent explosive power and form consistency.',
        'speed': 'Strong reaction time and acceleration patterns detected.',
        'recovery': 'Good recovery indicators with room for improvement.',
        'confidenceScore': 87.5,
        'recommendation': 'Focus on endurance training while maintaining current strength levels.',
        'biomechanics': 'Optimal joint angles and movement patterns observed.',
        'comparison': 'Above average performance for age group.',
        'areas_for_improvement': ['Flexibility', 'Cardiovascular endurance', 'Balance'],
        'predicted_potential': 'High athletic potential with proper training regimen.',
      },
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AIAnalysisScreen(results: results),
      ),
    );
  }

  Map<String, double> _generateMockMetrics() {
    final random = Random();
    switch (widget.testData.name) {
      case 'Vertical Jump':
        return {
          'Height': 40 + random.nextInt(20).toDouble(),
          'Form Score': 80 + random.nextInt(15).toDouble(),
          'Consistency': 75 + random.nextInt(20).toDouble(),
        };
      case 'Shuttle Run':
        return {
          'Speed': 85 + random.nextInt(10).toDouble(),
          'Agility': 78 + random.nextInt(15).toDouble(),
          'Endurance': 82 + random.nextInt(13).toDouble(),
        };
      default:
        return {
          'Strength': 80 + random.nextInt(15).toDouble(),
          'Endurance': 75 + random.nextInt(20).toDouble(),
          'Form': 85 + random.nextInt(10).toDouble(),
        };
    }
  }

  List<String> _generateMockImprovements() {
    return [
      'Focus on maintaining proper form throughout the exercise',
      'Increase the explosive power in your movements',
      'Work on consistency between repetitions',
      'Consider strength training to improve performance',
    ];
  }

  List<double> _generateMockChartData() {
    final random = Random();
    return List.generate(10, (index) => 70 + random.nextInt(25).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            _buildMockCameraPreview(),
            _buildHeader(),
            if (_showMLOverlay) _buildMLOverlay(),
            if (_showInstruction) _buildInstructionPopup(),
            if (_countdown > 0 && !_isRecording && !_isAnalyzing)
              _buildCountdownOverlay(),
            if (_isAnalyzing) _buildAnalyzingOverlay(),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildMockCameraPreview() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f0f23),
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam,
              color: Colors.white54,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              'MOCK CAMERA VIEW',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '(Demo Mode)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white30,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.testData.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.testData.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (_isRecording)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(_pulseController.value),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_recordingSeconds}s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMLOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: MLDetectionPainter(
          joints: _jointPositions,
          isDetected: _isFullBodyDetected,
        ),
      ),
    );
  }

  Widget _buildInstructionPopup() {
    if (_currentInstructionIndex >= _instructions.length) return const SizedBox();

    return Positioned(
      bottom: 150,
      left: 20,
      right: 20,
      child: AnimatedOpacity(
        opacity: _showInstruction ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF4dabf7).withOpacity(0.95),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Position Instruction',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _instructions[_currentInstructionIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Center(
                    child: Text(
                      '$_countdown',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _analyzeController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _analyzeController.value * 2 * 3.14159,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF4dabf7), width: 4),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        size: 50,
                        color: Color(0xFF4dabf7),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'AI Analysis in progress...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Processing your performance data',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!_isRecording && !_isAnalyzing)
            FloatingActionButton.extended(
              onPressed: _startRecording,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.videocam),
              label: const Text('Start Recording'),
            )
          else if (_isRecording)
            FloatingActionButton.extended(
              onPressed: _stopRecording,
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.stop),
              label: const Text('Stop Recording'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordingTimer?.cancel();
    _pulseController.dispose();
    _analyzeController.dispose();
    _mlOverlayController.dispose();
    super.dispose();
  }
}

// Custom painter for ML detection overlay
class MLDetectionPainter extends CustomPainter {
  final List<Offset> joints;
  final bool isDetected;

  MLDetectionPainter({
    required this.joints,
    required this.isDetected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (joints.isEmpty) return;

    // Main stick figure paint with thick lines
    final paint = Paint()
      ..color = isDetected ? Colors.green : Colors.red
      ..strokeWidth = 8.0  // Much thicker lines for visibility
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Joint circles paint
    final jointPaint = Paint()
      ..color = isDetected ? Colors.green : Colors.red
      ..style = PaintingStyle.fill;

    // White border paint for joints
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Define connections between joints to form stick figure
    final connections = [
      [0, 1], // head to neck
      [1, 2], [1, 3], // neck to shoulders
      [2, 5], [3, 6], // shoulders to elbows
      [5, 7], [6, 8], // elbows to hands
      [1, 4], // neck to center torso
      [4, 9], [4, 10], // center to hips
      [9, 11], [10, 12], // hips to knees
      [11, 13], [12, 14], // knees to ankles
    ];

    // Draw skeleton connections with thick lines
    for (final connection in connections) {
      if (connection[0] < joints.length && connection[1] < joints.length) {
        canvas.drawLine(joints[connection[0]], joints[connection[1]], paint);
      }
    }

    // Draw joints as large circles with borders
    for (final joint in joints) {
      // Draw main joint circle
      canvas.drawCircle(joint, 15.0, jointPaint); // Large radius for visibility
      
      // Draw white border around joint
      canvas.drawCircle(joint, 15.0, borderPaint);
    }

    // Draw detection status text with enhanced styling
    final textPainter = TextPainter(
      text: TextSpan(
        text: isDetected ? 'FULL BODY DETECTED ✓' : 'POSITION YOURSELF',
        style: TextStyle(
          color: isDetected ? Colors.green : Colors.orange,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          shadows: [
            Shadow(
              color: Colors.black87,
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    // Position text at bottom with padding
    textPainter.paint(
      canvas, 
      Offset(20, size.height - 120)
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Frozen diagram - no repainting needed
  }
}
