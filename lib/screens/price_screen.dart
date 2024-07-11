import 'package:ecom/components/item2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';
import 'coin_detail_screen.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}


class _PriceScreenState extends State<PriceScreen> {


  @override
  void initState() {
    // TODO: implement initState
    getCoindata();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {

    
    var myHeight = MediaQuery.of(context).size.height;
    var myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0,left: 8),
            child: Text(
              "Recommended to buy",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: myHeight * 0.02,
          ),
          isLoading
              ? Container(
                height: myHeight * 0.8,
                width: myWidth,
                child: Center(child: CircularProgressIndicator(color: Color(0xffFBC700),)))
              : Padding(
                padding:  EdgeInsets.symmetric(horizontal:myWidth * 0.02),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio:0.54,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemCount: coinMarket!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                         onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder:(context) => CoinDetailScreen(selectedItem: coinMarket![index],)));
                                  },
                        child: Item2(
                          item: coinMarket![index],
                        ),
                      );
                    }),
              ),
        ],
      ),
    );
  }

  List? coinMarket = [];

  bool isLoading = false;

  var coinMarketlist;

  Future<List<CoinModel>?> getCoindata() async {
    var url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

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
      var x = response.body;

      coinMarketlist = coinModelFromJson(x);

      setState(() {
        coinMarket = coinMarketlist;
        print(coinMarketlist);
      });
    } else {
      print(response.statusCode);
    }
  }
}
