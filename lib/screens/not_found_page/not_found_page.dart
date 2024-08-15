import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storepedia/screens/home_page/home_page.dart';
import 'package:storepedia/widgets/page_layout.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: Text(
        'Store Pedia',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Colors.white),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/spider_on_bin.png'),
              const SizedBox(
                height: 15,
              ),
              const Text('Page Not Found !!!',
                  style: TextStyle(fontSize: 20.0)),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () => context.pushReplacement(HomePage.routeName),
                child: const Text(
                  'Return Home',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
