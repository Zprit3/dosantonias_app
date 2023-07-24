import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:dosantonias_app/widgets/shopconts_widget.dart';
import 'package:dosantonias_app/pages/pages.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({Key? key}) : super(key: key);

  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.deepOrange,
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Mi Carro',
            style: style.copyWith(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: boughtitems.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: screenheight * .7,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: boughtitems.length,
                              itemBuilder: (context, index) {
                                return index % 2 == 0
                                    ? BounceInLeft(
                                        child: _buildcartitem(index: index))
                                    : BounceInRight(
                                        child: _buildcartitem(index: index));
                              })),
                      const SizedBox(
                        height: 39,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: screenwidth * .4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.deepOrangeAccent),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => CheckoutPage(
                                                  cartModel: boughtitems,
                                                )));
                                  },
                                  child: Text(
                                    'Verificar compra',
                                    style: style.copyWith(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Total = \$$total',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: style.copyWith(
                                    fontSize: 14, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                      'No has agregado ítems al carro',
                      style: style.copyWith(
                        color: const Color.fromARGB(255, 148, 29, 29),
                        fontSize: 16,
                      ),
                    ),
                  )),
      ),
    );
  }

  Widget _buildcartitem({required int index}) {
    var column = Column(
      children: [
        _additems(
          item: boughtitems[index].items,
          index: index,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
    var children2 = [
      Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: boughtitems[index].color),
          child: Image.asset(
            boughtitems[index].img,
            fit: BoxFit.cover,
            width: 80,
          )),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              boughtitems[index].name,
              maxLines: 1,
              style: style.copyWith(fontSize: 16, color: Colors.black),
            ),
            Text(
              '\$${boughtitems[index].price}',
              maxLines: 1,
              style: style.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            Text(
              'Cantidad : ${boughtitems[index].items}',
              style: style.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700]),
            ),
          ],
        ),
      ),
      column
    ];
    var boxDecoration = BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey,
            offset: Offset(0, 10),
          ),
        ]);
    return Dismissible(
      key: Key(boughtitems[index].name),
      onDismissed: (dir) {
        setState(() {
          total = (total - boughtitems[index].price);
          boughtitems.remove(boughtitems[index]);
        });
      },
      background: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.grey[300],
          size: 40,
        ),
        alignment: Alignment.centerLeft,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: boxDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children2,
        ),
      ),
    );
  }

  Widget _additems({required int item, required int index}) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              final originalprice =
                  boughtitems[index].price / boughtitems[index].items;

              boughtitems[index].items++;

              boughtitems[index].price =
                  originalprice * boughtitems[index].items;
              total = (total + originalprice);
            });
          },
          child: Text('+',
              style: style.copyWith(
                fontSize: 20,
                color: Colors.orangeAccent,
              )),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[800],
          ),
          child: Text(item.toString(),
              style: style.copyWith(
                fontSize: 14,
              )),
        ),
        InkWell(
          onTap: () {
            setState(() {
              final originalprice =
                  boughtitems[index].price / boughtitems[index].items;

              if (boughtitems[index].items > 1) {
                boughtitems[index].items--;
                boughtitems[index].price =
                    boughtitems[index].price - originalprice;

                total = (total - originalprice);
              }
            });
          },
          child: Text('-',
              style: style.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.orangeAccent)),
        ),
      ],
    );
  }
}
