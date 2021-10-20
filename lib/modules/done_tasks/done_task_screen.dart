import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {

        return ConditionalBuilder(
          condition: AppCubit.get(context).doneTasks.isNotEmpty,
          builder: (BuildContext context) => ListView.separated(
            itemBuilder:(context ,index) => buildTaskItem(AppCubit.get(context).doneTasks[index],context) ,
            separatorBuilder: (context , index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
              ),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            itemCount:AppCubit.get(context).doneTasks.length ,
          ),
          fallback: (BuildContext context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  size: 100,
                  color: Colors.black54,
                ),
                Text(
                  'No Tasks done Yet ..',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

        );
      },

    );

  }
}
