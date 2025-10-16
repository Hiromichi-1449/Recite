import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:recite_flutter/pages/counterPage.dart';

// NOTE: When you add your global state later, call it here.
// import 'package:recite_flutter/state/recitation_state.dart'; // TODO: wire up setTarget()

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  static const preSetOptions = [21, 49, 108, 1080];

  int? _selected; // null means "Custom…"
  final TextEditingController _customCtrl = TextEditingController();

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  void _applyTarget(int value) {
    ref.read(recitationProvider.notifier).setTarget(value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recitation target set to $value')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recite = ref.watch(recitationProvider);
    _selected = preSetOptions.contains(recite.target) ? recite.target : null;
    if (_selected == null) _customCtrl.text = recite.target.toString();
    return Scaffold(
      backgroundColor: const Color(0xFF555B6E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text('SETTINGS'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recitation target', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            DropdownButtonFormField<int?>(
              value: preSetOptions.contains(_selected) ? _selected : null,
              decoration: const InputDecoration(
                labelText: 'Choose a preset',
                border: OutlineInputBorder(),
              ),
              items: [
                ...preSetOptions.map(
                  (v) => DropdownMenuItem<int?>(
                    value: v,
                    child: Text('$v'),
                  ),
                ),
                const DropdownMenuItem<int?>(value: null, child: Text('Custom…')),
              ],
              onChanged: (val) {
                setState(() => _selected = val);
                if (val != null) {
                  _applyTarget(val);
                }
              },
            ),

            const SizedBox(height: 16),

            if (_selected == null)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Custom number',
                        hintText: 'Enter a positive integer',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      final v = int.tryParse(_customCtrl.text.trim());
                      if (v == null || v <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter a positive integer')),
                        );
                        return;
                      }
                      _applyTarget(v);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),

            const Spacer(),
            // Room for future settings (theme, haptics, etc.)
          ],
        ),
      ),
    );
  }
}