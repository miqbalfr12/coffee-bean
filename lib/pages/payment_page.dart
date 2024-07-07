import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:uas/modal/modal_content_qr.dart';
import 'package:uas/models/payment.dart';
import 'package:uas/pages/detail/detail_payment.dart';
import 'package:uas/services/api_service.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ApiService apiService = ApiService();
  late List<Payment> payments = [];
  late List<Payment> originalPayments = [];

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    try {
      List<Payment> fetchedPayments = await apiService.getPayments();
      // Mengurutkan payments berdasarkan editedAt terbaru
      fetchedPayments.sort((a, b) => b.editedAt.compareTo(a.editedAt));
      setState(() {
        payments = fetchedPayments;
        originalPayments = fetchedPayments;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _searchPayment(String query) {
    setState(() {
      if (query.isNotEmpty) {
        payments = originalPayments.where((payment) {
          return payment.consumer.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        payments = originalPayments.toList();
      }
    });
  }

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.grey.shade800,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.barcode_viewfinder,
                  color: Colors.grey.shade600,
                  size: 80,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Payment Page!",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Menampilkan List Payment",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: SizedBox(
            height: 40,
            child: TextField(
              cursorColor: Colors.amber,
              style: GoogleFonts.poppins(
                color: Colors.white, // Atur warna teks input
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade800,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10), // Atur padding vertikal
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search Payment",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ),
              onChanged: (value) {
                _searchPayment(value);
              },
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchPayments,
            backgroundColor: Colors.grey.shade800,
            color: Colors.amber,
            child: payments.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.amber,
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print(payments[index].status);
                          print("Tapped on ${payments[index].id}");
                          if (payments[index].status) {
                            print(payments[index].status);
                            // push to detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPayment(
                                  id: payments[index].id,
                                ),
                              ),
                            ).then((value) => _fetchPayments());
                          } else {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.amber,
                              builder: (BuildContext context) {
                                return ModalContent(
                                    title: 'Payment QR Code',
                                    obj: {"idQr": payments[index].id});
                              },
                            ).then((value) => _fetchPayments());
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                                  payments[index].status == true
                                      ? IconlyLight.ticket
                                      : IconlyBold.scan,
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
                                          payments[index].consumer,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          payments[index].status == true
                                              ? 'Paid - ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(payments[index].editedAt))}'
                                              : 'Unpaid',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print(
                                            'Container CheckIn clicked! ${payments[index].id}');
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade800,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              currencyFormatter.format(
                                                  payments[index].total),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
