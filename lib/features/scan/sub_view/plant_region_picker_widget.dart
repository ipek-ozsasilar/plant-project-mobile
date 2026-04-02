import 'dart:math' as math;
import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// Görüntü üzerinde dokunarak bitki bölgeleri ekler.
class PlantRegionPickerWidget extends StatefulWidget {
  const PlantRegionPickerWidget({
    required this.bytes,
    required this.regions,
    required this.selectedIndex,
    required this.onTapNormalized,
    required this.onSelectRegion,
    super.key,
  });

  final Uint8List bytes;
  final List<PlantRegionModel> regions;
  final int selectedIndex;
  final void Function(double nx, double ny) onTapNormalized;
  final ValueChanged<int> onSelectRegion;

  @override
  State<PlantRegionPickerWidget> createState() => _PlantRegionPickerWidgetState();
}

class _PlantRegionPickerWidgetState extends State<PlantRegionPickerWidget> {
  img.Image? _decoded;

  @override
  void initState() {
    super.initState();
    _decoded = img.decodeImage(widget.bytes);
  }

  @override
  Widget build(BuildContext context) {
    final img.Image? decoded = _decoded;
    if (decoded == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final double iw = decoded.width.toDouble();
    final double ih = decoded.height.toDouble();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxW = constraints.maxWidth;
        final double maxH = WidgetSizesEnum.maxContentWidth.value * 1.2;
        final double scale = math.min(maxW / iw, maxH / ih);
        final double dw = iw * scale;
        final double dh = ih * scale;
        return Center(
          child: SizedBox(
            width: dw,
            height: dh,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (TapDownDetails details) {
                    final Offset local = details.localPosition;
                    final double nx = (local.dx / dw).clamp(0.0, 1.0);
                    final double ny = (local.dy / dh).clamp(0.0, 1.0);
                    widget.onTapNormalized(nx, ny);
                  },
                  child: Image.memory(
                    widget.bytes,
                    width: dw,
                    height: dh,
                    fit: BoxFit.fill,
                  ),
                ),
                ...widget.regions.asMap().entries.map((MapEntry<int, PlantRegionModel> e) {
                  final int idx = e.key;
                  final PlantRegionModel r = e.value;
                  final bool sel = idx == widget.selectedIndex;
                  return Positioned(
                    left: r.nx * dw,
                    top: r.ny * dh,
                    width: r.nw * dw,
                    height: r.nh * dh,
                    child: GestureDetector(
                      onTap: () => widget.onSelectRegion(idx),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: sel ? ColorName.primary : Colors.white70,
                            width: 2,
                          ),
                          color: (sel ? ColorName.primary : Colors.white54).withValues(alpha: 0.15),
                        ),
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(
                            color: sel ? ColorName.primary : ColorName.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: TextSizesEnum.caption.value,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
