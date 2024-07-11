import 'package:ecom/components/item.dart';
import 'package:ecom/models/coin_model.dart';
import 'package:ecom/screens/coin_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

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

    bool selected = true;
    bool main , top;
    
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
          body: Container(
            height: myHeight,
            width: myWidth,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 255, 219, 73),
              Color(0xffFBC700)
            ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: myHeight * 0.008),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth * 0.03,
                            vertical: myHeight * 0.015),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                             selected = !selected ;
                             main = true;
                             top = false;
                            print(main);
                            print(top);
                          },
                          child: Text(
                            "Main Portfolio",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          
                            main = false;
                            top = true;

                            print(main);
                            print(top);
                          
                        },
                        child: Text(
                          "Top 10 coins",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Text(
                        "Experimental",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$ 7,466.20',
                        style: TextStyle(fontSize: 25),
                      ),
                      Container(
                        padding: EdgeInsets.all(myWidth * 0.02),
                        height: myHeight * 0.05,
                        width: myWidth * 0.1,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.5)),
                        child: Image.asset(
                          'assets/icons/5.1.png',
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                  child: Row(
                    children: [
                      Text(
                        '+162% all time',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: myHeight * 0.02,
                ),
                Container(
                  height: myHeight * 0.65,
                  width: myWidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey.shade300,
                            spreadRadius: 3,
                            offset: Offset(0, 3))
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: myHeight * 0.03,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Assets',
                              style: TextStyle(fontSize: 20),
                            ),
                            Icon(Icons.add)
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        height: myHeight * 0.54,
                        child: Expanded(
                          
                            child: isLoading ? Center(child: CircularProgressIndicator(color:Color(0xffFBC700))) : ListView.builder(
                                itemCount: coinMarket!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder:(context) => CoinDetailScreen(selectedItem: coinMarket![index],)));
                                    },
                                    child: Item(item: coinMarket![index],));
                                }))  ,
                      ),
                      SizedBox(
                        height: myHeight * 0.02,
                      ),
    
                     
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }


 

  List? coinMarket = [];

  bool isLoading = false;

  var coinMarketlist;

  Future<List<CoinModel>?> getCoindata() async {
    var url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isLoading = true;
    });

    var response = await http.get(Uri.parse(url),headers: {
      "Content-Type":"application/json",
      "Accept":"application/json"
    });

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200){
      var x = response.body;

      coinMarketlist = coinModelFromJson(x);

      setState(() {
        coinMarket = coinMarketlist;
      });
    }else {
      print(response.statusCode);
    }
  }
}

