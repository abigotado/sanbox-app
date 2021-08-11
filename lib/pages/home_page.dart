import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () {
              print('click');
            },
            child: Container(
              margin: EdgeInsets.only(left: 36, right: 36),
              height: 50,
              padding: EdgeInsets.fromLTRB(20, 13, 20, 14),
              decoration: BoxDecoration(
                color: Color.fromRGBO(117, 125, 232, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Join',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
