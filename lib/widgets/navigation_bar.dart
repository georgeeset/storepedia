import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/cubit/tab_controller_cubit/tab_controller_cubit.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabControllerCubit, int>(
      builder: (context, state) {
        return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fast_forward_outlined),
                label: 'Frequently Used',
              ),
            ],
            currentIndex: state,
            // selectedItemColor: Colors.amber[800],
            onTap: (selectedIndex) => context
                .read<TabControllerCubit>()
                .changeTab(tabNumber: selectedIndex));
      },
    );
  }
}
