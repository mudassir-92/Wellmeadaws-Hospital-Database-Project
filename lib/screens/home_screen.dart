import 'package:flutter/material.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TextEditingController nameC =TextEditingController();
  // TextEditingController addressC =TextEditingController();
  // TextEditingController telephoneC =TextEditingController();
  List<Map<String,dynamic>>? allSuppliers;
  Future<void> loadQouta()
  async {
    allSuppliers =  await DBHelper.instance.getAllSuppliers();
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQouta();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(title:  Text('The Wellmeadows Hospital'),),
      body:DataTable(columns: [
        DataColumn(label: Text("name")),
        DataColumn(label: Text("address")),
        DataColumn(label: Text("telephone")),

      ], rows: allSuppliers!.map((u){
            return DataRow(cells: [
              DataCell(Text(u['name'])),
              DataCell(Text(u['address'])),
              DataCell(Text(u['telephone'])),
            ]);
      }).toList())
    );
  }
}
