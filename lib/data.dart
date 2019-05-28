import 'package:flutter/material.dart';
import 'package:emania/custom_icons.dart';
import 'package:emania/models/category.dart';
import 'package:emania/models/product.dart';
import 'package:emania/import.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';

List<Product> products = [];
List<Category> categories = [];

List<Product> getProducts() {
  return products;
}

List<Category> getCategories() {
  return categories;
}

Category getCategory(name) {
  return Category(name, Icons.format_align_center);
}

void request() async {
  var c = HttpClient();
  c.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  var i = IOClient(c);
  var json = await i.get(
      "http://ec2-52-14-74-144.us-east-2.compute.amazonaws.com/api/products");
  var decoded = jsonDecode(json.body);

  for (var i = 0; i < decoded.length; i++) {
    categories.add(Category(decoded[i]["category"], Icons.format_align_center));
    products.add(Product(
        decoded[i]["images"][0],
        decoded[i]["name"],
        double.parse(decoded[i]["price"]),
        decoded[i]["desc"],
        getCategory(decoded[i][
            "category"]), //Category(decoded[i]["category"], Icons.format_align_center),
        i));
  }

  categories.toSet();//.toList(growable: true);
  //categories.

  appState.setState(() {
    appState.cL = categories;
    appState.pL = products;
  });
}

Category getCategoryFromName(name) {
  return categories 
      .firstWhere((c) => c.name.toLowerCase() == name.toString().toLowerCase());
}

void paymentCCDC(ccn, ey, em, cvv, name, address, phone) async {
  String merchantCode = "1000000032";

  String customerProfileId = "7uyA76gf2";
  var tokenRes = await http.post(
      "https://www.atfawry.com/ECommerceWeb/Fawry/cards/cardToken",
      body: {
        "mercahntCode": merchantCode,
        "customerProfileId": customerProfileId,
        "customerMobile": phone,
        "customerEmail": "test@example.com",
        "cardNumber": ccn,
        "expiryYear": ey,
        "expiryMonth": em,
        "cvv": cvv
      });
  var tokenDecoded = jsonDecode(tokenRes.body);
  var checkoutRes = await http.post(
    "https://www.atfawry.com/ECommerceWeb/Fawry/payments/charge",
    body: {
      "merchantCode": merchantCode,
      "merchantRefNum": "7uyA76gf2",
      "customerProfileId": "7uyA76gf2",
      "customerMobile": "01000000200",
      "customerEmail": "ahmedmgh67@gmail.com",
      "paymentMethod": "CARD",
      "amount": MyApp.shoppingBasket.totalPrice,
      "currencyCode": "EGP",
      "description": "the charge request description",
      "cardToken": tokenDecoded["card"]["token"],
      "chargeItems": [
        {
          "itemId": "897fa8e81be26df25db592e81c31c",
          "description": "asdasd",
          "price": 15.20,
          "quantity": 1
        }
      ],
      "signature":
          "fc82831bcd928d22337e9eace61d30c75d6fc027f59f0be571f90ab2231967fa"
    },
  );
  var checkoutDecoded = jsonDecode(checkoutRes.body);
  var orderRes = await http.post(
    "url",
    body: { 
      "": "",
    },
  );
  var orderDecoded = jsonDecode(orderRes.body);
}

void paymentCOD(name, address, phone) async {
  var orderRes = await http.post(
    "http://ec2-52-14-74-144.us-east-2.compute.amazonaws.com/api/orders",
    body: {
      "payment": "Cash On delivery",
      "user":name,
      "address": address,
      "phone": phone,
      "price":MyApp.shoppingBasket.totalPrice.toString(),
      "products":MyApp.shoppingBasket.itemsAndQuantities.keys.map((itemId) => getProducts()[itemId])
    },
  );
  var orderDecoded = jsonDecode(orderRes.body);

}

class Data {
  static List<Category> categories = [
    Category("Plant", CustomIcons.plant),
    Category("Lamp", CustomIcons.desk_lamp),
    Category("Chair", CustomIcons.chair),
    Category("Other", Icons.timeline)
  ];

  // static List<Product> products = [
  //   Product(
  //       "https://images.pexels.com/photos/112811/pexels-photo-112811.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //       "Elegant Lamp",
  //       13.00,
  //       "Both practical and beautiful, this lamp is a great addition to any workspace",
  //       getCategoryFromName("Lamp"),
  //       0),
  //   Product(
  //       "https://images.pexels.com/photos/509922/pexels-photo-509922.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //       "Traditional Chair",
  //       23.00,
  //       "A traditional chair, suitable for any application",
  //       getCategoryFromName("Chair"),
  //       1),
  //   Product(
  //       "https://images.pexels.com/photos/56589/cactus-plant-plant-rack-green-56589.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //       "Cactus",
  //       23.0,
  //       "in addition to being a decoration, cactus can also be a health benefit, let's buy cactus in our store because now discount 30%",
  //       getCategoryFromName("Plant"),
  //       2),
  //   Product(
  //       "https://images.pexels.com/photos/279618/pexels-photo-279618.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //       "Cupboard",
  //       13.0,
  //       "Simplistic cupboard, which works in every situation",
  //       getCategoryFromName("Other"),
  //       3),
  //   Product(
  //       "https://images.pexels.com/photos/276534/pexels-photo-276534.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //       "Reclined Chair",
  //       26.0,
  //       "White reclined chair",
  //       getCategoryFromName("Chair"),
  //       4),
  //   Product(
  //       "https://images.pexels.com/photos/993626/pexels-photo-993626.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //       "Alfalfa Plant",
  //       6.0,
  //       "Potted Alfalfa Plant",
  //       getCategoryFromName("Plant"),
  //       5),
  //   Product(
  //       "https://images.pexels.com/photos/135168/pexels-photo-135168.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //       "Rosemary",
  //       7.0,
  //       "Potted Rosemary Plant",
  //       getCategoryFromName("Plant"),
  //       6)
  // ];

  static Category getCategoryFromName(name) {
    return categories.firstWhere(
        (c) => c.name.toLowerCase() == name.toString().toLowerCase());
  }
}
