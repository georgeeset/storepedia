import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:storepedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';

import 'package:storepedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:storepedia/cubit/mark_bad_part/cubit/mark_bad_part_cubit.dart';
import 'package:storepedia/cubit/mark_exhausted_part_cubit/cubit/markexhaustedpart_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/firestore_operaions.dart';
import 'package:storepedia/screens/add_item_page/add_item_page.dart';
import 'package:storepedia/widgets/conditional_image.dart';
import 'package:storepedia/widgets/input_editor.dart';
import 'package:storepedia/widgets/online_pinch_zoom.dart';
import 'package:storepedia/widgets/page_layout.dart';
import 'package:storepedia/constants/string_constants.dart' as string_constants;
import 'package:storepedia/constants/number_constants.dart' as number_constants;

import '../../bloc/authentication_bloc/bloc/authentication_bloc.dart';
import '../../bloc/signin_option_bloc/bloc/signinoption_bloc.dart';
import '../signin_screen/signin_screen.dart';

class PartDetailPage extends StatelessWidget {
  static String routeName = '/part-detail/:companyName/:partId';
  static String name = 'detail';
  const PartDetailPage({
    this.part,
    required this.partId,
    required this.companyName,
    super.key,
  });
  final Part? part;
  final String partId;
  final String companyName;

  @override
  Widget build(BuildContext context) {
    // final part = ModalRoute.of(context)?.settings.arguments as Part;
    final FirestoreOperations firestoreOperations = FirestoreOperations();
    return part == null
        ? BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticatedState) {
                return FutureBuilder(
                    future: firestoreOperations.getPart(partId, companyName),
                    builder: (context, result) {
                      if (result.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (result.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${result.error}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      } else {
                        final part = result.data;
                        return PageLayout(
                          body: PartBody(part: part!),
                          title: partTitle(context, result.data!.partName!),
                          hasBackButton: true,
                        );
                      }
                    });
              }
              return MultiBlocProvider(
                providers: [
                  BlocProvider<SigninoptionBloc>(
                    create: (context) => SigninoptionBloc(),
                  ),
                ],
                child: const SigninScreen(),
              );
            },
          )
        : PageLayout(
            body: PartBody(
              part: part!,
            ),
            title: partTitle(context, part!.partName!),
            hasBackButton: true,
          );
  }

  Widget partTitle(context, String titleString) {
    return Text(
      titleString,
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
      textAlign: TextAlign.center,
      softWrap: true,
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
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth > number_constants.maxMobileView) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: constraint.maxWidth / 2,
              margin: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                  child: ConditionalImage(
                    imageUrl: widget.part.photo!,
                  ),
                  onTap: () {
                    context.push('/photo_view', extra: widget.part.photo);
                  }),
            ),
            Container(
                width: constraint.maxWidth / 2,
                padding: const EdgeInsets.only(left: 10.0),
                child: listItems(context, showFirstItem: false)),
          ],
        );
      } else {
        return listItems(context);
      }
    });
  }

  ListView listItems(BuildContext context, {bool showFirstItem = true}) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        showFirstItem
            ? OnlinePinchZoomImage(link: widget.part.photo)
            : const SizedBox(),
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
                string_constants.sectionTitle,
                widget.part.section!,
                context,
              ),
        textCard(
          string_constants.company,
          widget.part.company ?? 'None',
          context,
        ),
        textCard(
          string_constants.branch,
          widget.part.branch ?? 'None',
          context,
        ),
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
                          var myStatus = context.read<UserManagerCubit>().state;
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
                                    var userInfo =
                                        context.read<UserManagerCubit>().state;

                                    // only users with same company name can update this data
                                    if (userInfo is! UserLoadedState ||
                                        userInfo.userData.company !=
                                            widget.part.company) {
                                      return;
                                    }
                                    setState(() {
                                      widget.part.isExhausted = newValue;
                                    });
                                    context
                                        .read<MarkexhaustedpartCubit>()
                                        .makrExhausted(
                                            data: newValue,
                                            part: widget.part,
                                            companyName: myStatus
                                                    is UserLoadedState
                                                ? myStatus.userData.company ??
                                                    'Unknown'
                                                : 'Unknown');
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
                          context.pushNamed(AddItemPage.name);
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
                                    if (userInfo is UserLoadedState &&
                                        userInfo.userData.company ==
                                            widget.part.company &&
                                        userInfo.userData.accessLevel >
                                            number_constants
                                                .minimumDeleteLevel) {
                                      context.read<MarkpartCubit>().markBad(
                                          part: widget.part,
                                          reason: value,
                                          userId: userInfo.userData.userId!,
                                          companyName:
                                              userInfo.userData.company ??
                                                  'Umknown');
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
                      context.pop();
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
                                        partId: widget.part.partUid!,
                                        companyName: widget.part.company ??
                                            string_constants.partsCollection));
                              },
                              icon: const Icon(
                                Icons.delete_forever,
                                size: 40,
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
