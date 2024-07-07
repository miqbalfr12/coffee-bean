import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uas/services/api_service.dart';

import 'package:uas/globals/globals.dart' as globals;

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
  var idQr = "";
  var qrUrl = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final ApiService apiService = ApiService();
    String title = widget.title;
    Map<String, dynamic> obj = widget.obj;
    print('Title: $title');
    print('obj: $obj');

    await Future.delayed(const Duration(seconds: 2));

    if (title == 'Tambah Order') {
      if (mounted) {
        try {
          var response = await apiService.createPayment(
              obj['amount'], obj['consumer'], obj['createdBy'], obj['order']);
          print('response.statusCode: ${response.statusCode}');
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            print(jsonResponse['message']);
            idQr = jsonResponse['message']['id'];
            var urlPay = 'https://coffeebean.reidteam.web.id/$idQr';
            print('jsonResponse: $urlPay');
            setState(() {
              qrUrl = urlPay;
              // isSuccess = true;
              isLoading = false;
            });
            _startPolling();
          } else {
            print('Failed: ${response.statusCode}');
            setState(() {
              isSuccess = false;
              isLoading = false;
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          idQr = obj['idQr'];
          var urlPay = 'https://coffeebean.reidteam.web.id/$idQr';
          qrUrl = urlPay;
          // isSuccess = true;
          isLoading = false;
        });
        _startPolling();
      }
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await _refreshData();
    });
  }

  Future<void> _refreshData() async {
    print('https://coffeebean.reidteam.web.id/api/payment/$idQr');
    try {
      var response = await http.get(
        Uri.parse('https://coffeebean.reidteam.web.id/api/payment/$idQr'),
        headers: {'Content-Type': 'application/json'},
      );

      print('response.statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var statusQr = jsonResponse['message']['status'];

        print(statusQr);
        if (statusQr == true) {
          print("anjay Truee");
        } else {
          print("anjay False");
        }

        if (statusQr == true) {
          setState(() {
            qrUrl = "";
            isSuccess = true;
          });
          _timer?.cancel();
        }
      } else {
        print('Failed: ${response.statusCode}');
        setState(() {
          isSuccess = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
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
                child: isLoading
                    ? Image.asset('assets/gif/loading.gif')
                    : qrUrl != ""
                        ? QrImageView(
                            data: qrUrl,
                            version: QrVersions.auto,
                            size: 300.0,
                          )
                        : isSuccess
                            ? Image.asset('assets/gif/success.gif')
                            : Image.asset('assets/gif/fail.gif'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% of screen width
                child: isLoading
                    ? null
                    : qrUrl != ""
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    globals.orders.clear();
                                    Navigator.pop(context);
                                    if (widget.title == 'Tambah Order') {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              globals.orders.clear();
                              Navigator.pop(context);
                              if (widget.title == 'Tambah Order') {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
