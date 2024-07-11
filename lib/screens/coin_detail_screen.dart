import 'dart:convert';
import 'package:ecom/models/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/ohcl.dart';

class CoinDetailScreen extends StatefulWidget {
  var selectedItem;
  CoinDetailScreen({super.key, this.selectedItem});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  late TrackballBehavior trackballBehavior;
  List<OHLCData>? chartData;
  List<OHLCData2>? chartDataSecond;

  @override
  void initState() {
    // TODO: implement initState

    getCharts();
    trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/' +
            widget.selectedItem.id +
            '/ohlc?vs_currency=usd&days=' +
            days.toString() +
            "&precision=full"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        chartDataSecond = data.map<OHLCData2>((item) {
          final int timestamp = item[0];
          final double close = item[4].toDouble();
          return OHLCData2(
              DateTime.fromMillisecondsSinceEpoch(timestamp), close);
        }).toList();
      });
    }
  }

  Future<void> fetchData() async {
    try {
      final data = await fetchChartData();
      setState(() {
        chartData = data;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  bool isLoading = false;

  Future<List<OHLCData>> fetchChartData() async {
    final url = Uri.parse('https://api.coingecko.com/api/v3/coins/' +
        widget.selectedItem.id +
        '/ohlc?vs_currency=usd&days=' +
        days.toString() +
        "&precision=full");

    setState(() {
      isLoading = true;
    });

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final jsonData = json.decode(response.body) as List<dynamic>;
      final chartData = jsonData
          .map((item) => OHLCData(item[0].toDouble(), item[1].toDouble(),
              item[2].toDouble(), item[3].toDouble(), item[4].toDouble()))
          .toList();
      return chartData;
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to fetch chart data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var myHeight = MediaQuery.of(context).size.height;
    var myWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: myWidth * 0.05, vertical: myHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            height: myHeight * 0.08,
                            child: Image.network(widget.selectedItem.image)),
                        SizedBox(
                          width: myWidth * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedItem.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: myHeight * 0.005,
                            ),
                            Text(
                              widget.selectedItem.symbol,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$' + widget.selectedItem.currentPrice.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: myHeight * 0.005,
                        ),
                        Text(
                          widget.selectedItem.marketCapChangePercentage24H
                                  .toString() +
                              '%',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.selectedItem
                                          .marketCapChangePercentage24H >=
                                      0
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.05,
                          vertical: myHeight * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Low',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                height: myHeight * 0.01,
                              ),
                              Text(
                                '\$' + widget.selectedItem.low24H.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'High',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                height: myHeight * 0.01,
                              ),
                              Text(
                                '\$' + widget.selectedItem.high24H.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Vol',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                height: myHeight * 0.01,
                              ),
                              Text(
                                '\$' +
                                    widget.selectedItem.totalVolume.toString() +
                                    'M',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.015,
                    ),
                    Container(
                      height: myHeight * 0.4,
                      width: myWidth,
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            )
                          : chartDataSecond == null
                              ? Center(
                                  child: Text("Unable to find"),
                                )
                              : SfCartesianChart(
                                  primaryXAxis: DateTimeAxis(),
                                  legend: Legend(
                                    isVisible: false
                                  ),
                                  indicators: <TechnicalIndicators>[
                                    AccumulationDistributionIndicator(
                                      dataSource: chartDataSecond,
                                      isVisible: true,
                                     
                                    ),
                                  ],
                                  series: <LineSeries<OHLCData2, DateTime>>[
                                    LineSeries<OHLCData2, DateTime>(
                                      dataSource: chartDataSecond!,
                                      xValueMapper: (OHLCData2 data, _) =>
                                          data.x,
                                      yValueMapper: (OHLCData2 data, _) =>
                                          data.close,
                                    ),
                                  ],
                                  trackballBehavior: TrackballBehavior(
                                    enable: false,
                                    tooltipSettings: InteractiveTooltip(
                                      enable: true,
                                      color: Colors.black,
                                      borderWidth: 1,
                                      borderColor: Colors.grey,
                                      format: 'point.y',
                                    ),
                                    lineType: TrackballLineType.vertical,
                                    markerSettings: TrackballMarkerSettings(
                                      color: Colors.red,
                                    ),
                                  ),
                                  zoomPanBehavior: ZoomPanBehavior(
                                      enablePanning: false,
                                      enablePinching: true),
                                  crosshairBehavior: CrosshairBehavior(
                                    enable: true,
                                    activationMode: ActivationMode.singleTap,
                                    lineType: CrosshairLineType.both,
                                    lineColor: Colors.grey.withOpacity(0.7),
                                    lineWidth: 1,
                                    shouldAlwaysShow: true,
                                  )),
                      // : SfCartesianChart(
                      //     primaryXAxis: CategoryAxis(),
                      //     trackballBehavior: trackballBehavior,
                      //     annotations: <CartesianChartAnnotation>[
                      //       CartesianChartAnnotation(
                      //         widget: Container(
                      //           padding: EdgeInsets.all(10),
                      //           decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             borderRadius:
                      //                 BorderRadius.circular(5),
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color:
                      //                     Colors.black.withOpacity(0.2),
                      //                 spreadRadius: 2,
                      //                 blurRadius: 5,
                      //                 offset: Offset(0, 3),
                      //               ),
                      //             ],
                      //           ),
                      //           child: Text(
                      //             'Bitcoin OHLC Chart',
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         ),
                      //         coordinateUnit: CoordinateUnit.point,
                      //         x: '150',
                      //         y: 60000,
                      //         verticalAlignment: ChartAlignment.near,
                      //         horizontalAlignment: ChartAlignment.far,
                      //       ),
                      //     ],
                      //     zoomPanBehavior: ZoomPanBehavior(
                      //         enablePanning: true,
                      //         enablePinching: true,
                      //         zoomMode: ZoomMode.x),
                      //     series: <CandleSeries<OHLCData, String>>[
                      //       CandleSeries<OHLCData, String>(
                      //           enableSolidCandles: true,
                      //           enableTooltip: true,
                      //           bullColor: Colors.green,
                      //           bearColor: Colors.red,
                      //           dataSource: chartData!,
                      //           xValueMapper: (OHLCData sales, _) =>
                      //               sales.x.toString(),
                      //           lowValueMapper: (OHLCData sales, _) =>
                      //               sales.low,
                      //           highValueMapper: (OHLCData sales, _) =>
                      //               sales.high,
                      //           openValueMapper: (OHLCData sales, _) =>
                      //               sales.open,
                      //           closeValueMapper: (OHLCData sales, _) =>
                      //               sales.close,
                      //           animationDuration: 55)
                      //     ],
                      //   ),
                    ),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                    Center(
                      child: Container(
                        height: myHeight * 0.036,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: text.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: myWidth * 0.02),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    textBool = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    textBool[index] = true;
                                  });
                                  setDays(text[index]);
                                  fetchData();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: myWidth * 0.03,
                                      vertical: myHeight * 0.005),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: textBool[index] == true
                                        ? Color(0xffFBC700).withOpacity(0.3)
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    text[index],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.04,
                    ),
                    Expanded(
                        child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                          child: Text(
                            'News',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: myWidth * 0.06,
                              vertical: myHeight * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 17),
                                ),
                              ),
                              Container(
                                width: myWidth * 0.25,
                                child: CircleAvatar(
                                  radius: myHeight * 0.04,
                                  backgroundImage:
                                      AssetImage('assets/image/11.PNG'),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              Container(
                height: myHeight * 0.1,
                width: myWidth,
                // color: Colors.amber,
                child: Column(
                  children: [
                    Divider(),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: myHeight * 0.011),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xffFBC700)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: myHeight * 0.02,
                                ),
                                Text(
                                  'Add to portfolio',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: myHeight * 0.011),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey.withOpacity(0.2)),
                            child: Image.asset(
                              'assets/icons/3.1.png',
                              height: myHeight * 0.03,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<ChartModel>? itemChart;

  // bool isLoading = false;
  Future<void> getCharts() async {
    var url = 'https://api.coingecko.com/api/v3/coins/' +
        widget.selectedItem.id +
        '/ohlc?vs_currency=usd&days=1' +
        days.toString() +
        "&precision=full";
    //  +
    // days.toString();

    setState(() {
      isLoading = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);

      List<ChartModel> modelList =
          x.map((e) => ChartModel.fromJson(e)).toList();

      setState(() {
        itemChart = modelList;
        print(modelList);
      });
    } else {
      print(response.statusCode);
    }
  }

  List<String> text = ['D', 'W', 'M', '3M', '6M', 'Y'];
  List<bool> textBool = [false, false, true, false, false, false];

  int days = 30;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 90;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }
}

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<OHLCData>? chartData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await fetchChartData();
      setState(() {
        chartData = data;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart Example'),
      ),
      body: chartData != null
          ? SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries<OHLCData, String>>[
                CandleSeries<OHLCData, String>(
                  dataSource: chartData!,
                  xValueMapper: (OHLCData data, _) => data.x.toString(),
                  lowValueMapper: (OHLCData data, _) => data.low,
                  highValueMapper: (OHLCData data, _) => data.high,
                  openValueMapper: (OHLCData data, _) => data.open,
                  closeValueMapper: (OHLCData data, _) => data.close,
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<List<OHLCData>> fetchChartData() async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/bitcoin/ohlc?vs_currency=usd&days=1&precision=full');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      final chartData = jsonData
          .map((item) => OHLCData(item[0].toDouble(), item[1].toDouble(),
              item[2].toDouble(), item[3].toDouble(), item[4].toDouble()))
          .toList();
      return chartData;
    } else {
      throw Exception('Failed to fetch chart data');
    }
  }
}
