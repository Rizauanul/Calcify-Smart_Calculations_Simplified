// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final List<String> _categories = ['Length', 'Weight', 'Temperature', 'Height'];
  String selectedCategory = 'Length';

  final Map<String, List<String>> units = {
    'Length': [
      'Meter',
      'Kilometer',
      'Centimeter',
      'Mile',
      'Foot',
      'Inch',
      'Millimeter',
      'Yard',
      'Micrometer',
      'Nanometer',
      'Hectometer',
    ],
    'Weight': [
      'Kilogram',
      'Gram',
      'Pound',
      'Ounce',
      'Stone',
      'Milligram',
      'Ton',
      'Carat',
    ],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Height': [
      'Feet',
      'Inch',
      'Meter',
      'Centimeter',
      'Millimeter',
      'Kilometer',
      'Micrometer',
      'Yard',
      'Mile',
      'Nautical Mile',
    ],
  };

  String fromUnit = 'Meter';
  String toUnit = 'Kilometer';
  double inputValue = 0;
  double result = 0;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fromUnit = units[selectedCategory]!.first;
    toUnit = units[selectedCategory]![1];
    _inputController.text = '';
  }

  void convert() {
    setState(() {
      switch (selectedCategory) {
        case 'Length':
          result = convertLength(inputValue, fromUnit, toUnit);
          break;
        case 'Weight':
          result = convertWeight(inputValue, fromUnit, toUnit);
          break;
        case 'Temperature':
          result = convertTemperature(inputValue, fromUnit, toUnit);
          break;
        case 'Height':
          result = convertHeight(inputValue, fromUnit, toUnit);
          break;
      }
    });
  }

  void reset() {
    setState(() {
      selectedCategory = 'Length';
      fromUnit = units['Length']!.first;
      toUnit = units['Length']![1];
      inputValue = 0;
      result = 0;
      _inputController.text = '';
    });
  }

  double convertLength(double value, String from, String to) {
    final meters = {
      'Meter': 1.0,
      'Kilometer': 1000.0,
      'Centimeter': 0.01,
      'Mile': 1609.34,
      'Foot': 0.3048,
      'Inch': 0.0254,
      'Millimeter': 0.001,
      'Yard': 0.9144,
      'Micrometer': 0.000001,
      'Nanometer': 0.000000001,
      'Hectometer': 100.0,
    };
    return value * meters[from]! / meters[to]!;
  }

  double convertWeight(double value, String from, String to) {
    final kg = {
      'Kilogram': 1.0,
      'Gram': 0.001,
      'Pound': 0.453592,
      'Ounce': 0.0283495,
      'Stone': 6.35029,
      'Milligram': 0.000001,
      'Ton': 1000.0,
      'Carat': 0.0002,
    };
    return value * kg[from]! / kg[to]!;
  }

  double convertTemperature(double value, String from, String to) {
    if (from == to) return value;
    if (from == 'Celsius') {
      if (to == 'Fahrenheit') return value * 9 / 5 + 32;
      if (to == 'Kelvin') return value + 273.15;
    }
    if (from == 'Fahrenheit') {
      if (to == 'Celsius') return (value - 32) * 5 / 9;
      if (to == 'Kelvin') return (value - 32) * 5 / 9 + 273.15;
    }
    if (from == 'Kelvin') {
      if (to == 'Celsius') return value - 273.15;
      if (to == 'Fahrenheit') return (value - 273.15) * 9 / 5 + 32;
    }
    return value;
  }

  double convertHeight(double value, String from, String to) {
    final meters = {
      'Feet': 0.3048,
      'Inch': 0.0254,
      'Meter': 1.0,
      'Centimeter': 0.01,
      'Millimeter': 0.001,
      'Kilometer': 1000.0,
      'Micrometer': 0.000001,
      'Yard': 0.9144,
      'Mile': 1609.34,
      'Nautical Mile': 1852.0,
    };
    return value * meters[from]! / meters[to]!;
  }

  @override
  Widget build(BuildContext context) {
    final unitList = units[selectedCategory]!;
    const Color appBarColor = Colors.blue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // <- Set white icons
        title: const Text('Measurement Converter'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontSize: 22,
        ),
        backgroundColor: appBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: reset,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.blue),
                    SizedBox(width: 5),
                    Text('Reset', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildShadowedContainer(
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                underline: Container(),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                    fromUnit = units[selectedCategory]!.first;
                    toUnit = units[selectedCategory]![1];
                    result = 0;
                    inputValue = 0;
                    _inputController.text = '';
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildShadowedContainer(
                    child: DropdownButton<String>(
                      value: fromUnit,
                      isExpanded: true,
                      underline: Container(),
                      items: unitList.map((unit) {
                        return DropdownMenuItem(value: unit, child: Text(unit));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          fromUnit = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.compare_arrows),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildShadowedContainer(
                    child: DropdownButton<String>(
                      value: toUnit,
                      isExpanded: true,
                      underline: Container(),
                      items: unitList.map((unit) {
                        return DropdownMenuItem(value: unit, child: Text(unit));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          toUnit = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildShadowedContainer(
              child: TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter value',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    inputValue = double.tryParse(val) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: convert,
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Result :',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$inputValue $fromUnit = $result $toUnit',
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowedContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: child,
    );
  }
}