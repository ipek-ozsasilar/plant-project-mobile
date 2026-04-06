import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/services/disease_info_catalog.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Scan sonucunu PDF rapora çevirir (paylaşım UI'si üst katmanda).
class PdfReportService {
  const PdfReportService();

  Future<Uint8List> buildScanReportPdf({
    required ScanRecordModel record,
    required AppLocalizations l10n,
  }) async {
    final pw.Document doc = pw.Document();
    final DiseaseInfo info = const DiseaseInfoCatalog().get(record.diseaseLabel, l10n);
    final String diseaseDisplay = diseaseClassKeyToDisplay(record.diseaseLabel, l10n);
    final String dateLine = record.createdAt.toIso8601String();

    final double pad = WidgetSizesEnum.pdfPagePadding.value;
    final double titleSize = WidgetSizesEnum.pdfTitleFont.value;
    final double bodySize = WidgetSizesEnum.pdfBodyFont.value;
    final double sectionGap = WidgetSizesEnum.pdfSectionSpacing.value;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(pad),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text(
                l10n.pdfReportTitle,
                style: pw.TextStyle(fontSize: titleSize, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: sectionGap),
              _kv(l10n.pdfReportDate, dateLine, bodySize),
              _kv(l10n.pdfReportSpecies, record.speciesLabel, bodySize),
              _kv(
                l10n.pdfReportSpeciesConfidence,
                confidencePercentLabel(record.speciesConfidence),
                bodySize,
              ),
              _kv(l10n.pdfReportDisease, diseaseDisplay, bodySize),
              _kv(
                l10n.pdfReportDiseaseConfidence,
                confidencePercentLabel(record.diseaseConfidence),
                bodySize,
              ),
              pw.SizedBox(height: sectionGap),
              _section(l10n.diseaseDetailSectionDescription, info.description, bodySize),
              pw.SizedBox(height: sectionGap * 0.75),
              _section(l10n.diseaseDetailSectionCauses, info.causes, bodySize),
              pw.SizedBox(height: sectionGap * 0.75),
              _section(l10n.diseaseDetailSectionTreatment, info.treatment, bodySize),
              pw.SizedBox(height: sectionGap * 0.75),
              _section(l10n.diseaseDetailSectionPrevention, info.prevention, bodySize),
              pw.Spacer(),
              pw.Divider(),
              pw.Text(
                l10n.pdfReportDisclaimer,
                style: pw.TextStyle(fontSize: bodySize, color: PdfColors.grey700),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _kv(String k, String v, double size) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.SizedBox(
            width: 160,
            child: pw.Text(
              k,
              style: pw.TextStyle(fontSize: size, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(v, style: pw.TextStyle(fontSize: size)),
          ),
        ],
      ),
    );
  }

  pw.Widget _section(String title, String body, double size) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: size + 1, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Text(body, style: pw.TextStyle(fontSize: size)),
      ],
    );
  }
}

