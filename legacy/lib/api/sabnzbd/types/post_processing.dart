import 'package:thriftwood/types/enum/readable.dart';
import 'package:thriftwood/types/enum/serializable.dart';
import 'package:thriftwood/vendor.dart';

enum SABnzbdPostProcessing with EnumSerializable, EnumReadable {
  DEFAULT('-1'),
  NONE('0'),
  REPAIR('1'),
  REPAIR_UNPACK('2'),
  REPAIR_UNPACK_DELETE('3');

  @override
  final String value;

  const SABnzbdPostProcessing(this.value);

  @override
  String get readable {
    switch (this) {
      case SABnzbdPostProcessing.DEFAULT:
        return 'sabnzbd.CategoryDefault'.tr();
      case SABnzbdPostProcessing.NONE:
        return 'sabnzbd.None'.tr();
      case SABnzbdPostProcessing.REPAIR:
        return 'sabnzbd.Repair'.tr();
      case SABnzbdPostProcessing.REPAIR_UNPACK:
        return 'sabnzbd.RepairUnpack'.tr();
      case SABnzbdPostProcessing.REPAIR_UNPACK_DELETE:
        return 'sabnzbd.RepairUnpackDelete'.tr();
    }
  }
}
