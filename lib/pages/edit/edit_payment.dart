import 'package:flutter/material.dart';
import 'package:uas/modal/modal_content_qr.dart';
import 'package:uas/globals/globals.dart' as globals;

class EditPayment extends StatefulWidget {
  const EditPayment({super.key});

  @override
  EditPaymentState createState() => EditPaymentState();
}

class EditPaymentState extends State<EditPayment> {
  final _formKey = GlobalKey<FormState>();
  String _consumer = "";
  String _createdBy = "";
  int _amount = 0;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amount = calculateTotalAmount();
    _amountController.text = _amount.toString();
  }

  int calculateTotalAmount() {
    int total = 0;
    for (var order in globals.orders) {
      total += order.price * order.qty;
    }
    return total;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Tambah Order'),
      ),
      backgroundColor: Colors.amber, // Background color of the main Scaffold
      body: Stack(
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
              child: EditPayment(),
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(
                            "Adding Order for $_consumer with amount $_amount and createdBy $_createdBy");
                        // Cetak variabel global orders
                        print("Current global orders: ${globals.orders}");

                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.amber,
                          builder: (BuildContext context) {
                            return ModalContent(title: 'Add Payment', obj: {
                              "consumer": _consumer,
                              "amount": _amount,
                              "createdBy": _createdBy,
                              "order": globals.orders,
                            });
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Tambahkan',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi yang dijalankan saat tombol ditekan
                      print('Tombol 2 ditekan');
                      // pop the current page
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

  Form EditPayment() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Nama Kasir",
              prefixIcon: const Icon(
                Icons.assignment_ind_rounded, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nama Kasir tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _createdBy = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Nama Pemesan",
              prefixIcon: const Icon(
                Icons.person, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nama Pemesan tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _consumer = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            controller: _amountController,
            decoration: InputDecoration(
              labelText: "Harga Total Barang",
              prefixIcon: const Icon(
                Icons.monetization_on, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Harga Total Barang tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _amount = int.parse(value!),
          ),
        ],
      ),
    );
  }
}
