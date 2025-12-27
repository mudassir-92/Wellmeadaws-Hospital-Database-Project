import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';
class SendPatientToWard extends StatefulWidget {
  final int p_id;
  const SendPatientToWard({super.key,required this.p_id});

  @override
  State<SendPatientToWard> createState() => _SendPatientToWardState();
}

class _SendPatientToWardState extends State<SendPatientToWard> {
  TextEditingController _bedNoC=TextEditingController();
  TextEditingController _pidC=TextEditingController();
  String? startDate;
  String? endDate;
  String? wardSel;
  TextEditingController _wardIdC=TextEditingController();
  List<Map<String,dynamic>> wardList=[];
  Future<void> loadQouta() async {
    wardList= await DBHelper.instance.getAllWards();
    _pidC.text=widget.p_id.toString();
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    loadQouta();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Transfer to Ward', style: TextStyle(
              color: Colors.white
          ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Stack(
            alignment: AlignmentGeometry.topCenter,
            children: [
              Lottie.asset(
                'assets/bgG.json',
                width: size.width,
                height: size.height * 1.18,
                fit: BoxFit.cover,
                repeat: true,
              ),
              SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 300,
                          child: Image.asset('assets/logo.png'),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: _pidC,
                            readOnly: true,
                            decoration: InputDecoration(
                              label: Text('Patient Id'),
                              border: OutlineInputBorder(
                                // borderRadius:
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: _bedNoC,
                            decoration: InputDecoration(
                              label: Text('Bed No'),
                              border: OutlineInputBorder(
                                // borderRadius:
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        DropdownButton<String>(
                          hint: Text('Select Ward'),
                          value: wardSel,
                          items: wardList
                              .map(
                                (u) => DropdownMenuItem<String>(
                              value: 'id: ${u['ward_id']} : ${u['ward_name']}',
                              child: Text('id: ${u['ward_id']} : ${u['ward_name']}'),
                            ),
                          )
                              .toList(),
                          onChanged: (String? k) {
                            setState(() {
                              wardSel = k;
                              //  print(allSupply.map((e) => "'${e['name']}'").toList());
                              print("Current value: '$wardSel'");
                            });
                          },
                        ),
                        SizedBox(
                          width: 200,
                          child: FloatingActionButton(onPressed: () async {
                            if(wardSel==null || _bedNoC.text.trim().isEmpty){

                            }else{
                              int? bedNo=int.tryParse( _bedNoC.text);
                              int wardId=int.parse(wardSel!.split(":")[1]);
                              if(bedNo!=null) {
                                var i=await DBHelper.instance.insertIntoInpatient(bedNo: bedNo, admitDate: AppController.getDBStyleDate(DateTime.now()),
                                    wardId: wardId, patientId:widget.p_id);
                                if(i!=0){
                                  Navigator.pop(context);
                                }
                              }}
                          },backgroundColor: Colors.red.shade100,child: Text('Transfer'),),
                        )
                      ]
                  ))
            ])
    );
  }
}