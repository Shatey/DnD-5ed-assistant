import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditInitiativeItemDialog extends StatelessWidget {
  EditInitiativeItemDialog(
      {super.key, required this.text, required this.editValue});

  final TextEditingController controller = TextEditingController();
  final String text;
  final Function(String newValue) editValue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Изменить $text'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Введите значение',
            ),
            keyboardType: text == 'Имя' || text == 'Name'
                ? TextInputType.name
                : TextInputType.number,
            inputFormatters: [
              if (text != 'Имя' && text != 'Name')
                FilteringTextInputFormatter.digitsOnly
            ],
          ),
          // if (text != 'Имя' && text != 'Name')
          //   Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //       ...['Сохранить', 'Урон', 'Исцеление'].map(
          //         (buttonText) => ElevatedButton(
          //           child: Text(buttonText),
          //           onPressed: () {
          //             var hp = int.parse(controller.text);
          //             if (buttonText == 'Урон' || buttonText == 'Damage') {
          //             } else {}
          //             editValue(controller.text);
          //             Navigator.of(context).pop();
          //           },
          //           style: ElevatedButton.styleFrom(),
          //         ),
          //       )
          //     ],
          //   ),
        ],
      ),
      actions: [
        // if (text == 'Имя' || text == 'Name')
        ElevatedButton(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // if (text == 'Имя' || text == 'Name')
        ElevatedButton(
          child: const Text('Сохранить'),
          onPressed: () {
            // Действия с полученными значениями
            // ...
            editValue(controller.text);
            // Закрытие поп-апа
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
