import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class NewPage2 extends StatefulWidget {
  const NewPage2({super.key});

  @override
  _NewPage2State createState() => _NewPage2State();
}

class _NewPage2State extends State<NewPage2> {
  final String id = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the page initializes
  }

  // Fetch user data from Firebase Firestore
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      setState(() {
        userProfile = snapshot.data() as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProfile == null) {
      return const Center(child: Text('User not found.'));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome text
              Text(
                'Welcome, ${userProfile!['name']}',
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Daily Goals Section
              const Text(
                'Daily Goals:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              _buildGoalCard('Daily Calorie Goal',
                  userProfile!['dailyCalorieGoal'] ?? 2000, 'kcal'),
              _buildGoalCard(
                  'Daily Carb Goal', userProfile!['dailyCarbGoal'] ?? 0, 'g'),
              _buildGoalCard(
                  'Daily Fat Goal', userProfile!['dailyFatGoal'] ?? 0, 'g'),
              _buildGoalCard('Daily Protein Goal',
                  userProfile!['dailyProteinGoal'] ?? 0, 'g'),
              const SizedBox(height: 20),

              // Pie Chart to show daily intake goals
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sections: showingSections(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Meal Tracking Section
              const Text(
                'Meal Tracking:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMealCard('Breakfast', 300, 50, 10, 20),
                    _buildMealCard('Lunch', 600, 80, 20, 40),
                    _buildMealCard('Dinner', 500, 70, 15, 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build goal cards dynamically
  Widget _buildGoalCard(String title, num value, String unit) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              '$value $unit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build meal cards dynamically
  Widget _buildMealCard(
      String mealType, num calories, num carbs, num fats, num protein) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealType,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text('Calories: $calories kcal',
                style: const TextStyle(fontSize: 16)),
            Text('Carbs: $carbs g', style: const TextStyle(fontSize: 16)),
            Text('Fats: $fats g', style: const TextStyle(fontSize: 16)),
            Text('Protein: $protein g', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Method to create pie chart sections
  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        value: userProfile!['dailyProteinGoal'].toDouble(),
        color: Colors.green,
        title: '${userProfile!['dailyProteinGoal']}g',
        titleStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: userProfile!['dailyCarbGoal'].toDouble(),
        color: Colors.blue,
        title: '${userProfile!['dailyCarbGoal']}g',
        titleStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: userProfile!['dailyFatGoal'].toDouble(),
        color: Colors.red,
        title: '${userProfile!['dailyFatGoal']}g',
        titleStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];
  }
}
