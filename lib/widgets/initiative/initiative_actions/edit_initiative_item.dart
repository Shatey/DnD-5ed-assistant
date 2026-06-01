import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/services/initiativeDB.dart';
import 'package:initiative_support/utils/characteristics_checker.dart';

/// Bottom-sheet form used to edit a combat participant.
class EditInitiativeItem extends ConsumerStatefulWidget {
  /// Creates an editor for [mob].
  const EditInitiativeItem({
    super.key,
    required this.mob,
  });

  /// Participant being edited.
  final InitiativeItemModel mob;

  @override
  ConsumerState<EditInitiativeItem> createState() => _EditInitiativeItemState();
}

class _EditInitiativeItemState extends ConsumerState<EditInitiativeItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _armorClassController = TextEditingController();
  final TextEditingController _initiativeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _hpController.dispose();
    _armorClassController.dispose();
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
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _persistChanges() {
    ref.read(initiativeProvider.notifier).updateInitiativeItem(widget.mob);
  }

  void _editName() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      _showDialog('Имя не указано', 'Введите имя');
      return;
    }

    setState(() {
      widget.mob.name = newName;
      _persistChanges();
    });
  }

  void _editMaxHP() {
    final newHP = int.tryParse(_hpController.text);
    if (newHP == 0 || newHP == null) {
      _showDialog('HP не указано', 'Введите HP');
      return;
    }

    setState(() {
      widget.mob.maxHp = CharacteristicsChecker.getValidCharacteristicValue(newHP);
      _persistChanges();
    });
  }

  void _editCurrentHP() {
    final newHP = int.tryParse(_hpController.text);
    if (newHP == 0 || newHP == null) {
      _showDialog('HP не указано', 'Введите HP');
      return;
    }

    setState(() {
      widget.mob.currentHp = CharacteristicsChecker.getValidCharacteristicValue(newHP);
      _persistChanges();
    });
  }

  void _damage() {
    final damage = int.tryParse(_hpController.text);
    if (damage == 0 || damage == null) {
      _showDialog('Урон не указан', 'Введите урон');
      return;
    }

    setState(() {
      widget.mob.currentHp = CharacteristicsChecker.getValidCharacteristicValue(
        widget.mob.currentHp - damage,
      );
      _persistChanges();
    });
  }

  void _heal() {
    final heal = int.tryParse(_hpController.text);
    if (heal == 0 || heal == null) {
      _showDialog('Исцеление не указано', 'Введите исцеление');
      return;
    }

    setState(() {
      widget.mob.currentHp = CharacteristicsChecker.getValidCharacteristicValue(
        widget.mob.currentHp + heal,
      );
      _persistChanges();
    });
  }

  void _editArmorClass() {
    final newArmorClass = int.tryParse(_armorClassController.text);
    if (newArmorClass == 0 || newArmorClass == null) {
      _showDialog('AC не указан', 'Введите AC');
      return;
    }

    setState(() {
      widget.mob.armorClass = CharacteristicsChecker.getValidCharacteristicValue(
        newArmorClass,
      );
      _persistChanges();
    });
  }

  void _editInitiative() {
    final newInitiative = int.tryParse(_initiativeController.text);
    if (newInitiative == 0 || newInitiative == null) {
      _showDialog('Инициатива не указана', 'Введите инициативу');
      return;
    }

    setState(() {
      widget.mob.initiative = CharacteristicsChecker.getValidCharacteristicValue(
        newInitiative,
      );
      _persistChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, constrains) {
        return SizedBox(
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          widget.mob.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'HP: ${widget.mob.currentHp}/${widget.mob.maxHp}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'AC: ${widget.mob.armorClass}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'Инициатива: ${widget.mob.initiative}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'HP',
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
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _heal,
                                    child: const Text('Исцеление'),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _editCurrentHP,
                                    child: const Text('Изменить HP'),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _editMaxHP,
                                    child: const Text('Изменить макс. HP'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _initiativeController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _armorClassController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'AC',
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: _editArmorClass,
                                child: const Text('Изменить AC'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Добавить статус'),
                        ),
                        const SizedBox(height: 20),
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
      },
    );
  }
}
