// // ignore_for_file: camel_case_types, library_private_types_in_public_api

// ignore_for_file: camel_case_types, library_private_types_in_public_api, unused_element, must_be_immutable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diet/design/landing_design.dart';
import 'package:diet/design/profile_page_design.dart';
import 'package:diet/design/progrss.dart';
import 'package:diet/home/ai_img.dart';
import 'package:diet/home/bmi.dart';
import 'package:diet/home/chatbot.dart';
import 'package:diet/home/homepage.dart';
import 'package:diet/home/logmeal.dart';
import 'package:diet/home/serach_detailed.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';

// Import your other necessary pages and widgets here

class homepage_design extends StatefulWidget {
  const homepage_design({super.key});

  @override
  _homepage_designState createState() => _homepage_designState();
}

class _homepage_designState extends State<homepage_design> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    const SearchPage(),
    MealPlansPage(),
    profile_design()
    // ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Nutri Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety),
              title: const Text('BMI Calculator'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BMICalculator()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chatbot'),
              onTap: () {
                // Navigate to Chatbot Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ChatPage())); // Close the drawer
                // Add navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Vison'),
              onTap: () {
                // Navigate to Chatbot Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImgNutritionAI(
                              title: 'NutriVision',
                            ))); // Close the drawer
                // Add navigation logic here
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Hive.box('app').put('isProfileComplete', false);
                setState(() {});
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const design_landing()),
                    (route) => false);
                setState(() {});
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Meal Plans',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LogMealPage()),
          );
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
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

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                // title: Text(
                //   'Welcome, ${userProfile['name']}',
                //   style: TextStyle(color: Colors.green),
                // ),
                background: Image.asset(
                  'asset/phone.png',
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NutritionProgressWidget(
                        userId: userId, selectedDate: "2024-09-29"),
                    // _buildNutritionSummary(userProfile),
                    const SizedBox(height: 20),
                    _buildQuickActions(context),
                    const SizedBox(height: 20),
                    // _buildRecentMeals(),
                    RecentMealsWidget()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNutritionSummary(Map<String, dynamic> userProfile) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Nutrition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Protein');
                            case 1:
                              return const Text('Carbs');
                            case 2:
                              return const Text('Fat');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: userProfile['dailyProteinGoal'].toDouble(),
                        color: Colors.green,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      )
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                        toY: userProfile['dailyCarbGoal'].toDouble(),
                        color: Colors.blue,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      )
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                        toY: userProfile['dailyFatGoal'].toDouble(),
                        color: Colors.red,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      )
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              context,
              icon: Icons.calculate,
              label: 'BMI',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BMICalculator())),
            ),
            _buildActionButton(
              context,
              icon: Icons.chat,
              label: 'Chat',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ChatPage())),
            ),
            _buildActionButton(
              context,
              icon: Icons.camera_alt,
              label: 'Vision',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ImgNutritionAI(title: 'NutriVision'))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildRecentMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Meals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Here you would typically use a StreamBuilder or FutureBuilder to fetch recent meals
        // For demonstration, I'll use a ListView with placeholder items
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.food_bank),
                // backgroundImage:
                //     NetworkImage('https://via.placeholder.com/150'),
              ),
              title: Text('Meal ${index + 1}'),
              subtitle: Text('Description of meal ${index + 1}'),
              trailing: Text('${(index + 1) * 100} kcal'),
            );
          },
        ),
      ],
    );
  }
}

class RecentMealsWidget extends StatelessWidget {
  // final String selectedDate;
  String selectedDate = '2024-09-28'; // Pass the date as 'yyyy-MM-dd'

  RecentMealsWidget({required});

  @override
  Widget build(BuildContext context) {
    // Get the current user's auth ID

    return StreamBuilder<DocumentSnapshot>(
      // Query Firestore: users -> {userId} -> dailyIntakes -> {selectedDate}
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('dailyIntakes')
          .doc("2024-09-29")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          return const Text('No meal data available for this date.');
        }

        // Extract the data from Firestore
        var data = snapshot.data!.data() as Map<String, dynamic>;

        // Extract relevant fields
        var mealEntries =
            List<Map<String, dynamic>>.from(data['mealEntries'] ?? []);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Meals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Show list of meals
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mealEntries.length,
              itemBuilder: (context, index) {
                final meal = mealEntries[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.food_bank),
                  ),
                  title: Text(meal['mealType']),
                  subtitle: Text(
                      'Carbs: ${meal['carbs']}g, Fats: ${meal['fats']}g, Protein: ${meal['protein']}g'),
                  trailing: Text('Meal ${index + 1}'),
                );
              },
            ),
            // const SizedBox(height: 20),
            // Text('Carb Intake: ${carbIntake}g'),
            // Text('Fat Intake: ${fatIntake}g'),
            // Text('Protein Intake: ${proteinIntake}g'),
          ],
        );
      },
    );
  }
}

// The SearchPage, MealPlansPage, and ProfilePage would be implemented similarly,
// with improvements to their UI while maintaining their core functionality.

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Foods'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for food...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: _performSearch,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Center(
              child: Text('Search for food to see nutritional information')),
    );
  }

  void _performSearch(String value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: "YOUR_API_KEY_HERE", // Replace with your actual API key
      );

      final content = [
        Content.text(
            "Provide a detailed nutritional breakdown of [$value] in a tabular format. Include information on serving size, calories, macronutrients (protein, carbohydrates, fat), and key micronutrients (vitamins, minerals).")
      ];

      final response = await model.generateContent(content);
      String? data = response.text;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IdeaGenerated(data: data!)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
