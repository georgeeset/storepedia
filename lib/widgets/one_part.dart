import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/screens/part_detail_page/part_detail_page.dart';

class OnePart extends StatelessWidget {
  const OnePart({required this.part, Key? key}) : super(key: key);
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
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: part.photo == null
                      ? Icon(
                          Icons.error,
                          size: 50,
                        )
                      : Hero(
                          tag: part.photo!,
                          child: CachedNetworkImage(
                              imageUrl: part.photo!,
                              fit: BoxFit.cover,
                              placeholder: (context, data) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/bin.jpg'),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(),
                                    )
                                  ],
                                );
                              })),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Column(
                    children: [
                      part.partName == null
                          ? Text('No Part name')
                          : Text(
                              part.partName!,
                              softWrap: true,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      part.partDescription == null
                          ? Text('No Description')
                          : Text(
                              part.partDescription!,
                              softWrap: true,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                      part.storeLocation == null
                          ? Container()
                          : Text(
                              part.storeLocation!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ],
                  ))
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            PartDetailPage.routeName,
            arguments: part,
          );
        },
      ),
    );
  }
}
