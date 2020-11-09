import 'package:academind/widgets/chat/new_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen - (pixel ratio: $pixelRatio)'),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemBuilder:(ctx, index) => Container(
              padding: EdgeInsets.all(8.0),
              child: Bubble(
                style: styleMe,
                child: Text('This Works'),
              ),
            ),
          ),
          Positioned(
            child: NewMessage(),
            bottom: 0.0,
            left: 0.0,
            right: 0.0
          ),
        ],
      ),
    );
  }
}