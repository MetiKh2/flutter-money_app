import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_app/constants.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/new_transactions_screen.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static List<Money> moneyList = [
    Money(
        id: 0,
        isReceived: true,
        date: '1401/10/11',
        price: '1000',
        title: 'Test1'),
    Money(
        id: 1,
        isReceived: false,
        date: '1401/10/13',
        price: '3000',
        title: 'Test2'),
    Money(
        id: 2,
        isReceived: true,
        date: '1401/11/11',
        price: '13000',
        title: 'Test3'),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  void initState() {
    MyApp.getData();
    super.initState();
  }

  Widget HeaderWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              isOriginalAnimation: false,
              hintText: 'جستجو کنید ...',
              buttonElevation: 0,
              textEditingController: searchController,
              buttonBorderColour: Colors.black26,
              onFieldSubmitted: (String value) {
                List<Money> result = hiveBox.values
                    .where((element) =>
                        element.title.contains(value) ||
                        element.date.contains(value))
                    .toList();
                HomeScreen.moneyList.clear();
                setState(() {
                  for (var element in result) {
                    HomeScreen.moneyList.add(element);
                  }
                });
              },
              onCollapseComplete: () {
                MyApp.getData();
                searchController.text = '';
                setState(() {});
              },
              buttonWidget: Icon(
                Icons.search,
                color: Colors.black,
              ),
              secondaryButtonWidget: Icon(
                Icons.search,
                color: Colors.black,
              ),
              trailingWidget: Container(),
            ),
          ),
          Text('تراکنش ها', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NewTransactionsScreen.descriptionController.text = '';
            NewTransactionsScreen.priceController.text = '';
            NewTransactionsScreen.groupId = 0;
            NewTransactionsScreen.date = 'تاریخ';
            NewTransactionsScreen.isEditing = false;
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewTransactionsScreen()))
                .then((value) {
              MyApp.getData();
              setState(() {
                print('object');
              });
            });
          },
          backgroundColor: kPurpleColor,
          child: const Icon(Icons.add),
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              HeaderWidget(),
              // const Expanded(child: EmptyWidget())
              Expanded(
                  child: HomeScreen.moneyList.isEmpty
                      ? const EmptyWidget()
                      : ListView.builder(
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                NewTransactionsScreen.descriptionController
                                    .text = HomeScreen.moneyList[index].title;
                                NewTransactionsScreen.priceController.text =
                                    HomeScreen.moneyList[index].price;
                                NewTransactionsScreen.groupId =
                                    HomeScreen.moneyList[index].isReceived
                                        ? 2
                                        : 1;
                                NewTransactionsScreen.isEditing = true;
                                NewTransactionsScreen.index =
                                    HomeScreen.moneyList[index].id;
                                NewTransactionsScreen.date =
                                    HomeScreen.moneyList[index].date;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NewTransactionsScreen(),
                                    )).then((value) {
                                  MyApp.getData();
                                  setState(() {});
                                });
                              },
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                            'آیا از حذف این آیتم مطمئن هستید؟',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('خیر')),
                                            TextButton(
                                                onPressed: () {
                                                  hiveBox.deleteAt(index);
                                                  MyApp.getData();
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: Text('بله'))
                                          ],
                                          actionsAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ));
                              },
                              child: MyListTileWidget(
                                index: index,
                              ),
                            );
                          }),
                          itemCount: HomeScreen.moneyList.length,
                        ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyListTileWidget extends StatelessWidget {
  final int index;
  const MyListTileWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: HomeScreen.moneyList[index].isReceived
                      ? kGreenColor
                      : kRedColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Icon(
                  HomeScreen.moneyList[index].isReceived
                      ? Icons.add
                      : Icons.remove,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(HomeScreen.moneyList[index].title),
            ),
            Spacer(),
            Column(
              children: [
                Row(children: [
                  Text(
                    'تومان',
                    style: TextStyle(color: kRedColor),
                  ),
                  Text(
                    HomeScreen.moneyList[index].price,
                    style: TextStyle(color: kRedColor),
                  )
                ]),
                Text(HomeScreen.moneyList[index].date)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          'assets/images/empty.png',
          height: 200,
          width: 200,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('! تراکنشی موجود نیست '),
        const Spacer()
      ],
    );
  }
}
