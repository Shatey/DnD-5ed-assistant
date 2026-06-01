import 'package:flutter/material.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/widgets/initiative/initiative_list/initiative_item.dart';

/// Scrollable initiative order with a highlighted current turn summary.
class InitiativeList extends StatelessWidget {
  /// Creates an initiative list.
  const InitiativeList({
    super.key,
    required this.initiativeItems,
    required this.onRemoveInitiativeItem,
    required this.sort,
  });

  /// Participants in current initiative order.
  final List<InitiativeItemModel> initiativeItems;

  /// Called when an item is dismissed from the list.
  final void Function(InitiativeItemModel initiativeItem) onRemoveInitiativeItem;

  /// Re-applies initiative ordering after a participant changes.
  final void Function() sort;

  @override
  Widget build(BuildContext context) {
    final activeItem = initiativeItems.first;

    return Column(
      children: [
        _CurrentTurnCard(item: activeItem),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: initiativeItems.length,
            itemBuilder: (ctx, index) {
              final item = initiativeItems[index];

              return Dismissible(
                key: ValueKey('${item.id}-${item.name}-${item.initiative}'),
                background: const _DismissBackground(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => onRemoveInitiativeItem(item),
                child: InitiativeItem(mob: item, sort: sort),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CurrentTurnCard extends StatelessWidget {
  const _CurrentTurnCard({required this.item});

  final InitiativeItemModel item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Текущий ход',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (item.statuses.isEmpty)
              Text(
                'Нет активных статусов',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.75),
                    ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.statuses.entries
                    .map((entry) => _StatusChip(
                          name: entry.key,
                          duration: entry.value,
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.name,
    required this.duration,
  });

  final String name;
  final int duration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final durationLabel = duration < 0 ? 'до отмены' : '$duration р.';

    return Chip(
      avatar: const Icon(Icons.brightness_5_outlined, size: 16),
      label: Text('$name · $durationLabel'),
      backgroundColor: colorScheme.surface.withOpacity(0.8),
      side: BorderSide.none,
      labelStyle: TextStyle(color: colorScheme.onSurface),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        Icons.delete_outline,
        color: colorScheme.onErrorContainer,
      ),
    );
  }
}
