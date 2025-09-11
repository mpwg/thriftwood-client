import 'package:thriftwood/types/enum/readable.dart';
import 'package:thriftwood/types/enum/serializable.dart';
import 'package:thriftwood/vendor.dart';

enum SABnzbdClearHistory with EnumSerializable, EnumReadable {
  ALL('all'),
  COMPLETED('completed'),
  FAILED('failed');

  @override
  final String value;

  const SABnzbdClearHistory(this.value);

  @override
  String get readable {
    switch (this) {
      case SABnzbdClearHistory.ALL:
        return 'sabnzbd.All'.tr();
      case SABnzbdClearHistory.COMPLETED:
        return 'sabnzbd.Completed'.tr();
      case SABnzbdClearHistory.FAILED:
        return 'sabnzbd.Failed'.tr();
    }
  }
}
