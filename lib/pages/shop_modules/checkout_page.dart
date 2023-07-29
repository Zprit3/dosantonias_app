import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:dosantonias_app/widgets/shopconts_widget.dart';
import 'package:dosantonias_app/pages/pages.dart';
import 'package:dosantonias_app/widgets/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:dosantonias_app/otherthings/pay_globals.dart' as globals;
//import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartModel> cartModel;
  const CheckoutPage({Key? key, required this.cartModel}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  var isloading = false;
  
  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.chevron_left,
                size: 40,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.deepOrangeAccent,
          width: screenwidth,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: ClipPath(
                    clipper: MovieTicketClipper(),
                    child: Container(
                      color: white,
                      width: screenwidth * .8,
                      height: screenheight * .7,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'lib/images/icoMainBW.png',
                              width: 100,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Tienda Checkout',
                              style: style.copyWith(
                                  color: Colors.black, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              '\$$total',
                              maxLines: 1,
                              style: style.copyWith(
                                  color: Colors.black, fontSize: 40),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                              endIndent: 10,
                              indent: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  Text(
                                    DateTime.now().toString().substring(0, 16),
                                    style: style.copyWith(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Pago Vía: Paypal',
                                    style: style.copyWith(
                                        fontSize: 12, color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              indent: 10,
                              endIndent: 10,
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                                flex: 2,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: widget.cartModel.length,
                                    itemBuilder: (context, index) {
                                      return _builditems(
                                          name: widget.cartModel[index].name,
                                          price: widget.cartModel[index].price,
                                          items: widget.cartModel[index].items);
                                    })),
                            const SizedBox(
                              height: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(
                                      '@las2antonias',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      '+56999999999',
                                      style:
                                          TextStyle(color: Colors.orange[700]),
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildbutton(screenheight, screenwidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateUniqueId() {
    // Obtener la fecha y hora actual
    DateTime now = DateTime.now();

    // Crear una instancia de Uuid
    Uuid uuid = const Uuid();

    // Generar el ID unico basado en la fecha y hora
    String uniqueId =
        '${now.year}/${_padNumber(now.month)}/${_padNumber(now.day)}/${_padNumber(now.hour)}/${_padNumber(now.minute)}/${_padNumber(now.second)}_${uuid.v4()}';

    return uniqueId;
  }

  String _padNumber(int number) {
    // Agregar un cero delante del numero
    return number.toString().padLeft(2, '0');
  }

  void _saveProductsToFirebase(List<CartModel> cartModel) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final user = currentUser.email;
    final userProductsCollection = FirebaseFirestore.instance
        .collection('Ventas')
        .doc(user)
        .collection('TicketsComprados');

    bool isActive = true;
    for (final product in cartModel) {
      // Utilizar `add` genera un id automatico en firebase, recordar para usar en adminsite
      await userProductsCollection.add({
        'name': product.name,
        'price': product.price,
        'quantity': product.items,
        'status': isActive,
        'client': user,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}


  Widget _buildbutton(double screenheight, double screenwidth) {
    return Expanded(
      child: Container(
        width: screenwidth * .6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: MaterialButton(
          onPressed: () async {
            setState(() {
              isloading = true;
            });

            // Llamada al metodo para iniciar la integración con PayPal
            _saveProductsToFirebase(widget.cartModel); //esto debe ir despues de aprobar el pago, pero por el error de paypal esta antes para probar
            await _startPayPalCheckout();

            setState(() {
              isloading = false;
            });
          },
          child: (isloading)
              ? const CircularProgressIndicator(
                  color: Colors.orangeAccent,
                )
              : Text(
                  'Pagar ahora',
                  style: style.copyWith(fontSize: 18, color: Colors.black),
                ),
        ),
      ),
    );
  }

  _buildawesomedialog() {
    return AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            title: 'Pago Completado',
            btnOkText: 'Volver',
            btnOkIcon: Icons.check,
            dismissOnBackKeyPress: false,
            btnOkOnPress: () {
              boughtitems.clear();
              total = 0;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const ShopPage()));
            },
            btnOkColor: Colors.deepOrange,
            buttonsBorderRadius: BorderRadius.circular(20))
        .show();
  }

  Future<void> _startPayPalCheckout() async {
    String clientId = globals.ppClientID;
    String secretKey = globals.ppSecretKey1;

    double subtotal = 0;
    widget.cartModel.forEach((product) {
      subtotal += product.price * product.items;
    });

    List<Map<String, dynamic>> transactions = [
      {
        "amount": {
          "total": subtotal.toString(), // Total calculado de los artículos
          "currency": "USD",
        },
        "description": "Pago de productos",
        "item_list": {
          "items": widget.cartModel.map((product) {
            return {
              "name": product.name,
              "quantity": product.items,
              "price": product.price.toString(),
              "currency": "USD",
            };
          }).toList(),
        },
      },
    ];

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => /*PaypalCheckout*/ UsePaypal(
        sandboxMode: true,
        clientId: clientId,
        secretKey: secretKey,
        returnURL:
            "https://testapp.com/payment/success", // URL de retorno en caso de éxito
        cancelURL:
            "https://testapp.com/payment/cancel", // URL de retorno en caso de cancelación
        transactions: transactions,
        note: "Nota de pago",
        onSuccess: (Map params) async {
          print("onSuccess: $params");
          _saveProductsToFirebase(widget.cartModel);
          _buildawesomedialog();
        },
        onError: (error) {
          print("onError: $error");
        },
        onCancel: () {
          print('cancelled:');
        },
      ),
    ));
  }

  Widget _builditems(
      {required String name, required double price, required int items}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          Text(
            items > 1 ? '$name * $items' : name,
            style: style.copyWith(fontSize: 14, color: Colors.black),
          ),
          const Spacer(),
          Text(
            '\$$price',
            style: style.copyWith(fontSize: 14, color: Colors.black),
          )
        ],
      ),
    );
  }
}
