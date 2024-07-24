import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/invoice.dart';

class PdfApi {
  static createPdf(Invoice invoice) async {
    var logo = (await rootBundle.load("assets/images/zmzm_logo.png"))
        .buffer
        .asUint8List();
    final doc = pw.Document();
    final fontFamily = await PdfGoogleFonts.cairoRegular();
    final cairoBold = await PdfGoogleFonts.cairoBold();
    doc.addPage(
      pw.Page(
        textDirection: TextDirection.rtl,
        margin: const EdgeInsets.symmetric(
          vertical: 2.54 * PdfPageFormat.cm,
          horizontal: 2.54 * PdfPageFormat.cm,
        ),
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData(
          defaultTextStyle: pw.TextStyle(
            fontSize: 10,
            font: fontFamily,
          ),
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pw.Image(pw.MemoryImage(logo), height: 50),
              SizedBox(height: 10),
              buildHeader(cairoBold),
              buildInvoice(invoice, cairoBold),
              buildTotal(invoice, cairoBold),
              SizedBox(height: 10),
              buildfooter(cairoBold),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    const fileName = "sample.pdf";
    final savePath = path.join(dir.path, fileName);
    final file = File(savePath);
    await file.writeAsBytes(await doc.save());
    await OpenFilex.open(file.path);
  }

  static Widget buildHeader(font) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Row(
            children: [
              Expanded(child: textBold(text: 'كشف عهده لـ /', font: font)),
              Expanded(child: textBold(text: 'رقم العهده /', font: font)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Row(
            children: [
              Expanded(child: textBold(text: 'مشرف الموقع :', font: font)),
              Expanded(child: textBold(text: 'تاريخ العهده :', font: font)),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildfooter(font) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        textBold(text: 'الحسابات', font: font),
        textBold(text: 'مراجع الحسابات', font: font),
        textBold(text: 'مدير الموقع', font: font),
        textBold(text: 'الرئيس التنفيذى CEO', font: font),
      ],
    );
  }

  static Widget buildTotal(Invoice invoice, font) {
    var total = 0.0;
    for (var item in invoice.items) {
      total += int.parse(item.price ?? '0');
    }

    return Container(
      padding: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        textBold(text: 'الإجمالى', font: font),
        textBold(text: '$total', font: font),
      ]),
    );
  }

  static pw.Widget buildInvoice(Invoice invoice, font) {
    final headers = [
      'التوجيه',
      'المبلغ',
      'البيان',
      'رقم الإيصال',
      'التاريخ',
      'م',
    ];
    final data = invoice.items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final priceString = item.price;
      return [
        '',
        '\$ $priceString',
        item.name,
        item.cashNumber,
        item.date,
        '${index + 1}',
      ];
    }).toList();

    final columnWidths = [
      const pw.IntrinsicColumnWidth(), // Auto width for the first column
      const pw.FixedColumnWidth(60), // Fixed width for the second column
      const pw.FixedColumnWidth(150), // Fixed width for the third column
      const pw.FixedColumnWidth(65), // Fixed width for the fourth column
      const pw.FixedColumnWidth(75), // Fixed width for the fifth column
      const pw.FixedColumnWidth(30), // Fixed width for the sixth column
    ];

    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: Map.fromIterables(
        Iterable<int>.generate(columnWidths.length),
        columnWidths,
      ),
      children: [
        pw.TableRow(
          children: headers
              .map((header) => pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      header,
                      style: pw.TextStyle(font: font),
                      textAlign: pw.TextAlign.center,
                    ),
                  ))
              .toList(),
        ),
        ...data.map((row) {
          return pw.TableRow(
            children: row
                .map((cell) => pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        cell!,
                        textAlign: pw.TextAlign.center,
                      ),
                    ))
                .toList(),
          );
        }),
      ],
    );
  }

  static Widget textBold({required text, required font}) {
    return Text(text, style: TextStyle(font: font));
  }

  static Future<File?> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    try {
      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      print('PDF saved at ${file.path}');
      return file;
    } catch (e) {
      print('Error saving PDF: $e');
      return null;
    }
  }

  static Future<void> openFile(File file) async {
    try {
      final url = file.path;
      print('Attempting to open file at $url');
      final result = await OpenFilex.open(url);
      print('OpenFile result: ${result.message}');
    } catch (e) {
      print('Error opening file: $e');
    }
  }
}
