import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:socialbennett/components/coustom_bottom_nav_bar.dart';
import 'package:socialbennett/components/updateavailablescreen.dart';
import 'package:socialbennett/enums.dart';
import 'package:socialbennett/services/product_services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../constants.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool firsttime = false;
  bool maintenance = false;
  bool updateAvailable = false;

  checkInitial() async {
    ProductServices _services = ProductServices();
    DocumentSnapshot check = await _services.initialChecks.get();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;

    if (version != check["currentVersion"] && check["updateAvailable"]) {
      updateAvailable = true;
    }

    maintenance = check["maintenance"];

    if (updateAvailable) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateAvailable(
                  value: "Download Now",
                  bottomNavigation: false,
                )),
      );
    } else if (maintenance) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateAvailable(
                  value: "Come Back Soon",
                  bottomNavigation: false,
                )),
      );
    }
  }

  @override
  void initState() {
    firsttime = true;
    checkInitial();
    super.initState();
  }

  DateTime backbuttonpressedTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime currenttime = DateTime.now();
        bool backbutton = backbuttonpressedTime == null ||
            currenttime.difference(backbuttonpressedTime) >
                Duration(seconds: 2);
        if (backbutton) {
          backbuttonpressedTime = currenttime;
          Fluttertoast.showToast(
              msg: "Double Tap to close App",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 2,
              gravity: ToastGravity.BOTTOM);
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Builder(
            // builder is used only for the snackbar, if you don't want the snackbar you can remove
            // Builder from the tree
            builder: (BuildContext context) => HawkFabMenu(
              icon: AnimatedIcons.menu_arrow,
              fabColor: Colors.transparent,
              iconColor: Colors.green,
              items: [
                HawkFabMenuItem(
                  label: 'Menu 1',
                  ontap: () {
                    Scaffold.of(context)..hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Menu 1 selected')),
                    );
                  },
                  icon: Icon(Icons.home),
                  color: Colors.red,
                  labelColor: Colors.blue,
                ),
                HawkFabMenuItem(
                  label: 'Menu 2',
                  ontap: () {
                    Scaffold.of(context)..hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Menu 2 selected')),
                    );
                  },
                  icon: Icon(Icons.comment),
                  labelColor: Colors.white,
                  labelBackgroundColor: Colors.blue,
                ),
                HawkFabMenuItem(
                  label: 'Menu 3 (default)',
                  ontap: () {
                    Scaffold.of(context)..hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Menu 3 selected')),
                    );
                  },
                  icon: Icon(Icons.add_a_photo),
                ),
              ],
              body: Body(),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        ),
      ),
    );
  }
}


