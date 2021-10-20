// ignore_for_file: avoid_print


import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todoapp/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/done_tasks/done_task_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';
import 'package:todoapp/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  //object
static AppCubit get(context) => BlocProvider.of(context);

//var to appBar && bottom navigation
  int currentIndex = 0;

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> title = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  late Database database;
  //to get data
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archiveTasks =[];



  // navBottom
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  //CREATE DATABASE---->SqfLite: ^2.0.0+4 flutter
  void createDatabase() async {
   await openDatabase(
      'todo_database.db',
      version: 1,
      // ignore: duplicate_ignore
      onCreate: (database, version)  async{
         await database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY UNIQUE,title TEXT,time TEXT,date TEXT,status TEXT)')
            .then((value) {
          print("table created");
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
        print("database created");
      },
      onOpen: (database ) {
        getDataFromDatabase(database);
        print("database opened");
      },
    ).then((value) {
      database =value;
      emit(AppCreateDataBaseState());
    });
  }

   insertDatabase(
      {required String title, required String time, required String date}) async {
    await database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks (title,time,date,status) VALUES ("$title","$time","$date","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when insert database ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database)  {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];

    emit(AppGetDataFromDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {


      value.forEach((element) {
        if(element['status'] == 'new'){
          newTasks.add(element);
        }
        else if(element['status'] == 'done'){
          doneTasks.add(element);
        }
        else {
          archiveTasks.add(element);
        }


      });
      emit(AppGetDataFromDatabaseState());

    });
  }



  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataFromDatabaseState());
    });
  }



  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
void changeBottomCheetState({
  required bool  isShow,
  required IconData  icon,
}){
  isBottomSheetShown = isShow;
  fabIcon=icon;
  emit(AppChangeBottomCheetState());
}
}