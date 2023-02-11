import 'package:get/get.dart';
import 'package:scool_home_working/translates/en_translate.dart';
import 'package:scool_home_working/translates/ru_translate.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {'ru_RU': RuTranslations.map, 'en_US': EnTranslations.map};
}
