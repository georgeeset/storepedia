import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/model/part.dart';

import 'conditional_image.dart';

class OnePart extends StatelessWidget {
  const OnePart({required this.part, super.key});
  final Part part;
  @override
  Widget build(BuildContext context) {
    //Size space=MediaQuery.of(context).size;
    return Card(
      color: part.markedBadByUid != null
          ? Colors.red[50]
          : part.isExhausted == false
              ? Colors.blue[50]
              : Colors.orange,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: part.photo == null
                    ? const Icon(
                        Icons.error,
                        size: 50,
                      )
                    : Hero(
                        tag: part.photo!,
                        child: ConditionalImage(
                          imageUrl: part.photo!,
                        ),
                      ),
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: Column(
                  children: [
                    part.partName == null
                        ? const Text('No Part name')
                        : Text(
                            part.partName!,
                            softWrap: true,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    part.partDescription == null
                        ? const Text('No Description')
                        : Text(
                            part.partDescription!,
                            softWrap: true,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                    part.storeLocation == null
                        ? Container()
                        : Text(
                            part.storeLocation!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ],
                ))
          ],
        ),
        onTap: () {
          var user = context.read<UserManagerCubit>().state;
          if (user is UserLoadedState) {
            context.push(
                '/part-detail/${user.userData.company}/${part.partUid}',
                extra: part);
          }
        },
      ),
    );
  }
}
