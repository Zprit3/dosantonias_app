import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
// ignore: unnecessary_import
import 'package:badges/badges.dart' as badges;
import 'package:dosantonias_app/widgets/shopconts_widget.dart';
import 'package:dosantonias_app/pages/pages.dart';
import 'package:dosantonias_app/widgets/models.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Tienda',
              style: style.copyWith(color: Colors.black, fontSize: 32),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyCartPage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.money,
                      color: Colors.deepOrangeAccent,
                      size: 28,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      'Pagar',
                      style: style.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.deepOrangeAccent),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyFavorite()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15, right: 30),
                child: favouriteitems.isNotEmpty
                    ? badges.Badge(
                        badgeContent: Text(
                          favouriteitems.length.toString(),
                          style: style.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: white),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.deepOrange,
                          size: 28,
                        ),
                      )
                    : const Icon(
                        Icons.favorite,
                        color: Colors.deepOrangeAccent,
                        size: 28,
                      ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TabBar(
                  controller: _controller,
                  unselectedLabelStyle: style.copyWith(fontSize: 12),
                  labelStyle: style.copyWith(fontSize: 12),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orange),
                  unselectedLabelColor: Colors.grey.shade800,
                  tabs: const [
                    Tab(
                      text: 'Todo',
                    ),
                    Tab(
                      text: 'Tickets1',
                    ),
                    Tab(
                      text: 'Tickets2',
                    ),
                    Tab(
                      text: 'Tickets3',
                    ),
                  ]),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: TabBarView(controller: _controller, children: [
                  _buildlistitem(items: allTickets),
                  _buildlistitem(items: routeTicketList),
                  _buildlistitem(items: routeTicketList2),
                  _buildlistitem(items: routeTicketList3),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildlistitem({required List<TicketModel> items}) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return index % 2 == 0
              ? BounceInLeft(
                  duration: const Duration(milliseconds: 1000),
                  child: _builditem(myitems: items, index: index))
              : BounceInRight(
                  duration: const Duration(milliseconds: 1000),
                  child: _builditem(myitems: items, index: index));
        });
  }

  Widget _builditem({required List<TicketModel> myitems, required int index}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DetailsPage(
                      item: myitems[index],
                    )));
      },
      child: AspectRatio(
        aspectRatio: 3 / 2.3,
        child: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: myitems[index].color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 10, color: Colors.grey, offset: Offset(0, 10))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    myitems[index].img,
                    fit: BoxFit.cover,
                    width: 140,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          myitems[index].name,
                          style: style.copyWith(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              myitems[index].isselected =
                                  !myitems[index].isselected;
                            });
                            myitems[index].isselected
                                ? favouriteitems.add(myitems[index])
                                : favouriteitems.remove(myitems[index]);
                          },
                          child: Icon(
                            Icons.favorite_sharp,
                            color: myitems[index].isselected
                                ? Colors.deepOrangeAccent
                                : Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Text(
                      myitems[index].company,
                      style: style.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.deepOrangeAccent),
                    ),
                    const Spacer(),
                    Text(
                      '\$ ${myitems[index].price} ',
                      style: style.copyWith(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
