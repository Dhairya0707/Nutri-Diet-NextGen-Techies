import 'package:diet/home/serach_detailed.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class search_design extends StatefulWidget {
  const search_design({Key? key}) : super(key: key);

  @override
  _search_designState createState() => _search_designState();
}

class _search_designState extends State<search_design> {
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController();
  List<String> _recentSearches = [
    'Apple',
    'Chicken breast',
    'Quinoa',
    'Avocado'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search for food...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _controller.clear(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onSubmitted: _performSearch,
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Recent Searches',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ..._recentSearches.map((search) => ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(search),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _performSearch(search),
                        )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String value) async {
    setState(() {
      _isLoading = true;
    });

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey:
          "AIzaSyCKLL1KxCeuLKh3qsYWWpWYZlryKs422I4", // Replace with your actual API key
    );

    try {
      final content = [
        Content.text(
            "Provide a detailed nutritional breakdown of [$value] in a tabular format. Include information on serving size, calories, macronutrients (protein, carbohydrates, fat), and key micronutrients (vitamins, minerals).")
      ];

      final response = await model.generateContent(content);
      String? data = response.text;

      // Update recent searches
      setState(() {
        _recentSearches.remove(value);
        _recentSearches.insert(0, value);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.sublist(0, 5);
        }
      });

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => IdeaGenerated(data: data!)));
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
