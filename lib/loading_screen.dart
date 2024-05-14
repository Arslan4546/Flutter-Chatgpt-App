import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';
import 'dart:math' as math;
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin{


  late final AnimationController _controller = AnimationController(

      duration: const Duration(seconds: 3),
      vsync: this)..repeat();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.push(context,
            MaterialPageRoute(builder: (context)=>const ChatScreen())));

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            AnimatedBuilder(
                animation:_controller ,
                child: Container(
                  height: 200,
                  width: 200,
                  child: const Center(
                    child: Image(
                      image: AssetImage("assets/images/gpt.png"),
                    ),
                  ),
                ),
                builder:(BuildContext context, Widget? child ){
                  return Transform.rotate(
                    angle:_controller.value*2.0*math.pi,
                    child: child,
                  );
                }),
            const  SizedBox(height: 50,),
             Align(
              alignment: Alignment.center,
              child: Text("Welcome To\n   ChatGPT  ",style: GoogleFonts.dangrek(
                textStyle:const TextStyle(

                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009C74)

                )
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
