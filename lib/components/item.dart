import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  var item;
  Item({this.item});

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: myWidth * 0.020, vertical: myHeight * 0.025),
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  height: myHeight * 0.055, child: Image.network(item.image)),
            ),
            SizedBox(
              width: myWidth * 0.02,
            ),
            Expanded(
              flex: 2,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '0.4 ' + item.symbol,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                  ),
                ],
              ),
            ),
           
            Expanded(
              flex: 2,
              child: Container(
                height: myHeight * 0.05,
                width: myWidth * 0.15,
                // child: Text("Hello")
                child:Sparkline(
                  data: item.sparklineIn7D.price,
                  lineWidth: 2.0,
                  lineColor: item.marketCapChangePercentage24H >= 0
                      ? Colors.green
                      : Colors.red,
                  fillMode: FillMode.below,
                  fillGradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.7],
                      colors: item.marketCapChangePercentage24H >= 0
                          ? [Colors.green, Colors.green.shade100]
                          : [Colors.red, Colors.red.shade100]),
                ),
              ),
            ),
             SizedBox(width: myWidth * 0.04,),
           
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$ ' + item.currentPrice.toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: myHeight * 0.002,),
                  Text(
                    item.priceChange24H.toString().contains('-')
                        ? "-\$" +
                            item.priceChange24H
                                .toStringAsFixed(2)
                                .toString()
                                .replaceAll('-', '')
                        : "\$" + item.priceChange24H.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                   SizedBox(height: myHeight * 0.002,),
                  Text(
                    item.marketCapChangePercentage24H.toStringAsFixed(2) +
                    '%',
                    style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: item.marketCapChangePercentage24H >= 0
                        ? Colors.green
                        : Colors.red),
                  ),
                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
