DROP DATABASE IF EXISTS blood_bank_db;
-- CREATE DATABASE: Membuat database
CREATE DATABASE blood_bank_db;
USE blood_bank_db;

-- CREATE TABLE: Membuat tabel
CREATE TABLE Donor (
    donor_id INT AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    tanggal_lahir DATE NOT NULL,
    gol_darah CHAR(2) NOT NULL,
    rhesus CHAR(1) NOT NULL,
    no_telepon VARCHAR(15) NOT NULL,
    PRIMARY KEY(donor_id)
);

CREATE TABLE Donasi (
    donasi_id INT AUTO_INCREMENT,
    donor_id INT NOT NULL,
    tanggal_donasi DATE NOT NULL,
    volume_ml INT NOT NULL,
    hb_level FLOAT NOT NULL,
    PRIMARY KEY (donasi_id),
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id)
);

CREATE TABLE Stok_Darah (
    stok_id INT AUTO_INCREMENT,
    gol_darah CHAR(2) NOT NULL,
    rhesus CHAR(1) NOT NULL,
    volume_total_ml INT NOT NULL,
    tanggal_kedaluwarsa DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY(stok_id)
);

CREATE TABLE Permintaan_Darah (
    permintaan_id INT AUTO_INCREMENT,
    nama_rumah_sakit VARCHAR(100) NOT NULL,
    gol_darah CHAR(2) NOT NULL,
    rhesus CHAR(1) NOT NULL,
    volume_dibutuhkan INT NOT NULL,
    tanggal_permintaan DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY(permintaan_id)
);

-- INSERT: Memasukkan data ke tabel sebanyak 5 baris
INSERT INTO Donor (nama, tanggal_lahir, gol_darah, rhesus, no_telepon) VALUES
('Andi', '1990-06-12', 'A', '+', '081234567890'),
('Budi', '1985-04-21', 'B', '+', '081234567891'),
('Citra', '1992-09-10', 'O', '-', '081234567892'),
('Dewi', '1994-12-02', 'AB', '+', '081234567892'),
('Eka', '1989-01-25', 'A', '-', '081234567893');

INSERT INTO Donasi (donor_id, tanggal_donasi, volume_ml, hb_level) VALUES
(1, '2025-03-01', 450, 13.5),
(2, '2025-03-05', 400, 12.8),
(3, '2025-03-10', 350, 11.9),
(4, '2025-03-12', 450, 14.2),
(5, '2025-03-15', 400, 12.0);

INSERT INTO Stok_Darah (gol_darah, rhesus, volume_total_ml, tanggal_kedaluwarsa, status) VALUES
('A', '+', 450, '2025-06-01', 'tersedia'),
('B', '+', 400, '2025-06-03', 'tersedia'),
('O', '-', 350, '2025-06-10', 'tersedia'),
('AB', '+', 450, '2025-06-15', 'tersedia'),
('A', '-', 400, '2025-06-20', 'tersedia');

INSERT INTO Permintaan_Darah (nama_rumah_sakit, gol_darah, rhesus, volume_dibutuhkan, tanggal_permintaan, status) VALUES
('RS Sehat', 'A', '+', 300, '2025-04-01', 'pending'),
('RS Medika', 'B', '+', 200, '2025-04-02', 'dipenuhi'),
('RS Kasih', 'O', '-', 250, '2025-04-03', 'pending'),
('RS Pelita', 'AB', '+', 300, '2025-04-04', 'ditolak'),
('RS Harapan', 'A', '-', 200, '2025-04-05', 'pending');

-- UPDATE: Memperbarui 1 data per tabel
UPDATE Donor
SET no_telepon = '081234567895'
WHERE nama = 'Budi';

UPDATE Donasi
SET volume_ml = 475
WHERE donasi_id = 1;

UPDATE Stok_Darah
SET status = 'kedaluwarsa'
WHERE tanggal_kedaluwarsa < CURDATE();

UPDATE Permintaan_Darah
SET status = 'dipenuhi'
WHERE tanggal_permintaan < '2025-04-03';

-- DELETE: Menghapus 1 data per tabel
DELETE FROM Donasi
WHERE donasi_id = ;

DELETE FROM Donor
WHERE gol_darah = 'AB' AND rhesus = '+';

DELETE FROM Stok_Darah
WHERE tanggal_kedaluwarsa < '2025-06-05';

DELETE FROM Permintaan_Darah
WHERE status = 'ditolak';

