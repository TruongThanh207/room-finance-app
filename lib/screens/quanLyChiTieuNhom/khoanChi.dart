import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:room_financal_manager/config/initialization.dart';
import 'package:room_financal_manager/models/KhoanChiNhom.dart';
import 'package:room_financal_manager/providers/group_providers.dart';
import 'package:room_financal_manager/widgets/Nhom/item_KhoanChi_Nhom.dart';


class KhoanChi extends StatefulWidget {

  List<KhoanChiNhom> dsKhoanChi;
  KhoanChi({this.dsKhoanChi, });
  @override
  _KhoanChiState createState() => _KhoanChiState();
}

class _KhoanChiState extends State<KhoanChi> {
  RefreshController _refreshController;
  List<KhoanChiNhom> dsKhoanChi;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dsKhoanChi = widget.dsKhoanChi;
    _refreshController = RefreshController(initialRefresh: false);
  }
  void _onRefresh() async{
    Provider.of<GroupProviders>(context,listen: false).danhSachKhoanChi(Provider.of<GroupProviders>(context,listen: false).selectedGroup.id);
    dsKhoanChi =  Provider.of<GroupProviders>(context,listen: false).dsKhoanChiNhom;

    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _refreshController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    GroupProviders _groups = Provider.of<GroupProviders>(context);
    return  Padding(
      padding: const EdgeInsets.only(top: 50),
      child: _groups.status==Status.Loading?Center(
        child: CircularProgressIndicator(
        ),
      ):dsKhoanChi.length<=0?Center(child: Text("Không có dữ liệu!",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.black),),):ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
          shrinkWrap: true,
          itemCount: (dsKhoanChi != null)?dsKhoanChi.length : 0,
          itemBuilder: (value, index){
            return ItemExpensesGroup(dsItem: dsKhoanChi[index].listItemKhoanChi,ngayMua: dsKhoanChi[index].ngayMua,);
          }
      ),
    );
  }
}

