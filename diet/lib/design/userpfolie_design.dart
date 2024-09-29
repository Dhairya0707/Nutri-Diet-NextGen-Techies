// ignore_for_file: use_build_context_synchronously, camel_case_types, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet/design/homepage_design.dart';
import 'package:diet/pages/call/gemini_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:diet/home/homepage.dart';

class userpfolie_design extends StatefulWidget {
  const userpfolie_design({Key? key}) : super(key: key);

  @override
  _userpfolie_designState createState() => _userpfolie_designState();
}

class _userpfolie_designState extends State<userpfolie_design> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _healthConditionsController =
      TextEditingController();

  String _gender = 'Male';
  String _dietaryPreference = 'None';
  String _healthGoal = 'Weight Loss';
  String _activityLevel = 'Sedentary';

  final String _weightUnit = 'kg';
  final String _heightUnit = 'cm';

  List<String> dietaryPreferences = [
    'None',
    'Vegetarian',
    'Vegan',
    'Paleo',
    'Keto'
  ];
  List<String> healthGoals = ['Weight Loss', 'Muscle Gain', 'Maintenance'];
  List<String> activityLevels = ['Sedentary', 'Active', 'Very Active'];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        title: const Text(
          'Create Your Nutrition Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Personal Information'),
              const SizedBox(height: 16),
              _buildTextField(_nameController, 'Name', Icons.person),
              const SizedBox(height: 16),
              _buildTextField(_ageController, 'Age', Icons.cake,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildGenderSelection(),
              const SizedBox(height: 24),
              _buildSectionTitle('Body Metrics'),
              const SizedBox(height: 16),
              _buildMetricField(_weightController, 'Weight', _weightUnit,
                  Icons.fitness_center),
              const SizedBox(height: 16),
              _buildMetricField(
                  _heightController, 'Height', _heightUnit, Icons.height),
              const SizedBox(height: 24),
              _buildSectionTitle('Dietary Preferences'),
              const SizedBox(height: 16),
              _buildChipSelection(
                'Dietary Preference',
                dietaryPreferences,
                _dietaryPreference,
                (String? value) => setState(() => _dietaryPreference = value!),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Health Goals'),
              const SizedBox(height: 16),
              _buildChipSelection(
                'Health Goal',
                healthGoals,
                _healthGoal,
                (String? value) => setState(() => _healthGoal = value!),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Activity Level'),
              const SizedBox(height: 16),
              _buildChipSelection(
                'Activity Level',
                activityLevels,
                _activityLevel,
                (String? value) => setState(() => _activityLevel = value!),
              ),
              const SizedBox(height: 24),
              _buildTextField(_healthConditionsController,
                  'Health Conditions (Optional)', Icons.medical_services),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }

  Widget _buildMetricField(TextEditingController controller, String label,
      String unit, IconData icon) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          unit,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        const Text('Gender:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        ChoiceChip(
          label: const Text('Male'),
          selected: _gender == 'Male',
          onSelected: (bool selected) {
            setState(() {
              _gender = 'Male';
            });
          },
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Female'),
          selected: _gender == 'Female',
          onSelected: (bool selected) {
            setState(() {
              _gender = 'Female';
            });
          },
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Other'),
          selected: _gender == 'Other',
          onSelected: (bool selected) {
            setState(() {
              _gender = 'Other';
            });
          },
        ),
      ],
    );
  }

  Widget _buildChipSelection(String title, List<String> options,
      String selectedValue, Function(String?) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((String option) {
            return ChoiceChip(
              label: Text(option),
              selected: selectedValue == option,
              onSelected: (bool selected) {
                if (selected) {
                  onSelected(option);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Create My Nutrition Plan',
                style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Future<void> _saveProfile() async {
    // Check if all fields are filled
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _gender.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _dietaryPreference.isEmpty) {
      _showErrorDialog('Please fill in all required fields.');
      return; // Exit the method if validation fails
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    // Prepare user data
    final userProfileData = {
      'name': _nameController.text,
      'age': int.parse(_ageController.text),
      'gender': _gender,
      'weight': double.parse(_weightController.text),
      'height': double.parse(_heightController.text),
      'dietaryPreference': _dietaryPreference,
      'healthGoal': _healthGoal,
      'dailyProteinGoal': 100, // Retrieve from inputs if available
      'dailyCarbGoal': 200, // Retrieve from inputs if available
      'dailyFatGoal': 70, // Retrieve from inputs if available
    };

    try {
      // Store data in Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userProfileData);

        // Optionally, store in Hive if needed
        var box = await Hive.openBox('app');
        await box.put('profile', userProfileData);
        // profileBox.get('isProfileComplete', defaultValue: false);
        box.put('isProfileComplete', true);

        // Log the age type for debugging

        final age = userProfileData['age'];
        final gender = userProfileData['gender'];
        final weight = userProfileData['weight'];
        final height = userProfileData['height'];
        final dietaryPreferences = userProfileData['dietaryPreference'];
        final healthGoal = userProfileData['healthGoal'];
        final dailyProteinGoal = userProfileData['dailyProteinGoal'];
        final dailyCarbGoal = userProfileData['dailyCarbGoal'];
        final dailyFatGoal = userProfileData['dailyFatGoal'];

        // Generate Meal Plan
        MealPlanGenerator generator = MealPlanGenerator();
        Map<String, dynamic>? mealPlan = await generator.generateMealPlan("""
      Generate a personalized meal plan for a user with the following profile:

      Age: $age
      Gender: $gender
      Weight: $weight kg
      Height: $height cm
      Dietary Preferences: $dietaryPreferences
      Health Goals: $healthGoal
      Daily Protein Goal: ${dailyProteinGoal}g
      Daily Carb Goal: ${dailyCarbGoal}g
      Daily Fat Goal: ${dailyFatGoal}g

      Please provide the meal plan in the following JSON format:

      {
        "meals": [
          {
            "mealType": "Breakfast",
            "foodItems": ["Oatmeal", "Banana", "Almonds"],
            "calories": 350,
            "protein": 10,
            "carbs": 60,
            "fats": 8
          },
          {
            "mealType": "Lunch",
            "foodItems": ["Grilled Chicken", "Quinoa", "Broccoli"],
            "calories": 500,
            "protein": 40,
            "carbs": 45,
            "fats": 15
          }
          // Add more meals as needed
        ]
      }
      """);

        await saveDailyGoals(
          user.uid,
          dailyProteinGoal,
          dailyCarbGoal,
          dailyFatGoal,
          2000, // Set your daily calorie goal or retrieve from inputs
        );

        if (mealPlan != null) {
          print("Generated Meal Plan: $mealPlan");
          await generator.saveMealPlan(user.uid, mealPlan);
          await generator.saveMealPlanLocally(mealPlan);
        } else {
          print("Failed to generate meal plan");
        }

        // Navigate to the dashboard or next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homepage_design()),
        );
      } else {
        _showErrorDialog('User not found. Please log in again.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      // Stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Assume these functions are defined elsewhere in your project

// class MealPlanGenerator {
//   Future<Map<String, dynamic>?> generateMealPlan(String prompt) async {
//     // Implementation for generating meal plan
//     // This would typically involve calling an AI service or using a predefined algorithm
//     // For now, we'll return a dummy meal plan
//     return {
//       "meals": [
//         {
//           "mealType": "Breakfast",
//           "foodItems": ["Oatmeal", "Banana", "Almonds"],
//           "calories": 350,
//           "protein": 10,
//           "carbs": 60,
//           "fats": 8
//         },
//         {
//           "mealType": "Lunch",
//           "foodItems": ["Grilled Chicken", "Quinoa", "Broccoli"],
//           "calories": 500,
//           "protein": 40,
//           "carbs": 45,
//           "fats": 15
//         }
//       ]
//     };
//   }

//   Future<void> saveMealPlan(
//       String userId, Map<String, dynamic> mealPlan) async {
//     // Implementation for saving meal plan to Firestore
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('mealPlans')
//         .add(mealPlan);
//   }

//   Future<void> saveMealPlanLocally(Map<String, dynamic> mealPlan) async {
//     // Implementation for saving meal plan locally using Hive
//     var box = await Hive.openBox('mealPlans');
//     await box.put('currentMealPlan', mealPlan);
//   }
// }
