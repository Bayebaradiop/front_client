import 'package:get/get.dart';

import 'english.dart';
import 'french.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'fr_FR': fr,
      };
}
