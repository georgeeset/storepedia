import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';

import 'package:storepedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:storepedia/cubit/mark_bad_part/cubit/mark_bad_part_cubit.dart';
import 'package:storepedia/cubit/mark_exhausted_part_cubit/cubit/markexhaustedpart_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/screens/add_item_page/add_item_page.dart';
import 'package:storepedia/widgets/input_editor.dart';
import 'package:storepedia/widgets/online_pinch_zoom.dart';
import 'package:storepedia/widgets/page_layout.dart';
import 'package:storepedia/constants/string_constants.dart' as string_constants;
import 'package:storepedia/constants/number_constants.dart' as number_constants;

class PartDetailPage extends StatelessWidget {
  static const String routeName = '/part_detail_page';
  const PartDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final part = ModalRoute.of(context)?.settings.arguments as Part;

    return PageLayout(
      hasBackButton: true,
      body: PartBody(
        part: part,
      ),
      title: Text(
        part.partName!,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }
}

class PartBody extends StatefulWidget {
  const PartBody({required this.part, super.key});
  final Part part;

  @override
  State<PartBody> createState() => _PartBodyState();
}

class _PartBodyState extends State<PartBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        OnlinePinchZoomImage(link: widget.part.photo),

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
        widget.part.partDescription == null
            ? Container()
            : textCard(string_constants.partDescriptionTitle,
                widget.part.partDescription!, context),
        widget.part.brand == null
            ? Container()
            : textCard(
                string_constants.brandTitle, widget.part.brand!, context),

        widget.part.partNumber == null
            ? Container()
            : textCard(string_constants.partNumberTitle,
                widget.part.partNumber!, context),
        widget.part.storeId == null
            ? Container()
            : textCard(
                string_constants.storeIdTitle, widget.part.storeId!, context),
        widget.part.storeLocation == null
            ? Container()
            : textCard(string_constants.storeLocationTitle,
                widget.part.storeLocation!, context),
        widget.part.section == null
            ? Container()
            : textCard(
                string_constants.sectionTitle, widget.part.section!, context),
        widget.part.reasonForMarkingBad == null
            ? Container()
            : textCard('Deleted', widget.part.reasonForMarkingBad!, context),

        widget.part.addedBy == null
            ? Container()
            : textCard('Added By', widget.part.addedBy!, context),

        widget.part.dateAdded == null
            ? Container()
            : textCard(
                'Date Added',
                DateTime.fromMillisecondsSinceEpoch(widget.part.dateAdded!)
                    .toString(),
                context),

        widget.part.lastEditedBy == null
            ? Container()
            : textCard('Last Edited By', widget.part.lastEditedBy!, context),

        widget.part.searchKeywords == null
            ? Container()
            : textCard('Tags', widget.part.searchKeywords!.toString(), context),

        widget.part.markedBadByUid == null
            ? Card(
                color: widget.part.isExhausted
                    ? Colors.orange
                    : Theme.of(context).primaryColor,
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'THIS PART HAVE BEEN EXHAUSTED',
                          softWrap: true,
                          // style: Theme.of(context)
                          //     .textTheme
                          //     .bodyText1
                          //     ?.copyWith(color: Colors.white),
                        ),
                      ),
                      BlocBuilder<MarkexhaustedpartCubit,
                          MarkexhaustedpartState>(
                        builder: (context, state) {
                          return state == MarkexhaustedpartState.loading
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : Switch(
                                  value: widget.part.isExhausted,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.part.isExhausted = newValue;
                                    });
                                    context
                                        .read<MarkexhaustedpartCubit>()
                                        .makrExhausted(
                                            data: newValue, part: widget.part);
                                  });
                        },
                      )
                    ],
                  ),
                ),
              )
            : Container(),

        widget.part.markedBadByUid == null
            ? BlocBuilder<UserManagerCubit, UserManagerState>(
                builder: (context, state) {
                if (state is UserLoadedState &&
                    state.userData.accessLevel >=
                        number_constants.minimumAccessLevelForPartEdit) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<EditItemCubit>().jumpEdit(widget.part);
                          Navigator.of(context)
                              .popAndPushNamed(AddItemPage.routName);
                        },
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                      ),

                      //only display this delete icon
                      //if the file have not been marked for delete.
                      BlocBuilder<MarkpartCubit, MarkpartState>(
                        builder: (context, markState) {
                          if (markState == MarkpartState.idle) {
                            return IconButton(
                              onPressed: () {
                                //Todo marked bad
                                SignupFormDialog.formDialog(
                                  context: context,
                                  onSubmit: (value) {
                                    var userInfo =
                                        context.read<UserManagerCubit>().state;
                                    if (userInfo is UserLoadedState) {
                                      context.read<MarkpartCubit>().markBad(
                                          part: widget.part,
                                          reason: value,
                                          userId: userInfo.userData.userId!);
                                    }
                                  },
                                  title: 'State reason for Deleting this part',
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                              tooltip: 'Delete',
                            );
                          } else {
                            // indicate loading if mark bad delete button has been peressed.
                            if (markState == MarkpartState.loading) {
                              return const SizedBox(
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
                        number_constants.minimunAccessLevelForDeletingPart) {
                  return BlocConsumer<PartuploadwizardBloc,
                      PartuploadwizardState>(
                    listener: (context, state) {
                      Navigator.of(context).pop();
                      if (state is PartuploadwizardErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blue,
                            duration: const Duration(
                                seconds: number_constants.errorSnackBarDelay),
                            content: Text(
                                'Delete not successful:\n${state.message}'),
                          ),
                        );
                      }
                    },
                    builder: (context, partState) {
                      return partState is PartuploadwizardLoadingState
                          ? const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator())
                          : IconButton(
                              onPressed: () {
                                context.read<PartuploadwizardBloc>().add(
                                    DeletePartEvent(
                                        partId: widget.part.partUid!));
                              },
                              icon: const Icon(
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
              }),
        Container(
          height: 40,
        )
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
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          children: [
            Text(
              '$field: ',
              style: Theme.of(context).textTheme.titleMedium,
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
