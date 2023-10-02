import 'package:flutter/material.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/widgets/initiative/initiative_actions/edit_initiative_item.dart';

class InitiativeItem extends StatefulWidget {
  const InitiativeItem({super.key, required this.mob, required this.sort});

  final InitiativeItemModel mob;
  final void Function() sort;

  @override
  State<InitiativeItem> createState() {
    return _InitiativeItemState();
  }
}

class _InitiativeItemState extends State<InitiativeItem> {
  void _openInitiativeItemOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditInitiativeItem(
        mob: widget.mob,
      ),
    ).then((value) => widget.sort());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Checkbox(
                  value: widget.mob.hasActed,
                  onChanged: (bool? newValue) {
                    // setState(
                    //   () {
                    widget.mob.hasActed = !widget.mob.hasActed;
                    //   },
                    // );
                    widget.sort();
                  }),
            ),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: _openInitiativeItemOverlay,
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
