import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controller/localization_controller.dart';
import '../../../data/model/language.dart';
import '../../../helper/navigation.dart';
import '../../../utils/colors.dart';
import '../../../utils/style.dart';
import '../../base/common/primary_button.dart';
import '../../base/common/textfield.dart';
import '../../base/common/divider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('language'.tr),
      ),
      body: GetBuilder<LocalizationController>(builder: (con) {
        return Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: 'search_langauge'.tr,
                suffixIcon: Icon(Iconsax.search_normal, size: 20.sp),
                radius: 32.sp,
                filled: true,
                onChanged: con.searchLanguage,
              ),
              SizedBox(height: 16.sp),
              Expanded(
                child: ListView.separated(
                  itemCount: con.languages.length,
                  separatorBuilder: (context, index) => CustomDivider(padding: 0.sp),
                  itemBuilder: (context, index) {
                    LanguageModel language = con.languages[index];
                    bool selected = con.selectedIndex == index;

                    return InkWell(
                      onTap: () {
                        con.setSelectIndex(index);
                        con.setLanguage(Locale(language.languageCode, language.countryCode));
                      },
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.sp),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 35,
                              width: 35,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.asset(
                                  'assets/images/${language.countryCode.toLowerCase()}.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                language.languageName,
                              ),
                            ),
                            LanguageRadioButton(selected: selected),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: pagePadding.copyWith(top: 0),
        child: PrimaryButton(text: 'done'.tr, onPressed: pop),
      ),
    );
  }
}

class LanguageRadioButton extends StatelessWidget {
  final bool selected;
  const LanguageRadioButton({super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 20.sp,
      width: 20.sp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? primaryColor : Theme.of(context).dividerColor,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 12.sp,
          width: 12.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
