import 'package:flutter/material.dart';
import '../theme/design_system.dart';

enum HomeState {
  normal,      // Page 26
  checkInDone, // Page 27
  firstTime,   // Page 28
  offline,     // Page 29
}

class StateSelector extends StatefulWidget {
  final HomeState currentState;
  final ValueChanged<HomeState> onStateChanged;

  const StateSelector({
    super.key,
    required this.currentState,
    required this.onStateChanged,
  });

  @override
  State<StateSelector> createState() => _StateSelectorState();
}

class _StateSelectorState extends State<StateSelector> {
  bool _isExpanded = false;

  String _getStateName(HomeState state) {
    switch (state) {
      case HomeState.normal:
        return '26 - Normal';
      case HomeState.checkInDone:
        return '27 - Done';
      case HomeState.firstTime:
        return '28 - First Time';
      case HomeState.offline:
        return '29 - Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90,
      right: 16,
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isExpanded)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.layers_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getStateName(widget.currentState),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Work Sans',
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
                ),
                ...HomeState.values.map((state) {
                  final isSelected = widget.currentState == state;
                  return GestureDetector(
                    onTap: () {
                      widget.onStateChanged(state);
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accentGold : Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getStateName(state).split(' - ').last,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Work Sans',
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
