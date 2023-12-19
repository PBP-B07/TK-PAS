import 'package:flutter/material.dart';
import 'package:ulasbuku/user_profile/screens/edit_your_reviews.dart';
import 'package:http/http.dart' as http;

class YourReviewsItem {
  final double bookRating;
  final String bookTitle;
  final int bookPk;
  final int pk;
  final String description;
  final int star;
  final DateTime dateAdded;
  YourReviewsItem(
    this.bookRating,
    this.bookTitle,
    this.bookPk,
    this.pk,
    this.description,
    this.star,
    this.dateAdded,
  );
  String get formattedDateAdded =>
      "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}";
}

class YourReviewsCard extends StatelessWidget {
  final YourReviewsItem item;

  final Function() onDelete;

  const YourReviewsCard(this.item, {Key? key, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian 1 (Kiri)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100.0, // Lebar fixed
                  height: 125.0, // Tinggi fixed
                  decoration: BoxDecoration(
                    color: Colors.grey, // Warna abu-abu
                    borderRadius: BorderRadius.circular(10.0), // Corners tumpul
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "NO PHOTOS",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Tulisan putih
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          width: 50.0, // Lebar fixed (bisa disesuaikan)
                          height: 30.0, // Tinggi fixed (bisa disesuaikan)
                          decoration: BoxDecoration(
                            color: Color(0xFF102542), // Warna oval kecil
                            borderRadius:
                                BorderRadius.circular(16.0), // Corners round
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.bookRating.toString(), // Rating buku
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12.0,
                                    color: Colors.white, // Tulisan rating putih
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Icon(
                                  Icons.star,
                                  size: 12.0,
                                  color: Colors.white, // Icon bintang putih
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(width: 16.0), // Spasi antara Bagian 1 dan Bagian 2

            // Bagian 2 (Tengah Kanan)
            // Bagian 2 (Tengah Kanan)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian 2A (Judul Buku)
                  Text(
                    item.bookTitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // Bagian 2B (User Info)
                  Row(
                    children: [
                      Icon(Icons.account_circle_rounded,
                          color: Color(0xFF102542)),
                      SizedBox(width: 4.0),
                      Text("You"),
                      SizedBox(width: 4.0),
                    ],
                  ),
                  SizedBox(height: 8.0),

                  // Bagian 2C (Rating)
                  Row(
                    children: [
                      // Icon bintang berwarna kuning sebanyak item.star
                      Row(
                        children: List.generate(
                          item.star,
                          (index) => Icon(Icons.star, color: Colors.yellow),
                        ),
                      ),
                      // Icon bintang tidak berwarna kuning sebanyak 5 - item.star
                      Row(
                        children: List.generate(
                          5 - item.star,
                          (index) => Icon(Icons.star, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),

                  // Bagian 2D (Description)
                  Text(item.description),

                  SizedBox(height: 8.0),

                  Text(
                    item.formattedDateAdded, // Ubah sesuai property date pada objek item
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Bagian 3 (Kanan Bawah)
            PopupMenuButton<String>(
              onSelected: (value) {
                // Implementasikan aksi sesuai pilihan yang dipilih
                if (value == 'edit') {
                  // Aksi untuk edit
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewEditPage(
                          reviewId: item.pk,
                          star: item.star,
                          description: item.description),
                    ),
                  );
                } else if (value == 'delete') {
                  // Aksi untuk delete
                  // Tampilkan pop-up konfirmasi penghapusan
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirmation"),
                        content: Text("Are you sure you want to delete this?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Batal menghapus
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontFamily: 'Poppins', color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Lakukan aksi penghapusan
                              Navigator.pop(context);
                              // TODO: Tambahkan logika penghapusan data
                              var url = Uri.parse(
                                  "http://localhost:8000/profile/delete_review_flutter/${item.pk}/");
                              final response = await http.post(url);
                              if (response.statusCode == 200) {
                                // Review berhasil dihapus
                                // Tambahkan logika lanjutan jika perlu
                                print(
                                    "Success to delete review. Status code: ${response.statusCode}");

                                // Invoke the onDelete callback to notify YourReviewsPage
                                onDelete();
                              } else {
                                // Terjadi kesalahan saat menghapus review
                                // Tampilkan pesan kesalahan atau lakukan aksi yang sesuai
                                print(
                                    "Failed to delete review. Status code: ${response.statusCode}");
                              }
                            },
                            child: Text("Sure"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, color: Colors.blue),
                    title: Text('Edit'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete'),
                  ),
                ),
              ],
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
