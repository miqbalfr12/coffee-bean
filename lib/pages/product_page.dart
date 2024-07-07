import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas/models/product.dart';
import 'package:uas/pages/edit/edit_product.dart';
import 'package:uas/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:uas/models/order.dart';
import 'package:uas/globals/globals.dart' as globals;

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ApiService apiService = ApiService();
  late List<Product> products = [];
  late List<Product> originalProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> fetchedProducts = await apiService.getProducts();
      setState(() {
        products = fetchedProducts;
        originalProducts = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _searchProduct(String query) {
    setState(() {
      if (query.isNotEmpty) {
        products = originalProducts.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        products = originalProducts.toList();
      }
    });
  }

  void _incrementOrder(Product product) {
    setState(() {
      Order? existingOrder = globals.orders.firstWhere(
          (order) => order.product == product.name,
          orElse: () => Order(id: '', product: '', qty: 0, price: 0));
      if (existingOrder.product.isEmpty) {
        globals.orders.add(Order(
            id: product.id,
            product: product.name,
            qty: 1,
            price: product.price));
      } else {
        existingOrder.qty += 1;
      }
    });
  }

  void _decrementOrder(Product product) {
    setState(() {
      Order? existingOrder = globals.orders.firstWhere(
          (order) => order.product == product.name,
          orElse: () => Order(id: '', product: '', qty: 0, price: 0));
      if (existingOrder.product.isNotEmpty && existingOrder.qty > 0) {
        existingOrder.qty -= 1;
        if (existingOrder.qty == 0) {
          globals.orders.remove(existingOrder);
        }
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
                  CupertinoIcons.bag,
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
                        "Product Page!",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Menampilkan List Product",
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
                hintText: "Search Product",
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
                _searchProduct(value);
              },
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              globals.orders.clear();
              return _fetchProducts();
            },
            backgroundColor: Colors.grey.shade600,
            color: Colors.amber,
            child: products.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.amber,
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // push to product edit
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProduct(
                                      id: products[index].id,
                                    ),
                                  ),
                                ).then((value) => _fetchProducts());
                                print("Tapped on ${products[index].id}");
                              },
                              child: Container(
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
                                        products[index].category == 'Makanan'
                                            ? Icons.local_dining_rounded
                                            : products[index].category ==
                                                    'Minuman'
                                                ? Icons.local_cafe_rounded
                                                : Icons.fastfood_rounded,
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
                                                products[index].name,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                products[index].category,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  currencyFormatter.format(
                                                      products[index].price),
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Quantity: ${globals.orders.firstWhere((order) => order.product == products[index].name, orElse: () => Order(id: '', product: '', qty: 0, price: 0)).qty}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _decrementOrder(products[index]);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade800,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "-",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      _incrementOrder(products[index]);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade800,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "+",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
