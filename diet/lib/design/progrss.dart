// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProgressComparisonWidget extends StatelessWidget {
//   final String userId;
//   final String selectedDate;

//   const ProgressComparisonWidget({
//     Key? key,
//     required this.userId,
//     required this.selectedDate,
//   }) : super(key: key);

//   Future<Map<String, dynamic>> fetchData() async {
//     try {
//       // Fetch daily goals
//       DocumentSnapshot goalsSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('dailyGoals')
//           .doc(userId)
//           .get();

//       // Fetch daily intakes
//       DocumentSnapshot intakeSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('dailyIntakes')
//           .doc(selectedDate)
//           .get();

//       return {
//         'goals': goalsSnapshot.data(),
//         'intake': intakeSnapshot.data(),
//       };
//     } catch (e) {
//       throw Exception('Failed to fetch data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: fetchData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         final data = snapshot.data!;
//         final goals = data['goals'] ?? {};
//         final intake = data['intake'] ?? {};

//         // Provide default values if keys are not present
//         final dailyCalorieGoal = goals['dailyCalorieGoal'] ?? 0;
//         final calorieIntake = intake['calorieIntake'] ?? 0;

//         final dailyCarbGoal = goals['dailyCarbGoal'] ?? 0;
//         final carbIntake = intake['carbIntake'] ?? 0;

//         final dailyFatGoal = goals['dailyFatGoal'] ?? 0;
//         final fatIntake = intake['fatIntake'] ?? 0;

//         final dailyProteinGoal = goals['dailyProteinGoal'] ?? 0;
//         final proteinIntake = intake['proteinIntake'] ?? 0;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Progress Comparison',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             _buildProgressBar(
//               title: 'Calories',
//               goal: dailyCalorieGoal,
//               intake: calorieIntake,
//             ),
//             _buildProgressBar(
//               title: 'Carbs',
//               goal: dailyCarbGoal,
//               intake: carbIntake,
//             ),
//             _buildProgressBar(
//               title: 'Fats',
//               goal: dailyFatGoal,
//               intake: fatIntake,
//             ),
//             _buildProgressBar(
//               title: 'Proteins',
//               goal: dailyProteinGoal,
//               intake: proteinIntake,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildProgressBar({
//     required String title,
//     required int goal,
//     required int intake,
//   }) {
//     // Check if goal is zero to avoid division by zero error
//     if (goal == 0) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('$title: $intake / $goal (Goal not set)'),
//           const SizedBox(
//             height: 10,
//             child: LinearProgressIndicator(
//               value: 0.0,
//               backgroundColor: Colors.grey,
//               color: Colors.red,
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       );
//     }

//     double percentage = (intake / goal).clamp(0.0, 1.0);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('$title: $intake / $goal'),
//         SizedBox(
//           height: 10,
//           child: LinearProgressIndicator(
//             value: percentage,
//             backgroundColor: Colors.grey[300],
//             color: Colors.blue,
//           ),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionProgressWidget extends StatelessWidget {
  final String userId;
  final String selectedDate;

  const NutritionProgressWidget({
    Key? key,
    required this.userId,
    required this.selectedDate,
  }) : super(key: key);

  Future<Map<String, dynamic>> fetchData() async {
    try {
      DocumentSnapshot goalsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyGoals')
          .doc(userId)
          .get();

      DocumentSnapshot intakeSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyIntakes')
          .doc(selectedDate)
          .get();

      return {
        'goals': goalsSnapshot.data(),
        'intake': intakeSnapshot.data(),
      };
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data!;
        final goals = data['goals'] ?? {};
        final intake = data['intake'] ?? {};

        final dailyCarbGoal = goals['dailyCarbGoal'] ?? 0;
        final carbIntake = intake['carbIntake'] ?? 0;
        final dailyFatGoal = goals['dailyFatGoal'] ?? 0;
        final fatIntake = intake['fatIntake'] ?? 0;
        final dailyProteinGoal = goals['dailyProteinGoal'] ?? 0;
        final proteinIntake = intake['proteinIntake'] ?? 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nutrition Progress',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 20),
              _buildNutrientProgress(
                title: 'Carbs',
                goal: dailyCarbGoal,
                intake: carbIntake,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildNutrientProgress(
                title: 'Fats',
                goal: dailyFatGoal,
                intake: fatIntake,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              _buildNutrientProgress(
                title: 'Proteins',
                goal: dailyProteinGoal,
                intake: proteinIntake,
                color: Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutrientProgress({
    required String title,
    required int goal,
    required int intake,
    required Color color,
  }) {
    double percentage = goal > 0 ? (intake / goal).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '$intake / $goal g',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}
