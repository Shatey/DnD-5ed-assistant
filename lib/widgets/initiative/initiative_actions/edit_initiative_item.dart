import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/utils/characteristics_checker.dart';

class EditInitiativeItem extends StatefulWidget {
  const EditInitiativeItem({
    super.key,
    required this.mob,
    // required this.editHP,
    // required this.editMaxHP,
    // required this.editName,
    // required this.editKD,
    // required this.editInitiative,
  });

  final InitiativeItemModel mob;
  // final void Function(int newHp) editHP;
  // final void Function(int newHp) editMaxHP;
  // final void Function(String name) editName;
  // final void Function(int newKd) editKD;
  // final void Function(int newInitiative) editInitiative;

  @override
  State<EditInitiativeItem> createState() {
    return _EditInitiativeItemState();
  }
}

class _EditInitiativeItemState extends State<EditInitiativeItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _kdController = TextEditingController();
  final TextEditingController _initiativeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _hpController.dispose();
    _kdController.dispose();
    _initiativeController.dispose();
    super.dispose();
  }

  void _showDialog(String title, String content) {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _editName() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      _showDialog('Имя не указано', 'Введите Имя');
      return;
    }
    setState(() {
      // widget.editName(newName);
      widget.mob.name = newName;
    });
  }

  void _editMaxHP() {
    final newHP = int.tryParse(_hpController.text);
    if (newHP == 0 || newHP == null) {
      _showDialog('ХП не указано', 'Введите ХП');
      return;
    }
    setState(() {
      // widget.editMaxHP(newHP);
      widget.mob.maxHp =
          CharacteristicsChecker.getValidCharacteristicValue(newHP);
    });
  }

  void _editCurrentHP() {
    final newHP = int.tryParse(_hpController.text);
    if (newHP == 0 || newHP == null) {
      _showDialog('ХП не указано', 'Введите ХП');
      return;
    }
    setState(() {
      // widget.editHP(newHP);
      widget.mob.currentHp =
          CharacteristicsChecker.getValidCharacteristicValue(newHP);
    });
  }

  void _damage() {
    final damage = int.tryParse(_hpController.text);
    if (damage == 0 || damage == null) {
      _showDialog('Урон не указан', 'Введите урон');
      return;
    }
    setState(() {
      // widget.editHP(widget.mob.currentHp! - damage);
      widget.mob.currentHp = CharacteristicsChecker.getValidCharacteristicValue(
          widget.mob.currentHp! - damage);
    });
  }

  void _heal() {
    final heal = int.tryParse(_hpController.text);
    if (heal == 0 || heal == null) {
      _showDialog('Исцеление не указано', 'Введите исцеление');
      return;
    }
    setState(() {
      // widget.editHP(widget.mob.currentHp! + heal);
      widget.mob.currentHp = CharacteristicsChecker.getValidCharacteristicValue(
          widget.mob.currentHp! + heal);
    });
  }

  void _editKD() {
    final newKD = int.tryParse(_kdController.text);
    if (newKD == 0 || newKD == null) {
      _showDialog('КД не указано', 'Введите КД');
      return;
    }
    setState(() {
      // widget.editKD(newKD);
      widget.mob.kd = CharacteristicsChecker.getValidCharacteristicValue(newKD);
    });
  }

  void _editInitiative() {
    final newInitiative = int.tryParse(_initiativeController.text);
    if (newInitiative == 0 || newInitiative == null) {
      _showDialog('Инициатива не указана', 'Введите инициативу');
      return;
    }
    setState(() {
      // widget.editInitiative(newInitiative);
      widget.mob.initiative =
          CharacteristicsChecker.getValidCharacteristicValue(newInitiative);
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constrains) {
      return SizedBox(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Text(
                      widget.mob.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          'ХП: ${widget.mob.currentHp}/${widget.mob.maxHp}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        Text(
                          'КД: ${widget.mob.kd}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        Text(
                          'Инициатива: ${widget.mob.initiative}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _hpController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                labelText: 'ХП',
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: _damage,
                                  child: const Text('Урон'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: _heal,
                                  child: const Text('Исцеление'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: _editCurrentHP,
                                  child: const Text('Изменить ХП'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: _editMaxHP,
                                  child: const Text('Изменить макс. ХП'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _initiativeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Инициатива',
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: _editInitiative,
                              child: const Text('Изменить инициативу'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _kdController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                labelText: 'КД',
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: _editKD,
                              child: const Text('Изменить КД'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                labelText: 'Имя',
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: _editName,
                              child: const Text('Изменить имя'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Добавить статус'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Убрать статус'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
