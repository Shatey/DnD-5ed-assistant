import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';

/// Form used to add a new participant to the initiative tracker.
class NewInitiativeItem extends StatefulWidget {
  /// Creates a form with a save callback.
  const NewInitiativeItem({super.key, required this.save});

  /// Called when the form creates a valid initiative item.
  final void Function(InitiativeItemModel) save;

  @override
  State<NewInitiativeItem> createState() => _NewInitiativeItemState();
}

class _NewInitiativeItemState extends State<NewInitiativeItem> {
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

  void _submitInitiativeItemData() {
    final name = _nameController.text.trim();
    final hp = int.tryParse(_hpController.text);
    final armorClass = int.tryParse(_armorClassController.text);
    final initiative = int.tryParse(_initiativeController.text) ?? 0;

    if (name.isEmpty || hp == null || armorClass == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Некорректные данные!'),
          content: const Text('Имя, HP и AC обязательно должны быть указаны.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ок'),
            ),
          ],
        ),
      );
      return;
    }

    widget.save(
      InitiativeItemModel(
        name: name,
        maxHp: hp,
        initiative: initiative,
        armorClass: armorClass,
        statuses: {},
        monsterId: -1,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(labelText: 'Имя'),
          ),
          TextField(
            controller: _hpController,
            decoration: const InputDecoration(labelText: 'HP'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            controller: _armorClassController,
            decoration: const InputDecoration(labelText: 'AC'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            controller: _initiativeController,
            decoration: const InputDecoration(labelText: 'Инициатива'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
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
}
