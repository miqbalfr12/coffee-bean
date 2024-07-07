import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:uas/modal/modal_content.dart';
import 'package:uas/models/order.dart';
import 'package:uas/models/payment.dart';
import 'package:uas/services/api_service.dart';

class DetailPayment extends StatefulWidget {
  const DetailPayment({super.key, required this.id});

  final String id;

  @override
  DetailPaymentState createState() => DetailPaymentState();
}

class DetailPaymentState extends State<DetailPayment> {
  final ApiService apiService = ApiService();
  String consumer = "";
  String createdBy = "";
  List<Order> order = [];
  int editedAt = 0;
  int total = 0;
  bool status = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct(widget.id);
  }

  Future<void> _fetchProduct(id) async {
    try {
      Payment fetchedPayment = await apiService.getPayment(id);
      print(fetchedPayment);
      setState(() {
        consumer = fetchedPayment.consumer;
        editedAt = fetchedPayment.editedAt;
        status = fetchedPayment.status;
        total = fetchedPayment.total;
        createdBy = fetchedPayment.createdBy;
        order = fetchedPayment.order;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Detail Payment'),
      ),
      backgroundColor: Colors.amber, // Background color of the main Scaffold
      body: _isLoading // Show loading indicator if data is being fetched
          ? Container(
              width: double.infinity, // Set width to full width available
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Image.asset('assets/gif/loading.gif'),
                ),
              ),
            )
          : Stack(
              children: [
                Container(
                  width: double.infinity, // Set width to full width available
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  IconlyLight.ticket,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          consumer,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          status == true
                                              ? 'Paid - ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(editedAt))}'
                                              : 'Unpaid',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade800,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            currencyFormatter.format(total),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: order.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(children: [
                                    Container(
                                      width: 50,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text('${order[index].qty}x',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey.shade800,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        order[index].product,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '@ ${currencyFormatter.format(order[index].price)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ]));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close, color: Colors.amber),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
