import 'package:flutter/material.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/widgets/initiative/initiative_actions/edit_initiative_item.dart';

/// Card that represents one combat participant in the initiative order.
class InitiativeItem extends StatefulWidget {
  /// Creates a participant card.
  const InitiativeItem({
    super.key,
    required this.mob,
    required this.sort,
  });

  /// Participant displayed by this card.
  final InitiativeItemModel mob;

  /// Callback used to re-apply turn order after the participant changes.
  final void Function() sort;

  @override
  State<InitiativeItem> createState() => _InitiativeItemState();
}

class _InitiativeItemState extends State<InitiativeItem> {
  void _openInitiativeItemOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditInitiativeItem(mob: widget.mob),
    ).then((value) => widget.sort());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hpRatio = widget.mob.maxHp <= 0
        ? 0.0
        : (widget.mob.currentHp / widget.mob.maxHp).clamp(0.0, 1.0);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openInitiativeItemOverlay,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: widget.mob.hasActed,
                    onChanged: (bool? newValue) {
                      widget.mob.hasActed = newValue ?? !widget.mob.hasActed;
                      widget.sort();
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.mob.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Редактировать',
                    onPressed: _openInitiativeItemOverlay,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: hpRatio,
                  minHeight: 8,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatChip(
                    icon: Icons.favorite_outline,
                    label: 'HP ${widget.mob.currentHp}/${widget.mob.maxHp}',
                  ),
                  _StatChip(
                    icon: Icons.shield_outlined,
                    label: 'AC ${widget.mob.kd}',
                  ),
                  _StatChip(
                    icon: Icons.bolt_outlined,
                    label: 'INIT ${widget.mob.initiative}',
                  ),
                  if (widget.mob.statuses.isNotEmpty)
                    _StatChip(
                      icon: Icons.auto_awesome_outlined,
                      label: '${widget.mob.statuses.length} стат.',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
