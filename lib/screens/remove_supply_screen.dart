import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../model/DBHelper.dart';
class RemoveSupplyScreen extends StatefulWidget {
  const RemoveSupplyScreen({super.key});

  @override
  State<RemoveSupplyScreen> createState() => _RemoveSupplyScreenState();
}

class _RemoveSupplyScreenState extends State<RemoveSupplyScreen> {
  bool isAnyError=false;
  String errorMsg="";
  var _idC=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
        appBar:AppBar(
          title: Text('The Wellmeadows Hospital ',style: TextStyle(
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
                          hintText: 'Enter Drug No',
                          label: Text('Drug No'),
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
                          // check if any issue with data then insert into
                          if(_idC.text.trim().isEmpty ){
                            isAnyError=true;

                            setState(() {
                              errorMsg="Please Enter ID";
                            });
                          }else{
                            // inwert detail
                            var instance = DBHelper.instance;
                            // print(gender);
                            var i = await instance.removeSupplyWithId(int.parse(_idC.text));
                            if(i==0) {
                              isAnyError=true;
                              setState(() {
                                errorMsg="No Such Drug Exists";
                              });
                            }else
                              Navigator.pop(context);
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
