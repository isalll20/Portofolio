----------1. TABLE BASE Pelanggan ----------
DROP TABLE pelanggan

CREATE TABLE pelanggan (
  id_customer VARCHAR(10),
  level VARCHAR(10),
  nama VARCHAR(20),
  id_cabang_sales VARCHAR(10),
  cabang_sales VARCHAR(10),
  id_group VARCHAR(10),
  "group" VARCHAR(10)
);

SELECT * FROM pelanggan

----------2. TABLE BASE Penjualan----------
DROP TABLE penjualan

CREATE TABLE penjualan (
  id_distributor VARCHAR(10),
  id_cabang VARCHAR(10),
  id_invoice VARCHAR(10),
  tanggal DATE,
  id_customer VARCHAR(10),
  id_barang VARCHAR(10),
  jumlah_barang NUMERIC(10, 2),
  unit VARCHAR(5),
  harga NUMERIC(10, 2),
  mata_uang VARCHAR(5),
  brand_id VARCHAR(10),
  lini VARCHAR(10)
);

SELECT * FROM penjualan

----------3. TABLE Aggregate pelanggan_terbaik----------
DROP TABLE pelanggan_terbaik

CREATE TABLE pelanggan_terbaik AS
SELECT p.id_customer, p.nama, SUM(j.harga) AS total_harga, SUM(j.jumlah_barang) AS total_barang
FROM pelanggan p
JOIN penjualan j ON p.id_customer = j.id_customer
GROUP BY p.id_customer, p.nama
ORDER BY total_harga;

SELECT * FROM tabel_agregat

----------4. TABLE Aggregate pendapatan_perbulan----------
DROP TABLE pendapatan_perbulan

CREATE TABLE pendapatan_perbulan AS
SELECT TO_CHAR(DATE_TRUNC('month', tanggal), 'Month') AS bulan, 
	COUNT(*) AS total_data, SUM(harga) AS Total_pendapatan, 
	SUM(jumlah_barang) AS total_barang_terjual
FROM penjualan
GROUP BY DATE_TRUNC('month', tanggal)
ORDER BY DATE_TRUNC('month', tanggal);

SELECT * FROM pendapatan_perbulan
ORDER BY bulan
