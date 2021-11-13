import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';

import 'package:store_pedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:store_pedia/cubit/mark_bad_part/cubit/markbadpart_cubit.dart';
import 'package:store_pedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/screens/add_item_page/add_item_page.dart';
import 'package:store_pedia/widgets/input_editor.dart';
import 'package:store_pedia/widgets/online_pinch_zoom.dart';
import 'package:store_pedia/widgets/page_layout.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

class PartDetailPage extends StatelessWidget {
  static String routeName = '/part_detail_page';
  const PartDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final part = ModalRoute.of(context)!.settings.arguments as Part;

    return PageLayout(
      hasBackButton: true,
      body: PartBody(
        part: part,
      ),
      title: Text(
        part.partName!,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.white),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }
}

class PartBody extends StatelessWidget {
  const PartBody({required this.part, Key? key}) : super(key: key);
  final Part part;
  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        OnlinePinchZoomImage(link: part.photo),

        // Container(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Text(
        //         part.likesCount == null ? '0' : part.likesCount.toString(),
        //         style: Theme.of(context).textTheme.headline6,
        //       ),
        //       Container(
        //         width: 20.0,
        //       ),
        //       IconButton(
        //         icon: Icon(
        //           Icons.thumb_up,
        //           size: 30,
        //         ),
        //         onPressed: () {
        //           //increase likes here;
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        space(),
        part.partDescription == null
            ? Container()
            : textCard(StringConstants.partDescriptionTitle,
                part.partDescription!, context),
        part.brand == null
            ? Container()
            : textCard(StringConstants.brandTitle, part.brand!, context),

        part.partNumber == null
            ? Container()
            : textCard(
                StringConstants.partNumberTitle, part.partNumber!, context),
        part.storeId == null
            ? Container()
            : textCard(StringConstants.storeIdTitle, part.storeId!, context),
        part.storeLocation == null
            ? Container()
            : textCard(StringConstants.storeLocationTitle, part.storeLocation!,
                context),
        part.section == null
            ? Container()
            : textCard(StringConstants.sectionTitle, part.section!, context),
        part.reasonForMarkingBad == null
            ? Container()
            : textCard('Deleted', part.reasonForMarkingBad!, context),

        part.addedBy == null
            ? Container()
            : textCard('Added By', part.addedBy!, context),

        part.dateAdded == null
            ? Container()
            : textCard(
                'Date Added',
                DateTime.fromMillisecondsSinceEpoch(part.dateAdded!).toString(),
                context),

        part.lastEditedBy == null
            ? Container()
            : textCard('Last Edited By', part.lastEditedBy!, context),

        part.searchKeywords == null
            ? Container()
            : textCard('Tags', part.searchKeywords!.toString(), context),

        part.markedBadByUid == null
            ? BlocBuilder<UserManagerCubit, UserManagerState>(
                builder: (context, state) {
                if (state is UserLoadedState &&
                    state.userData.accessLevel != null &&
                    state.userData.accessLevel >=
                        NumberConstants.minimumAccessLevelForPartEdit) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<EditItemCubit>().jumpEdit(part);
                          Navigator.of(context)
                              .popAndPushNamed(AddItemPage.routName);
                        },
                        icon: Icon(Icons.edit),
                        tooltip: 'Edit',
                      ),

                      //only display this delete icon
                      //if the file have not been marked for delete.
                      BlocBuilder<MarkbadpartCubit, MarkbadpartState>(
                        builder: (context, markState) {
                          if (markState == MarkbadpartState.idle) {
                            return IconButton(
                              onPressed: () {
                                //Todo marked bad
                                SignupFormDialog.formDialog(
                                  context: context,
                                  onSubmit: (value) {
                                    var userInfo =
                                        context.read<UserManagerCubit>().state;
                                    if (userInfo is UserLoadedState) {
                                      context.read<MarkbadpartCubit>().markBad(
                                          part: part,
                                          reason: value,
                                          userId: userInfo.userData.userId!);
                                    }
                                  },
                                  title: 'State reason for Deleting this part',
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                              ),
                              tooltip: 'Delete',
                            );
                          } else {
                            // indicate loading if mark bad delete button has been peressed.
                            if (markState == MarkbadpartState.loading) {
                              return Container(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(),
                              );
                            }
                            //if data has been marked bad already and the user level >=7 then show
                            // permanent delete icon, so it can be deleted finally.
                            //delete the image file with cloud function to save time.

                            return Container();
                          }
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              })
            : BlocBuilder<UserManagerCubit, UserManagerState>(
                builder: (context, state) {
                if (state is UserLoadedState &&
                    state.userData.accessLevel >=
                        NumberConstants.minimunAccessLevelForDeletingPart) {
                  return BlocConsumer<PartuploadwizardBloc,
                      PartuploadwizardState>(
                    listener: (context, state) {
                      if (state is PartuploadwizardState) {
                        Navigator.of(context).pop();
                      }
                      if (state is PartuploadwizardErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blue,
                            duration: Duration(
                                seconds: NumberConstants.errorSnackBarDelay),
                            content: Text(
                                'Delete not successful:\n${state.message}'),
                          ),
                        );
                      }
                    },
                    builder: (context, partState) {
                      return partState is PartuploadwizardLoadingState
                          ? Container(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator())
                          : IconButton(
                              onPressed: () {
                                context.read<PartuploadwizardBloc>().add(
                                    DeletePartEvent(partId: part.partUid!));
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.redAccent,
                              ),
                              tooltip: 'Delete Forever',
                            );
                    },
                  );
                } else {
                  return Container();
                }
              })
      ],
    );
  }

  Widget textCard(
    String field,
    String value,
    BuildContext context,
  ) {
    return Card(
      color: Colors.blue[50],
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          children: [
            Text(
              '$field: ',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(
              child: SelectableText(
                value,
                //softWrap: true,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget space() {
    return Container(
      height: 5.0,
    );
  }
}
