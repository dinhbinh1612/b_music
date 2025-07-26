import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/register/register_data_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/presentation/widgets/common_auth_scaffold.dart';
import 'package:spotify_b/presentation/widgets/next_button.dart';

class BirthdatePutScreen extends StatefulWidget {
  const BirthdatePutScreen({super.key});

  @override
  State<BirthdatePutScreen> createState() => _BirthdatePutScreenState();
}

class _BirthdatePutScreenState extends State<BirthdatePutScreen> {
  int selectedDay = 1;
  int selectedMonth = 1;
  int selectedYear = 2000;

  final int minYear = 1900;
  final int maxYear = DateTime.now().year;
  final double itemExtent = 40;

  String? errorText; // Thông báo lỗi sẽ hiển thị tại đây

  bool get isValid {
    final birthDate = DateTime(selectedYear, selectedMonth, selectedDay);
    final now = DateTime.now();
    final age =
        now.year -
        birthDate.year -
        ((now.month < birthDate.month ||
                (now.month == birthDate.month && now.day < birthDate.day))
            ? 1
            : 0);
    return age >= 13 && age <= 140;
  }

  List<Widget> generatePickerItems(List items) {
    return items
        .map(
          (item) => Center(
            child: Text(
              '$item',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

    return CommonAuthScaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Ngày sinh của bạn là gì?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            /// 3 Picker: Ngày - Tháng - Năm
            Row(
              children: [
                /// Ngày
                Expanded(
                  child: SizedBox(
                    height: itemExtent * 3,
                    child: CupertinoPicker(
                      itemExtent: itemExtent,
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedDay - 1,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDay = index + 1;
                          errorText = null;
                        });
                      },
                      children: generatePickerItems(
                        List.generate(daysInMonth, (i) => i + 1),
                      ),
                    ),
                  ),
                ),

                /// Tháng
                Expanded(
                  child: SizedBox(
                    height: itemExtent * 3,
                    child: CupertinoPicker(
                      itemExtent: itemExtent,
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedMonth - 1,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonth = index + 1;
                          errorText = null;
                        });
                      },
                      children: generatePickerItems(
                        List.generate(12, (i) => 'thg ${i + 1}'),
                      ),
                    ),
                  ),
                ),

                /// Năm
                Expanded(
                  child: SizedBox(
                    height: itemExtent * 3,
                    child: CupertinoPicker(
                      itemExtent: itemExtent,
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedYear - minYear,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = minYear + index;
                          errorText = null;
                        });
                      },
                      children: generatePickerItems(
                        List.generate(
                          maxYear - minYear + 1,
                          (i) => minYear + i,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Hiển thị lỗi (nếu có)
            if (errorText != null)
              Center(
                child: Text(
                  errorText!,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),

            const SizedBox(height: 30),
            Center(
              child: NextButton(
                isEnabled: true,
                onPressed: () {
                  setState(() {
                    final birthDate = DateTime(
                      selectedYear,
                      selectedMonth,
                      selectedDay,
                    );
                    final now = DateTime.now();
                    final age =
                        now.year -
                        birthDate.year -
                        ((now.month < birthDate.month ||
                                (now.month == birthDate.month &&
                                    now.day < birthDate.day))
                            ? 1
                            : 0);
                    if (age < 13) {
                      errorText = "Bạn không đủ tuổi sử dụng ứng dụng này.";
                    } else if (age > 140) {
                      errorText = "Vui lòng nhập tuổi thực của bạn.";
                    } else {
                      errorText = null;

                      // Cập nhật ngày sinh vào RegisterDataCubit
                      context.read<RegisterDataCubit>().updateBirthdate(
                        '$selectedDay/${selectedMonth.toString().padLeft(2, '0')}/$selectedYear',
                      );

                      Navigator.pushNamed(context, AppRoutes.chooseGender);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
