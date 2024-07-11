import 'package:ecom/screens/navbar_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    var myHeight = MediaQuery.of(context).size.height;
    var myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: myHeight,
        width: myWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/image/1.gif"),
            Column(
              children: [
                Text("The Future",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
            Text("Learn about crypto currency Look to, ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Colors.grey),),
            Text("Top 10 currency for future",style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Colors.grey),),
              ],
            ),
            
            SizedBox(height: 10,),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: myWidth * 0.14),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffFBC700),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child:Padding(
                    padding:  EdgeInsets.symmetric(horizontal:myWidth*0.05,vertical: myHeight * 0.013),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("CREATE PORTFOLIO",style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
                        RotationTransition(
                          turns: AlwaysStoppedAnimation(310/360),
                          child: Icon(Icons.arrow_forward_rounded))
                      ],
                    ),
                  ) 
                  ,
                ),
              ),
            )
            
          ],
        ),
      ),
    );
  }
}