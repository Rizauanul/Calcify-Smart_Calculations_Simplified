import 'package:flutter/material.dart';

void main() {
  runApp(const CGPACalculatorApp());
}

class CGPACalculatorApp extends StatelessWidget {
  const CGPACalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CGPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CGPACalculatorHomePage(),
    );
  }
}

class CGPACalculatorHomePage extends StatelessWidget {
  const CGPACalculatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CGPA',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const CGPACalculatorHomePage())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Row(
                children: [
                  Icon(Icons.refresh, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('Reset', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: const CGPACalculator(),
    );
  }
}

class CGPACalculator extends StatefulWidget {
  const CGPACalculator({super.key});

  @override
  State<CGPACalculator> createState() => _CGPACalculatorState();
}

class _CGPACalculatorState extends State<CGPACalculator> {
  List<Course> courses = [];
  double cgpa = 0.0;

  @override
  void initState() {
    super.initState();
    courses.add(Course()); // Ensure at least one course is always present
  }

  void calculateCGPA() {
    double totalCredits = 0;
    double weightedSum = 0;

    for (var course in courses) {
      if (course.gradePoints != null && course.creditHours != null) {
        totalCredits += course.creditHours!;
        weightedSum += course.gradePoints! * course.creditHours!;
      }
    }

    setState(() {
      cgpa = totalCredits > 0 ? weightedSum / totalCredits : 0.0;
    });
  }

  void removeCourse(Course course) {
    setState(() {
      if (courses.length > 1) {
        courses.remove(course);
      }
      calculateCGPA();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...courses.map<Widget>((course) => CourseInput(
              key: UniqueKey(),
              course: course,
              onChanged: () {
                calculateCGPA();
                setState(() {});
              },
              onRemove: () {
                removeCourse(course);
              },
            )),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => courses.add(Course()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Add Course',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Calculated CGPA:',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              Text(cgpa.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class Course {
  double? gradePoints;
  double? creditHours;
}

class CourseInput extends StatefulWidget {
  final Course course;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  const CourseInput({
    required super.key,
    required this.course,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<CourseInput> createState() => _CourseInputState();
}

class _CourseInputState extends State<CourseInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButtonFormField<double>(
                      decoration: const InputDecoration(
                        labelText: 'Grade Points',
                        border: InputBorder.none,
                      ),
                      value: widget.course.gradePoints,
                      items: const [
                        DropdownMenuItem(value: 4.0, child: Text('A+ 4.00')),
                        DropdownMenuItem(value: 3.75, child: Text('A  3.75')),
                        DropdownMenuItem(value: 3.5, child: Text('A- 3.50')),
                        DropdownMenuItem(value: 3.25, child: Text('B+ 3.25')),
                        DropdownMenuItem(value: 3.0, child: Text('B  3.00')),
                        DropdownMenuItem(value: 2.75, child: Text('B- 2.75')),
                        DropdownMenuItem(value: 2.5, child: Text('C+ 2.50')),
                        DropdownMenuItem(value: 2.25, child: Text('C  2.25')),
                        DropdownMenuItem(value: 2.0, child: Text('D  2.00')),
                        DropdownMenuItem(value: 0.0, child: Text('F  0.00')),
                      ],
                      onChanged: (double? value) {
                        setState(() {
                          widget.course.gradePoints = value;
                          widget.onChanged();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButtonFormField<double>(
                      decoration: const InputDecoration(
                        labelText: 'Credit Hours',
                        border: InputBorder.none,
                      ),
                      value: widget.course.creditHours,
                      items: List<DropdownMenuItem<double>>.generate(
                        9,
                            (index) => DropdownMenuItem<double>(
                          value: (index + 1).toDouble(),
                          child: Text('${index + 1}'),
                        ),
                      ),
                      onChanged: (double? value) {
                        setState(() {
                          widget.course.creditHours = value;
                          widget.onChanged();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: widget.onRemove,
              child:
              const Text('Remove Course', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}