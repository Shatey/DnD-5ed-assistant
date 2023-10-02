import 'package:flutter/material.dart';
import 'package:initiative_support/widgets/initiative/initiative_list/initiative_item.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';

class InitiativeList extends StatelessWidget {
  const InitiativeList(
      {super.key,
      required this.initiativeItems,
      required this.onRemoveInitiativeItem,
      required this.sort});

  final List<InitiativeItemModel> initiativeItems;
  final void Function(InitiativeItemModel initiativeItem)
      onRemoveInitiativeItem;
  final void Function() sort;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Card(
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: initiativeItems[0].statuses.isNotEmpty
                    ? Text(
                        '${initiativeItems[0].name} ${initiativeItems[0].statuses.entries.map((entry) => '${entry.key}: ${entry.value < 0 ? 'до отмены' : entry.value}').join(', ')}')
                    : Text('${initiativeItems[0].name} Нет статусов'),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: initiativeItems.length,
                  itemBuilder: (ctx, index) => Dismissible(
                    key: ValueKey(initiativeItems[index]),
                    onDismissed: (direction) {
                      onRemoveInitiativeItem(initiativeItems[index]);
                    },
                    child:
                        InitiativeItem(mob: initiativeItems[index], sort: sort),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
