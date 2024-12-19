import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../config/constants/constants.dart';
import '../../config/constants/widgets.dart';

class ContactUsTableScreen extends StatelessWidget {
  const ContactUsTableScreen({super.key});

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  void _deleteDocument(String docId) {
    FirebaseFirestore.instance.collection('Contact_Us').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Связаться с нами'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Contact_Us').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: spinKit());
          }

          List<TableRow> tableRows = [
            const TableRow(
              decoration: BoxDecoration(color: AppColors.orange),
              children: [
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Имя',
                            style: TextStyle(color: AppColors.white)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Номер телефона или почта',
                            style: TextStyle(color: AppColors.white)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Сообщение',
                            style: TextStyle(color: AppColors.white)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Временная метка',
                            style: TextStyle(color: AppColors.white)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Удалить',
                            style: TextStyle(color: AppColors.white)))),
              ],
            ),
          ];

          for (var doc in snapshot.data!.docs) {
            var data = doc.data() as Map<String, dynamic>;
            var name = data['name'] ?? '';
            var contactInfo = data['contact'] ?? '';
            var message = data['message'] ?? '';
            var timestamp = data['timestamp'] as Timestamp?;

            tableRows.add(
              TableRow(
                decoration: BoxDecoration(color: Colors.orange.shade50),
                children: [
                  TableCell(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(name))),
                  TableCell(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(contactInfo))),
                  TableCell(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(message))),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(timestamp != null
                          ? formatTimestamp(timestamp)
                          : 'N/A'),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.orange),
                        onPressed: () => _deleteDocument(doc.id),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Table(
                  border: TableBorder.all(color: AppColors.orange),
                  children: tableRows,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
