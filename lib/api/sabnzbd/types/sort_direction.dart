import 'package:thriftwood/types/enum/readable.dart';
import 'package:thriftwood/types/enum/serializable.dart';
import 'package:thriftwood/vendor.dart';

enum SABnzbdSortDirection with EnumSerializable, EnumReadable {
  ASCENDING('asc'),
  DESCENDING('desc');

  @override
  final String value;

  const SABnzbdSortDirection(this.value);

  @override
  String get readable {
    switch (this) {
      case SABnzbdSortDirection.ASCENDING:
        return 'sabnzbd.Ascending'.tr();
      case SABnzbdSortDirection.DESCENDING:
        return 'sabnzbd.Descending'.tr();
    }
  }
}
