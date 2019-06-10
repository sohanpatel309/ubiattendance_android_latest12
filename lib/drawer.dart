import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'privacypolicy.dart';
import 'attendance_summary.dart';
import 'about.dart';
import 'package:Shrine/services/services.dart';
import 'home.dart';
import 'settings.dart';
import 'reports.dart';
import 'globals.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment.dart';
import 'profile.dart';
import 'userGuide.dart';
import 'services/services.dart';
import 'flexi_time.dart';


class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  /*var _defaultimage = new NetworkImage(
      "http://ubiattendance.ubihrm.com/assets/img/avatar.png");*/
  var profileimage;
  bool _checkLoaded = true;
  String fname="";
  String lname="";
  String store="";
  String sstatus="";
  String desination="";
  String profile="";
  int reportper = 0;
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";

  Services services=new Services();
  @override
  void initState() {
    super.initState();
    checknetonpage(context);
    initPlatformState();
  }
  String admin_sts='0';
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    //String admin= await getUserPerm();
    setState(() {
      admin_sts=prefs.getString('sstatus').toString();
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      store = prefs.getString('store') ?? '';
      sstatus = (int.parse(prefs.getString('sstatus')))==1 ? 'You have logged in as Admin':'';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
     // reportper = report_permission;
      reportper =int.parse(prefs.getString('sstatus')) ?? 0;
      buystatus = prefs.getString('buysts') ?? '';
      trialstatus = prefs.getString('trialstatus') ?? '';
      orgmail = prefs.getString('orgmail') ?? '';
      profileimage = new NetworkImage(profile);
      profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
        if (mounted) {
          setState(() {
            _checkLoaded = false;
          });

        }
      });
    });
  }

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  showDialogWidget(String loginstr, String buystr){
    if(buystatus=="0") {
      return showDialog(context: context, child:
      new AlertDialog(
        title: new Text(buystr,
          style: TextStyle(fontSize: 15.0),),
        content: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('Later'),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RaisedButton(
              child: Text('Pay Now', style: TextStyle(color: Colors.white),),
              color: Colors.orangeAccent,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );

              },
            ),
          ],
        ),
      )
      );
    }else{
      return showDialog(context: context, builder:(context) {

        return new AlertDialog(
          title: new Text(
            loginstr,
            style: TextStyle(fontSize: 15.0),),
          content: ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Later',style: TextStyle(fontSize: 13.0)),
                shape: Border.all(),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              RaisedButton(
                child: Text(
                  'Login Now', style: TextStyle(color: Colors.white,fontSize: 13.0),),
                color: Colors.orangeAccent,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  launchMap("https://ubiattendance.ubihrm.com/");
                },
              ),
            ],
          ),
        );
      }
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return new Drawer(
      child:new ListView(
        children: <Widget>[
          new Container(
            color: Colors.teal,
            height: sstatus==''?160.0:172.0,
            child: new DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:<Widget>[
                  Center(),
                  Column(
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                  new Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: _checkLoaded ? AssetImage('assets/avatar.png') : profileimage,
                          )
                      )),
                new Positioned(
                  right: MediaQuery.of(context).size.width*-.06,
                  top: MediaQuery.of(context).size.height*.07,
                  child: new RawMaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                    },
                    child: new Icon(
                      Icons.edit,
                      size: 18.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 0.5,
                    fillColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(1.0),
                  ),
                ),
            ]),
                  //SizedBox(height: 2.0),
                  //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                  // SizedBox(height: 5.0),
                  Text("Hi "+fname,style: new TextStyle(fontSize: 20.0,color: Colors.white)),
                  // SizedBox(height: 3.0),
                  Text(desination,style: new TextStyle(fontSize: 12.0,color: Colors.white)),
                  sstatus!=''?Text(sstatus,style: new TextStyle(fontSize: 10.0,color: Colors.white)):Center(),
                ],
              ),
                  (buystatus=="0" && reportper==1)?new Column(
                      children:<Widget>[
                        ButtonTheme(
                    minWidth: 60.0,
                    height: 30.0,
                    child:RaisedButton(
                      child: Row(children:<Widget>[Text("Buy Now")]),
                      color: Colors.orangeAccent,
                      onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentPage()),
                        );
                      },
                      textColor: Colors.white,
                    ),

                  )]):Center(),
        ]
              ),

            ),
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.home,size: 20.0),SizedBox(width: 5.0),
                new Text('Home', style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          reportper ==1?new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.library_books,size: 20.0),SizedBox(width: 5.0),
                new Text("Reports", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Reports()),
              );
            },
          ):new Center(),

          flexi_permission ==1 ?
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.av_timer,size: 20.0),SizedBox(width: 5.0),
                new Text("Flexi Time ", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Flexitime()),
              );
            },
          ):new Center(),
          reportper ==1&&geoFence==1?new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.location_on,size: 20.0),SizedBox(width: 5.0),
                new Text("Set Geo Fence", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              showDialogWidget("To set Geo Fence, login to the web admin panel.", "To set Geo Fence upgrade to Premium Plan.");
            },
          ):new Center(),
    /*      reportper ==1?new ListTile(
           title: Row(
              children: <Widget>[
                Icon(Icons.attach_money,size: 20.0),SizedBox(width: 5.0),
                new Text("Generate Payroll", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              showDialogWidget("To Generate Payroll, Login to the web panel.", "To Generate Payroll upgrade to Premium Plan.");
            },
          ):new Center(),*/
          reportper == 1?new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.camera,size: 20.0),SizedBox(width: 5.0),
                new Text("Generate QR Code", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              showDialogWidget("To Generate QR Code of Employee, Login to the web panel.", "To Generate QR Code of Employee upgrade to Premium Plan.");
            },
          ):new Center(),
         /* new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.account_box,size: 20.0),SizedBox(width: 5.0),
                new Text("Profile", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),*/
     /*     new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.perm_contact_calendar,size: 20.0),SizedBox(width: 5.0),
                new Text("Employee History", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              /*
              getUserPerm().then((res){
                print('func called with response: '+res);
              });*/


              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );

            },
          ),*/
       /*   new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.location_city,size: 20.0),SizedBox(width: 5.0),
                new Text("Organization", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),*/
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.settings,size: 20.0),SizedBox(width: 5.0),
                new Text("Settings", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
             // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.share,size: 20.0),SizedBox(width: 5.0),
                new Text("Share App", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              final RenderBox box = context.findRenderObject();
              Share.share("Check out ubiAttendance App. I use it to track attendance and visits of my employees. Get it for free at \n"+store,
                  sharePositionOrigin:
                  box.localToGlobal(Offset.zero) &
                  box.size);
            },
          ),
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.star,size: 20.0),SizedBox(width: 5.0),
                new Text("Rate Us", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              LaunchReview.launch(
                  androidAppId: "org.ubitech.attendance"
                  );
            },
          ),

        /*  new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.security,size: 20.0),SizedBox(width: 5.0),
                new Text("Privacy Policy", style: new TextStyle(fontSize: 14.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppPolicy()),
              );
            },
          ), */
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.security,size: 20.0),SizedBox(width: 5.0),
                new Text("User Guide", style: new TextStyle(fontSize: 14.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserGuide()),
              );
            },
          ),
        /*  new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.location_on,size: 20.0),SizedBox(width: 5.0),
                new Text("About Us", style: new TextStyle(fontSize: 14.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppAbout()),
              );
            },
          ),*/
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.lock_open,size: 20.0),SizedBox(width: 5.0),
                new Text("Log out", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }
  logout() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('response');
    prefs.remove('fname');
    prefs.remove('lname');
    prefs.remove('empid');
    prefs.remove('email');
    prefs.remove('status');
    prefs.remove('sstatus');
    prefs.remove('orgid');
    prefs.remove('orgdir');
    prefs.remove('sstatus');
    prefs.remove('org_name');
    prefs.remove('destination');
    prefs.remove('profile');
    prefs.remove('latit');
    prefs.remove('longi');
    prefs.remove('aid');
    prefs.remove('shiftId');
    department_permission = 0;
    designation_permission = 0;
    leave_permission = 0;
    shift_permission = 0;
    timeoff_permission = 0;
    punchlocation_permission = 0;
    employee_permission = 0;
    permission_module_permission = 0;
    report_permission = 0;
   /* Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );*/
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
    );
    //Navigator.pushNamed(context, '/home');
    // Navigator.pushNamed(context, '/home');
  }


}