import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
          //直接返回流式布局
          raiseFlowLayout(context),
    );
  }

  //创建流式布局方法
  Widget raiseFlowLayout(BuildContext context) {
    //import 'dart:math';用来生成随机颜色
    var random = new Random();
    EdgeInsets edgeInsets = EdgeInsets.all(5);
    //存储单词块的集合
    _generateWSList(30, random);
    //循环添加
    //记录添加控件之后的宽度
    return new Flow(
      delegate: MyFlowDelegate(EdgeInsets.all(5)),
      children: _generateWSList(30, random),
    );
  }

  //生成单个单词块
  Widget _generateWordSquare(Random random) {
    //随机颜色
    var color = Color.fromARGB(random.nextInt(255), random.nextInt(255),
        random.nextInt(255), random.nextInt(255));
    var wp = WordPair.random();
    return new Container(
      color: color,
      height: 30,
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
          wp.asPascalCase,
          style: TextStyle(fontSize: 16),
        ),],
      )
    );
  }

  //生成n个单词块
  List<Widget> _generateWSList(int n, Random random) {
    var list = new List<Widget>();
    for (int i = 0; i < n; i++) {
      list.add(_generateWordSquare(random));
    }
    return list;
  }
}

class MyFlowDelegate extends FlowDelegate {
  //定义默认边距=0
  var _margin = EdgeInsets.zero;
  //提供构造方法,可以根据构造设定_margin的值
  MyFlowDelegate(this._margin);
  @override
  void paintChildren(FlowPaintingContext context) {
    //绘制单词块的左边距
    var offsetX = _margin.left;
    //绘制单词块的顶边距
    var offsetY = _margin.top;
    //屏幕/父容器宽度
    var winSizeWidth = context.size.width;
    //开始循环绘制，绘制过程中进行offset的变化
    for (int i = 0; i < context.childCount; i++) {
      //当前的宽度
      var w = offsetX + context.getChildSize(i).width + _margin.right;
      //如果当前的宽度大于等于屏幕宽度，那么就需要换行，否则，继续在本行绘制
      if (w < winSizeWidth) {
        //绘制子控件
        context.paintChild(i,
            transform: new Matrix4.translationValues(offsetX, offsetY, 0.0));
        //绘制完后记得对x进行累加
        offsetX = w + _margin.left;
      } else {
        //换行
        //充值左边距
        offsetX = _margin.left;
        //换行之后的y偏移量=上面一个的偏移量+行高+顶部margin+底部margin
        offsetY +=
            context.getChildSize(i).height + _margin.bottom + _margin.top;
        //绘制
        context.paintChild(i,
            transform: new Matrix4.translationValues(offsetX, offsetY, 0.0));
        //绘制完下一行的第一个之后，记得更新offsetX
        offsetX += context.getChildSize(i).width + _margin.right;
      }
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    // 暂时不用
    return null;
  }
}
