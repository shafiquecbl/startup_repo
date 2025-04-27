import 'package:startup_repo/core/utils/app_padding.dart';
import 'package:startup_repo/core/utils/app_radius.dart';
import 'package:startup_repo/core/utils/design_system.dart';
import '../../../../imports.dart';

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
          padding: AppPadding.padding16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: 'search_langauge'.tr,
                suffixIcon: Iconsax.search_normal,
                onChanged: con.searchLanguage,
              ),
              SizedBox(height: AppSize.s16),
              Expanded(
                child: ListView.separated(
                  itemCount: con.languages.length,
                  separatorBuilder: (context, index) => const Divider(),
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
                        padding: AppPadding.vertical(12),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 35.sp,
                              width: 35.sp,
                              child: ClipRRect(
                                borderRadius: AppRadius.circular100,
                                child: Image.asset(
                                  'assets/images/${language.countryCode.toLowerCase()}.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSize.s10),
                            Expanded(child: Text(language.languageName)),
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
        padding: AppPadding.padding16.copyWith(top: 0),
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
          decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
        ),
      ),
    );
  }
}
