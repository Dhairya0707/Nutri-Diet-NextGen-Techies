import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final _formKey = GlobalKey<FormState>();
  double? height;
  double? weight;
  double? bmi;
  String? resultMessage;
  List<String> chatMessages = [];

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        bmi = weight! / ((height! / 100) * (height! / 100));
        if (bmi! < 18.5) {
          resultMessage = "Underweight";
        } else if (bmi! < 25) {
          resultMessage = "Normal weight";
        } else if (bmi! < 30) {
          resultMessage = "Overweight";
        } else {
          resultMessage = "Obese";
        }
        chatMessages.add(
            "Your BMI is ${bmi!.toStringAsFixed(1)}. You are $resultMessage.");
        if (resultMessage == "Normal weight") {
          chatMessages.add("Great job! You're maintaining a healthy weight.");
        } else {
          chatMessages.add("Would you like some tips to improve your BMI?");
        }
      });
    }
  }

  Widget _buildGaugeChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          startDegreeOffset: 180,
          sections: [
            PieChartSectionData(
              color: Colors.red.shade300,
              value: 18.5,
              title: 'Under',
              radius: 60,
              titleStyle: TextStyle(fontSize: 12, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.green.shade400,
              value: 6.5,
              title: 'Normal',
              radius: 60,
              titleStyle: TextStyle(fontSize: 12, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.orange.shade400,
              value: 5,
              title: 'Over',
              radius: 60,
              titleStyle: TextStyle(fontSize: 12, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.red.shade400,
              value: 10,
              title: 'Obese',
              radius: 60,
              titleStyle: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          centerSpaceColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputForm(),
              SizedBox(height: 24),
              if (bmi != null) _buildResultCard(),
              SizedBox(height: 24),
              if (chatMessages.isNotEmpty) _buildChatCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Your Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildTextField(
                  'Height (cm)', (value) => height = double.parse(value!)),
              SizedBox(height: 16),
              _buildTextField(
                  'Weight (kg)', (value) => weight = double.parse(value!)),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateBMI,
                child: Text('Calculate BMI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your BMI Result',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '${bmi!.toStringAsFixed(1)}',
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Text(
              resultMessage!,
              style: TextStyle(fontSize: 24, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            _buildGaugeChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Coach',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...chatMessages.map((message) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.chat, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(child: Text(message)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
