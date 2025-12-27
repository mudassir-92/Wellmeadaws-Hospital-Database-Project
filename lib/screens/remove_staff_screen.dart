import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../model/DBHelper.dart';
class RemoveStaffScreen extends StatefulWidget {
  const RemoveStaffScreen({super.key});

  @override
  State<RemoveStaffScreen> createState() => _RemoveStaffScreenState();
}

class _RemoveStaffScreenState extends State<RemoveStaffScreen> {
  bool isAnyError=false;
  String errorMsg="";
  var _idC=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
        appBar:AppBar(
          title: Text('Remove Staff',style: TextStyle(
              color: Colors.white
          ),
          ),
          backgroundColor: Colors.black,
        ),
        body:Stack(
            alignment: AlignmentGeometry.topCenter,
            children:[
              Lottie.asset(
                'assets/bgG.json',
                width: size.width,
                height: size.height*1.18,
                fit: BoxFit.cover,
                repeat: true,
              ),
              Column(
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
                        controller: _idC,
                        decoration: InputDecoration(
                          hintText: 'Enter Staff ID',
                          label: Text('ID'),
                          // labelText: 'id'
                          border: OutlineInputBorder(
                            // borderRadius:
                          ),
                        ),
                      ),
                    ),
                    if(isAnyError && errorMsg.isNotEmpty)
                      SizedBox(
                        height: 15,
                      ),
                    if(isAnyError && errorMsg.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.red,
                        child: Text(
                          errorMsg,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 150,
                      child: FloatingActionButton.extended(
                        onPressed: () async {
                         if(int.tryParse(_idC.text)==null)
                           {
                             errorMsg="Enter a number only ";
                             isAnyError=true;
                             setState(() {
                             });
                           }
                         else  if(int.parse(_idC.text)==1) {
                            errorMsg="Can't delete the medical Director";
                            isAnyError=true;
                            setState(() {
                            });
                          } else if(_idC.text.trim().isEmpty){
                            isAnyError=true;
                            setState(() {
                                errorMsg="Please Enter ID";
                            });
                          }else{
                            // inwert detail
                            var instance = DBHelper.instance;
                            // print(gender);
                            var i = await instance.removeStaffWithId(id: int.parse(_idC.text));
                            if(i==0) {
                              isAnyError=true;
                              setState(() {
                                errorMsg="No Such Supplier Exists";
                              });
                            }else {
                              Navigator.pop(context);
                            }
                            //   showDialog(context: context, builder: (context) {
                            //     return AlertDialog(
                            //       title: Text('Success'),
                            //       content: Text('Supplier Added successfully'),
                            //       actions: [
                            //         ElevatedButton(
                            //           onPressed: () {
                            //             Navigator.pop(context);
                            //           },
                            //           child: Text('OK'),
                            //         )
                            //       ],
                            //     );
                            //   });
                            // navigate to Medical director

                          }
                        },
                        label: Text('Remove'),
                      ),
                    ),
                  ]
              )
            ]
        )
    );
}
}
