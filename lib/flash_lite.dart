import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashMate extends StatefulWidget {
  const FlashMate({Key? key}) : super(key: key);

  @override
  State<FlashMate> createState() => _FlashMateState();
}

class _FlashMateState extends State<FlashMate> {
  final bgeColor = const Color(0xff2C3333);
  final textColor = const Color(0xffE7F6F2);
  var isActive = false;
  var controller = TorchController();
  Timer? _timer;
  var isFlashing = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleFlash() {
    if (!isFlashing) {
      showDialog(
        context: context,
        builder: (context) {
          int minutes = 0;
          int seconds = 0;
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),

            ),
            title: Text(
              "Set duration ⚡",
              style: GoogleFonts.dmSerifDisplay(
                  color: Colors.yellow,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,


              ),
            ),

            backgroundColor: const Color(0x007FAF00),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("Minutes :",style: GoogleFonts.dmSerifDisplay(
                      color: Colors.white60,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          minutes = int.tryParse(value) ?? 0;
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),

                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Seconds :",style: GoogleFonts.dmSerifDisplay(color: Colors.white60,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          seconds = int.tryParse(value) ?? 0;
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel",style: GoogleFonts.dmSerifDisplay(color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                ),),
              ),
              TextButton(
                onPressed: () {
                  if (minutes > 0 || seconds > 0) {
                    isFlashing = true;
                    int duration = minutes * 60 + seconds;
                    _timer =
                        Timer.periodic(Duration(seconds: duration), (timer) {
                          // controller.turnOff();
                          isFlashing = false;
                          _timer?.cancel();
                          setState(() {});
                        });
                    _timer = Timer.periodic(
                        const Duration(milliseconds: 500), (timer) {
                      controller.toggle();
                      isActive = !isActive;
                      setState(() {});
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Text("OK",style: GoogleFonts.dmSerifDisplay(color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),),
              ),
            ],
          );
        },
      );
    } else {
      isFlashing = false;
      _timer?.cancel();
      // controller.turnOff();
      isActive = false;
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            "⚡Flash Mate",
            style: GoogleFonts.sigmarOne(
              fontSize: 28.0,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          isActive ? 'images/flash2.png' : 'images/flash1.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          minRadius: 28,
                          maxRadius: 43,
                          child: Transform.scale(
                            scale: 1.5,
                            child: IconButton(
                              onPressed: () {
                                if (isActive) {
                                  // controller.turnOff();
                                  isActive = false;
                                } else {
                                  controller.toggle();
                                  isActive = true;
                                }
                                setState(() {});
                              },
                              icon: Icon(
                                isActive ? Icons.flash_on : Icons.flash_off,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          minRadius: 28,
                          maxRadius: 43,
                          child: Transform.scale(
                            scale: 1.5,
                            child: IconButton(
                              onPressed: _toggleFlash,
                              icon: const Icon(
                                Icons.electric_bolt_outlined,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Developed by Bikash",
            style: GoogleFonts.dancingScript(
              color: textColor,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
        ],
      ),
    );
  }
}
