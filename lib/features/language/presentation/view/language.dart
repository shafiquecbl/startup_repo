import 'package:startup_repo/imports.dart';
import 'package:startup_repo/features/language/data/model/language.dart';
import 'package:startup_repo/features/language/presentation/controller/localization_controller.dart';

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
          padding: AppPadding.p16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: 'search_langauge'.tr,
                suffixIcon: Iconsax.search_normal,
                onChanged: con.searchLanguage,
              ),
              SizedBox(height: 16.sp),
              Expanded(
                child: ListView.separated(
                  itemCount: con.languages.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final LanguageModel language = con.languages[index];
                    final bool selected = con.selectedIndex == index;

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
                                borderRadius: AppRadius.r100,
                                child: Image.asset(
                                  'assets/images/${language.countryCode.toLowerCase()}.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.sp),
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
        padding: AppPadding.p16.copyWith(top: 0),
        child: PrimaryButton(text: 'done'.tr, onPressed: Get.back),
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
          color: selected ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 12.sp,
          width: 12.sp,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
