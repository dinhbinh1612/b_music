import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/hot/hot_cubit.dart';
import 'package:spotify_b/blocs/hot/hot_state.dart';

class HotHeader extends StatelessWidget {
  const HotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bài hát thịnh hành',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<HotCubit, HotState>(
            builder: (context, state) {
              return Row(
                children: [
                  _RangeChip(
                    label: 'Tuần',
                    isSelected: state.range == 'week',
                    onTap: () => context.read<HotCubit>().changeRange('week'),
                  ),
                  const SizedBox(width: 8),
                  _RangeChip(
                    label: 'Tháng',
                    isSelected: state.range == 'month',
                    onTap: () => context.read<HotCubit>().changeRange('month'),
                  ),
                  const SizedBox(width: 8),
                  _RangeChip(
                    label: 'Năm',
                    isSelected: state.range == 'year',
                    onTap: () => context.read<HotCubit>().changeRange('year'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1DB954) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1DB954) : Colors.white54,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
