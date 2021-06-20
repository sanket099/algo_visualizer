import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<int> _numbers = [];
  int _sampleSize = 500;
  late StreamController<List<int>> _streamController;
  late Stream<List<int>> _stream;
  _randomize(){

    _numbers = [];

  for(int i = 0; i<_sampleSize; i++){
    _numbers.add(Random().nextInt(_sampleSize));
  }

    _streamController.add(_numbers);

  }
  _sort() async{
    for (int i = 0; i < _numbers.length; ++i) {
      for (int j = 0; j < _numbers.length - i - 1; ++j) {
        if (_numbers[j] > _numbers[j + 1]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
        }

        await Future.delayed(Duration(microseconds : 500));
        _streamController.add(_numbers);

      }
    }


  }

  @override
  void initState() {

    super.initState();
    _randomize();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          title: Text("Sort"),
        ),
        body: Container(
          child: StreamBuilder<Object>(
            stream: _stream,
            builder: (context, snapshot) {
              int counter =0;

              return Row(
                children: _numbers.map((int number) {
                  counter++;
                    return CustomPaint(
                      painter: BarPainter(
                        width : MediaQuery.of(context).size.width / _sampleSize,
                        value: number,
                        index: counter
                      ),
                    );
                }).toList(),
              );
            }
          ),
        ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(child: FlatButton(
            onPressed: _randomize,
            child: Text("Randomize"),
          )),
          Expanded(child: FlatButton(
            onPressed: _sort,
            child: Text("Sort"),
          ))
        ],
      ),

    );
  }

}
class BarPainter extends CustomPainter{
  final double width;
  final int value;
  final int index;

  BarPainter({required this.width , required this.value, required this.index});
  @override
  void paint(Canvas canvas, Size size) {
      Paint paint = Paint();
      if (this.value < 500 * .10) {
        paint.color = Color(0xFFDEEDCF);
      } else if (this.value < 500 * .20) {
        paint.color = Color(0xFFBFE1B0);
      } else if (this.value < 500 * .30) {
        paint.color = Color(0xFF99D492);
      } else if (this.value < 500 * .40) {
        paint.color = Color(0xFF74C67A);
      } else if (this.value < 500 * .50) {
        paint.color = Color(0xFF56B870);
      } else if (this.value < 500 * .60) {
        paint.color = Color(0xFF39A96B);
      } else if (this.value < 500 * .70) {
        paint.color = Color(0xFF1D9A6C);
      } else if (this.value < 500 * .80) {
        paint.color = Color(0xFF188977);
      } else if (this.value < 500 * .90) {
        paint.color = Color(0xFF137177);
      } else {
        paint.color = Color(0xFF0E4D64);
      }
      paint.strokeWidth = width;
      paint.strokeCap = StrokeCap.round;
      
      canvas.drawLine(Offset(index * width, 0), Offset(index * width, value.ceilToDouble()), paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}
