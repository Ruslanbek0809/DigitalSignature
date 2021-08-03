import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:ereceipt/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class SharePage extends StatefulWidget {
  static const routeName = '/share';
  SharePage({Key key, @required this.title}) : super(key: key);

  final String title;
  @override
  _SharePage createState() => _SharePage(title);
}

class _SharePage extends State<SharePage> {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 5.0;
  String publicKey;
  final _sign = GlobalKey<SignatureState>();
  String title;
  _SharePage(this.title);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(color: AppColors.MAIN),
              child: Center(
                child: Text(
                  'Enter your digital signature in the section below',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Signature(
                    color: color,
                    key: _sign,
                    onSign: () {
                      final sign = _sign.currentState;
                      debugPrint(
                          '${sign.points.length} points in the signature');
                    },
                    backgroundPainter: _WatermarkPaint("2.0", "Watermark name"),
                    strokeWidth: strokeWidth,
                  ),
                ),
                color: Colors.black12,
              ),
            ),
            _img.buffer.lengthInBytes == 0
                ? Container()
                : Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.memory(
                      _img.buffer.asUint8List(),
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                  ),
            Container(
              color: AppColors.MAIN,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: Colors.white,
                        elevation: 3,
                        onPressed: () async {
                          final sign = _sign.currentState;

                          final image = await sign.getData();
                          var data = await image.toByteData(
                              format: ui.ImageByteFormat.png);
                          sign.clear();
                          final encoded =
                              base64.encode(data.buffer.asUint8List());

                          publicKey = encoded;
                          await Share.file(
                              'E-gol: ' + title,
                              title + 'e_gol.png',
                              data.buffer.asUint8List(),
                              'image/png',
                              text: 'E-gol: ' + title);
                          setState(() {
                            _img = data;
                          });
                          debugPrint("Public Key of your digital signature " +
                              encoded);
                        },
                        child: Text(
                          'Share',
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: const EdgeInsets.all(8.0),
                      ),
                      MaterialButton(
                          color: Colors.white,
                          onPressed: () {
                            final sign = _sign.currentState;
                            sign.clear();
                            setState(() {
                              _img = ByteData(0);
                            });
                          },
                          child: Text(
                            'Clear',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                          onPressed: () {
                            setState(() {
                              color = color == AppColors.MAIN
                                  ? Colors.black
                                  : AppColors.MAIN;
                            });
                          },
                          child: Text(
                            'Change color',
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(width: 15.0),
                      MaterialButton(
                          onPressed: () {
                            setState(() {
                              int min = 1;
                              int max = 10;
                              int selection =
                                  min + (Random().nextInt(max - min));
                              strokeWidth = selection.roundToDouble();
                              debugPrint("change stroke width to $selection");
                            });
                          },
                          child: Text(
                            'Change stroke width',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget button(String text) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[UIHelper().buttonShadow],
        borderRadius: UIHelper().buttonBorderRadius,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: UIHelper().buttonBorderRadius,
        child: InkWell(
          onTap: () {},
          borderRadius: UIHelper().buttonBorderRadius,
          child: Center(
            child: Text(
              text,
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawPaint(Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}
