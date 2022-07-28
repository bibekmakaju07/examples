import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweening and Curves',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Counter With Inherited notifier'),
        ),
        body:  ThreeCounter(),
      ),
    );
  }
}
enum CounterType { one, two, three }

class CounterInheritedModelWidget extends InheritedModel<CounterType> {
  final int count1, count2, count3;
  CounterInheritedModelWidget({
    Key? key,
    required Widget child,
    required this.count1,
    required this.count2,
    required this.count3,
  }) : super(
          child: child,
        );

  static CounterInheritedModelWidget of(context, CounterType aspects) {
    return InheritedModel.inheritFrom<CounterInheritedModelWidget>(context,
                                                                  aspect:aspects )!;
  }

  @override
  bool updateShouldNotify(covariant CounterInheritedModelWidget oldWidget) {
    return count1 != oldWidget.count1 ||
        count2 != oldWidget.count2 ||
        count3 != oldWidget.count3;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant CounterInheritedModelWidget oldWidget,
      Set<CounterType> dependencies) {
    if (dependencies.contains(CounterType.one) && count1 != oldWidget.count1) {
      return true;
    }  if (dependencies.contains(CounterType.two)&&
        count2 != oldWidget.count2) {
      return true;
    }  if (dependencies.contains(CounterType.three) &&
        count3 != oldWidget.count3) {
      return true;
    }
    return false;
  }
}

class ThreeCounter extends StatefulWidget {
  ThreeCounter({Key? key}) : super(key: key);

  @override
  State<ThreeCounter> createState() => _ThreeCounterState();
}

class _ThreeCounterState extends State<ThreeCounter> {
  int count1 = 0;

  int count2 = 0;

  int count3 = 0;

  @override
  Widget build(BuildContext context) {
    return CounterInheritedModelWidget(
      count3: count3,
      count2: count2,
      count1: count1,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      count1 += 1;
                    });
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      count2 += 1;
                    });
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      count3 += 1;
                    });
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              CountContainer(counterType: CounterType.one),
              CountContainer(counterType: CounterType.two),
              CountContainer(counterType: CounterType.three),
            ],
          )
        ],
      ),
    );
  }
}

class CountContainer extends StatelessWidget {
  const CountContainer({Key? key, required this.counterType}) : super(key: key);

  final CounterType counterType;

  @override
  Widget build(BuildContext context) {
    final provider = CounterInheritedModelWidget.of(context, counterType);
    switch (counterType) {
      case CounterType.one:
        print('counter 1 rebuild');
        break;
      case CounterType.two:
        print('counter 2 rebuild');

        break;
      case CounterType.three:
        print('counter 3 rebuild');

        break;
      default:
        break;
    }
    return Expanded(
      child: Container(
        color: Colors.red,
        child: Text(
          counterType == CounterType.one
              ? '${provider.count1}'
              : counterType == CounterType.two
                  ? '${provider.count2}'
                  : counterType == CounterType.three
                      ? '${provider.count3}'
                      : '0',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
