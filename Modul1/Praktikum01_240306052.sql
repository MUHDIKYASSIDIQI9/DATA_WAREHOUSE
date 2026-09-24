-- UADW v1.0 - Modul Praktikum 01
CREATE SCHEMA IF NOT EXISTS src;
DROP TABLE IF EXISTS src.program_studi;
CREATE TABLE src.program_studi (kode_prodi TEXT,nama_prodi TEXT,fakultas TEXT,departemen TEXT,status TEXT);
DROP TABLE IF EXISTS src.semester;
CREATE TABLE src.semester (semester_id TEXT,tahun_akademik TEXT,term TEXT,urutan_tahun TEXT,tanggal_mulai TEXT,tanggal_selesai TEXT);
DROP TABLE IF EXISTS src.mahasiswa;
CREATE TABLE src.mahasiswa (nim TEXT,nama TEXT,jk_raw TEXT,tanggal_lahir_raw TEXT,kota_asal_raw TEXT,kode_prodi_raw TEXT,prodi_raw TEXT,angkatan TEXT,tanggal_masuk_raw TEXT,status_raw TEXT,email_kampus TEXT);
DROP TABLE IF EXISTS src.dosen;
CREATE TABLE src.dosen (nidn TEXT,nama_dosen TEXT,jk_raw TEXT,unit_prodi_raw TEXT,jabatan_akademik TEXT,tanggal_masuk_raw TEXT,status TEXT);
DROP TABLE IF EXISTS src.mata_kuliah;
CREATE TABLE src.mata_kuliah (kode_mk TEXT,nama_mk TEXT,kode_prodi TEXT,sks TEXT,semester_rekomendasi TEXT,kategori TEXT,aktif TEXT);




-- Menjalankan Exercise C - Membuat Data Inventory --

SELECT 
    'program_studi' AS tabel, 
    COUNT(*) AS jumlah_baris,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'src' AND table_name = 'program_studi') AS jumlah_kolom
FROM src.program_studi

UNION ALL

SELECT 
    'semester', 
    COUNT(*),
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'src' AND table_name = 'semester')
FROM src.semester

UNION ALL

SELECT 
    'mahasiswa', 
    COUNT(*),
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'src' AND table_name = 'mahasiswa')
FROM src.mahasiswa

UNION ALL

SELECT 
    'dosen', 
    COUNT(*),
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'src' AND table_name = 'dosen')
FROM src.dosen

UNION ALL

SELECT 
    'mata_kuliah', 
    COUNT(*),
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'src' AND table_name = 'mata_kuliah')
FROM src.mata_kuliah;



-- Menjalankan Exercise D - Eksplorasi Awal & Problem Challenge --

-- [Poin 2 & 3] Cek Baris Raw, NIM Unik, dan Excess Duplicate
select count(*) raw_rows,
		count(distinct nim ) as distinct_nim,
		count(*) - count(distinct nim) as excess_duplicate_rows
from src.mahasiswa;

-- [Poin 4] Rentang Angkatan pada Base Load (DITAMBAHKAN)
select min(angkatan) as angkatan_tertua,
       max(angkatan) as angkatan_termuda
from src.mahasiswa;

-- [Poin 5] Mahasiswa yang Kota Asal Kosong
select count(*) as missing_kota
from src.mahasiswa
where trim(coalesce(kota_asal_raw,'')) = '';

-- [Poin 6] Distribusi Label prodi_raw (Query Anda)
SELECT prodi_raw, COUNT(*) AS jumlah
FROM src.mahasiswa
GROUP BY prodi_raw
ORDER BY prodi_raw;

-- [Poin 6] Perbandingan Jumlah Label prodi_raw vs Prodi Canonical (DITAMBAHKAN)
select 
    (select count(distinct prodi_raw) from src.mahasiswa) as jumlah_label_prodi_raw,
    (select count(*) from src.program_studi) as jumlah_prodi_canonical;

-- [Poin 7] Deteksi Pola Anomali Lainnya (DITAMBAHKAN)

-- 7a. Variasi Penulisan Jenis Kelamin (jk_raw)
select jk_raw, count(*) as jumlah
from src.mahasiswa
group by jk_raw;

-- 7b. Variasi Format Tanggal Lahir
select tanggal_lahir_raw, count(*) as frekuensi
from src.mahasiswa
group by tanggal_lahir_raw
limit 10;

-- 7c. Spasi Liar atau Perbedaan Casing Teks pada prodi_raw
select prodi_raw, count(*) as jumlah
from src.mahasiswa
where prodi_raw != trim(prodi_raw) or prodi_raw != upper(prodi_raw)
group by prodi_raw;