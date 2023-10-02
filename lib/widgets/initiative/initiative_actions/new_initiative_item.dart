import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';

class NewInitiativeItem extends StatefulWidget {
  const NewInitiativeItem({super.key, required this.save});

  final void Function(InitiativeItemModel) save;

  @override
  State<NewInitiativeItem> createState() {
    return _NewInitiativeItemState();
  }
}

class _NewInitiativeItemState extends State<NewInitiativeItem> {
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

  void _submitInitiativeItemData() {
    // Получение значений полей
    String name = _nameController.text;
    final hp = int.tryParse(_hpController.text);
    final kd = int.tryParse(_kdController.text);
    int initiative = int.tryParse(_initiativeController.text) ?? 0;
    if (name.trim().isEmpty || hp == null || kd == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            title: const Text('Некорректные данные!'),
            content:
                const Text('Имя, хп и кд обязательно должны быть указаны.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ок'),
              )
            ]),
      );
      return;
    }
    // Действия с полученными значениями
    widget.save(InitiativeItemModel(
      name: name,
      maxHp: hp,
      initiative: initiative,
      kd: kd,
      statuses: {},
    ));
    // Закрытие поп-апа
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: 'Имя',
            ),
          ),
          TextField(
            controller: _hpController,
            decoration: const InputDecoration(
              labelText: 'ХП',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            controller: _kdController,
            decoration: const InputDecoration(
              labelText: 'КД',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            controller: _initiativeController,
            decoration: const InputDecoration(
              labelText: 'Инициатива',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                onPressed: _submitInitiativeItemData,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return TextButton(
  //     onPressed: () => showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         title: const Text('Новый монстр/герой'),
  //         content: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: nameController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Имя',
  //               ),
  //               keyboardType: TextInputType.name,
  //             ),
  //             TextField(
  //               controller: hpController,
  //               decoration: const InputDecoration(
  //                 labelText: 'ХП',
  //               ),
  //               keyboardType: TextInputType.number,
  //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             ),
  //             TextField(
  //               controller: kdController,
  //               decoration: const InputDecoration(
  //                 labelText: 'КД',
  //               ),
  //               keyboardType: TextInputType.number,
  //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             ),
  //             TextField(
  //               controller: initiativeController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Инициатива',
  //               ),
  //               keyboardType: TextInputType.number,
  //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text('Отмена'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           ElevatedButton(
  //             child: const Text('Сохранить'),
  //             onPressed: () {
  //               // Получение значений полей
  //               String name = nameController.text;
  //               int hp = int.tryParse(hpController.text) ?? 0;
  //               int kd = int.tryParse(kdController.text) ?? 0;
  //               int initiative = int.tryParse(initiativeController.text) ?? 0;
  //               // Действия с полученными значениями
  //               widget.save(InitiativeItemModel(
  //                 name: name,
  //                 hp: hp,
  //                 initiative: initiative,
  //                 kd: kd,
  //               ));
  //               // Закрытие поп-апа
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //     child: const Text('Добавить монстра/героя'),
  //   );
  // }
}
