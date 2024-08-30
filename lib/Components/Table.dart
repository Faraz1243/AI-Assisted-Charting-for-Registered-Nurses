import 'package:flutter/material.dart';

class CsvTableWidget extends StatelessWidget {
  final String csvString;

  CsvTableWidget({required this.csvString});

  @override
  Widget build(BuildContext context) {
    List<List<String>> data = parseCsvv(csvString);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          border: TableBorder.all(),
          columnWidths: _buildColumnWidths(context, data),
          children: data.map((row) {
            return TableRow(
              children: row.map((cell) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(cell),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Function to build dynamic column widths
  Map<int, TableColumnWidth> _buildColumnWidths(BuildContext context, List<List<String>> data) {
    // Calculate number of columns based on the first row of data
    int columnCount = data.isNotEmpty ? data[0].length : 0;
    // Define a default width based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = screenWidth / (columnCount > 0 ? columnCount : 1);

    // Create a map of column widths, making sure the width does not go below a minimum value
    return {
      for (int i = 0; i < columnCount; i++)
        i: FixedColumnWidth(columnWidth > 100 ? columnWidth : 100)
    };
  }
}

// Your existing parseCsv function remains unchanged
List<List<String>> parseCsvv(String csvString) {
  // Split the CSV string into rows
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

  return rows;
}

