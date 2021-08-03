import 'dart:io';

import 'package:ereceipt/models/email_model.dart';
import 'package:ereceipt/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

import 'package:signature/signature.dart';

class SignPage extends StatefulWidget {
  static const routeName = '/sign';

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final picker = ImagePicker();

  //Signature Controller
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

//initialisation function -- meaning before app runs all the codes
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //get the email data from previous route
    final emailData = ModalRoute.of(context).settings.arguments as EmailModel;

    Future<void> send() async {
      if (_controller.isNotEmpty) {
        var data = await _controller.toPngBytes();
        final imgName = 'egol_email.png';
        String dir = (await getExternalStorageDirectory()).path;

        print(dir);

        await Directory('$dir/signatures').create(recursive: true);

        final fullPath = '$dir/signatures/$imgName';

        File(fullPath).writeAsBytesSync(data);

        final Email email = Email(
          body: emailData.msg,
          subject: emailData.subject,
          recipients: [emailData.email],
          attachmentPaths: [fullPath],
          isHTML: false,
        );

        try {
          await FlutterEmailSender.send(email);
        } catch (e) {
          _showErrorDialog(e.toString());
        }
      } else {
        _showErrorDialog('Enter digital signature');
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('E-Signature'),
        backgroundColor: AppColors.MAIN,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: send,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Signature(
            controller: _controller,
            width: double.infinity,
            height: double.infinity,
            backgroundColor: Colors.white,
          ),
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 9,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      'Enter your digital signature',
                      style: TextStyle(color: AppColors.MAIN, fontSize: 17),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 25,
                    ),
                    color: AppColors.MAIN,
                    onPressed: () {
                      setState(() => _controller.clear());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
