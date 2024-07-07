import 'package:flutter/material.dart';
import 'package:uas/modal/modal_content.dart';
import 'package:uas/models/product.dart';
import 'package:uas/services/api_service.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.id});

  final String id;

  @override
  EditProductState createState() => EditProductState();
}

class EditProductState extends State<EditProduct> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  String _itemName = "";
  String _itemCategory = "";
  String _itemDescription = "";
  List<dynamic> _itemMaterials = [];
  int _itemPrice = 0;
  int _itemStock = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct(widget.id);
  }

  Future<void> _fetchProduct(id) async {
    try {
      Product fetchedProduct = await apiService.getProduct(id);
      print(fetchedProduct);
      setState(() {
        _itemName = fetchedProduct.name;
        _itemCategory = fetchedProduct.category;
        _itemDescription = fetchedProduct.description;
        _itemMaterials = fetchedProduct.materials;
        _itemPrice = fetchedProduct.price;
        _itemStock = fetchedProduct.stock;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Edit Product'),
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
                    child: formEditProduct(),
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
                              print("Delete Product");
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.amber,
                                builder: (BuildContext context) {
                                  return ModalContent(
                                      title: 'Delete Product',
                                      obj: {"id": widget.id});
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Hapus',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              print(
                                  "Editing Product for $_itemName with stock $_itemStock ");
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.amber,
                                builder: (BuildContext context) {
                                  return ModalContent(
                                      title: 'Edit Product',
                                      obj: {
                                        "id": widget.id,
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
                              Icon(Icons.edit, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
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

  Form formEditProduct() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            initialValue: _itemName,
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
            initialValue: _itemCategory,
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
            initialValue: _itemDescription,
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
            initialValue: _itemMaterials.join(','),
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
            initialValue: _itemPrice.toString(),
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
            initialValue: _itemStock.toString(),
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
