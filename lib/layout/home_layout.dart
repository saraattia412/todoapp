// ignore_for_file: avoid_print


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  //call database

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit ,AppStates>(
        listener: (BuildContext context, Object? state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {

          AppCubit cubit = AppCubit.get(context);//object

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              backgroundColor: Colors.black54,

            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataFromDatabaseLoadingState ,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(
                        20.0,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Title must be not empty';
                                }
                                return null;
                              },
                              onTap: () {
                                print(titleController);
                              },
                              label: 'Task Title',
                              prefix: Icons.title,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Time must be not empty';
                                }
                                return null;
                              },
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text = value!.format(context);
                                  print(value.format(context));
                                });
                              },
                              label: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Date must be not empty';
                                }
                                return null;
                              },
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2021-11-03'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                  print(DateFormat.yMMMd().format(value));
                                });
                              },
                              label: 'Task Date',
                              prefix: Icons.date_range_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  )
                      .closed
                      .then((value) async {
                    cubit.changeBottomCheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomCheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black54,
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                {
                  cubit.changeIndex(index);//call method in cubit
                }
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Nwe Tasks',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.done,
                    ),
                    label: 'Done Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived Tasks'),
              ],
            ),
          );
        },

      ),
    );
  }

}
