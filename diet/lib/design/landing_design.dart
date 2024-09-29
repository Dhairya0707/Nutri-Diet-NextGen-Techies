// ignore_for_file: camel_case_types

import 'package:diet/design/login_design.dart';
import 'package:diet/design/signin_design.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class design_landing extends StatelessWidget {
  const design_landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade300,
              Colors.teal.shade500,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App logo and name
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.eco,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'NutriPlan',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Tagline
              Text(
                'Your path to a healthier you',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 40),
              // Feature carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 250.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.easeInOut,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: const [
                  FeatureCard(
                    title: "Smart Meal Planning",
                    description:
                        "Get personalized meal plans based on your goals and preferences.",
                    icon: Icons.restaurant_menu,
                  ),
                  FeatureCard(
                    title: "Nutrition Tracking",
                    description:
                        "Monitor your macros and micronutrients with ease.",
                    icon: Icons.pie_chart,
                  ),
                  FeatureCard(
                    title: "Progress Insights",
                    description:
                        "Visualize your journey with detailed analytics and reports.",
                    icon: Icons.insights,
                  ),
                ],
              ),
              const Spacer(),
              // Call-to-action buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const sign_design()));
                      },
                      icon: const Icon(Icons.arrow_forward, color: Colors.teal),
                      label: const Text('Get Started'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.teal,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const login_design()));
                      },
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text('Already have an account? Log in'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
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
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeatureCard(
      {super.key,
      required this.title,
      required this.description,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.teal),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style:
                GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
