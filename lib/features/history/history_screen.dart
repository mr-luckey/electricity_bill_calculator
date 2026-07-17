import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/disco_info.dart';
import '../../core/providers/app_providers.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/calculation_record.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/banner_ad_widget.dart';
import '../../shared/widgets/disco_logo.dart';
import '../../shared/widgets/main_shell.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _categoryLabel(BuildContext context, ConsumerCategory category) {
    final l10n = context.l10n;
    return category == ConsumerCategory.protected
        ? l10n.protected
        : l10n.unprotected;
  }

  Future<void> _openRecord(
    BuildContext context,
    WidgetRef ref,
    CalculationRecord record,
  ) async {
    await ref.read(billSessionProvider.notifier).restoreFromRecord(record);
    if (!context.mounted) return;
    context.push('/result');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final records = ref.watch(calculationHistoryProvider);
    final lastRecord = records.isEmpty ? null : records.first;

    return MainShell(
      currentIndex: 1,
      body: Column(
        children: [
          Expanded(
            child: lastRecord == null
                ? _EmptyHistoryState(l10n: l10n, theme: theme, scheme: scheme)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    children: [
                      Text(
                        l10n.lastCalculation,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _LastCalculationCard(
                        record: lastRecord,
                        categoryLabel: _categoryLabel(
                          context,
                          lastRecord.category,
                        ),
                        onTap: () => _openRecord(context, ref, lastRecord),
                      ),
                      if (records.length > 1) ...[
                        const SizedBox(height: 24),
                        Text(
                          l10n.recentCalculations,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...records.skip(1).map(
                          (record) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _HistoryListTile(
                              record: record,
                              categoryLabel: _categoryLabel(
                                context,
                                record.category,
                              ),
                              isDark: isDark,
                              onTap: () => _openRecord(context, ref, record),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState({
    required this.l10n,
    required this.theme,
    required this.scheme,
  });

  final AppLocalizations l10n;
  final ThemeData theme;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 36,
                color: scheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.noCalculationHistory,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noCalculationHistorySubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastCalculationCard extends StatelessWidget {
  const _LastCalculationCard({
    required this.record,
    required this.categoryLabel,
    required this.onTap,
  });

  final CalculationRecord record;
  final String categoryLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final disco = DiscoInfo.byId(record.disco);
    final dateLabel = DateFormat('d MMM yyyy, h:mm a').format(
      record.calculatedAt,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary.withValues(alpha: isDark ? 0.22 : 0.12),
                scheme.primary.withValues(alpha: isDark ? 0.10 : 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (disco != null)
                    DiscoLogo(disco: disco, size: 48, selected: true)
                  else
                    CircleAvatar(
                      backgroundColor: scheme.primary.withValues(alpha: 0.15),
                      child: Icon(Icons.electrical_services_rounded,
                          color: scheme.primary),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.disco,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          categoryLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: scheme.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      label: context.l10n.units,
                      value: '${record.units} kWh',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoChip(
                      label: context.l10n.pkr,
                      value: CurrencyFormatter.format(record.total),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.calculatedOn(dateLabel),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryListTile extends StatelessWidget {
  const _HistoryListTile({
    required this.record,
    required this.categoryLabel,
    required this.isDark,
    required this.onTap,
  });

  final CalculationRecord record;
  final String categoryLabel;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final disco = DiscoInfo.byId(record.disco);
    final dateLabel = DateFormat('d MMM, h:mm a').format(record.calculatedAt);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1D24) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              if (disco != null)
                DiscoLogo(disco: disco, size: 40)
              else
                CircleAvatar(
                  radius: 20,
                  backgroundColor: scheme.primary.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.electrical_services_rounded,
                    size: 18,
                    color: scheme.primary,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${record.disco} • $categoryLabel',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${record.units} kWh • PKR ${CurrencyFormatter.format(record.total)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                dateLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.45),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
