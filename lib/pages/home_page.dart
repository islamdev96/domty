// ignore_for_file: unused_local_variable

import '../all_export.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, TextEditingController>? _startOfDayControllers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('صفحة البداية')),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartOfDayPage(
                          onSubmit: (controllers) {
                            setState(() {
                              _startOfDayControllers = controllers;
                            });
                          },
                          startOfDayControllers: const {},
                        ),
                      ),
                    );
                  },
                  child: const Text('إدخال بيانات بداية اليوم'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startOfDayControllers != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EndOfDayPage(
                                startOfDayControllers: _startOfDayControllers!,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text('إدخال بيانات نهاية اليوم'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
