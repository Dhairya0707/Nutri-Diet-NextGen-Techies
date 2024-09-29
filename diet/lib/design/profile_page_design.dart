import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile_design extends StatelessWidget {
  final String id = FirebaseAuth.instance.currentUser!.uid;

  profile_design({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(id).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User not found.'));
        }

        var userProfile = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            backgroundColor: Colors.green,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(userProfile),
                _buildInfoSection(userProfile),
                _buildGoalSection(userProfile),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Map<String, dynamic> userProfile) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              userProfile['name'],
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> userProfile) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildInfoItem(Icons.cake, 'Age', '${userProfile['age']} years'),
            _buildInfoItem(Icons.wc, 'Gender', userProfile['gender']),
            _buildInfoItem(
                Icons.fitness_center, 'Weight', '${userProfile['weight']} kg'),
            _buildInfoItem(
                Icons.height, 'Height', '${userProfile['height']} cm'),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSection(Map<String, dynamic> userProfile) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Health Goals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildInfoItem(Icons.restaurant_menu, 'Dietary Preference',
                userProfile['dietaryPreference']),
            _buildInfoItem(
                Icons.trending_up, 'Health Goal', userProfile['healthGoal']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
