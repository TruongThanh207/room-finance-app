import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';
import 'package:room_financal_manager/models/info_group.dart';
import 'package:room_financal_manager/models/user.dart';
import 'package:room_financal_manager/providers/group_providers.dart';
import 'package:room_financal_manager/providers/home_provider.dart';
import 'package:room_financal_manager/providers/user_provider.dart';

import 'package:room_financal_manager/services/authentication.dart';
import 'package:room_financal_manager/services/storage.dart';
import 'package:room_financal_manager/widgets/Nhom/create_group.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'home_page.dart';
import 'login_page.dart';



class PersonalPage extends StatefulWidget {
  final UserData user;
  PersonalPage({this.user});
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {



  SecureStorage secureStorage = SecureStorage();
  final _key = GlobalKey<ScaffoldState>();
  UserData _account;
  List<InformationGroup> _dsNhom = [];
  Authentication authentication = Authentication();

  List<Widget> listGroups = [];
  List<Widget> loadDanhSachNhom(GroupProviders _groups){

    List<Widget> ds = [];
   _groups.dsNhom.forEach((item) {
      ds.add(itemNhom(item));
    });


   setState(() {
     listGroups = ds;
   });
  return listGroups;
  }
  File _image;
  getImageSuccess(File image) async {
    if(image!=null){

      firebase_storage.Reference firebaseStorageRef =
      firebase_storage.FirebaseStorage.instance.ref().child(image.path);
      firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(image);
      uploadTask.whenComplete(() async {
        String url = await uploadTask.snapshot.ref.getDownloadURL();
        FirebaseFirestore.instance.collection("Users").doc(widget.user.id).update({
          "avatar": url
        });
        Provider.of<UserProvider>(context, listen: false).userData.urlAvt = url;
      });
      setState(() {

        _image = image;
      });

    }

  }
  Widget itemNhom(InformationGroup group){
    return   Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          Provider.of<GroupProviders>(context, listen: false).listGroupShow = false;
          Provider.of<GroupProviders>(context, listen: false).selectedGroup = group;
          Provider.of<GroupProviders>(context,listen: false).danhSachKhoanChi(group.id);
          Provider.of<HomeProviders>(context, listen: false).screen = 4;
          Navigator.pushReplacement(context,   MaterialPageRoute(
              builder: (context) => HomePage(user: widget.user,)
          ));
        },
        child: Row(
          children: [
            ClipOval(
                child: Container(
                    width: 50,
                    height: 50,
                    color: Color(0xFFCDCCCC),
                    child:group.avatar ==""?Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ):Image.network(group.avatar,fit: BoxFit.fill,))
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(group.nameGroup,
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadInitData();
  }
  loadInitData()async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.user.id).get().then((value) {
      setState(() {
        _account = UserData.formSnapShot(value);
      });
    });
  }
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    GroupProviders _groups = Provider.of<GroupProviders>(context);
    HomeProviders _home = Provider.of<HomeProviders>(context);
    UserProvider _user = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Color(0xFF42AF3B),
        centerTitle: true,
        title: Text(
          "TRANG C?? NH??N",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Image.asset(
                    "assets/image.jpeg",
                    fit: BoxFit.fill,
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: ClipOval(
                        child: Container(
                            width: 100,
                            height: 100,
                            color: Color(0xFFCDCCCC),
                            child: _image!=null?Image.file(_image, fit: BoxFit.fill,):_user.userData.urlAvt==""?Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ):Image.network(widget.user.urlAvt,fit: BoxFit.fill,))
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black54
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.camera_alt,color: Colors.white,),
                        onPressed: (){
                         _home.showPicker(context:context, success: getImageSuccess);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              _user.userData.displayName,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text("T???ng quan",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ID:",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    Text(_user.userData.id,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "S??? ??i???n tho???i:",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    Text(_user.userData.phoneNumber,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "S??? d?? hi???n c??:",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    Text(_account!=null?"${_account.money} vnd":"0 vnd",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text("Nh??m c???a b???n",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 10),
            child: Column(
              children:  loadDanhSachNhom(_groups)
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: CreateGroup(user: _user.userData,),
                        type: PageTransitionType.bottomToTop));
              },
              child: Row(
                children: [
                  Container(
                    height: 50.0,
                    width: 50.0,
                    child: new CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 30.0,
                      child: Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("Th??m nh??m",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text("Kh??c",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                    trailing: Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ),

                //H??? tr???
                InkWell(
                  onTap: () async {
                    await showDialog(
                        context: this.context,
                        builder: (context)=> AlertDialog(
                        backgroundColor: Colors.white,
                        title:  Center(
                        child: Text("H??? tr???", style: TextStyle(color: Colors.blue[900], fontSize: 22, fontWeight: FontWeight.bold),)),
                    content: Container(
                    height: 100,
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
                    trailing: Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ),

                //Th??ng tin li??n h???
                InkWell(
                  onTap: () async {
                    await showDialog(
                        context: this.context,
                        builder: (context)=> AlertDialog(
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
                    trailing: Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width - 80,
            child: RaisedButton(
              onPressed: () async {
                _user.auth.signOut();
                //_user.googleSignIn.disconnect();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage()));
              },
              color: Colors.white,
              child: Text(
                "????ng xu???t",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          )
        ],
      )),
    );
  }

}
