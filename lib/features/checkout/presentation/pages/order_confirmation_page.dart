import 'package:flutter/widgets.dart';

class OrderConfirmationPage extends StatefulWidget {
  final int? orderId;
  const OrderConfirmationPage({super.key, required this.orderId});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}