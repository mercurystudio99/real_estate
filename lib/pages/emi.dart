import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:real_estate/theme/color.dart';

class EMIPage extends StatefulWidget {
  const EMIPage({Key? key}) : super(key: key);
  @override
  _EMIPageState createState() => _EMIPageState();
}

class _EMIPageState extends State<EMIPage> {
  late double _result = 0;
  late double _rate = 0;
  late double _tax = 0;
  late double _insurance = 0;
  late List<ChartData> chartData = [
    ChartData('principal', 0, Colors.blue.shade900),
    ChartData('tax', 0, Colors.blue.shade600),
    ChartData('insurance', 0, Colors.blue.shade200)
  ];

  final _totalamountController = TextEditingController();
  final _downpaymentController = TextEditingController();
  final _interestrateController = TextEditingController();
  final _loantermsController = TextEditingController();
  final _taxController = TextEditingController();
  final _insuranceController = TextEditingController();

  void _calculate() {
    double total = double.parse(_totalamountController.text.trim());
    double down = double.parse(_downpaymentController.text.trim());
    double rate = double.parse(_interestrateController.text.trim());
    double terms = double.parse(_loantermsController.text.trim());
    double tax = double.parse(_taxController.text.trim());
    double insurance = double.parse(_insuranceController.text.trim());
    _rate = rate;
    _tax = tax;
    _insurance = insurance;
    _result = total + down + rate * terms + tax * insurance;
    chartData = [
      ChartData('principal', _rate, Colors.blue.shade900),
      ChartData('tax', _tax, Colors.blue.shade600),
      ChartData('insurance', _insurance, Colors.blue.shade200)
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.22),
            const Text(
              'EMI Calculate',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _totalamountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Amount(\₹)',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: TextField(
                controller: _downpaymentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Down Payment',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ])),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _interestrateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Interest Rate(%)',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: TextField(
                controller: _loantermsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Loan Terms(Years)',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ])),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _taxController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Property Tax(\₹)',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: TextField(
                controller: _insuranceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Home Insurance(\₹)',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ])),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
        child: SizedBox(
            height: 50, //height of button
            width: MediaQuery.of(context).size.width, //width of button
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  elevation: 10, //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(8)),
                  shadowColor: Colors.black.withOpacity(0.4),
                  padding:
                      const EdgeInsets.all(5) //content padding inside button
                  ),
              onPressed: _calculate,
              child: const Text(
                'CALCULATE',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            )),
      ),
      const SizedBox(height: 20),
      Container(
          child: SfCircularChart(annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
            widget: Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: '\₹$_result',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28)),
              TextSpan(text: '\n'),
              TextSpan(
                  text: 'monthly',
                  style: TextStyle(color: Colors.black, fontSize: 24)),
            ]),
          ),

          //         Column(children: [
          //   const Text('\$752',
          //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
          //   const Text('monthly', style: TextStyle(fontSize: 26)),
          // ])
        ))
      ], series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
            dataSource: chartData,
            pointColorMapper: (ChartData data, _) => data.color,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            radius: '100%')
      ])),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Principal & Interest'),
            const Spacer(),
            Text(_rate.toString())
          ])),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Property Tax'),
            const Spacer(),
            Text(_tax.toString())
          ])),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade200,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Home Insurance'),
            const Spacer(),
            Text(_insurance.toString())
          ])),
      const SizedBox(height: 80)
    ])));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
