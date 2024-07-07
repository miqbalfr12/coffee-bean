import 'package:uas/models/order.dart';

class Payment {
  final String id;
  final bool status;
  final int total;
  final int createdAt;
  final int editedAt;
  final String consumer;
  final List<Order> order;

  Payment(
      {required this.id,
      required this.status,
      required this.total,
      required this.createdAt,
      required this.editedAt,
      required this.order,
      required this.consumer});

  factory Payment.fromJson(Map<String, dynamic> json) {
    var orderFromJson = json['order'] as List;
    List<Order> orderList =
        orderFromJson.map((orderJson) => Order.fromJson(orderJson)).toList();

    return Payment(
      id: json['id'],
      status: json['status'],
      total: json['total'],
      createdAt: json['createdAt'],
      editedAt: json['editedAt'],
      order: orderList,
      consumer: json['consumer'],
    );
  }
}
