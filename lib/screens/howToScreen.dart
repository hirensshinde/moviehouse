import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/navigation_item.dart';
import 'package:moviehouse/provider/navigationProvider.dart';
import 'package:moviehouse/widgets/howToWidget.dart';
import 'package:provider/provider.dart';

class HowToScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to download'),
        backgroundColor: Color.fromARGB(255, 25, 27, 45),

        leading: IconButton(
          splashRadius: 25.0,
          padding: EdgeInsets.all(0.0),
          icon: SvgPicture.asset(
            'assets/icons/Back.svg',
            height: 35.0,
          ),
          onPressed: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);
            provider.setNavigationItem(NavigationItem.home);
            return Navigator.of(context).pop();
          },
        ),
        // centerTitle: true,
      ),
      body: HowToUseWidget(
        pages: <Widget>[
          Image.asset("assets/images/01.png", fit: BoxFit.fill),
          Image.asset("assets/images/02.png", fit: BoxFit.fill),
          Image.asset("assets/images/03.png", fit: BoxFit.fill),
          Image.asset("assets/images/04.png", fit: BoxFit.fill),
          Image.asset("assets/images/05.png", fit: BoxFit.fill),
          Image.asset("assets/images/06.png", fit: BoxFit.fill),
        ],
        onIntroCompleted: () {
          Navigator.pop(context);
          //To the navigation stuff here
        },
      ),
    );
  }
}
