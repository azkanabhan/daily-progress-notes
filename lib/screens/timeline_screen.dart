import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/reflection_entry.dart';
import '../providers/reflection_provider.dart';
import '../screens/reflection_entry_screen.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  String _filterType = 'all'; // all, week, month
  DateTime _filterDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReflectionProvider>(context, listen: false).loadEntries();
    });
  }

  List<ReflectionEntry> _getFilteredEntries(List<ReflectionEntry> entries) {
    switch (_filterType) {
      case 'week':
        final weekStart = _filterDate.subtract(
          Duration(days: _filterDate.weekday - 1),
        );
        return entries.where((entry) {
          return entry.createdAt.isAfter(
                weekStart.subtract(const Duration(days: 1)),
              ) &&
              entry.createdAt.isBefore(
                weekStart.add(const Duration(days: 7)),
              );
        }).toList();
      case 'month':
        return entries.where((entry) {
          return entry.createdAt.year == _filterDate.year &&
              entry.createdAt.month == _filterDate.month;
        }).toList();
      default:
        return entries;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _filterDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Refleksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildFilterSheet(),
              );
            },
          ),
        ],
      ),
      body: Consumer<ReflectionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = _getFilteredEntries(provider.entries);

          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada refleksi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai tulis refleksi harianmu',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadEntries(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _buildEntryCard(context, entry);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReflectionEntryScreen(),
            ),
          );
          if (result == true) {
            Provider.of<ReflectionProvider>(context, listen: false)
                .loadEntries();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tulis Refleksi'),
      ),
    );
  }

  Widget _buildFilterSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Filter Timeline',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          RadioListTile<String>(
            title: const Text('Semua'),
            value: 'all',
            groupValue: _filterType,
            onChanged: (value) {
              setState(() {
                _filterType = value!;
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Minggu Ini'),
            value: 'week',
            groupValue: _filterType,
            onChanged: (value) {
              setState(() {
                _filterType = value!;
                _filterDate = DateTime.now();
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Bulan Ini'),
            value: 'month',
            groupValue: _filterType,
            onChanged: (value) {
              setState(() {
                _filterType = value!;
                _filterDate = DateTime.now();
              });
              Navigator.pop(context);
            },
          ),
          if (_filterType != 'all') ...[
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _filterType == 'week'
                    ? 'Pilih Minggu'
                    : 'Pilih Bulan',
              ),
              subtitle: Text(
                DateFormat('MMMM yyyy', 'id_ID').format(_filterDate),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                _selectDate(context);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEntryCard(BuildContext context, ReflectionEntry entry) {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm', 'id_ID');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReflectionEntryScreen(
                existingEntry: entry,
              ),
            ),
          );
          if (result == true) {
            Provider.of<ReflectionProvider>(context, listen: false)
                .loadEntries();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateFormat.format(entry.createdAt),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeFormat.format(entry.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (entry.mood != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            entry.mood!.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entry.mood!.label,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                'Apa yang membuat hari ini lebih baik?',
                entry.whatMadeBetter,
                Icons.arrow_upward,
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                'Hal yang bisa diperbaiki',
                entry.whatToImprove,
                Icons.trending_up,
                Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content.length > 150 ? '${content.substring(0, 150)}...' : content,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

