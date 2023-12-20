# UlasBuku 📖

## Link deploy:
https://install.appcenter.ms/orgs/tkpbp-b07/apps/ulas-buku/distribution_groups/public

## Kelompok B-07 💁‍♂️💁‍♀️
- Alifa Hanania Ardha - 2206024392<br>
- Hanan Adipratama - 2206081824<br>
- Muhammad Azmi Falah - 2206082285<br>
- Muhammad Farrel Altaf - 2206829332<br>
- Monica Gloria Damanik - 2206082442<br>
- Rahida Syafa Nurdya - 2206829023

## Cerita Aplikasi 👨‍💻
Dalam dunia yang terus bergerak cepat dalam inovasi teknologi dan ilmu komputer, mencari sumber referensi berkualitas menjadi tantangan tersendiri. Sebagian besar mahasiswa, terutama mereka yang baru memulai perjalanan akademik di bidang ini, sering kali merasa terjebak dalam belantara informasi. Ditambah lagi, pemasaran buku yang menarik sering kali mengecoh, memancing mereka untuk membeli buku dengan harapan tinggi namun kemudian merasa kecewa dengan isi halamannya.

Sekelompok mahasiswa dari Fakultas Ilmu Komputer UI, yang telah menghabiskan banyak waktu dalam pencarian buku yang tepat, memutuskan untuk mengambil langkah proaktif. Mereka mendirikan "UlasBuku", sebuah platform online di mana mereka dan orang-orang lain yang berkecimpung di dunia Computer Science dapat meninggalkan ulasan jujur tentang buku-buku yang mereka baca. Tujuannya sederhana: membantu orang lain menghindari kesalahan yang sama dan memastikan bahwa setiap pembelian buku memang bernilai.

Namun, UlasBuku bukan sekadar tempat untuk ulasan. Seiring dengan pertumbuhan penggunanya, fitur-fitur baru diperkenalkan. Forum diskusi diluncurkan, memberikan ruang bagi anggota untuk mendiskusikan konsep-konsep yang mereka temukan dalam buku-buku tersebut, membagikan perspektif, atau bahkan meminta bantuan dalam topik yang sulit.


## Manfaat Aplikasi 👍
1. Peningkatan Keputusan Pembelian Buku: Dengan adanya ulasan dan rekomendasi dari komunitas, pengguna dapat menghemat waktu dan uang dengan memilih buku yang benar-benar sesuai dengan kebutuhan dan kualitas yang diharapkan.

2. Mengurangi Kesulitan dalam Menemukan Materi Berkualitas: Banyaknya buku di pasaran seringkali membingungkan. UlasBuku menjadi penyaring informasi, memudahkan pengguna menemukan buku berkualitas tinggi berdasarkan ulasan komunitas.

3. Menambah Pengetahuan: Melalui diskusi dengan komunitas yang aktif, pengguna mendapat wawasan tambahan tentang topik-topik dalam buku, yang mungkin tidak mereka peroleh hanya dengan membaca buku tersebut.

## Daftar Modul 📚
1. Homepage (main) -> berisi rekomendasi, forum dan ulasan terbaru dari user, dan iklan dari buku yang ada di database. (Monica)
    - Menampilkan rekomendasi buku berupa forum yang sedang ramai diperbincangkan dan juga forum yang kurang peminatnya dari seluruh user UlasBuku 
    - Menampilkan buku dengan ulasan terbaru dan terbaik dari user 
    - Menampilkan buku dengan forum terbaru dan ter-ramai dari user 
    - Menampilkan event/iklan yang berhubungan dengan buku pada database 
    - `Admin` Menambahkan event/iklan yang berhubungan dengan buku pada database 
    - Tentang UlasBuku 
    

2. Profile (Posisi di drawer) (Hanan)
    - Riwayat ulasan buku yang pernah diulas oleh user 
    - Riwayat forum yang pernah user kontribusi 
    - Deskripsi diri 
    - Hapus ulasan 
    - Edit ulasan 

3. Catalogue buku (Posisi di drawer) (Farrel)
    - Menampilkan buku yang ada di UlasBuku yang terurut sesuai abjad 
    - Fitur ‘search’ buku 
    - Fitur filter, berdasarkan:
        1. Kategori buku
        2. Bintang (hasil ulasan)
    - `Admin` dapat menambahkan detail buku 

4. Deskripsi Buku (Azmi)
    - Details buku (Judul, Deskripsi, Penulis, ISBN-10, ISBN-13, Tanggal Rilis, Edisi, Best Seller, Estimasi Harga, tag buku) 
    - Melihat review dan rate user jika ada 
    - Lihat ringkasan review dan rate yang ada di buku yang berkaitan 
    - Lihat ringkasan forum diskusi yang ada di buku yang berkaitan 
    - `Admin` dapat mengedit deskripsi buku 

5. Review + Rate (Alifa)
    - User dapat memberikan satu review/ulasan dan rating terhadap satu buku 
    - User dapat melihat review dan rating secara lengkap 
    - User dapat memfilter review dan rating yang diinginkan berdasarkan: 
        1. Jumlah Bintang (1-5) 
        2. Terbaru-Terlama

6. Forum (Rahida)
    - User dapat memposting pembicaraannya pada forum 
    - User dapat mengirimkan foto pada forum 
    - User dapat melihat perbincangan di forum tersebut 

7. Login dan Register (Bersama)
    - User dapat masuk menggunakan login 
    - User dapat mendaftarkan menggunakan register 

## Role 👥
1. Role dari pengunjung terdaftar: 
    - Dapat mendaftarkan akun dan melakukan login
    - Dapat menambahkan review buku yang ada di UlasBuku 
    - Dapat melihat detail dan review dari tiap buku yang ada di UlasBuku
    - Dapat menambahkan diskusi di forum diskusi UlasBuku
    - Dapat melakukan pencarian buku dengan filter yang diterapkan
2. Role dari admin:
    - Dapat mendaftarkan akun dan melakukan login
    - Dapat mengelola katalog buku yang ada di UlasBuku

## Alur pengintegrasian dengan web service untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester
1. Menyelesaikan penambahan end-point pada situs web untuk setiap modul, termasuk untuk mengambil dan mengirim data.
2. Menambahkan middleware pada aplikasi Django agar API dapat diakses dari luar situs web.
3. Mengembangkan fungsi asinkron untuk semua proses yang terkait dengan pengambilan, pengiriman, dan pembaruan data.
4. Untuk mengambil data, akan menggunakan metode HTTP GET dari end-point data di situs web, yang hasilnya akan digunakan untuk ditampilkan dalam widget yang digunakan.
5. Untuk mengirim data, akan menggunakan metode HTTP POST yang mengarah ke end-point untuk menyimpan data yang ada dalam basis data Django.
			      
## Berita Acara
https://docs.google.com/spreadsheets/d/1O1KTTi_EoY6jM48UkqbLE_DGYHezYQU1T4mp4qgpH7I/edit?usp=sharing
