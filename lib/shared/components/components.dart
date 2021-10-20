import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  TextInputAction onSubmit = TextInputAction.done,
  required FormFieldValidator? validator,
  required String label,
  required IconData prefix,

  //part password
  bool isPassword = false,
  IconData? suffix,
  Function? suffixPressed,

  //todo app
  Function? onTap,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,

      onFieldSubmitted: (s) {
        onSubmit;
      },

      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),

        border: const OutlineInputBorder(),

        //password
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
      ),

      //password
      obscureText: isPassword,

      //todo app
      onTap: () {
        onTap!();
      },
      enabled: isClickable,
    );



Widget buildTaskItem(Map model , context) =>
    Dismissible(
      key:   Key(model['id'].toString()),

      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: model['id']);

      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [

            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 40,
              child: Text(
                "${model['time']}",

              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),

            IconButton(onPressed: (){
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
                  icon: const Icon(
                      Icons.check_box,
                    color: Colors.green,
                  )
              ),

            IconButton(onPressed: (){
              AppCubit.get(context).updateData(
                status: 'archive',
                id: model['id'],
              );
            },
                icon: const Icon(
                    Icons.archive,
                  color: Colors.black45,
                )
            ),
          ],
        ),
      ),

    );
