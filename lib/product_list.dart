import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:product_project/cart_model.dart';
import 'package:product_project/cart_provider.dart';
import 'package:product_project/cart_screen.dart';
import 'package:product_project/db_helper.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = [
    "Mango",
    "Orange",
    "Grapes",
    "Banana",
    "Cherry",
    "Peach",
    "Mix Fruit Bascet"
  ];
  List<String> productUnit = ["Kg", "Dozen", "Kg", "Dozen", "Kg", "Kg", "Kg"];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'assets/images/mangologo.png',
    'assets/images/orangelogo.png',
    'assets/images/grapeslogo.png',
    'assets/images/bananalogo.png',
    'assets/images/cherrylogo.png',
    'assets/images/peachlogo.png',
    'assets/images/fruitbascet.png'
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ));
            },
            child: Center(
              child: Badge(
                label: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getCounter().toString());
                  },
                ),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                  height: 100,
                                  width: 100,
                                  image: AssetImage(
                                      productImage[index].toString())),
                              SizedBox(width: 15),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productName[index].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  SizedBox(height: 5),
                                  Text(
                                      productUnit[index].toString() +
                                          "   " +
                                          r"$" +
                                          productPrice[index].toString(),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9E9E9E))),
                                  InkWell(
                                    onTap: () {
                                      print(productName[index].toString());
                                      print(productPrice[index]);
                                      print(productUnit[index].toString());
                                      print(productImage[index].toString());

                                      dbHelper!
                                          .insert(Cart(
                                              id: index,
                                              productId: index.toString(),
                                              productName:
                                                  productName[index].toString(),
                                              initialPrice: productPrice[index],
                                              productPrice: productPrice[index],
                                              quantity: 1,
                                              unitTag:
                                                  productUnit[index].toString(),
                                              image: productImage[index]
                                                  .toString()))
                                          .then((value) {
                                        print("Product is added in cart");
                                        cart.addTotalPrice(double.parse(
                                            productPrice[index].toString()));
                                        cart.addCounter();
                                      }).onError((error, stackTrace) {
                                        print("error" + error.toString());
                                      });
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: Text("Add to cart",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
