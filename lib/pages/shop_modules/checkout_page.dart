import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:dosantonias_app/widgets/shopconts_widget.dart';
import 'package:dosantonias_app/pages/pages.dart';
import 'package:dosantonias_app/widgets/models.dart';

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
                                    'Medio de pago: MercadoPago',
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

  Expanded _buildbutton(double screenheight, screenwidth) {
    return Expanded(
      child: Container(
        width: screenwidth * .6,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: white),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              isloading = true;
            });
            Future.delayed(const Duration(seconds: 3)).then((value) {
              setState(() {
                isloading = false;
              });
              _buildawesomedialog();
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
