import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uas/services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String title = widget.title;
    Map<String, dynamic> obj = widget.obj;
    print('Title: $title');
    print('obj: $obj');

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      try {
        final ApiService apiService = ApiService();
        var response = await apiService.createPayment(
            obj['amount'], obj['consumer'], obj['createdBy'], obj['order']);
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          idQr = jsonResponse['message']['id'];
          var urlPay = 'https://apiuasppm.vercel.app/$idQr';
          print('jsonResponse: $urlPay');
          setState(() {
            qrUrl = urlPay;
            // isSuccess = true;
            isLoading = false;
          });
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
  }

  Future<void> _refreshData() async {
    print('https://apiuasppm.vercel.app/api/payment/$idQr');
    try {
      var response = await http.get(
        Uri.parse('https://apiuasppm.vercel.app/api/payment/$idQr'),
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
                                    _refreshData();
                                  },
                                  child: const Text(
                                    'Refresh',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
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
                          )
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
