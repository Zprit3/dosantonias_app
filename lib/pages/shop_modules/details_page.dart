import 'package:flutter/material.dart';
import 'package:dosantonias_app/widgets/models.dart';

import 'package:dosantonias_app/widgets/shopconts_widget.dart';

class DetailsPage extends StatefulWidget {
  final TicketModel item;

  const DetailsPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(.5),
                Colors.black.withOpacity(.0),
              ],
              begin: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              _buildupperpart(
                  screenwidth: screenwidth, screenheight: screenheight),
              _buildbottompart(screenheight)
            ],
          )),
    );
  }

  Expanded _buildbottompart(double screenheight) {
    return Expanded(
        child: Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.item.name,
              style: style.copyWith(color: Colors.black),
            ),
            const SizedBox(
              height: 80,
            ),
            Text(
              'Ticket para recorridos en bicicleta en "las 2 Antonias". Puedes cambiar la cantidad de tickets en el carro de compras',
              style: style.copyWith(
                  fontWeight: FontWeight.w100,
                  fontSize: 16,
                  color: Color.fromARGB(255, 193, 106, 0)),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildbutton(screenheight)
          ],
        ),
      ),
    ));
  }

  Flexible _buildbutton(double screenheight) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        height: screenheight * .08,
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: widget.item.color),
        child: MaterialButton(
          onPressed: () {
            if (boughtitems
                .map((item) => item.name)
                .contains(widget.item.name)) {
              final snackBar = SnackBar(
                  backgroundColor: Colors.teal,
                  duration: const Duration(seconds: 2),
                  content: Text(
                    'Este ítem ya ha sido agregado anteriormente y esta listo en el carro de compras',
                    style: style.copyWith(fontSize: 14, color: Colors.white),
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              boughtitems.add(
                CartModel(
                  name: widget.item.name,
                  price: widget.item.price,
                  img: widget.item.img,
                  color: widget.item.color,
                  items: 1,
                ),
              );
              total = (total + widget.item.price);
              Navigator.pop(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.backpack,
                color: white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Agregar al carro',
                style: style.copyWith(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildupperpart(
      {required var screenwidth, required var screenheight}) {
    return Container(
      width: screenwidth,
      height: screenheight * .6,
      decoration: BoxDecoration(
          color: widget.item.color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.item.isselected = !widget.item.isselected;

                      widget.item.isselected
                          ? favouriteitems.add(widget.item)
                          : favouriteitems.remove(widget.item);
                    });
                  },
                  child: Icon(
                    Icons.favorite_sharp,
                    color: widget.item.isselected ? Colors.red : Colors.white,
                    size: 30,
                  ),
                )
              ],
            ),
            Center(
              child: Image.asset(
                widget.item.img,
                width: 500,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
