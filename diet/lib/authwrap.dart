import 'package:diet/design/homepage_design.dart';
import 'package:diet/design/landing_design.dart';
import 'package:diet/home/homepage.dart';
import 'package:diet/pages/profile_setup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class authwrap2 extends StatelessWidget {
  const authwrap2({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // User is logged in, now check if profile is complete using Hive
          var profileBox = Hive.box('app');
          bool isProfileComplete =
              profileBox.get('isProfileComplete', defaultValue: false);

          // If profile is complete, show dashboard, else show profile setup
          if (isProfileComplete) {
            return homepage_design(); // Show dashboard
          } else {
            return const UserProfileSetup(); // Navigate to profile setup if incomplete
          }
        } else {
          return const design_landing(); // User is not logged in
        }
      },
    );
  }
}
