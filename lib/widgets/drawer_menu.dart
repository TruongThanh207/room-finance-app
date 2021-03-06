import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_financal_manager/models/user.dart';
import 'package:room_financal_manager/providers/user_provider.dart';
import 'package:room_financal_manager/screens/login_page.dart';
import 'package:room_financal_manager/screens/personal_page.dart';

class DrawerMenu extends StatefulWidget {
  final UserData user;
  DrawerMenu({this.user});
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    UserProvider _user = Provider.of<UserProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF42AF3B), Color(0xFF17B6A0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            accountEmail: Column(
              children: [
                Row(
                  children: [
                    Text(
                      _user.userData.displayName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("ID: ${_user.userData.id}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 16,
                    ),
                    Text(_user.userData.phoneNumber,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
              ],
            ),
            currentAccountPicture: GestureDetector(
              child: ClipOval(
                  child: Container(
                      width: 100,
                      height: 100,
                      color: Color(0xFFCDCCCC),
                      child: _user.userData.urlAvt==""?Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ):Image.network(_user.userData.urlAvt,fit: BoxFit.fill,))
              ),
            ),
          ),

          ///Trang c?? nh??n
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PersonalPage(user: widget.user,)));
            },
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.account_box,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Trang c?? nh??n",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),

          //C??i ?????t
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "C??i ?????t",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),

          //H??? tr???
          InkWell(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context)=>AlertDialog(
                    backgroundColor: Colors.white,
                    title:  Center(
                        child: Text("H??? tr???", style: TextStyle(color: Colors.blue[900], fontSize: 22, fontWeight: FontWeight.bold),)),
                    content: Container(
                        height: 200,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("B???n ??ang g???p s??? c????"),
                            Text(" Li??n h??? ngay v???i ch??ng t??i!"),
                            SizedBox(height: 20,),
                            Text("17521062 - Tr????ng V??n Th??nh"),
                            Text("17520916 - Nguy???n Duy Ph?????c"),
                            Text("17520906 - Nguy???n ?????c Ph??c")
                          ],)
                    ),contentPadding: EdgeInsets.all(0),

                    actions: <Widget>[
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text("Tho??t", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  )
              );
            },
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.help,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "H??? tr???",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),

          //Th??ng tin li??n h???
          InkWell(
            onTap: () async {
              await showDialog(
                  context: this.context,
                  builder: (context)=>AlertDialog(
                  backgroundColor: Colors.white,
                  title:  Center(
                  child: Text("Th??ng tin li??n h???", style: TextStyle(color: Colors.blue[900], fontSize: 22, fontWeight: FontWeight.bold),)),
                    content: Container(
                        height: 100,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("17521062 - Tr????ng V??n Th??nh"),
                            Text("17520916 - Nguy???n Duy Ph?????c"),
                            Text("17520906 - Nguy???n ?????c Ph??c")
                          ],)
                    ),contentPadding: EdgeInsets.all(0),

                  actions: <Widget>[
                    InkWell(
                    onTap: (){
                    Navigator.pop(context);
                    },
                    child: Text("Tho??t", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                    ],
                  )
              );
            },
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.info,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Th??ng tin li??n h???",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),

          //????ng xu???t
          InkWell(
            onTap: () {
              _user.auth.signOut();
              //_user.googleSignIn.disconnect();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage()));
            },
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "????ng xu???t",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
