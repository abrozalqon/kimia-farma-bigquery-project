SELECT
    -- Mengambil kolom dari tabel Transaksi (t1)
    t1.transaction_id,
    t1.date,
    t1.branch_id,
    t1.customer_name,
    t1.product_id,
    t1.rating AS rating_transaksi,
    t1.price AS actual_price,
    t1.discount_percentage,
    
    -- Mengambil kolom dari tabel Kantor Cabang (t2)
    t2.branch_name,
    t2.kota,
    t2.provinsi,
    t2.rating AS rating_cabang,

    -- Mengambil kolom dari tabel Produk (t3)
    t3.product_name,

    -- Membuat kolom hitungan
    -- 1. Nett Sales: Harga setelah diskon
    (t1.price * (1 - t1.discount_percentage)) AS nett_sales,

    -- 2. Persentase Gross Laba: Menggunakan CASE WHEN berdasarkan harga
    CASE
        WHEN t1.price < 50000 THEN 0.10
        WHEN t1.price BETWEEN 50000 AND 100000 THEN 0.15
        WHEN t1.price BETWEEN 100001 AND 300000 THEN 0.20
        WHEN t1.price BETWEEN 300001 AND 500000 THEN 0.25
        WHEN t1.price > 500000 THEN 0.30
    END AS persentase_gross_laba,

    -- 3. Nett Profit: Keuntungan bersih (Nett Sales * Persentase Laba)
    (t1.price * (1 - t1.discount_percentage)) *
    CASE
        WHEN t1.price < 50000 THEN 0.10
        WHEN t1.price BETWEEN 50000 AND 100000 THEN 0.15
        WHEN t1.price BETWEEN 100001 AND 300000 THEN 0.20
        WHEN t1.price BETWEEN 300001 AND 500000 THEN 0.25
        WHEN t1.price > 500000 THEN 0.30
    END AS nett_profit

-- Menghubungkan tabel-tabel
FROM
    `glassy-storm-466902-c1.kf_dataset.kf_final_transaction` AS t1
LEFT JOIN
    `glassy-storm-466902-c1.kf_dataset.kf_kantor_cabang` AS t2
    ON t1.branch_id = t2.branch_id
LEFT JOIN
    `glassy-storm-466902-c1.kf_dataset.kf_product` AS t3
    ON t1.product_id = t3.product_id;
