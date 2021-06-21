import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'Constants.dart';

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
  late StreamController<List<int>>  _streamController = StreamController<List<int>>();
  late Stream<List<int>> _stream = _streamController.stream;
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

        await Future.delayed(Duration(microseconds : 100));
        _streamController.add(_numbers);

      }
    }


  }

  _insertionSort() async {

      if (_numbers.length == 0) return;
      int n = _numbers.length;
      int temp, i, j;

      for(i=1; i< n; i++) {
        temp = _numbers[i];
        j=i-1;
        while(j >= 0 && temp < _numbers[j] ) {
          _numbers[j+1] = _numbers[j];
          --j;

          await Future.delayed(Duration(microseconds : 100));
          _streamController.add(_numbers);
        }
        _numbers[j+1] = temp;
      }
    }

  void merge(int leftIndex, int middleIndex, int rightIndex){
    int leftSize = middleIndex - leftIndex + 1;
    int rightSize = rightIndex - middleIndex;

    List leftList = new List.filled(leftSize, null, growable: false);
    List rightList = new List.filled(rightSize, null, growable: false);

    for (int i = 0; i < leftSize; i++) leftList[i] = _numbers[leftIndex + i];
    for (int j = 0; j < rightSize; j++) {rightList[j] = _numbers[middleIndex + j + 1];
   }

    int i = 0, j = 0;
    int k = leftIndex;

    while (i < leftSize && j < rightSize) {
      if (leftList[i] <= rightList[j]) {
        _numbers[k] = leftList[i];
        i++;
      } else {
        _numbers[k] = rightList[j];
        j++;
      }
      k++;

    }

    while (i < leftSize) {
      _numbers[k] = leftList[i];
      i++;
      k++;
    }

    while (j < rightSize) {
      _numbers[k] = rightList[j];
      j++;
      k++;
    }

  }

   mergeSort(int leftIndex, int rightIndex) {
    if (leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;



      mergeSort( leftIndex, middleIndex);

      mergeSort( middleIndex + 1, rightIndex);


      merge(leftIndex, middleIndex, rightIndex);
    }
  }
  void swap(List list, int i, int j) {
    int temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

   partition(List list, int low, int high) async {
     if (list.length == 0) return 0;
     int pivot = list[high];
     int i = low - 1;

     for (int j = low; j < high; j++) {
       if (list[j] <= pivot) {
         i++;
         swap(list, i, j);
       }
       await Future.delayed(Duration(microseconds : 100));
       _streamController.add(_numbers);
       swap(list, i + 1, high);
       return i + 1;
     }
   }

    void quickSort(List list, int low, int high) {
      if (low < high) {
        int pi = partition(list, low, high);
        quickSort(list, low, pi-1);
        quickSort(list, pi+1, high);
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
          backgroundColor: Color(0x000000),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: choiceAction,
                itemBuilder: (BuildContext buildContext){
                      return Constants.choices.map((String choice){
                              return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),);
            })
              .toList();

                })
          ],
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
  void choiceAction(String choice){
    if(choice == Constants.MergeSort){
      mergeSort(0, _numbers.length-1);
    }
    else if(choice == Constants.BubbleSort){
      _sort();
    }
    else if(choice == Constants.InsertionSort){
      _insertionSort();
    }
    else if(choice == Constants.QuickSort){
      quickSort(_numbers, 0, _numbers.length - 1);
    }
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
