import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'IconText.dart';


const activeColor = Color(0xFF1D1E33);
const deActivColor = Color(0xFF111328);


class InputPage extends StatefulWidget {
  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
      ), // AppBar
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RepeatRefactorCode(


      cardwidget: RefactorTextandIcon(
                      iconData:FontAwesomeIcons.person,
                      label: "MALE",
                    ),
                  ),

                ),
                Expanded(
                  child: RepeatRefactorCode(
                    onPressed: (){
                      setState(() {
                        selectGender=Gender.female;
                      });
                    },
                    colors:selectGender==Gender.female?activeColor:deActivColor,
                    cardwidget: RefactorTextandIcon(
                      iconData:FontAwesomeIcons.female,
                      label: "FEMALE",
                    ),),


                ),
              ],
            ),
          ),
          Expanded(
            child:RepeatRefactorCode(colors:Color(0xFF1D1E33), onPressed: () {  },
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child:RepeatRefactorCode(colors:Color(0xFF1D1E33), onPressed: () {  },
                  ),
                ),
                Expanded(
                  child: RepeatRefactorCode(colors:Color(0xFF1D1E33), onPressed: () {  },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ); //
  }
}