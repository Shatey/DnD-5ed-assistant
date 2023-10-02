import 'package:flutter/material.dart';

class StatusesScreen extends StatefulWidget {
  const StatusesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatusesState();
  }
}

class _StatusesState extends State<StatusesScreen> {
  final List<String> _statuses = [
    'БЕССОЗНАТЕЛЬНЫЙ',
    'ИСПУГАННЫЙ',
    'ИСТОЩЁННЫЙ',
    'НЕВИДИМЫЙ',
    'НЕДЕЕСПОСОБНЫЙ',
    'ОГЛОХШИЙ',
    'ОКАМЕНЕВШИЙ',
    'ОПУТАННЫЙ',
    'ОСЛЕПЛЁННЫЙ',
    'ОТРАВЛЕННЫЙ',
    'ОЧАРОВАННЫЙ',
    'ОШЕЛОМЛЁННЫЙ',
    'ПАРАЛИЗОВАННЫЙ',
    'СБИТЫЙ С НОГ / ЛЕЖАЩИЙ НИЧКОМ',
    'СХВАЧЕННЫЙ',
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = _statuses
        .map(
          (status) => Center(
            child: Card(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(status),
                ),
              ),
            ),
          ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статусы'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }
}
