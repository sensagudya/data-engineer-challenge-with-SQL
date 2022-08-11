#Mengacu pada table ms_produk, tampilkan daftar produk yang memiliki harga antara 50.000 and 150.000. Nama kolom yang harus ditampilkan: no_urut, kode_produk, nama_produk, dan harga.

SELECT no_urut,kode_produk,nama_produk,harga 
FROM ms_produk 
WHERE harga > 50000 AND harga < 150000

#Tampilkan semua produk yang mengandung kata Flashdisk. Nama kolom yang harus ditampilkan: no_urut, kode_produk, nama_produk, dan harga.

SELECT no_urut,kode_produk,nama_produk,harga
FROM ms_produk
WHERE nama_produk LIKE '%Flashdisk%'

#Tampilkan hanya nama-nama pelanggan yang hanya memiliki gelar-gelar berikut: S.H, Ir. dan Drs. Nama kolom yang harus ditampilkan: no_urut, kode_pelanggan, nama_pelanggan, dan alamat.

SELECT no_urut,kode_pelanggan,nama_pelanggan,alamat
FROM ms_pelanggan
WHERE nama_pelanggan LIKE '%S.H%' OR nama_pelanggan LIKE '%Ir.%'
OR nama_pelanggan LIKE '%Drs.%'

#Tampilkan nama-nama pelanggan dan urutkan hasilnya berdasarkan kolom nama_pelanggan dari yang terkecil ke yang terbesar (A ke Z). Nama kolom yang harus ditampilkan: nama_pelanggan.

SELECT nama_pelanggan
FROM ms_pelanggan
ORDER BY nama_pelanggan ASC

#Tampilkan nama-nama pelanggan dan urutkan hasilnya berdasarkan kolom nama_pelanggan dari yang terkecil ke yang terbesar (A ke Z), namun gelar tidak boleh menjadi bagian dari urutan. Contoh: Ir. Agus Nugraha harus berada di atas Heidi Goh. Nama kolom yang harus ditampilkan: nama_pelanggan.

SELECT 
	nama_pelanggan
FROM 
	ms_pelanggan
ORDER BY CASE 
	WHEN LEFT(nama_pelanggan,3)='Ir.' 
	THEN SUBSTRING(nama_pelanggan,5,100)  
ELSE nama_pelanggan END
ASC;

#Tampilkan nama pelanggan yang memiliki nama paling panjang. Jika ada lebih dari 1 orang yang memiliki panjang nama yang sama, tampilkan semuanya. Nama kolom yang harus ditampilkan: nama_pelanggan.

SELECT nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) IN (SELECT MAX(LENGTH(nama_pelanggan)) FROM ms_pelanggan)

#Tampilkan nama orang yang memiliki nama paling panjang (pada row atas), dan nama orang paling pendek (pada row setelahnya). Gelar menjadi bagian dari nama. Jika ada lebih dari satu nama yang paling panjang atau paling pendek, harus ditampilkan semuanya. Nama kolom yang harus ditampilkan: nama_pelanggan.

SELECT nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) IN
(SELECT MAX(LENGTH(nama_pelanggan)) FROM ms_pelanggan)
OR LENGTH(nama_pelanggan) IN (SELECT MIN(LENGTH(nama_pelanggan)) FROM ms_pelanggan)
ORDER BY LENGTH(nama_pelanggan) DESC;

#Tampilkan produk yang paling banyak terjual dari segi kuantitas. Jika ada lebih dari 1 produk dengan nilai yang sama, tampilkan semua produk tersebut. Nama kolom yang harus ditampilkan: kode_produk, nama_produk,total_qty.

SELECT ms_produk.kode_produk,ms_produk.nama_produk,SUM(tr_penjualan_detail.qty) AS total_qty 
FROM ms_produk
JOIN tr_penjualan_detail
ON ms_produk.kode_produk = tr_penjualan_detail.kode_produk
GROUP BY ms_produk.kode_produk,ms_produk.nama_produk
HAVING total_qty = 7;

#Siapa saja pelanggan yang paling banyak menghabiskan uangnya untuk belanja? Jika ada lebih dari 1 pelanggan dengan nilai yang sama, tampilkan semua pelanggan tersebut. Nama kolom yang harus ditampilkan: kode_pelanggan, nama_pelanggan, total_harga.

SELECT DISTINCT ms_pelanggan.kode_pelanggan,ms_pelanggan.nama_pelanggan, SUM(tr_penjualan_detail.qty*tr_penjualan_detail.harga_satuan) AS total_harga
FROM ms_pelanggan
JOIN tr_penjualan
ON ms_pelanggan.kode_pelanggan = tr_penjualan.kode_pelanggan
JOIN tr_penjualan_detail
ON tr_penjualan.kode_transaksi = tr_penjualan_detail.kode_transaksi
GROUP BY ms_pelanggan.kode_pelanggan,ms_pelanggan.nama_pelanggan
ORDER BY total_harga DESC 
LIMIT 1

#Tampilkan daftar pelanggan yang belum pernah melakukan transaksi. Nama kolom yang harus ditampilkan: kode_pelanggan, nama_pelanggan, alamat.

SELECT DISTINCT ms_pelanggan.kode_pelanggan,ms_pelanggan.nama_pelanggan,ms_pelanggan.alamat
FROM ms_pelanggan
WHERE ms_pelanggan.kode_pelanggan NOT IN (SELECT kode_pelanggan FROM tr_penjualan)

#Tampilkan transaksi-transaksi yang memiliki jumlah item produk lebih dari 1 jenis produk. Dengan lain kalimat, tampilkan transaksi-transaksi yang memiliki jumlah baris data pada table tr_penjualan_detail lebih dari satu. Nama kolom yang harus ditampilkan:  kode_transaksi, kode_pelanggan, nama_pelanggan, tanggal_transaksi, jumlah_detail

SELECT DISTINCT tr_penjualan.kode_transaksi,tr_penjualan.kode_pelanggan,ms_pelanggan.nama_pelanggan,tr_penjualan.tanggal_transaksi,COUNT(tr_penjualan_detail.kode_transaksi) AS jumlah_detail
FROM ms_pelanggan
JOIN tr_penjualan
ON ms_pelanggan.kode_pelanggan = tr_penjualan.kode_pelanggan
JOIN tr_penjualan_detail
ON tr_penjualan.kode_transaksi = tr_penjualan_detail.kode_transaksi
GROUP BY tr_penjualan.kode_transaksi,tr_penjualan.kode_pelanggan,ms_pelanggan.nama_pelanggan,tr_penjualan.tanggal_transaksi
HAVING jumlah_detail > 1
