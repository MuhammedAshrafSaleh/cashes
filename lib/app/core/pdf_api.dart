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
import 'package:http/http.dart' as http;

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
          horizontal: 1 * PdfPageFormat.cm,
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
              buildHeader(
                font: cairoBold,
                projectName: invoice.projectName,
                engineerName: invoice.engineerName,
              ),
              buildInvoice(invoice, cairoBold),
              buildTotal(invoice, cairoBold),
              SizedBox(height: 10),
              buildfooter(cairoBold),
            ],
          );
        },
      ),
    );

    // Add a page for each image in invoice.items.image
    for (var cash in invoice.items) {
      if (cash.imageURl != null) {
        final imageData = await _fetchImageData(cash.imageURl!);
        doc.addPage(
          pw.Page(
            textDirection: TextDirection.rtl,
            pageFormat: PdfPageFormat.a4,
            theme: pw.ThemeData(
              defaultTextStyle: pw.TextStyle(
                fontSize: 10,
                font: fontFamily,
              ),
            ),
            build: (context) {
              return pw.Column(children: [
                pw.Text(cash.name!),
                SizedBox(height: 10),
                pw.Image(pw.MemoryImage(imageData!)),
              ]);
            },
          ),
        );
      }
    }

    final dir = await getTemporaryDirectory();
    const fileName = "sample.pdf";
    final savePath = path.join(dir.path, fileName);
    final file = File(savePath);
    await file.writeAsBytes(await doc.save());
    await OpenFilex.open(file.path);
  }

  // Helper method to fetch image data from a URL
  static Future<Uint8List?> _fetchImageData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

  static Widget buildHeader(
      {required font,
      required String projectName,
      required String engineerName}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Row(
            children: [
              Expanded(
                  child:
                      textBold(text: 'كشف عهده لـ / $projectName', font: font)),
              Expanded(child: textBold(text: 'رقم العهده /', font: font)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Row(
            children: [
              Expanded(
                  child: textBold(
                      text: 'مشرف الموقع : $engineerName', font: font)),
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
    if (data.length < 25) {
      for (int i = data.length; i < 25; i++) {
        // int index = i + 1;
        // String number = index.toString();
        data.add([
          '',
          '',
          '',
          '',
          '',
          '',
          //  number,
        ]);
      }
    }

    final columnWidths = [
      const pw.FixedColumnWidth(90), // Auto width for the first column
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
}
