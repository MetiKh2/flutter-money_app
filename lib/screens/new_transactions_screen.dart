import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_app/constants.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class NewTransactionsScreen extends StatefulWidget {
  const NewTransactionsScreen({super.key});
  static int groupId = 0;
  static String date = 'تاریخ';
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int index = 0;
  @override
  State<NewTransactionsScreen> createState() => _NewTransactionsScreenState();
}

class _NewTransactionsScreenState extends State<NewTransactionsScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NewTransactionsScreen.isEditing
                    ? 'ویرایش تراکنش'
                    : 'تراکنش جدید',
                style: TextStyle(fontSize: 18),
              ),
              MyTextField(
                hintText: 'توضیحات',
                controller: NewTransactionsScreen.descriptionController,
                type: TextInputType.text,
              ),
              MyTextField(
                hintText: 'مبلغ',
                type: TextInputType.number,
                controller: NewTransactionsScreen.priceController,
              ),
              TextButton(
                  onPressed: () async {
                    var pickedDate = await showPersianDatePicker(
                        context: context,
                        initialDate: Jalali.now(),
                        firstDate: Jalali(1400),
                        lastDate: Jalali(1500),
                        cancelText: null);

                    setState(() {
                      if (pickedDate != null) {
                        String year = pickedDate.year.toString();
                        String month = pickedDate.month.toString().length == 1
                            ? '0${pickedDate.month.toString()}'
                            : pickedDate.month.toString();
                        String day = pickedDate.day.toString().length == 1
                            ? '0${pickedDate.day.toString()}'
                            : pickedDate.day.toString();
                        NewTransactionsScreen.date =
                            year + '/' + month + '/' + day;
                      }
                    });
                  },
                  child: Text(
                    NewTransactionsScreen.date,
                    style: TextStyle(color: Colors.black),
                  )),
              MyRadioButton(
                groupValue: NewTransactionsScreen.groupId,
                onChanged: (value) {
                  setState(() {
                    NewTransactionsScreen.groupId = value!;
                  });
                },
                value: 1,
                text: 'پرداختی',
              ),
              MyRadioButton(
                groupValue: NewTransactionsScreen.groupId,
                onChanged: (value) {
                  setState(() {
                    NewTransactionsScreen.groupId = value!;
                  });
                },
                value: 2,
                text: 'دریافتی',
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Money money = Money(
                        date: NewTransactionsScreen.date,
                        price: NewTransactionsScreen.priceController.text,
                        title: NewTransactionsScreen.descriptionController.text,
                        id: Random().nextInt(999999999),
                        isReceived:
                            NewTransactionsScreen.groupId == 1 ? false : true);
                    if (!NewTransactionsScreen.isEditing) {
                      // HomeScreen.moneyList.add(money);
                      hiveBox.add(money);
                    } else {
                      int index = 0;
                      MyApp.getData();
                      for (var i = 0; i < hiveBox.values.length; i++) {
                        if (hiveBox.values.elementAt(i).id ==
                            NewTransactionsScreen.index) {
                          index = i;
                        }
                      }
                      hiveBox.putAt(index, money);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(NewTransactionsScreen.isEditing
                      ? 'ویرایش کردن'
                      : 'اضافه کردن'),
                  style: TextButton.styleFrom(
                      backgroundColor: kPurpleColor, elevation: 0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyRadioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;
  const MyRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(text),
      ],
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.grey.shade300,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)),
          hintText: hintText),
    );
  }
}
