import 'package:election_exit_poll_620710115/pages/candidates_page.dart';
import 'package:election_exit_poll_620710115/pages/candidates_result.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: CandidatesPage(),
      routes: {
        CandidatesPage.routeName: (context) => const CandidatesPage(),
        CandidatesResult.routeName: (context) => const CandidatesResult(),
      },
      initialRoute: CandidatesPage.routeName,
    );
  }
}