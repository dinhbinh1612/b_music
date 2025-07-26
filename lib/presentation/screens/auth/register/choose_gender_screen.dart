import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/register/register_data_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/presentation/widgets/common_auth_scaffold.dart';
import 'package:spotify_b/presentation/widgets/next_button.dart';

class ChooseGenderScreen extends StatefulWidget {
  const ChooseGenderScreen({super.key});

  @override
  State<ChooseGenderScreen> createState() => _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends State<ChooseGenderScreen> {
  String? selectedGender;

  final List<String> genders = [
    'Nữ',
    'Nam',
    'Phi nhị giới',
    'Khác',
    'Không muốn nêu cụ thể',
  ];

  @override
  Widget build(BuildContext context) {
    return CommonAuthScaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              "Giới tính của bạn là gì?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  genders.map((gender) {
                    final isSelected = selectedGender == gender;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = gender;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text(
                          gender,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            SizedBox(height: 24),
            Center(
              child: NextButton(
                isEnabled: selectedGender != null,
                onPressed: () {
                  if (selectedGender != null) {
                    // Cập nhật giới tính vào RegisterDataCubit
                    context.read<RegisterDataCubit>().updateGender(
                      selectedGender!,
                    );

                    Navigator.pushNamed(context, AppRoutes.nameInput);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