-- SELECT Queries pada tabel Donor
-- LIKE: Mencari donor dengan nama mengandung "an"
SELECT * FROM Donor
WHERE nama LIKE '%an%';
-- SORTING: Mengurutkan berdasarkan tanggal lahir tertua
SELECT * FROM Donor
ORDER BY tanggal_lahir ASC;
-- GROUPING: Mengelompokkan jumlah donor per golongan darah
SELECT gol_darah, COUNT(*) AS jumlah_donor
FROM Donor
GROUP BY gol_darah;

-- SELECT Queries pada tabel Donasi
-- Aggregate: Rata-rata hemoglobin
SELECT AVG(hb_level) AS rata_rata_hb
FROM Donasi;
-- GROUPING & HAVING: Jumlah donasi per donor > 1
SELECT donor_id, COUNT(*) AS jumlah_donasi
FROM Donasi
GROUP BY donor_id
HAVING COUNT(*) > 1;
-- SORTING: Mengurutkan donasi dari volume terbesar
SELECT * FROM Donasi
ORDER BY volume_ml DESC;

-- SELECT Queries pada tabel Stok_Darah
-- Aggregate: Total volume semua stok tersedia
SELECT SUM(volume_total_ml) AS total_stok
FROM Stok_Darah
WHERE status = 'tersedia';
-- GROUPING: Mengelompokkan total volume per golongan darah
SELECT gol_darah, SUM(volume_total_ml) AS total_volume
FROM Stok_Darah
GROUP BY gol_darah;
-- LIKE: Mencari stok dengan rhesus negatif
SELECT * FROM Stok_Darah
WHERE rhesus = '-';

-- SELECT Queries pada tabel Permintaan_Darah
-- SORTING: Mengurutkan berdasarkan volume_dibutuhkan tertinggi
SELECT * FROM Permintaan_Darah
ORDER BY volume_dibutuhkan DESC;
-- GROUPING: Mengelompokkan permintaan per golongan darah
SELECT gol_darah, COUNT(*) AS jumlah_permintaan
FROM Permintaan_Darah
GROUP BY gol_darah;
-- LIKE: Mencari rumah sakit dengan nama mengandung “RS”
SELECT * FROM Permintaan_Darah
WHERE nama_rumah_sakit LIKE '%RS%';

-- SELECT Queries Operasi Himpunan
-- UNION: Menggabungkan nama dari tabel Donor dan Rumah Sakit yang namanya mengandung "a", tanpa duplikat
SELECT nama FROM Donor
WHERE nama LIKE '%a%'
UNION
SELECT nama_rumah_sakit AS nama FROM Permintaan_Darah
WHERE nama_rumah_sakit LIKE '%a%';
-- UNION ALL: Menggabungkan nama dari tabel Donor dan Rumah Sakit yang namanya mengandung "a", boleh ada duplikat
SELECT nama FROM Donor
WHERE nama LIKE '%a%'
UNION ALL
SELECT nama_rumah_sakit AS nama FROM Permintaan_Darah
WHERE nama_rumah_sakit LIKE '%a%';

-- Operasi JOIN
-- Menampilkan semua data donasi lengkap dengan nama donor
SELECT d.donasi_id, r.nama, d.tanggal_donasi, d.volume_ml, d.hb_level
FROM Donasi d
JOIN Donor r ON d.donor_id = r.donor_id;
-- JOIN Permintaan_Darah dengan stok darah berdasarkan golongan darah dan rhesus
SELECT p.nama_rumah_sakit, p.gol_darah, p.rhesus, s.volume_total_ml, s.status
FROM Permintaan_Darah p
JOIN Stok_Darah s
ON p.gol_darah = s.gol_darah AND p.rhesus = s.rhesus;

-- Operasi SUBQUERY
-- Mencari nama donor yang pernah melakukan donasi volume > rata-rata
SELECT nama FROM Donor
WHERE donor_id IN (
    SELECT donor_id FROM Donasi
    WHERE volume_ml > (SELECT AVG(volume_ml) FROM Donasi)
);
-- Menampilkan rumah sakit yang meminta volume darah lebih dari stok tertinggi yang tersedia
SELECT nama_rumah_sakit FROM Permintaan_Darah
WHERE volume_dibutuhkan > (
    SELECT MAX(volume_total_ml) FROM Stok_Darah
    WHERE status = 'tersedia'
);