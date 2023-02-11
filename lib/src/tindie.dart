library darttindie;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Represents an ordered [Item] of a Tindie [Order]
class Item {
  final String? modelNumber;
  final String? options;
  final bool preOrder;
  final double priceTotal;
  final double priceUnit;
  final String product;
  final int quantity;
  final String sku;
  final String status;

  Item({
    this.modelNumber,
    this.options,
    required this.preOrder,
    required this.priceTotal,
    required this.priceUnit,
    required this.product,
    required this.quantity,
    required this.sku,
    required this.status,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        modelNumber: json['model_number'] == '' ? null : json['model_number'],
        options: json['options'] == '' ? null : json['options'],
        preOrder: json['pre_order'],
        priceTotal: json['price_total'],
        priceUnit: json['price_unit'],
        product: json['product'],
        quantity: json['quantity'],
        sku: json['sku'],
        status: json['status'],
      );
}

/// Represents a Tindie [Order]
class Order {
  final int number;
  final DateTime date;
  final DateTime? dateShipped;
  final String? discountCode;
  final String message;

  final String email;
  final String phone;
  final String? companyTitle;

  final String shippingCity;
  final String shippingCountry;
  final String shippingCountryCode;
  final String? shippingInstructions;
  final String shippingName;
  final String shippingPostcode;
  final String shippingService;
  final String shippingState;
  final String shippingStreet;

  final double total;
  final double totalCCFee;
  final double totalDiscount;
  final double totalKickback;
  final double totalSeller;
  final double totalShipping;
  final double totalSubtotal;
  final double totalTindieFee;

  final String? trackingCode;
  final String? trackingUrl;

  final String payment;
  final bool refunded;
  final bool shipped;

  final List<Item> items;

  get firstName => shippingName.split(' ').first;
  get surName => shippingName.split(' ').last;

  Order({
    required this.number,
    required this.date,
    this.dateShipped,
    this.discountCode,
    required this.message,
    required this.email,
    required this.phone,
    this.companyTitle,
    required this.shippingCity,
    required this.shippingCountry,
    required this.shippingCountryCode,
    this.shippingInstructions,
    required this.shippingName,
    required this.shippingPostcode,
    required this.shippingService,
    required this.shippingState,
    required this.shippingStreet,
    required this.total,
    required this.totalCCFee,
    required this.totalDiscount,
    required this.totalKickback,
    required this.totalSeller,
    required this.totalShipping,
    required this.totalSubtotal,
    required this.totalTindieFee,
    this.trackingCode,
    this.trackingUrl,
    required this.payment,
    required this.refunded,
    required this.shipped,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        number: json['number'],
        date: DateTime.parse(json['date']),
        dateShipped: json['date_shipped'] == ''
            ? null
            : DateTime.parse(json['date_shipped']),
        discountCode:
            json['discount_code'] == '' ? null : json['discount_code'],
        message: json['message'],
        email: json['email'],
        phone: json['phone'],
        companyTitle:
            json['company_title'] == '' ? null : json['company_title'],
        shippingCity: json['shipping_city'],
        shippingCountry: json['shipping_country'],
        shippingCountryCode: json['shipping_country_code'],
        shippingInstructions: json['shipping_instructions'],
        shippingName: json['shipping_name'],
        shippingPostcode: json['shipping_postcode'],
        shippingService: json['shipping_service'],
        shippingState: json['shipping_state'],
        shippingStreet: json['shipping_street'],
        total: json['total'],
        totalCCFee: json['total_ccfee'],
        totalDiscount: double.parse(json['total_discount']),
        totalKickback: json['total_kickback'],
        totalSeller: json['total_seller'],
        totalShipping: json['total_shipping'],
        totalSubtotal: json['total_subtotal'],
        totalTindieFee: json['total_tindiefee'],
        trackingCode:
            json['tracking_code'] == '' ? null : json['tracking_code'],
        trackingUrl: json['tracking_url'] == '' ? null : json['tracking_url'],
        payment: json['payment'],
        refunded: json['refunded'],
        shipped: json['shipped'],
        items:
            List<Item>.from(json['items'].map((model) => Item.fromJson(model))),
      );
}

/// High level Tindie class
class Tindie {
  final String username;
  final String apikey;

  Tindie({required this.username, required this.apikey});

  Future<List<Order>> getOrders(
      {final int? limit, final int? offset, final bool? shipped}) async {
    Map<String, dynamic> parameters = {};
    if (limit != null) {
      parameters['limit'] = limit;
    }
    if (offset != null) {
      parameters['offset'] = offset;
    }
    if (shipped != null) {
      parameters['shipped'] = shipped;
    }
    final response = await http.get(
      Uri(
        scheme: 'https',
        host: 'www.tindie.com',
        path: '/api/v1/order',
        queryParameters: parameters,
      ),
      headers: {
        'Authorization': 'ApiKey $username:$apikey',
      },
    );

    if (response.statusCode != 200) {
      return Future.error(
          "Could not fetch orders. StatusCode ${response.statusCode}");
    }

    final data = jsonDecode(response.body)['orders'];
    List<Order> orders = [];
    for (Map<String, dynamic> order in data) {
      orders.add(Order.fromJson(order));
    }
    return orders;
  }
}
