import 'package:flutter/material.dart';

class Item2 extends StatelessWidget {
  var item;
  Item2({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    var myHeight = MediaQuery.of(context).size.height;
    var myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
          left: myWidth * 0.005, top: myWidth * 0.01, bottom: myWidth * 0.01),
      child: Container(
          height: myHeight * 0.007,
          width: myWidth * 0.05,
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  color: Colors.grey.shade300,
                  spreadRadius: 2,
                  offset: Offset(0, 3))
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: myWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: myHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.04),
                  child: Image.network(
                    item.image,
                    height: myHeight * 0.08,
                  ),
                ),
                SizedBox(
                  height: myHeight * 0.02,
                ),
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: myHeight * 0.01,
                ),
                Text(item.currentPrice.toString()),
                SizedBox(height: myHeight * 0.008),
                Text(
                  item.marketCapChangePercentage24H.toStringAsFixed(2) + "%",
                  style: TextStyle(
                      color: item.marketCapChangePercentage24H >= 0
                          ? Colors.green
                          : Colors.red),
                ),
                SizedBox(height: myHeight * 0.008),
                Text(item.priceChange24H.toStringAsFixed(5),style: TextStyle(
                  color: item.marketCapChangePercentage24H >= 0
                          ? Colors.green
                          : Colors.red
                ),)
              ],
            ),
          )),
    );
  }
}
