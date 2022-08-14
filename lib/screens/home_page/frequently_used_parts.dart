import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;
import 'package:flutter/material.dart';
import 'package:store_pedia/cubit/query_common_items_cubit/query_common_items_cubit.dart';
import 'package:store_pedia/widgets/frequently_used_search_result.dart';
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

import '../../cubit/department_selector_cubit/department_selector_cubit.dart';

class FrequentlyUsedParts extends StatelessWidget {
  const FrequentlyUsedParts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size pageSize = MediaQuery.of(context).size;
    return Builder(
      builder: (context) {
        return Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0.0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 200,
                  height: 100,
                  child: BlocConsumer<DepartmentSelectorCubit, String>(
                    listener: (context, state) {
                      context
                          .read<QueryCommonItemsCubit>()
                          .getCommonItems(state);
                    },
                    builder: (context, department) {
                      return DropdownButton(
                        isExpanded: true,
                        value: department, //changed when tapped
                        elevation: 3,
                        hint: Text(
                          'Select Department',
                        ),
                        items:
                            StringConstants.sectionList.map((String machine) {
                          return DropdownMenuItem<String>(
                            child: Text(
                              machine,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            value: machine,
                          );
                        }).toList(),

                        onChanged: (newValue) {
                          context
                              .read<DepartmentSelectorCubit>()
                              .changeDepartment(department: newValue);
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: NumberConstants.dropdownMenuHeight,
                // bottom: 0,
                child: Container(
                    height: pageSize.height -
                        NumberConstants.dropdownMenuHeight -
                        160,
                    width: pageSize.width,
                    child: FrequentlyUsedSearchResult()),
              )
            ],
          ),
        );
      },
    );
  }
}
