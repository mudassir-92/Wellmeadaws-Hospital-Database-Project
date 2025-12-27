import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';
import 'package:wellmeadows_hospital/screens/give_medication_to_patient.dart';
import 'package:wellmeadows_hospital/screens/send_patient_to_ward.dart';


class PatientDetailManagmentScreen extends StatefulWidget {
  final int p_id;
  const PatientDetailManagmentScreen({super.key,required this.p_id});

  @override
  State<PatientDetailManagmentScreen> createState() => _PatientDetailManagmentScreenState();
}

class _PatientDetailManagmentScreenState extends State<PatientDetailManagmentScreen> {
  List<Map<String,dynamic>> patient=[];
  Map<String,dynamic> p={};
  String? description;
  bool wardBeingShown=false;
  List<Map<String,dynamic>> wardsList=[];
  String? wardSel;
  Future<void> loadQouta()
  async {
    patient= await DBHelper.instance.getPatientWithId(id: widget.p_id);
    p= Map<String, dynamic>.from(patient[0]);
    wardsList=await DBHelper.instance.getAllWards();
    description= await AppController.getDescriptionOfPatient(p_id: widget.p_id);
    print('Patient Detail tab${widget.p_id} $description');
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
      appBar: AppBar(
        title: Text(
          'Patient OverView',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: p.isEmpty?CircularProgressIndicator():
    Card(
    elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Header
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  child: Text(
                    p['name'][0],
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  p['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 13),
              ],
            ),

            const Divider(height: 30),

            _infoRow(Icons.badge, 'Patient ID', p['p_id'].toString()),
            _infoRow(Icons.home, 'Address', p['address']),
            _infoRow(Icons.phone, 'Telephone', p['telephone']),
            _infoRow(Icons.cake, 'DOB', p['dob']),
            _infoRow(
              Icons.favorite,
              'Marital Status',
              p['martial_status'] == 'N' ? 'Single' : 'Married',
            ),
            _infoRow(
              Icons.person,
              'Gender',
              p['GENDER'] == 'M' ? 'Male' : 'Female',
            ),
            _infoRow(Icons.description, 'Description', description??"description not loaded"),
            SizedBox(
              height: 20,
            ),

            SizedBox(
              width: 200,
              child: FloatingActionButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SendPatientToWard(p_id: p['p_id']);
                      },));
              },backgroundColor: Colors.red.shade100,child: Text('Send To Ward'),),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: FloatingActionButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GiveMedicationToPatient(patientDetail: p,);
                    },));
              },backgroundColor: Colors.red.shade100,child: Text('Give Medication'),),
            )
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(onPressed: () {
        loadQouta();
      },child: Icon(Icons.refresh),),
    );
  }
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

}
