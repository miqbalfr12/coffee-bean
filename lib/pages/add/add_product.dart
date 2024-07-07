import 'package:flutter/material.dart';
import 'package:uas/modal/modal_content.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  AddProductState createState() => AddProductState();
}

class AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String _itemName = "";
  String _itemCategory = "";
  String _itemDescription = "";
  List<String> _itemMaterials = [];
  int _itemPrice = 0;
  int _itemStock = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Tambah Product'),
      ),
      backgroundColor: Colors.amber, // Background color of the main Scaffold
      body: Stack(
        children: [
          Container(
            width: double.infinity, // Set width to full width available
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: formAddProduct(),
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Handle form submission with _itemName and _itemStock
                        // You can potentially call a function to add stock
                        print(
                            "Adding Product for $_itemName with stock $_itemStock ");
                        print({
                          "name": _itemName,
                          "category": _itemCategory,
                          "price": _itemPrice,
                          "description": _itemDescription,
                          "materials": _itemMaterials,
                          "stock": _itemStock
                        });
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.amber,
                          builder: (BuildContext context) {
                            return ModalContent(title: 'Add Product', obj: {
                              "name": _itemName,
                              "category": _itemCategory,
                              "price": _itemPrice,
                              "description": _itemDescription,
                              "materials": _itemMaterials,
                              "stock": _itemStock
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

  Form formAddProduct() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Nama Barang",
              prefixIcon: const Icon(
                Icons.shopping_bag_outlined, // Change to your desired icon
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
                return "Nama barang tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemName = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Category",
              prefixIcon: const Icon(
                Icons.category_outlined, // Change to your desired icon
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
                return "Category tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemCategory = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Description",
              prefixIcon: const Icon(
                Icons.description_outlined, // Change to your desired icon
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
                return "Description tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemDescription = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Materials",
              prefixIcon: const Icon(
                Icons.inventory_2_rounded, // Change to your desired icon
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
                return "Materials tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemMaterials =
                value!.split(',').map((e) => e.trim()).toList(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Price",
              prefixIcon: const Icon(
                Icons.monetization_on_rounded, // Change to your desired icon
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
                return "Price tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemPrice = int.parse(value!),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Jumlah Stock",
              prefixIcon: const Icon(
                Icons.numbers_rounded, // Change to your desired icon
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
                return "Jumlah Stock tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemStock = int.parse(value!),
          ),
        ],
      ),
    );
  }
}
