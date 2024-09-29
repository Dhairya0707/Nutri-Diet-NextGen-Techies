import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class newboard extends StatefulWidget {
  const newboard({Key? key}) : super(key: key);

  @override
  _newboardState createState() => _newboardState();
}

class _newboardState extends State<newboard> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  late Future<DocumentSnapshot> _userFuture;
  late Future<DocumentSnapshot> _dailyIntakeFuture;

  @override
  void initState() {
    super.initState();
    _userFuture =
        FirebaseFirestore.instance.collection('users').doc(userId).get();
    _dailyIntakeFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('dailyIntake')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: Future.wait([_userFuture, _dailyIntakeFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData ||
                snapshot.data![0].data() == null ||
                snapshot.data![1].data() == null) {
              return const Center(child: Text('No data available.'));
            }

            final userProfile =
                snapshot.data![0].data() as Map<String, dynamic>;
            final dailyIntake =
                snapshot.data![1].data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${userProfile['name']}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    _buildMacroCard(userProfile, dailyIntake),
                    const SizedBox(height: 24),
                    _buildDailyGoalsCard(userProfile, dailyIntake),
                    const SizedBox(height: 24),
                    _buildQuickActionsCard(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMacroCard(
      Map<String, dynamic> userProfile, Map<String, dynamic> dailyIntake) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Macros',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: dailyIntake['carbIntake'].toDouble(),
                      title: 'Carbs',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: dailyIntake['fatIntake'].toDouble(),
                      title: 'Fats',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: dailyIntake['proteinIntake'].toDouble(),
                      title: 'Protein',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyGoalsCard(
      Map<String, dynamic> userProfile, Map<String, dynamic> dailyIntake) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Goals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildProgressBar('Calories', dailyIntake['calorieIntake'],
                userProfile['dailyCalorieGoal'], Colors.purple),
            const SizedBox(height: 8),
            _buildProgressBar('Carbs', dailyIntake['carbIntake'],
                userProfile['dailyCarbGoal'], Colors.red),
            const SizedBox(height: 8),
            _buildProgressBar('Fats', dailyIntake['fatIntake'],
                userProfile['dailyFatGoal'], Colors.green),
            const SizedBox(height: 8),
            _buildProgressBar('Protein', dailyIntake['proteinIntake'],
                userProfile['dailyProteinGoal'], Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, int current, int goal, Color color) {
    double progress = (current / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $current / $goal'),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionButton(Icons.calculate, 'BMI Calculator', () {
                  // Navigate to BMI Calculator
                }),
                _buildQuickActionButton(Icons.message, 'Nutrition Chat', () {
                  // Navigate to Chatbot
                }),
                _buildQuickActionButton(Icons.restaurant_menu, 'Meal Plan', () {
                  // Navigate to Meal Plan
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: Icon(icon),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
