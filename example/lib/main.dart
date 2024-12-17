import 'package:example/network/model_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_network_engine/flutter_network_engine.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'model/weather_model.dart';

//全局的网络请求引擎
late DioHttpEngine dioHttpEngine;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initNetworkEngine();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  void initNetworkEngine() {
    ResponseResult.onGetCode = (ResponseResult result, Type dataType) {
      //you can custom your code
      return result.response?.statusCode;
    };
    ResponseResult.onGetMessage = (ResponseResult result, Type dataType) {
      //you can custom your message
      return result.response?.statusMessage;
    };
    ResponseResult.onIsSuccess = (ResponseResult result, Type dataType) {
      //you can custom your isSuccess
      return result.response?.statusCode != null &&
          result.response!.statusCode! >= 200 &&
          result.response!.statusCode! < 300;
    };

    //init
    dioHttpEngine = DioHttpEngine(
      timeout: const Duration(seconds: 8),
      baseUrl: "https://apis.juhe.cn",
      printLog: true,
      jsonParser: ModelFactory.generateOBJ,
      onShowError: ({int? code, String? msg, dynamic error}) {},
      onShowLoading: (bool isShow, {String? msg}) {},
    )..addInterceptor(TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
      ));
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
    var resp =
        await dioHttpEngine.requestFuture<WeatherModel>(RequestMethod.get, url,
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
              },
            ),
            queryParameters: param);

    setState(() {
      resultData = resp.getData()?.errorCode?.toString() ?? "123";
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
