import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import 'package:uci/ChatGPT.dart';
import 'Table.dart';

class TextReport extends StatefulWidget {
  final String report;
  final String csv;
  const TextReport({super.key, required this.report, required this.csv});

  @override
  State<TextReport> createState() => _TextReportState();
}

class _TextReportState extends State<TextReport> {


  @override
  Widget build(BuildContext context) {
    double height  = MediaQuery.of(context).size.height;

    print(widget.report);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Report"),
        actions: [
          IconButton(
            onPressed: () {
              exportMarkdownToPdf(context, widget.report, widget.csv );
            },
            icon: Icon(Icons.share),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.8 ,
                child: Markdown(
                  controller: ScrollController(),
                  selectable: true,
                  data: widget.report,
                  extensionSet: md.ExtensionSet(
                    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                    <md.InlineSyntax>[
                      md.EmojiSyntax(),
                      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                    ],
                  ),
                ),
              ),
              CsvTableWidget(
                csvString: widget.csv,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Function to parse CSV data
List<List<String>> parseCSV(String csvString) {
  List<List<String>> rows = csvString
      .trim()
      .split('\n')
      .map((row) => row.split(',').map((cell) => cell.trim()).toList())
      .toList();

  // Determine the maximum number of columns in any row
  int maxColumns = rows.map((row) => row.length).reduce((a, b) => a > b ? a : b);

  // Normalize all rows to have the same number of columns
  for (var row in rows) {
    while (row.length < maxColumns) {
      row.add(''); // Add empty string to fill missing cells
    }
  }
  if(rows[0][0]!='Time'){
    rows.removeAt(0);
  }
  return rows;
}

// Function to export Markdown and CSV data to a PDF
Future<void> exportMarkdownToPdf(BuildContext context, String markdown, String csvString) async {
  final pdf = pw.Document();

  // Split Markdown into lines for pagination
  final lines = markdown.split('\n');
  const int maxLinesPerPage = 50; // Adjust based on content size

  // Divide the Markdown text into pages
  List<List<String>> pages = [];
  for (int i = 0; i < lines.length; i += maxLinesPerPage) {
    pages.add(lines.sublist(i, (i + maxLinesPerPage).clamp(0, lines.length)));
  }

  // Add Markdown content to the PDF
  for (var pageLines in pages) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: pageLines.map((line) {
              if (line.startsWith('# ')) {
                return pw.Text(
                  line.substring(2),
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                );
              } else if (line.startsWith('## ')) {
                return pw.Text(
                  line.substring(3),
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                );
              } else if (line.startsWith('### ')) {
                return pw.Text(
                  line.substring(4),
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                );
              } else if (line.startsWith('#### ')) {
                return pw.Text(
                  line.substring(4),
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                );
              } else if (line.startsWith('- ')) {
                return pw.Text(
                  line.substring(2),
                  style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
                );
              } else {
                return pw.Text(
                  line,
                  style: pw.TextStyle(fontSize: 12),
                );
              }
            }).toList(),
          );
        },
      ),
    );
  }

  // Parse the CSV data
  List<List<String>> data = parseCSV(csvString);
  data[0] = helper(data[0]);


  // Add a new page with the CSV table to the PDF with rotated headers
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Table(
          border: pw.TableBorder.all(),
          children: [
            // Add rotated headers with optimized layout
            pw.TableRow(
              children: data.isNotEmpty
                  ? data[0].map((header) {
                return pw.Container(
                  width: 60, // Increase width for better text accommodation
                  height: 180, // Decrease height as per rotation
                  child: pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 16) ,
                    child:pw.Center(
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8, // Adjust font size for clarity and fit
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  )
                );
              }).toList()
                  : [],
            ),
            // Add table data
            ...data.sublist(1).map((row) {
              return pw.TableRow(
                children: row.map((cell) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      cell,
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ],
        );
      },
    ),
  );


  // Save the PDF to a file
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/document.pdf");
  await file.writeAsBytes(await pdf.save());

  // Share the PDF file
  Share.shareXFiles([XFile(file.path)], text: 'Here is your PDF file with Markdown and CSV table!');
}





List<String> helper(List<String> row){
  List<String> newRow = [];
  for(int i = 0; i < row.length; i++){
    newRow.add(addNewLine(row[i]));
  }
  return newRow;
}

//a function that takes a string and add \n after each character of the string
String addNewLine(String text){
  String newText = '';
  for(int i = 0; i < text.length; i++){
    newText += text[i] + '\n';
  }
  return newText;
}