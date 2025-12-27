# Wellmeadows Hospital Management System

[![Project Demo](https://img.youtube.com/vi/JUeVRRMV9g0/0.jpg)](https://www.youtube.com/watch?v=JUeVRRMV9g0)

## Description

Wellmeadows Hospital Management System is a Flutter-based application developed to manage hospital-related operations such as patient records, drug information, and treatment data.
The application uses SQLite as a local database to ensure fast access, data consistency, and offline functionality.

---

## Technologies Used

* Flutter
* SQLite

---

**Database Repository Link:**
[https://github.com/mudassir-92/Wellmeadaws-Hospital-Database-Project](https://github.com/mudassir-92/Wellmeadaws-Hospital-Database-Project)

---

## Setup Instructions

### Step 1: Make the Flutter Project

```
flutter create hospital_managment_system
cd hospital_managment_system
```

---

### Step 2: Clone the Project Repo

```
git clone https://github.com/mudassir-92/Wellmeadaws-Hospital-Database-Project
```

Use the SQL schema and queries from this repository inside your Flutter project’s SQLite helper or database service files.

---

### Step 3: Install Dependencies

```
flutter pub get
```

Ensure the following packages are included in `pubspec.yaml`:

* sqflite
* path
* path_provider

---

### Step 4: Run the Application

```
flutter run
```

---

## Notes

* The application works offline using SQLite.
* Database tables must be created before performing CRUD operations.
* The database structure is modular and reusable.
