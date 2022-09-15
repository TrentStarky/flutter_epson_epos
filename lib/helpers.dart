import 'enums.dart';
import 'const.dart';
import 'models.dart';
import 'package:collection/collection.dart';

class EpsonEPOSHelper {
  EpsonEPOSHelper();

  dynamic getPortType(EpsonEPOSPortType enumData, {bool returnInt = false}) {
    switch (enumData) {
      case EpsonEPOSPortType.TCP:
        return returnInt ? 1 : 'TCP';
      case EpsonEPOSPortType.BLUETOOTH:
        return returnInt ? 2 : 'BT';
      case EpsonEPOSPortType.USB:
        return returnInt ? 3 : 'USB';
      default:
        return returnInt ? 0 : 'ALL';
    }
  }

  EPSONSeries? getSeries(String modelName) {
    if (modelName.isEmpty) return null;
    EPSONSeries? series = epsonSeries
        .firstWhereOrNull((element) => element.models.contains(modelName));
    if (series == null) {
      series = epsonSeries.firstWhereOrNull((element) =>
          element.models.contains(modelName.split('_')[0]));
    }
    return series;
  }
}
