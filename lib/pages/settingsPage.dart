import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:recite_flutter/recitation_state.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  void _applyTarget(int value) {
    ref.read(recitationProvider.notifier).setTarget(value);
  }

  @override
  Widget build(BuildContext context) {
    final recite = ref.watch(recitationProvider);
    _selected = preSetOptions.contains(recite.target) ? recite.target : null;
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
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2, // adjust how much space the title takes
              child: Text(
                'Cycle Target:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2, // adjust dropdown width
              child: SizedBox(
                height: 60, // slightly smaller looks cleaner
                child: DropdownButton2<int?>(
                  isExpanded: true,
                  dropdownStyleData: DropdownStyleData
                  (
                    decoration: BoxDecoration
                    (
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  items: [
                    ...preSetOptions.map(
                      (v) => DropdownMenuItem<int?>
                      (
                        value: v,
                        child: Text('$v'),
                      ),
                    ),        
                  ],
                  onChanged: (val) {
                    setState(() => _selected = val);
                    if (val != null) { _applyTarget(val);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
          ],
        ),
      ),
    );
  }
}