import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:example/model/base_result.dart';
import 'package:example/network/model_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_network_engine/flutter_network_engine.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'model/weather_model.dart';

//全局的网络请求引擎
var dioHttpEngine = DioHttpEngine(
    baseUrl: "https://apis.juhe.cn", jsonParser: ModelFactory.generateOBJ)
  ..addInterceptor(PrettyDioLogger());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String resultData = "";

  void _incrementCounter() async {
    String url = "https://apis.juhe.cn/simpleWeather/query";

    var param = {"city": "雅安", "key": "6880a0c6e99ba78cbbf7207fd35528b3"};

    var postFuture = await dioHttpEngine.getFuture<WeatherModel>(url, queryParameters: param);

    var error = postFuture.getError();
    log(error.toString());

    setState(() {
      resultData = postFuture.getData()?.result?.realtime?.direct??"";
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                resultData,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
