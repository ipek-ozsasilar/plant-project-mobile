import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/error_strings_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:image/image.dart' as img;

/// Normalize dikdörtgen alandan görüntü kırpar.
class ImageCropService {
  ImageCropService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  Uint8List? cropRegion({
    required Uint8List imageBytes,
    required PlantRegionModel region,
  }) {
    try {
      final img.Image? decoded = img.decodeImage(imageBytes);
      if (decoded == null) {
        return null;
      }
      final int w = decoded.width;
      final int h = decoded.height;
      final int left = (region.nx * w).round().clamp(0, w - 1);
      final int top = (region.ny * h).round().clamp(0, h - 1);
      final int cropW = (region.nw * w).round().clamp(1, w - left);
      final int cropH = (region.nh * h).round().clamp(1, h - top);
      final img.Image cropped = img.copyCrop(
        decoded,
        x: left,
        y: top,
        width: cropW,
        height: cropH,
      );
      final Uint8List out = Uint8List.fromList(img.encodeJpg(cropped, quality: 92));
      return out;
    } catch (e, st) {
      _logger.e(ErrorStringsEnum.crop.value, e, st);
      return null;
    }
  }

  /// Dokunuş merkezli varsayılan kare bölge (normalize).
  PlantRegionModel regionAroundTap({
    required double nx,
    required double ny,
    double? side,
  }) {
    final double s = side ?? WidgetSizesEnum.regionMinSide.value;
    double left = nx - s / 2;
    double top = ny - s / 2;
    if (left < 0) {
      left = 0;
    }
    if (top < 0) {
      top = 0;
    }
    if (left + s > 1) {
      left = 1 - s;
    }
    if (top + s > 1) {
      top = 1 - s;
    }
    return PlantRegionModel(
      id: '',
      nx: left,
      ny: top,
      nw: s,
      nh: s,
    );
  }
}
