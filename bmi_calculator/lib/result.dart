import 'package:flutter/material.dart';
import 'constFile.dart';
import 'ContainerFile.dart';
import 'input_page.dart';

class resultscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: Text('Your Result',
                style: KTitleStyle,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: RepeatRefactorCode(
              colors: activeColor,
              cardwidget: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Normal',
                    style: kresultText,
                  ),
                  Text(
                    '18.3',
                    style: kbmiStyle,
                  ),
                  Text(
                    'BMI is low, You should work more',
                    textAlign: TextAlign.center,
                    style: kBodyStyle,
                  ),
                ],
              ),
            ),
          ),
          Expanded(

          ),
        ],

      )
    );
  }
}
