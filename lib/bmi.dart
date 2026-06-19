import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.light,
      home: const BMICalculatorPage(),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();

  double? _bmi;
  String _message = '';

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _feetController.dispose();
    super.dispose();
  }

  String _getBMIInterpretation(double bmi) {
    if (bmi < 16.0) {
      return 'Severely underweight';
    } else if (bmi >= 16.0 && bmi <= 16.9) {
      return 'Moderately underweight';
    } else if (bmi >= 17.0 && bmi <= 18.4) {
      return 'Mildly underweight';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return 'Normal (healthy weight)';
    } else if (bmi >= 25.0 && bmi <= 29.9) {
      return 'Overweight';
    } else if (bmi >= 30.0 && bmi <= 34.9) {
      return 'Obese Class I (Moderate)';
    } else if (bmi >= 35.0 && bmi <= 39.9) {
      return 'Obese Class II (Severe)';
    } else {
      return 'Obese Class III (Very Severe / Morbid)';
    }
  }

  void _calculateBMI() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      setState(() {
        _bmi = null;
        _message = 'Please enter valid values for height and weight.';
      });
      return;
    }

    final double bmi = weight / pow(height / 100, 2);
    String resultMessage = _getBMIInterpretation(bmi);

    setState(() {
      _bmi = bmi;
      _message = 'Your BMI is ${_bmi!.toStringAsFixed(2)} ($resultMessage)';
    });
  }

  void _resetFields() {
    _heightController.clear();
    _weightController.clear();
    _feetController.clear();
    setState(() {
      _bmi = null;
      _message = '';
    });
  }

  void _convertFeetToCm() {
    final double? feet = double.tryParse(_feetController.text);

    if (feet == null || feet <= 0) {
      setState(() {
        _heightController.text = '';
      });
      return;
    }

    final double totalInches = feet * 12;
    final double centimeters = totalInches * 2.54;

    _heightController.text = centimeters.toStringAsFixed(2);
  }

  Widget _buildGradientButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'BMI',
            style: TextStyle(
                fontStyle: FontStyle.italic, color: Colors.white, fontSize: 18),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: _resetFields,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Reset',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Convert your height Feet to CM',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _feetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Feet',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildGradientButton('Convert', _convertFeetToCm),
              const SizedBox(height: 30),
              const Text(
                'Enter your height and weight',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildGradientButton('Calculate BMI', _calculateBMI),
              const SizedBox(height: 40),
              Text(
                _message,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}