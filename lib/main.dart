import 'package:ereceipt/pages/pages.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'utils/utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'E-Gol',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen.navigate(
          name: 'assets/eSign.flr',
          next: (context) => MainPage(title: 'E-Signature App'),
          until: () => Future.delayed(
            Duration(milliseconds: 4000),
          ),
          backgroundColor: AppColors.MAIN,
          startAnimation: 'animate',
        ),
        routes: {
          EmailFormPage.routeName: (ctx) => EmailFormPage(title: _displayValue),
          SignPage.routeName: (ctx) => SignPage(),
          SharePage.routeName: (ctx) => SharePage(title: _displayValue),
        });
  }
}

String _displayValue = "";

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String title;

  TextEditingController _textFieldController = TextEditingController();

  _onSubmitted(String value) {
    setState(() => _displayValue = value);
  }

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2.5,
              ),
              SizedBox(height: MediaQuery.of(context).size.width / 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: AppColors.MAIN),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: _onSubmitted,
                  //Validates Form
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),
              button('Email & E-Signature', () async {
                final isValid = _form.currentState.validate();
                if (!isValid) {
                  return;
                }

                _form.currentState.save();
                Navigator.of(context).pushNamed(EmailFormPage.routeName,
                    arguments: _displayValue);
              }),
              const SizedBox(height: 25),
              button('E-Signature & Share', () async {
                final isValid = _form.currentState.validate();
                if (!isValid) {
                  return;
                }

                _form.currentState.save();
                Navigator.of(context)
                    .pushNamed(SharePage.routeName, arguments: _displayValue);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(String text, Function onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      height: 40,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[UIHelper().buttonShadow],
        borderRadius: UIHelper().buttonBorderRadius,
      ),
      child: Material(
        color: AppColors.MAIN,
        borderRadius: UIHelper().buttonBorderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: UIHelper().buttonBorderRadius,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
