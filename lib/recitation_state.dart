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

  void increment() {
    if (state.current + 1 >= state.target) {
      state = state.copyWith(current: 0, cycles: state.cycles + 1);
    } else {
      state = state.copyWith(current: state.current + 1);
    }
  }
}

final recitationProvider = StateNotifierProvider<RecitationController, Recitation>(
  (ref) { return RecitationController();});