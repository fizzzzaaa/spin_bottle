import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'IconText.dart';
import 'ContainerFile.dart';
import 'constFile.dart';

enum gender{
  male,
  female,
}

class InputPage extends StatefulWidget {
  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputPage> {
  gender? selectGender;
  int sliderHeight=180;
  int sliderWeight=60;

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
                    onPressed: (){
                      setState(() {
                        selectGender=gender.male;
                      });
                    },
                    colors: selectGender==gender.male? activeColor:deActivColor,
                    cardwidget: RefactorTextandIcon(
                      iconData:FontAwesomeIcons.person,
                      label: "Male",
                    ),
                  ),

                ),
                Expanded(
                  child: RepeatRefactorCode(
                    onPressed: (){
                      setState(() {
                        selectGender=gender.female;
                      });
                    },
                    colors:selectGender==gender.female? activeColor:deActivColor,
                    cardwidget: RefactorTextandIcon(
                      iconData:FontAwesomeIcons.female,
                      label: "Female",
                    ),),


                ),
              ],
            ),
          ),
          Expanded(
            child:RepeatRefactorCode(colors:Color(0xFF1D1E33), onPressed: () {  },
            cardwidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget> [
                SizedBox(
                  width: 1000.0,
                ),
                Text('Height',
                  style: KLabelStyle,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      sliderHeight.toString(),
                      style: HLablelStyle,
                    ),
                    Text(
                      'cm',
                      style: KLabelStyle,
                    ),

                  ],
                ),
                Slider(
                  value: sliderHeight.toDouble(),
                  min: 120.0,
                  max: 220.0,
                  activeColor: Color(0xFFEB1555),
                  inactiveColor: Color(0xFF8D8E98),
                  onChanged: (double newvalue){
                    setState(() {
                      sliderHeight=newvalue.round();
                    });
                  },
                ),
              ],
            ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child:RepeatRefactorCode(
                    colors:Color(0xFF1D1E33), onPressed: () {  },
                    cardwidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Weight',
                          style: KLabelStyle,),
                        Text(
                          sliderWeight.toString(),
                          style: HLablelStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIcon(
                              iconData: FontAwesomeIcons.minus,
                              onPress: () {
                                setState(() {
                                  sliderWeight--;
                                });
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ), // Add the missing comma here
                            RoundIcon(
                              iconData: FontAwesomeIcons.plus,
                              onPress: () {
                                setState(() {
                                  sliderWeight++;
                                });
                              },
                            ),
                          ],
                        ),

                      ],
                    ),
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

class RoundIcon extends StatelessWidget{
  RoundIcon({required this.iconData, required this.onPress});
final IconData iconData;
final VoidCallback onPress;
Widget build(BuildContext context){
    return RawMaterialButton(
        child: Icon(iconData),
        onPressed: onPress,
      elevation: 6.0,
      constraints:  BoxConstraints.tightFor(
        height: 40.0,
        width: 40.0,
      ),
      shape: CircleBorder(),
      fillColor: Color(0xFF4C4F5E),
    );
  }

}