import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';

class DBHelper {
  // private ctor
  DBHelper._();
  static final DBHelper instance = DBHelper._();
  Database? db;
  Future<Database> getDB() async {
    db ??= await initDB();
    return db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "hospital.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          // all the tables should be here
          """
              CREATE TABLE IF NOT EXISTS patient
              (
                p_id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                address TEXT,
                telephone TEXT,
                dob TEXT NOT NULL,
                martial_status TEXT CHECK(martial_status IN ('Y','N')),
                GENDER TEXT CHECK(GENDER IN ('M','F'))
              );
              CREATE  TABLE IF NOT EXISTS next_of_kin( 
                  nok_id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name TEXT NOT NULL,
                  relationship TEXT NOT NULL,
                  telephone TEXT,
                  p_id INTEGER ,
                  FOREIGN KEY (p_id) REFERENCES patient(p_id)
              );
       
              CREATE TABLE IF NOT EXISTS local_doctor -- done
              (
                clinic_no INTEGER PRIMARY KEY UNIQUE,
                telephone TEXT,
                address TEXT,
                p_id INTEGER ,
                  FOREIGN KEY (p_id) REFERENCES patient(p_id)
              );
              --select * from local_doctor
              --DROP TABLE local_doctor
              
              CREATE TABLE IF NOT EXISTS patient_medication
              (
                m_id INTEGER PRIMARY KEY AUTOINCREMENT,
                p_id INTEGER NOT NULL,
                FOREIGN KEY (p_id) REFERENCES patient(p_id)
              );
              CREATE TABLE supplier 
              (
                s_id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                address TEXT,
                telephone TEXT
              );
              CREATE TABLE IF NOT EXISTS pharma_supply
              (
                drug_no INTEGER  PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT,
                qty INTEGER, 
                dosage REAL, -- WILL BE IN MG/ML
                method_of_use TEXT NOT NULL,
                cost_per_unit REAL, -- FOR COUNTRY CURRENCY 
                s_id INTEGER NOT NULL,
                FOREIGN KEY (s_id) REFERENCES supplier(s_id)
              );
              
              CREATE TABLE  IF NOT EXISTS medication_details
              (
                md_id INTEGER NOT NULL,
                m_id INTEGER NOT NULL,
                start_date TEXT,
                end_date TEXT,
                drug_no INTEGER NOT NULL,
                FOREIGN KEY (drug_no) REFERENCES pharma_supply(drug_no),
                FOREIGN KEY  (m_id) REFERENCES patient_medication(m_id)
              );
              CREATE TABLE IF NOT EXISTS staff
              (
                stf_id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                gender TEXT CHECK( gender IN ('f','m','o')), -- female ,male ,other
                shift TEXT CHECK( shift IN ('d','n')), -- day ,night
                telephone TEXT ,
                dob TEXT,
                address TEXT,
                designation TEXT, -- INCHARGE  NURSE, MEDICAL DIRECTOR
                insurance_number TEXT,
                salary REAL
              );
              CREATE TABLE IF NOT EXISTS staff_qualification
              (
                sq_id INTEGER PRIMARY KEY AUTOINCREMENT,
                qualification TEXT NOT NULL,
                start_date TEXT,
                end_date TEXT,
                institute TEXT,
                stf_id INTEGER,
                FOREIGN KEY (stf_id) REFERENCES staff(stf_id)
              );
              CREATE TABLE IF NOT EXISTS staff_contract
              (
                sc_id INTEGER PRIMARY KEY AUTOINCREMENT,
                hours_per_weak REAL NOT NULL,
                salary_type TEXT ,-- MONTHLY// WEAKLY DAILY // ANUAL 
                stf_id INTEGER,
                FOREIGN KEY (stf_id) REFERENCES staff(stf_id)
              );
              CREATE TABLE IF NOT EXISTS staff_experience
              (
                se_id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                organization  TEXT,
                start_date TEXT,
                end_date TEXT,
                stf_id INTEGER,
                FOREIGN KEY (stf_id) REFERENCES staff(stf_id)
              );
              CREATE TABLE IF NOT EXISTS ward
              (
                ward_id INTEGER PRIMARY KEY AUTOINCREMENT,
                ward_name TEXT NOT NULL ,
                number_of_beds INTEGER,
                location TEXT,
                stf_id INTEGER,
                FOREIGN KEY (stf_id) REFERENCES staff(stf_id) -- SHOULD BE INCHARGE NURSE
              );
              CREATE TABLE IF NOT EXISTS in_patient
              (
                ip_id INTEGER PRIMARY KEY AUTOINCREMENT,
                bed_no INTEGER NOT NULL,
                admit_date TEXT NOT NULL,
                exit_date TEXT,
                ward_id INTEGER,
                p_id INTEGER,
                FOREIGN KEY (p_id) REFERENCES patient(p_id), 
                FOREIGN KEY (ward_id) REFERENCES ward(ward_id) 
              );
              CREATE TABLE IF NOT EXISTS  requesition
              (
                r_id INTEGER PRIMARY KEY AUTOINCREMENT,
                date_ordered TEXT,
                ward_id INTEGER NOT NULL,
                FOREIGN KEY (ward_id) REFERENCES ward(ward_id)
              );
              CREATE TABLE IF NOT EXISTS requesition_detail
              (
                rd_id INTEGER PRIMARY KEY AUTOINCREMENT,
                qty_required INTEGER ,
                drug_no INTEGER NOT NULL,
                r_id INTEGER NOT NULL,
                FOREIGN KEY (r_id) REFERENCES requesition(r_id)
              );
              CREATE TABLE IF NOT EXISTS appointment
              (
                apt_id INTEGER PRIMARY KEY AUTOINCREMENT,
                apt_room INTEGER NOT NULL,
                date TEXT,
                time TEXT,
                p_id INTEGER,
                stf_id INTEGER,
                FOREIGN KEY (p_id) REFERENCES patient(p_id),
                FOREIGN KEY (stf_id) REFERENCES staff(stf_id) 
              );
           """,
        );
      },
    );
  }

  // OTHER FUNCTIONS SHOULD BE ADDED
  //supplier -- CREATE TABLE supplier
  //               (
  //                 s_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //                 name TEXT NOT NULL,
  //                 address TEXT,
  //                 telephone TEXT
  //               );
  Future<int> insertInSupplier({
    required String name,
    required String address,
    required String mobile,
  }) async {
    final dbTemp = await getDB();
    return await dbTemp.rawInsert(
      "insert into supplier(name,address,telephone) values (?,?,?)",
      [name, address, mobile],
    );
  }

  Future<List<Map<String, dynamic>>> getAllSuppliers() async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery("select * from supplier");
  }

  Future<List<Map<String, dynamic>>> getMinSupplierId() async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery('select max(s_id) as ms from supplier');
  }

  Future<List<Map<String, dynamic>>> getSupplierWithSupplierID(int id) async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery('select * from supplier where s_id=?', [id]);
  }

  Future<int> removeSupplierWithId(int id) async {
    final dbTemp = await getDB();
    return await dbTemp.rawDelete('delete from supplier where s_id=?', [id]);
  }

  // staff queries are below
  // stf_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //                 name TEXT NOT NULL,
  //                 gender TEXT CHECK( gender IN ('f','m','o')), -- female ,male ,other
  //                 shift TEXT CHECK( shift IN ('d','n')), -- day ,night
  //                 telephone TEXT ,
  //                 dob TEXT,
  //                 address TEXT,
  //                 designation TEXT, -- INCHARGE  NURSE, MEDICAL DIRECTOR
  //                 insurance_number TEXT,
  //                 salary REAL
  Future<int> insertIntoStaff({
    required name,
    required gender,
    String? shift,
    String? telephone,
    String? dob,
    String? address,
    String? designation,
    String? insurance_no,
    double? salary,
  }) async {
    print(gender);
    final dbTemp = await getDB();
    return await dbTemp.rawInsert(
      """
     insert into staff(name,gender,shift,telephone,dob,address,designation,insurance_number,salary)
                 values(?,?,?,?,?,?,?,?,?)
    """,
      [
        name,
        gender,
        shift,
        telephone,
        dob,
        address,
        designation,
        insurance_no,
        salary,
      ],
    );
  }

  Future<int> updateJobOfStaffWithId({
    required String newJob,
    required int staffId,
  }) async {
    final dbTemp = await getDB();
    return await dbTemp.rawUpdate(
      'update table staff set designation=? where stf_id=?',
      [newJob, staffId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllStaff() async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery('select * from staff');
  }

  Future<List<Map<String, dynamic>>> getStaffWhereDesignation({
    required String designation,
  }) async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery('select * from staff where designation= ?', [
      designation,
    ]);
  }

  Future<List<Map<String, dynamic>>> getStaffWhereDesignationAndIdid({
    required String designation,
    required int id,
  }) async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery(
      'select * from staff where designation= ? and stf_id=?',
      [designation, id],
    );
  }

  Future<List<Map<String, dynamic>>> getMinStaffId() async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery('select min(stf_id) as ms from staff');
  }

  Future<List<Map<String, dynamic>>> getMaxStaffId() async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery('select max(stf_id) as ms from staff');
  }

  Future<int> removeStaffWithId({required int id}) async {
    final dbTemp = await getDB();
    return await dbTemp.rawDelete('delete from staff where stf_id=?', [id]);
  }

  Future<List<Map<String, dynamic>>> getDesignationOfStaffWithId({
    required int id,
  }) async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery(
      'select designation from staff where stf_id= ?',
      [id],
    );
  }

  Future<List<Map<String, dynamic>>> getNameOdStaffWithId({
    required int id,
  }) async {
    final dbTemp = await getDB();
    return await dbTemp.rawQuery('select name from staff where stf_id= ?', [
      id,
    ]);
  }
  // pharma supply
  //CREATE TABLE IF NOT EXISTS pharma_supply
  //               (
  //                 drug_no INTEGER  PRIMARY KEY AUTOINCREMENT,
  //                 name TEXT NOT NULL,
  //                 description TEXT,
  //                 qty INTEGER,
  //                 dosage REAL, -- WILL BE IN MG/ML
  //                 method_of_use TEXT NOT NULL,
  //                 cost_per_unit REAL, -- FOR COUNTRY CURRENCY
  //                 s_id INTEGER NOT NULL,
  //                 FOREIGN KEY (s_id) REFERENCES supplier(s_id)
  //               );

  Future<int> insertIntoPharmaSupply({
    required String name,
    required String description,
    required int qty,
    required double dosage,
    required String methodOfUse,
    required double costPerUnit,
    required int supplierId,
  }) async {
    var database = await getDB();
    // if database containts that db
    var rawQuery = await database.rawQuery(
      'select s_id from supplier where s_id=?',
      [supplierId],
    );
    if (rawQuery.isNotEmpty) {
      return await database.rawInsert(
        'insert into pharma_supply (name,description,qty,dosage,method_of_use,cost_per_unit,s_id) values (?,?,?,?,?,?,?)',
        [name, description, qty, dosage, methodOfUse, costPerUnit, supplierId],
      );
    } else {
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getALlSupply() async {
    var database = await getDB();
    return await database.rawQuery('select * from pharma_supply');
  }

  Future<int> removeSupplyWithId(int drug_no) async {
    var database = await getDB();
    return await database.rawDelete(
      'delete from pharma_supply where drug_no=?',
      [drug_no],
    );
  }

  // staff experince
  // CREATE TABLE IF NOT EXISTS staff_qualification
  // (
  // sq_id INTEGER PRIMARY KEY AUTOINCREMENT,
  // qualification TEXT NOT NULL,
  // start_date TEXT,
  // end_date TEXT,
  // institute TEXT,
  // stf_id INTEGER,
  // FOREIGN KEY (stf_id) REFERENCES staff(stf_id)
  // );

  Future<int> insertIntoStaffQualification({
    required int StaffId,
    required String title,
    required String startDate,
    required String endDate,
    required String institute,
  }) async {
    var doesAnySupplierExistWithId =
        await AppController.doesAnySupplierExistWithId(StaffId);
    if (doesAnySupplierExistWithId) {
      var database = await getDB();
      return await database.rawInsert(
        'insert into staff_qualification(qualification,start_date,end_date,institute,stf_id) values (?,?,?,?,?)',
        [title, startDate, endDate, institute, StaffId],
      );
    }
    return 0;
  }

  // CREATE TABLE IF NOT EXISTS staff_experience
  // (
  // se_id INTEGER PRIMARY KEY AUTOINCREMENT,
  // title TEXT NOT NULL,
  // organization  TEXT,
  // start_date TEXT,
  // end_date TEXT,
  // stf_id INTEGER,
  // FOREIGN KEY (stf_id) REFERENCES staff(stf_id)
  // );
  Future<int> insertIntoStaffExperience({
    required int StaffId,
    required String title,
    required String startDate,
    required String endDate,
    required String oragnization,
  }) async {
    var doesAnySupplierExistWithId =
        await AppController.doesAnySupplierExistWithId(StaffId);
    if (doesAnySupplierExistWithId) {
      var database = await getDB();
      return await database.rawInsert(
        'insert into staff_experience(title,start_date,end_date,organization,stf_id) values (?,?,?,?,?)',
        [title, startDate, endDate, oragnization, StaffId],
      );
    }
    return 0;
  }

  // ward_id INTEGER PRIMARY KEY AUTOINCREMENT,
  // ward_name TEXT NOT NULL ,
  //     number_of_beds INTEGER,
  // location TEXT,
  //     stf_id INTEGER,
  // FOREIGN KEY (stf_id) REFERENCES staff(stf_id) -

  Future<int> insertIntoWard({
    required String wardName,
    required int nob,
    required String location,
    required int stfId,
  }) async {
    bool temp = await AppController.doesAnySupplierExistWithIdWithDesgination(
      id: stfId,
      desg: 'Incharge Nurse',
    );
    if (!temp) {
      return 0;
    }
    var database = await getDB();
    return await database.rawInsert(
      'insert into ward(ward_name,number_of_beds,location,stf_id) values (?,?,?,?)',
      [wardName, nob, location, stfId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllWards() async {
    var database = await getDB();
    return await database.rawQuery('select * from ward');
  }

  Future<List<Map<String, dynamic>>> getWardWithStfId({
    required int stf_id,
  }) async {
    var database = await getDB();
    return await database.rawQuery('select * from ward where stf_id=?', [
      stf_id,
    ]);
  }

  Future<List<Map<String, dynamic>>> getWardWithWardId({
    required int wardId,
  }) async {
    var database = await getDB();
    return await database.rawQuery('select * from ward where ward_id=?', [
      wardId,
    ]);
  }

  // CREATE TABLE IF NOT EXISTS  requesition
  //               (
  //                 r_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //                 date_ordered TEXT,
  //                 ward_id INTEGER NOT NULL,
  //                 FOREIGN KEY (ward_id) REFERENCES ward(ward_id)
  //               );
  Future<List<Map<String, dynamic>>> getAllRequisitionsOfWard({
    required int wardId,
  }) async {
    var database = await getDB();
    return await database.rawQuery(
      'select * from requesition where ward_id=?',
      [wardId],
    );
  }

  Future<int> insertIntoRequisition({
    required String dateOrdered,
    required int ward_id,
    required List<({int drugNo, int qty})> orders,
  }) async {
    var wardWithWardId = await instance.getWardWithWardId(wardId: ward_id);
    if (wardWithWardId.isEmpty) {
      return 0;
    }
    var database = await getDB();
    int res = await database.rawInsert(
      'insert into requesition(date_ordered,ward_id) values (?,?)',
      [dateOrdered, ward_id],
    );
    if (res == 0) {
      return res;
    }
    // get its Id
    List<Map<String, dynamic>> rawQuery = await database.rawQuery(
      "select max(r_id) as mx from requesition",
    );
    int id = rawQuery[0]['mx'];
    for (int i = 0; i < orders.length; i++) {
      var detail = await instance._insertIntoRequisitionDetail(
        qtyReuired: orders[i].qty,
        drugNo: orders[i].drugNo,
        requizitionId: id,
      );
      if (detail == 0) {
        return -1;
      }
    }
    return res;
  }

  Future<void> deleteRequesistionInRange({
    required int start,
    required int end,
  }) async {
    var database = await getDB();
    await database.rawDelete(
      'delete from requesition where r_id>=? and r_id<=?',
      [start, end],
    );
  }

  //               CREATE TABLE IF NOT EXISTS requesition_detail
  //               (
  //                 rd_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //                 qty_required INTEGER ,
  //                 drug_no INTEGER NOT NULL,
  //                 r_id INTEGER NOT NULL,
  //                 FOREIGN KEY (r_id) REFERENCES requesition(r_id)
  //               );
  Future<int> _insertIntoRequisitionDetail({
    required int qtyReuired,
    required int drugNo,
    required int requizitionId,
  }) async {
    var database = await getDB();
    var i = await database.rawUpdate(
      'update pharma_supply set qty=qty-? where qty-?>=0',
      [qtyReuired, qtyReuired],
    );
    print('came here with $qtyReuired and affected are $i');
    if (i == 0) {
      return 0;
    }
    return await database.rawInsert(
      'insert into requesition_detail(qty_required,drug_no,r_id) values (?,?,?)',
      [qtyReuired, drugNo, requizitionId],
    );
  }

  //      CREATE TABLE IF NOT EXISTS in_patient
  //               (
  //                 ip_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //                 bed_no INTEGER NOT NULL,
  //                 admit_date TEXT NOT NULL,
  //                 exit_date TEXT,
  //                 ward_id INTEGER,
  //                 p_id INTEGER,
  //                 FOREIGN KEY (p_id) REFERENCES patient(p_id),
  //                 FOREIGN KEY (ward_id) REFERENCES ward(ward_id)
  //               );

  // if exist date is inserted then patient has gone
  Future<int> insertIntoInpatient({
    required int bedNo,
    required String admitDate,
    String? exitDate,
    required int wardId,
    required int patientId,
  }) async {
    var database = await getDB();
    return await database.rawInsert(
      'insert into in_patient(bed_no,admit_date,exit_date,ward_id,p_id) values (?,?,?,?,?)',
      [bedNo, admitDate, exitDate, wardId, patientId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllInPatientOfWard({
    required int wardNo,
  }) async {
    var database = await getDB();
    print("cte is  called");
    return await database.rawQuery(
      '''
      with cte as(
        select i.p_id,name,admit_date,exit_date,ward_id,bed_no from in_patient i left join patient p on i.p_id=p.p_id)
    select * from cte where  ward_id=?
''',
      [wardNo],
    );
  }
  //  CREATE TABLE IF NOT EXISTS patient
  //               (
  //                 p_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //                 name TEXT NOT NULL,
  //                 address TEXT,
  //                 telephone TEXT,
  //                 dob TEXT NOT NULL,
  //                 martial_status TEXT CHECK(martial_status IN ('Y','N')),
  //                 GENDER TEXT CHECK(GENDER IN ('M','F'))
  //               );
  Future<int> insertIntoPatients({
    required String name,
    required String address,
    required String tele,
    required String dob,
    required String martialStat,
    required String gender,
    required int d_id,
    required String description,
  }) async {
    var database = await getDB();
    var val = await database.rawInsert('''
        insert into patient (name,address,telephone,dob,martial_status,GENDER) 
            values (?,?,?,?,?,?) ''', [
              name,address,tele,dob,martialStat,gender
    ]);
    if(val==0){
      return 0;
    }
    // now insert fetail of doctor assif
    List<Map<String,dynamic>> rawQuery = await database.rawQuery('select max(p_id) mx from patient');
    int pid=rawQuery[0]['mx'] ;
    await AppController.AddToDoctorList(doc_id: d_id, patientId: pid);
    AppController.addDescriptionToPatient(p_id: pid, description: description);
    return val;
  }
  Future<List<Map<String, dynamic>>> getAllPatients() async {
    var database = await getDB();
    return await database.rawQuery('select * from patient');
  }
  Future<List<Map<String, dynamic>>> getPatientWithId({required int id}) async {
    var database = await getDB();
    return await database.rawQuery('select * from patient where p_id =?',[id]);
  }
  Future<List<Map<String, dynamic>>> getPatientWithIds({required List<int> ls}) async {
    var database = await getDB();
    String placeHolder=List.filled(ls.length, '?').join(',');
    return await database.rawQuery('select * from patient where p_id in ($placeHolder)',ls);
  }

  //               CREATE  TABLE IF NOT EXISTS next_of_kin(
  //                   nok_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //                   name TEXT NOT NULL,
  //                   relationship TEXT NOT NULL,
  //                   telephone TEXT,
  //                   p_id INTEGER ,
  //                   FOREIGN KEY (p_id) REFERENCES patient(p_id)
  //               );
Future<int> insertIntoNextOfKin({required String name,required String relationShip,required String telephone ,required int p_id})
async {
  var database =await getDB();
  return await database.rawInsert('insert into next_of_kin(name,relationship,telephone,p_id)  values (?,?,?,?)',[name,relationShip,telephone,p_id]);
}
Future<List<Map<String, dynamic>>> getNextOfKinWherePatientIdIs({required int pid}) async {
  var database =await getDB();
  return await database.rawQuery('select * from next_of_kin where p_id=?',[pid]);
}
//  CREATE TABLE  IF NOT EXISTS medication_details
//               (
//                 md_id INTEGER NOT NULL,
//                 m_id INTEGER NOT NULL,
//                 start_date TEXT,
//                 end_date TEXT,
//                 drug_no INTEGER NOT NULL,
//                 FOREIGN KEY (drug_no) REFERENCES pharma_supply(drug_no),
//                 FOREIGN KEY  (m_id) REFERENCES patient_medication(m_id)
//               );
Future<int> insertIntoMedication({required int p_id,required List<Map<String,dynamic>> list})
async {
    var database =await getDB();
    int i= await database.rawInsert('insert into patient_medication(p_id) values (?)',[p_id]);
     List<Map<String,dynamic>> ls= await database.rawQuery('selected max(m_id) mx from patient_medication');
     int m_id=ls[0]['m_id'];
     for(int i=0;i<list.length;i++){
       await database.rawInsert('insert into medication_details(m_id,start_date,end_date,drug_no) values (?,?,?,?)',[m_id,list[i]['start_date'],list[i]['end_date'],list[i]['drug_no']]);
     }
    return i;
}
}


