// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GPACalculatorApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GPACalculatorApp extends StatefulWidget {
  const GPACalculatorApp({super.key});

  @override
  State<GPACalculatorApp> createState() => _GPACalculatorPageState();
}

class _GPACalculatorPageState extends State<GPACalculatorApp> {
  final List<CourseData> _courses = [];
  double _gpa = 0.0;

  @override
  void initState() {
    super.initState();
    _addSubject();
  }

  void _calculateGPA() {
    double totalCredits = 0;
    double totalPoints = 0;

    for (final course in _courses) {
      final gradePoints = course.selectedGradePoint;

      if (gradePoints != null) {
        totalCredits += 3;
        totalPoints += gradePoints * 3;
      }
    }

    setState(() {
      _gpa = totalCredits == 0 ? 0 : totalPoints / totalCredits;
    });
  }

  void _addSubject() {
    setState(() {
      _courses.add(CourseData());
    });
  }

  void _removeSubject(int index) {
    setState(() {
      _courses.removeAt(index);
      if (_courses.isEmpty) {
        _addSubject();
      }
      _calculateGPA();
    });
  }

  void _reset() {
    setState(() {
      _courses.clear();
      _addSubject();
      _gpa = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('GPA', style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            height: 50, // increased height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.blue.shade700),
            ),
            child: TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, color: Colors.blue),
              label: const Text('Reset', style: TextStyle(color: Colors.blue)),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _courses.length + 1, // +1 for the Add Subject button
              itemBuilder: (context, index) {
                if (index == _courses.length) {
                  // Place Add Subject button after the last course
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: _addSubject,
                        child: const Text('Add Subject', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                }
                // Render course item
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: GradePointsDropdown(
                                  value: _courses[index].selectedGradePoint,
                                  onChanged: (value) {
                                    setState(() {
                                      _courses[index].selectedGradePoint = value;
                                      _calculateGPA();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () => _removeSubject(index),
                            child: const Text('Remove Subject', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Calculated GPA: ${_gpa.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class CourseData {
  double? selectedGradePoint;
  CourseData({this.selectedGradePoint});
}

class GradePointsDropdown extends StatefulWidget {
  const GradePointsDropdown({super.key, this.value, this.onChanged});

  final double? value;
  final ValueChanged<double?>? onChanged;

  @override
  State<GradePointsDropdown> createState() => _GradePointsDropdownState();
}

class _GradePointsDropdownState extends State<GradePointsDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<double>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Grade',
      ),
      value: widget.value,
      items: const [
        DropdownMenuItem(value: 5.0, child: Text('A+ (80-100)')),
        DropdownMenuItem(value: 4.0, child: Text('A (70-79)')),
        DropdownMenuItem(value: 3.5, child: Text('A- (60-69)')),
        DropdownMenuItem(value: 3.0, child: Text('B (50-59)')),
        DropdownMenuItem(value: 2.0, child: Text('C (40-49)')),
        DropdownMenuItem(value: 1.0, child: Text('D (33-39)')),
        DropdownMenuItem(value: 0.0, child: Text('F (0-32)')),
      ],
      onChanged: widget.onChanged,
    );
  }
}