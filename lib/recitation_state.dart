import 'package:flutter_riverpod/flutter_riverpod.dart';

class Recitation {
  final int target;
  final int current;
  final int cycles;

  const Recitation({ required this.target, this.current = 0, this.cycles = 0});

  Recitation copyWith({ int? target, int? current, int? cycles,}) 
  {
    return Recitation(
      target: target ?? this.target,
      current: current ?? this.current,
      cycles: cycles ?? this.cycles,
    );
  }
}

class RecitationController extends StateNotifier<Recitation> {
  RecitationController() : super(const Recitation(target: 108));

  void setTarget(int newTarget) {
    state = state.copyWith(target: newTarget);
  }

  void setCycleGoal(int newCycleGoal) {
    state = state.copyWith(cycles: newCycleGoal);
  }

  void handleRecitationTap() {
    final next = state.current + 1;
    if (next >= state.target) {
      // finished a cycle: reset current, decrement remaining cycles
      final remaining = state.cycles > 0 ? state.cycles - 1 : 0;
      state = state.copyWith(current: 0, cycles: remaining);
    } else {
      state = state.copyWith(current: next);
    }
  }
}

final recitationProvider = StateNotifierProvider<RecitationController, Recitation>(
  (ref) { return RecitationController();});