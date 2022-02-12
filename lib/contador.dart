import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class Contador extends StatefulWidget {
  const Contador({Key? key}) : super(key: key);

  @override
  _ContadorState createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  TextEditingController? minuto, segundos;
  bool _validateMinute = false;
  bool _validateSecond = false;
  final interval = const Duration(seconds: 1);

  int timerMaxSeconds = 60;
  bool finish = false;
  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        // print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          setState(() {
            finish = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    // startTimeout();
    super.initState();
    minuto = TextEditingController();
    segundos = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              const Text(
                "Contador",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.timer,
                    size: 40.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    timerText,
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: minuto,
                      decoration: InputDecoration(
                        errorText:
                            _validateMinute ? "Complete Este Campo" : null,
                        contentPadding: const EdgeInsets.all(10),
                        labelText: 'Minutos',
                        labelStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: segundos,
                      decoration: InputDecoration(
                        errorText:
                            _validateSecond ? "Complete Este Campo" : null,
                        contentPadding: const EdgeInsets.all(10),
                        // errorText: _validateNombre ? "Complete Este Campo" : null,
                        labelText: 'Segundos',
                        labelStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              finish
                  ? const Text(
                      "La cuenta terminó",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  // startTimeout();
                  setState(() {
                    minuto!.text.isEmpty
                        ? _validateMinute = true
                        : _validateMinute = false;
                    segundos!.text.isEmpty
                        ? _validateSecond = true
                        : _validateSecond = false;
                  });
                  if (_validateMinute == false && _validateSecond == false) {
                    int minutoConverted = int.parse(minuto!.text);
                    int secondConverted = int.parse(segundos!.text);
                    var converttoSeconds = minutoConverted * 60;
                    // print(converttoSeconds);
                    int totalseconds = converttoSeconds + secondConverted;
                    // print(totalseconds);
                    setState(() {
                      timerMaxSeconds = totalseconds;
                    });
                    startTimeout();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20.0)),
                    height: 35,
                    child: const Center(
                      child: Text(
                        "Iniciar",
                        style: TextStyle(
                          // fontSize: 2 * SizeConfig.textMultiplier,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        // SizeConfig().init(constraints, orientation);
      });
    });
    // Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: <Widget>[
    //     Icon(Icons.timer),
    //     SizedBox(
    //       width: 5,
    //     ),
    //     Text(timerText)
    //   ],
    // );
  }
}

class SizeConfig {
  late double _screenWidth;
  late double _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  late double textMultiplier;
  late double imageSizeMultiplier;
  late double heightMultiplier;
  late double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;

    // print(_blockSizeHorizontal);
    // print(_blockSizeVertical);
    //
  }
}
