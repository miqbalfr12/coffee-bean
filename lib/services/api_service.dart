import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uas/models/order.dart';
import 'package:uas/models/payment.dart';
import 'package:uas/models/product.dart';

class ApiService {
  static const String baseUrl = 'https://coffeebean.reidteam.web.id/api';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/product'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['message'];
      print(data);
      return data.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProduct(id) async {
    final response = await http.get(Uri.parse('$baseUrl/product/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['message'];
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<Payment>> getPayments() async {
    final response = await http.get(Uri.parse('$baseUrl/payment'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['message'];
      print(data);
      return data.map((payment) => Payment.fromJson(payment)).toList();
    } else {
      throw Exception('Failed to load payment');
    }
  }

  Future<Payment> getPayment(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/payment/$id'));
    if (response.statusCode == 200) {
      return Payment.fromJson(json.decode(response.body)['message']);
    } else {
      throw Exception('Failed to load payment');
    }
  }
}
