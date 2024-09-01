-- init.sql
-- Script ini menginisialisasi database, user, dan tabel untuk aplikasi

-- Buat user galih jika belum ada
-- Menggunakan blok DO untuk menghindari error jika user sudah ada
DO
$do$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'galih') THEN
      CREATE USER galih WITH PASSWORD 'password';
   END IF;
END
$do$;

-- Buat database app jika belum ada
-- Catatan: Ini mungkin gagal jika database sudah ada, yang bukan masalah dalam konteks ini
CREATE DATABASE app;

-- Hubungkan ke database app
-- Ini memastikan semua perintah berikutnya dijalankan dalam konteks database 'app'
\c app

-- Berikan hak akses ke galih
-- Ini membuat galih sebagai pemilik database dan memberikan semua hak istimewa
ALTER DATABASE app OWNER TO galih;
GRANT ALL PRIVILEGES ON DATABASE app TO galih;

-- Buat schema public jika belum ada dan berikan akses
-- Schema public biasanya sudah ada, tapi kita memastikannya untuk keamanan
CREATE SCHEMA IF NOT EXISTS public;
GRANT ALL ON SCHEMA public TO galih;
GRANT ALL ON SCHEMA public TO public;

-- Set default privileges untuk galih
-- Ini memastikan galih memiliki akses ke semua tabel yang akan dibuat di masa depan
ALTER DEFAULT PRIVILEGES FOR ROLE galih IN SCHEMA public
GRANT ALL ON TABLES TO galih;

-- Hapus tabel users jika sudah ada, kemudian buat ulang
-- Ini memastikan kita mulai dengan tabel yang bersih setiap kali script dijalankan
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Berikan semua hak akses untuk tabel users ke galih
-- Ini termasuk hak untuk menggunakan sequence yang digunakan oleh kolom id
GRANT ALL PRIVILEGES ON TABLE users TO galih;
GRANT USAGE, SELECT ON SEQUENCE users_id_seq TO galih;

-- Verifikasi bahwa tabel telah dibuat
-- Ini akan menampilkan daftar tabel dalam database saat ini
\dt

-- Tampilkan hak akses galih
-- Ini akan menampilkan peran dan atribut yang dimiliki oleh user galih
\du galih