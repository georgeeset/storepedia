import 'package:flutter/material.dart';
import 'package:storepedia/widgets/input_editor.dart';

class FormListItem extends StatelessWidget {
  const FormListItem({
    super.key,
    required this.sizeData,
    this.fieldValue,
    required this.title,
    required this.info,
    required this.onSubmit,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputType,
    this.initialValue,
    this.noSpace = false,
  });

  final Size sizeData;
  final String title;
  final String info;
  final String? fieldValue;
  final Function onSubmit;
  final TextInputType? textInputType;
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final bool noSpace;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 3.0,
      shadowColor: Colors.blue,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    //width: sizeData.width / 2,
                    child: Text(
                      info,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.black54),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  SignupFormDialog.formDialog(
                    context: context,
                    onSubmit: onSubmit,
                    title: title,
                    initialValue: fieldValue,
                    textCapitalization: textCapitalization,
                    noSpace: noSpace,
                  );
                },
                child: Container(
                  color: Colors.red[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          fieldValue ?? '<Empty>',
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
