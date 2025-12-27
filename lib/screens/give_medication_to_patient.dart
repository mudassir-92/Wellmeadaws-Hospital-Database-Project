import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../model/DBHelper.dart';
class GiveMedicationToPatient extends StatefulWidget {
  Map<String,dynamic> patientDetail;

  GiveMedicationToPatient({super.key,required Map<String,dynamic> this.patientDetail});
  @override
  State<GiveMedicationToPatient> createState() => _GiveMedicationToPatientState();
}

class _GiveMedicationToPatientState extends State<GiveMedicationToPatient> {
  List<Map<String, dynamic>> allSupply = [];
  bool isLoading =true;
  List<Map<String,dynamic>>  selectedSupply=[];
  TextEditingController _nameC=TextEditingController();
  TextEditingController _p_idC=TextEditingController();
  TextEditingController _startDateC=TextEditingController();
  TextEditingController _endDateC=TextEditingController();
  bool isAnyError=false;
  String errMsg="";
  String? drugStr;
  Future<void> loadQouta() async {
    // get All Pharma Supply
    allSupply = await DBHelper.instance.getALlSupply();

    // print("aaya");
    setState(() {
      isLoading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _p_idC.text=widget.patientDetail['p_id'].toString();
    _nameC.text=widget.patientDetail['name'];
    loadQouta();
  }
  Widget _buildMedeicationScreen(BuildContext context)
  {
    var size=MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _p_idC,
              readOnly: true,
              decoration: InputDecoration(
                hintText: widget.patientDetail['p_id'].toString(),
                label: Text('Patient Id'),
                // labelText: 'id'
                border: OutlineInputBorder(
                  // borderRadius:
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _nameC,
              readOnly: true,
              decoration: InputDecoration(
                hintText: widget.patientDetail['name'],
                label: Text('Name'),
                // labelText: 'id'
                border: OutlineInputBorder(
                  // borderRadius:
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
      DropdownButton<String>(
        hint: const Text('Select Drug'),
        value: allSupply.any((u) => u['drug_no'].toString() == drugStr)
            ? drugStr
            : null, // fallback to null if value not found
        items: allSupply.map((u) {
          return DropdownMenuItem<String>(
            value: u['drug_no'].toString(),
            child: Text("${u['drug_no']} : ${u['name']}"),
          );
        }).toList(),
        onChanged: (k) {
          setState(() => drugStr = k);
        },
      ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _startDateC,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: 'Select Date',
                  // labelStyle: 'Dat',
                  labelText: 'Start Date',
                  prefixIcon: Icon(Icons.today),
                  border: OutlineInputBorder(
                  )
              ),
              onTap: () async{
                final DateTime? pickedDate=await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime(2050));
                var _dateTime=pickedDate;
                if(pickedDate!=null) {
                  _startDateC.text='${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                }},
            ),
          ),
          SizedBox(height: 15,),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _endDateC,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: 'Select Date',
                  // labelStyle: 'Dat',
                  labelText: 'EndDate',
                  prefixIcon: Icon(Icons.today),
                  border: OutlineInputBorder(
                  )
              ),
              onTap: () async{
                final DateTime? pickedDate=await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime(2050));
                var _dateTime=pickedDate;
                if(pickedDate!=null) {
                  _endDateC.text='${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                }},
            ),
          ),
          if (isAnyError)
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.red,
              child: Text(
                "Some Entry is not correct/Filled",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: FloatingActionButton(onPressed: () {
                  if(drugStr==null || _startDateC.text.trim().isEmpty
                      || _endDateC.text.trim().isEmpty)
                  {
                    isAnyError=true;
                    errMsg="Please Fill Correctly";
                    setState(() {

                    });
                  }else{
                    
                    int drugNo=int.parse(drugStr!.split(":")[0]);
                    String? drugName;

                    if (drugStr != null) {
                      final selectedDrug = allSupply.firstWhere(
                            (u) => u['drug_no'].toString() == drugStr,
                        orElse: () => {},
                      );
                      drugName = selectedDrug['name'];
                    }
                    selectedSupply.add(
                        {'p_id':widget.patientDetail['p_id'],
                      'name':widget.patientDetail['name'],
                      'drug_no':drugNo,
                      'drug_name':drugName,
                      'start_date':_startDateC.text,
                      'end_date':_endDateC.text
                    });

                    print({'p_id':widget.patientDetail['p_id'],
                      'name':widget.patientDetail['name'],
                      'drug_no':drugNo,
                      'drug_name':drugName,
                      'start_date':_startDateC.text,
                      'end_date':_endDateC.text
                    });
                    setState(() {
                        isAnyError=false;
                    });
                  }
                },backgroundColor: Colors.red.shade100,child: Text('Add Drug'),),
              ),
              SizedBox(
                width: 5,
              ),
              FloatingActionButton(onPressed: () async {
                if(selectedSupply.isEmpty)
                {
                  isAnyError=true;
                  errMsg="Should be atleast one Drug";
                  setState(() {
                  });
                }else{
                  int i=await DBHelper.instance.insertIntoMedication(p_id: widget.patientDetail['p_id'], list: selectedSupply);
                  if(i!=0){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inserted Successfully'))
                    );
                    Navigator.pop(context);
                  }
                }
              },backgroundColor: Colors.red.shade100,child: Icon(Icons.done_all_outlined),),
              SizedBox(
                width: 5,
              ),
              FloatingActionButton(onPressed: () async {
                await generatePatientPDF(widget.patientDetail,selectedSupply);
              },backgroundColor: Colors.red.shade100,child: Icon(Icons.print),),

            ],
          ),
          SizedBox(height: 15),
          isLoading
              ? CircularProgressIndicator()
              : SizedBox(
            height: size.height * .35,
            child: DataTable2(
              decoration: BoxDecoration(

              ),
              dividerThickness: 3,
              // columnSpacing: 10,
              headingRowColor: WidgetStatePropertyAll(
                Colors.deepPurpleAccent,
              ),
              columns: [
                DataColumn2(label: Text('Patient ID')),
                DataColumn2(label: Text('Name')),
                DataColumn2(label: Text('Drug No')),
                DataColumn2(label: Text('Drug Name')),
                DataColumn2(label: Text('Start Date')),
                DataColumn2(label: Text('End Date')),
              ],
              rows: selectedSupply.map((e) {
                return DataRow(
                  cells: [
                    DataCell(Text(e['p_id'].toString())),
                    DataCell(Text(e['name'].toString())),
                    DataCell(Text(e['drug_no'].toString())),
                    DataCell(Text(e['drug_name'].toString())),
                    DataCell(Text(e['start_date'].toString())),
                    DataCell(Text(e['end_date'].toString())),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Medication', style: TextStyle(
            color: Colors.white
        ),
        ),
        backgroundColor: Colors.black,
      ),
       body:_buildMedeicationScreen(context)
    );
  }
  Future<void> generatePatientPDF(
      Map<String, dynamic> patient,
      List<Map<String, dynamic>> selectedSupply) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Patient Details',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Patient ID: ${patient['p_id']}'),
              pw.Text('Name: ${patient['name']}'),
              pw.Text('Address: ${patient['address']}'),
              pw.Text('Telephone: ${patient['telephone']}'),
              pw.Text('DOB: ${patient['dob']}'),
              pw.SizedBox(height: 20),
              pw.Text('Medication Details',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: [
                  'Patient ID',
                  'Name',
                  'Drug No',
                  'Drug Name',
                  'Start Date',
                  'End Date'
                ],
                data: selectedSupply.map((e) {
                  return [
                    e['p_id'].toString(),
                    e['name'],
                    e['drug_no'].toString(),
                    e['drug_name'],
                    e['start_date'],
                    e['end_date']
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    // Preview or print
    await Printing.layoutPdf(
        onLayout: (format) async => pdf.save());
  }

}
