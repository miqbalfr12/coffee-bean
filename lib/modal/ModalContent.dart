import 'dart:math';

import 'package:flutter/material.dart';

class ModalContent extends StatefulWidget {
  const ModalContent({super.key, required this.title, this.obj = const {}});
  final Map<String, dynamic> obj;
  final String title;

  @override
  _ModalContentState createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  bool isLoading = true;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // ambil nilai variable title
    String title = widget.title;
    Map<String, dynamic> obj = widget.obj;
    // make variable succes random
    bool success;
    success = Random().nextBool();
    print('Title: $title');
    print('obj: $obj');
    print('Success: $success');
    // Simulating a network request
    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay

    if (mounted) {
      if (success) {
        setState(() {
          isSuccess = true;
          isLoading = false; // Assume response status is 200
        });
      } else {
        setState(() {
          isSuccess = false;
          isLoading = false; // Assume response status is 200
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Image.asset(
                  isLoading
                      ? 'assets/gif/loading.gif'
                      : isSuccess
                          ? 'assets/gif/success.gif'
                          : 'assets/gif/fail.gif',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% of screen width
                child: isLoading
                    ? null
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
