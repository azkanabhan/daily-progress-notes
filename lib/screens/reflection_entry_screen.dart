import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reflection_entry.dart';
import '../models/mood.dart';
import '../providers/reflection_provider.dart';
import '../widgets/mood_selector.dart';
import '../widgets/rich_text_field.dart';
import '../widgets/date_time_display.dart';

class ReflectionEntryScreen extends StatefulWidget {
  final ReflectionEntry? existingEntry;

  const ReflectionEntryScreen({
    super.key,
    this.existingEntry,
  });

  @override
  State<ReflectionEntryScreen> createState() => _ReflectionEntryScreenState();
}

class _ReflectionEntryScreenState extends State<ReflectionEntryScreen> {
  late TextEditingController _whatMadeBetterController;
  late TextEditingController _whatToImproveController;
  Mood? _selectedMood;
  DateTime _createdAt = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _whatMadeBetterController = TextEditingController();
    _whatToImproveController = TextEditingController();

    if (widget.existingEntry != null) {
      final entry = widget.existingEntry!;
      _whatMadeBetterController.text = entry.whatMadeBetter;
      _whatToImproveController.text = entry.whatToImprove;
      _selectedMood = entry.mood;
      _createdAt = entry.createdAt;
    }
  }

  @override
  void dispose() {
    _whatMadeBetterController.dispose();
    _whatToImproveController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    final whatMadeBetter = _whatMadeBetterController.text.trim();
    final whatToImprove = _whatToImproveController.text.trim();

    if (whatMadeBetter.isEmpty || whatToImprove.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua kolom yang wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final provider = Provider.of<ReflectionProvider>(context, listen: false);
      final entry = ReflectionEntry(
        id: widget.existingEntry?.id,
        whatMadeBetter: whatMadeBetter,
        whatToImprove: whatToImprove,
        mood: _selectedMood,
        createdAt: _createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.existingEntry != null) {
        await provider.updateEntry(entry);
      } else {
        await provider.addEntry(entry);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingEntry != null
                  ? 'Refleksi berhasil diperbarui'
                  : 'Refleksi berhasil disimpan',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingEntry != null
              ? 'Edit Refleksi'
              : 'Refleksi Hari Ini',
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveEntry,
              tooltip: 'Simpan',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DateTimeDisplay(dateTime: _createdAt),
            const SizedBox(height: 24),
            RichTextField(
              controller: _whatMadeBetterController,
              label: 'Apa yang membuat hari ini lebih baik dari kemarin?',
              hint: 'Tuliskan hal-hal positif yang terjadi hari ini...',
            ),
            const SizedBox(height: 24),
            RichTextField(
              controller: _whatToImproveController,
              label: 'Hal apa yang bisa aku perbaiki untuk besok?',
              hint: 'Tuliskan hal-hal yang ingin diperbaiki...',
            ),
            const SizedBox(height: 24),
            MoodSelector(
              selectedMood: _selectedMood,
              onMoodSelected: (mood) {
                setState(() {
                  _selectedMood = mood;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveEntry,
              icon: const Icon(Icons.save),
              label: Text(
                widget.existingEntry != null ? 'Perbarui Refleksi' : 'Simpan Refleksi',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

