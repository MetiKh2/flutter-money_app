import 'package:flutter/material.dart';
import 'package:money_app/utils/calculate.dart';
import 'package:money_app/widgets/chart_widget.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
              child: Text('مدیریت تراکنش ها به تومان'),
            ),
            MoneyInfoWidget(
              firstPrice: Calculate.incomeToday().toString(),
              firstText: ' : دریافتی امروز',
              secondText: ' : پرداختی امروز',
              secondPrice: Calculate.payToday().toString(),
            ),
            MoneyInfoWidget(
              firstPrice: Calculate.incomeMonth().toString(),
              firstText: ' : دریافتی ماه',
              secondText: ' : پرداختی ماه',
              secondPrice: Calculate.payMonth().toString(),
            ),
            MoneyInfoWidget(
              firstPrice: Calculate.incomeYear().toString(),
              firstText: ' : دریافتی سال',
              secondText: ' : پرداختی سال',
              secondPrice: Calculate.payYear().toString(),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.all(20.0),
              height: 500,
              child: Center(
                child: BarChartSample3(),
              ),
            ),
            Spacer(),
          ],
        ),
      )),
    );
  }
}

class MoneyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;

  const MoneyInfoWidget({
    Key? key,
    required this.firstText,
    required this.firstPrice,
    required this.secondText,
    required this.secondPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
      child: Row(
        children: [
          Expanded(
              child: Text(
            firstPrice,
            textAlign: TextAlign.right,
          )),
          Text(firstText),
          Expanded(
              child: Text(
            secondPrice,
            textAlign: TextAlign.right,
          )),
          Text(secondText)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
  }
}
