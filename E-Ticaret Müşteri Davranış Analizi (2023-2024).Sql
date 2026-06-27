--             E-Commerce Analizi (Türkiye)
-- Kaynak: Kaggle: ttps://www.kaggle.com/datasets/umuttuygurr/e-commerce-customer-behavior-and-sales-analysis-tr

--                                        Çalışmam Aşağıdaki Başlıkları İçermektedir
/*  Veri Keşfi ve Veri Kalitesi (EDA)
Veri setinin genel yapısını, satır sayısı kontrol edildi.
eksik (NULL) ve tekrar eden (duplicate) kayıtlar analiz edilerek 
verinin analize uygunluğu değerlendirildi.

1. Müşteri Demografisi Analizi
Müşteriler yaş, cinsiyet ve şehir bazında incelendi.
Müşteri kitlesinin yapısı ve dağılımı analiz edilerek hedef kitle profili çıkarıldı.

2. Ürün ve Kategori Analizi
Ürün kategorileri satış, gelir, sipariş sayısı ve 
müşteri memnuniyeti metrikleri ile değerlendirildi. En güçlü ve zayıf kategoriler belirlendi.

3. Ödeme ve Cihaz Davranışı Analizi
Müşterilerin ödeme yöntemleri ve kullandıkları cihaz türleri analiz edildi. 
En güçlü ödeme–cihaz kombinasyonları ve satış performansına etkisi incelendi.

4. Müşteri Memnuniyeti ve Sadakat Analizi
Müşteri puanları, teslimat süresi etkisi ve geri dönen müşteri davranışları analiz edildi. 
Sadık müşteri oranı ve müşteri değer segmentleri belirlendi.

5. Zaman Serisi ve Gelir Analizi
Aylık satış trendleri, gelir değişimi, müşteri sayısı ve 
kümülatif gelir analiz edilerek zaman içindeki performans ve sezonsallık incelendi.

6.Müşteri Sadakat Analizi
Müşteri puanları, teslimat süresi etkisi ve geri dönen müşteri davranışları analiz edildi.
 Müşteri sadakati, tekrar satın alma oranı ve müşteri değer segmentleri belirlendi.
 */
/*
        Veri Setindeki Alanlar
        
Kolon	                   Açıklama

Order_ID	               Sipariş No
Customer_ID	               Müşteri No
Date	                   Sipariş Tarihi
Age	                       Yaş
Gender	                   Cinsiyet
City	                   Şehir
Product_Category	       Ürün Kategorisi
Unit_Price	               Birim Fiyat
Quantity	               Adet
Discount_Amount	           İndirim
Total_Amount	           Toplam Tutar
Payment_Method	           Ödeme Yöntemi
Device_Type	               Cihaz Türü
Session_Duration_Minutes   Sitede Geçirilen Süre
Pages_Viewed	           Görüntülenen Sayfa
Is_Returning_Customer	   Geri Dönen Müşteri
Delivery_Time_Days	       Teslimat Süresi
Customer_Rating	           Müşteri Puanı
*/

-- Veriye Genel Bakış / Önce veri seti neler içeriyor anlamaya çalışalım.
-- veri sayısını/ satır sayısını kontrol edelim
SELECT COUNT(*)
FROM ecommerce_customer_behavior_dataset_v2;

-- Tablo yapısını kontrol edelim.
DESCRIBE ecommerce_customer_behavior_dataset_v2;

-- Null Kontrolü
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Order_ID_null,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Customer_ID_null,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_null,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_null,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_null,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_null,
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS Product_Category_null,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS Unit_Price_null,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Quantity_null,
    SUM(CASE WHEN Discount_Amount IS NULL THEN 1 ELSE 0 END) AS Discount_Amount_null,
    SUM(CASE WHEN Total_Amount IS NULL THEN 1 ELSE 0 END) AS Total_Amount_null,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS Payment_Method_null,
    SUM(CASE WHEN Device_Type IS NULL THEN 1 ELSE 0 END) AS Device_Type_null,
    SUM(CASE WHEN Session_Duration_Minutes IS NULL THEN 1 ELSE 0 END) AS Session_Duration_Minutes_null,
    SUM(CASE WHEN Pages_Viewed IS NULL THEN 1 ELSE 0 END) AS Pages_Viewed_null,
    SUM(CASE WHEN Is_Returning_Customer IS NULL THEN 1 ELSE 0 END) AS Is_Returning_Customer_null,
    SUM(CASE WHEN Delivery_Time_Days IS NULL THEN 1 ELSE 0 END) AS Delivery_Time_Days_null,
    SUM(CASE WHEN Customer_Rating IS NULL THEN 1 ELSE 0 END) AS Customer_Rating_null
FROM ecommerce_customer_behavior_dataset_v2;

-- Tüm sütunlarda duplicate satırları bulma
SELECT
    Order_ID,
    Customer_ID,
    Date,
    Age,
    Gender,
    City,
    Product_Category,
    Unit_Price,
    Quantity,
    Discount_Amount,
    Total_Amount,
    Payment_Method,
    Device_Type,
    Session_Duration_Minutes,
    Pages_Viewed,
    Is_Returning_Customer,
    Delivery_Time_Days,
    Customer_Rating,
    COUNT(*) AS duplicate_count
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY
    Order_ID,
    Customer_ID,
    Date,
    Age,
    Gender,
    City,
    Product_Category,
    Unit_Price,
    Quantity,
    Discount_Amount,
    Total_Amount,
    Payment_Method,
    Device_Type,
    Session_Duration_Minutes,
    Pages_Viewed,
    Is_Returning_Customer,
    Delivery_Time_Days,
    Customer_Rating
HAVING COUNT(*) > 1;

-- duplicate sayısını görelim
-- “Kaç tane birebir aynı satır tekrar etmiş? bulmamızı sağlar.
SELECT
    COUNT(*) - COUNT(DISTINCT CONCAT(
        Order_ID, Customer_ID, Date, Age, Gender, City,
        Product_Category, Unit_Price, Quantity, Discount_Amount,
        Total_Amount, Payment_Method, Device_Type,
        Session_Duration_Minutes, Pages_Viewed,
        Is_Returning_Customer, Delivery_Time_Days, Customer_Rating
    )) AS duplicate_rows
FROM ecommerce_customer_behavior_dataset_v2;

--                     1) Müşteri Demoğrafisi 
-- Her yaştan kaç adet müşteri var? 
Select Age, count(Customer_ID)
From ecommerce_customer_behavior_dataset_v2
Group By age
Order By age;

-- Müşterilerin min ve max yaş aralığına bakalım
Select Min(Age) as min_age, Max(Age) as max_age
From ecommerce_customer_behavior_dataset_v2;

-- Müşterilerin cinsiyet dağılımına bakalım
Select Gender , count(Gender),
       ROUND(100.0 * COUNT(Gender) / SUM(COUNT(Gender)) OVER (),2) AS gender_percentage
From ecommerce_customer_behavior_dataset_v2
Group By Gender;

-- En fazla siparişin geldiği 10 şehir                 A
-- Gelire göre Top 10 şehir (Total_Amount)             B
-- Bu analiz “en çok para kazandıran şehirler”i gösterir.
-- Bu “hangi şehir daha yüksek harcıyor?” sorusudur:
SELECT
    City,
    COUNT(*) AS order_count,                            -- A
	ROUND(SUM(Total_Amount), 2) AS total_revenue,       -- B
	COUNT(DISTINCT Customer_ID) AS unique_customers     -- C
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY City
ORDER BY order_count DESC, 
		total_revenue  DESC,
        unique_customers DESC
LIMIT 10;
--                                    Orta Seviye Sorgu
-- Yukarıdaki Sorgunun Orta Seviye Sorgusu
-- Window Function ile Sıralama
-- İlk 10 şehri LIMIT yerine RANK() ile yapabiliriz.
WITH city_sales AS (
    SELECT
        City,
        COUNT(*) AS order_count,
        ROUND(SUM(Total_Amount),2) AS total_revenue,
        COUNT(DISTINCT Customer_ID) AS unique_customers
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY City
),
city_rank AS (
    SELECT *,
           RANK() OVER(
               ORDER BY order_count DESC,
                        total_revenue DESC,
                        unique_customers DESC
           ) AS city_rank
    FROM city_sales
)
SELECT *
FROM city_rank
WHERE city_rank <= 10;

--                          2) Ürün Analizi
-- En çok gelir getiren ürün kategorisini kontrol edelim
SELECT
    Product_Category,
    ROUND(SUM(Total_Amount), 2) AS total_revenue
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Product_Category
ORDER BY total_revenue DESC;

--                       Orta Seviye Sorgu
-- CTE - Window Function
-- Her kategorinin toplam gelirin yüzde kaçını oluşturduğunu hesaplayalım.
WITH category_sales AS (
    SELECT
        Product_Category,
        SUM(Total_Amount) AS total_revenue
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY Product_Category
)
SELECT
    Product_Category,
    ROUND(total_revenue,2) AS total_revenue,
    ROUND(
        total_revenue * 100 /
        SUM(total_revenue) OVER(),
        2
    ) AS revenue_percentage
FROM category_sales
ORDER BY total_revenue DESC;

-- Alternatif 
--  Case When İle Gelir Segmenti
WITH category_sales AS (
    SELECT
        Product_Category,
        SUM(Total_Amount) AS total_revenue
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY Product_Category
)
SELECT
    Product_Category,
    ROUND(total_revenue,2) AS total_revenue,
    CASE
        WHEN total_revenue >= 5000000 THEN 'High'
        WHEN total_revenue >= 2000000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_level
FROM category_sales
ORDER BY total_revenue DESC;

-- Kategori bazında ortalama sipariş değerini kontrol edelim
SELECT
    Product_Category,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Product_Category
ORDER BY avg_order_value DESC;

-- Sipariş sayıları ve satılan toplam adet ürün sayıları ile birlikte bakalım. 
SELECT
    Product_Category,
    COUNT(*) AS order_count,                                -- sipariş sayısı 
    SUM(Quantity) AS total_units_sold,                      -- satılan toplam birim(adet) ürün sayısı
    ROUND(SUM(Total_Amount), 2) AS total_revenue,           -- toplam gelir
    ROUND(AVG(Total_Amount), 2) AS avg_order_value,         -- ortalama sipariş değeri
    ROUND(AVG(Customer_Rating), 2) AS avg_customer_rating   -- Ortalam müşteri puan değerleri
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Product_Category
ORDER BY total_revenue DESC;

/*
Tablo şu soruları birlikte cevaplar:
En çok kazandıran kategori hangisi?                 Elektornik
En çok satan kategori hangisi?                      Spor   
Müşteri en çok hangi kategoriden memnun?            Ev ve bahçe ürünlerinden
En çok sipariş alan kategori?                       Spor
Sorularına cevap vermiş oluruz
*/ 

--                         Orta Seviye Sorgu
-- Danse_Rank ve Case Kullanalım
-- Kategorileri hem sıralayıp hem de performans etiketi ekleyelim.
WITH category_summary AS (
    SELECT
        Product_Category,
        COUNT(*) AS order_count,
        SUM(Quantity) AS total_units_sold,
        SUM(Total_Amount) AS total_revenue,
        AVG(Total_Amount) AS avg_order_value,
        AVG(Customer_Rating) AS avg_customer_rating
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY Product_Category
)
SELECT
    Product_Category,
    order_count,
    total_units_sold,
    ROUND(total_revenue,2) AS total_revenue,
    ROUND(avg_order_value,2) AS avg_order_value,
    ROUND(avg_customer_rating,2) AS avg_customer_rating,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    CASE
        WHEN DENSE_RANK() OVER (ORDER BY total_revenue DESC) <= 2
            THEN 'Top Performer'
        WHEN DENSE_RANK() OVER (ORDER BY total_revenue DESC) <= 4
            THEN 'Average Performer'
        ELSE 'Low Performer'
    END AS performance_group
FROM category_summary
ORDER BY revenue_rank;
--                     3)Ödeme ve Cihaz Analizi
-- En çok kullanılan ödeme yöntemi, En çok gelir getiren ödeme yöntemi, ortalama harcama
SELECT
    Payment_Method,
    COUNT(*) AS order_count,
    ROUND(SUM(Total_Amount), 2) AS total_revenue,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Payment_Method
ORDER BY total_revenue DESC;

-- En çok kullanılan cihaz türü
SELECT
    Device_Type,
    COUNT(*) AS order_count,
    ROUND(SUM(Total_Amount), 2) AS total_revenue,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Device_Type
ORDER BY total_revenue DESC;

-- Mobile + Credit Card en güçlü kombinasyon mu?
SELECT
    Payment_Method,
    Device_Type,
    COUNT(*) AS order_count,
    ROUND(SUM(Total_Amount), 2) AS total_revenue,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Payment_Method, Device_Type
ORDER BY total_revenue DESC; 

/* Bu analiz ile:
Hangi ödeme yöntemi daha kârlı              Kredi kart
Hangi cihaz daha çok satış getiriyor        Mobile
Hangi kombinasyon en güçlü segment          kredi kart - mobile en güçlü kombinasyon
*/

--                        Orta Seviye Sorgu (A)
-- CTE + toplam içindeki pay + ranking + segmentasyon.
WITH combo_stats AS (
    SELECT
        Payment_Method,
        Device_Type,
        COUNT(*) AS order_count,
        SUM(Total_Amount) AS total_revenue,
        AVG(Total_Amount) AS avg_order_value
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY Payment_Method, Device_Type
)
SELECT
    Payment_Method,
    Device_Type,
    order_count,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(avg_order_value, 2) AS avg_order_value,

    -- toplam gelir içindeki pay
    ROUND(total_revenue * 100 /
        SUM(total_revenue) OVER(), 2) AS revenue_share,

    -- kombinasyon sıralaması
    RANK() OVER(ORDER BY total_revenue DESC ) AS revenue_rank
    
FROM combo_stats
ORDER BY revenue_rank;

--                    Orta Seviye Sorgu (B)
-- Yorum Ekleyelim
WITH combo_stats AS (
    SELECT
        Payment_Method,
        Device_Type,
        COUNT(*) AS order_count,
        SUM(Total_Amount) AS total_revenue
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY Payment_Method, Device_Type
),
ranked AS (
    SELECT *,
           RANK() OVER(ORDER BY total_revenue DESC) AS rnk
    FROM combo_stats
)
SELECT
    Payment_Method,
    Device_Type,
    order_count,
    ROUND(total_revenue, 2) AS total_revenue,
    rnk,
    CASE
        WHEN rnk = 1 THEN 'Best Combination'
        WHEN rnk <= 3 THEN 'High Performance'
        ELSE 'Standard'
    END AS performance_label
FROM ranked
ORDER BY rnk;

--                4) Mişteri Memnuniyeti
-- Genel müşteri memnuniyeti
SELECT
    ROUND(AVG(Customer_Rating), 2) AS avg_customer_rating
FROM ecommerce_customer_behavior_dataset_v2;

-- Puan dağılımı
-- 1,2,3,4,5 puanlarının yüzdelik dağılımı
SELECT
    Customer_Rating,
    COUNT(*) AS review_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),2) AS percentage
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Customer_Rating
ORDER BY Customer_Rating;

-- Kategori bazında memnuniyet
SELECT
    Product_Category,
    ROUND(AVG(Customer_Rating), 2) AS avg_rating
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Product_Category
ORDER BY avg_rating DESC;
-- En yüksek müşteri memnuniyetine sahip kategori  -- Ev ve bahçe ürünleri kategorisi

-- Teslimat süresi ve memnuniyeti
SELECT
    Delivery_Time_Days,
    ROUND(AVG(Customer_Rating), 2) AS avg_rating
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Delivery_Time_Days
ORDER BY Delivery_Time_Days;

-- Yeni vs Geri Dönen Müşteri Memnuniyeti
SELECT
    Is_Returning_Customer,
    COUNT(*) AS order_count,
    ROUND(AVG(Customer_Rating), 2) AS avg_rating
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Is_Returning_Customer;

--                    Orta Seviye Sorgu
WITH customer_stats AS (
    SELECT
        Is_Returning_Customer,
        COUNT(*) AS order_count,
        AVG(Customer_Rating) AS avg_rating
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY Is_Returning_Customer
)
SELECT
    Is_Returning_Customer,
    order_count,
    ROUND(avg_rating, 2) AS avg_rating,

    -- toplam sipariş içindeki pay
    ROUND(order_count * 100.0 /
        SUM(order_count) OVER(), 2) AS order_share,

    -- karşılaştırmalı sıralama
    RANK() OVER (ORDER BY avg_rating DESC) AS rating_rank
    
FROM customer_stats
ORDER BY rating_rank;

-- Yukarıdaki sorgu ile ;
 /*
 Yeni müşteri mi daha yüksek puan veriyor, yoksa geri dönen mi?
Hangi grup daha fazla sipariş üretiyor?
Memnuniyet ve hacim birlikte nasıl değişiyor?
*/

-- Geri dönen müşteriler daha mı memnun?  3.90 ile daha memnuniyet ortalaması 3.88 ile yeni müşterilerden daha fazla.

-- Ürün kategorilerine; satılan adet, ortalama müşteri mennuniyet oranı, ortalama teslimat sürelerini,
-- ortalama gelir oranını bakalım.
SELECT
    Product_Category,
    COUNT(*) AS order_count,                               -- sipariş sayısı
    ROUND(AVG(Customer_Rating), 2) AS avg_rating,
    ROUND(AVG(Delivery_Time_Days), 2) AS avg_delivery_days,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Product_Category
ORDER BY avg_rating DESC;
--                                   Orta Seviye Sorgu
WITH category_stats AS (
    SELECT
        Product_Category,
        COUNT(*) AS order_count,
        AVG(Customer_Rating) AS avg_rating,
        AVG(Delivery_Time_Days) AS avg_delivery_days,
        AVG(Total_Amount) AS avg_order_value
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY Product_Category
)
SELECT
    Product_Category,
    order_count,
    ROUND(avg_rating, 2) AS avg_rating,
    ROUND(avg_delivery_days, 2) AS avg_delivery_days,
    ROUND(avg_order_value, 2) AS avg_order_value,

    -- toplam sipariş içindeki pay
    ROUND( order_count * 100.0 /
        SUM(order_count) OVER(), 2) AS order_share,

    -- rating'e göre sıralama
    RANK() OVER (ORDER BY avg_rating DESC) AS rating_rank,

    -- teslimat süresi performansı
    RANK() OVER (ORDER BY avg_delivery_days ASC) AS delivery_rank

FROM category_stats
ORDER BY rating_rank;

-- Bu sorgu ile ; 
/* Rating’e göre en iyi kategori
Delivery speed’e göre en iyi kategori
En hızlı ama düşük rating mi?
En yüksek rating ama yavaş teslimat mı?   sorgularuna yanıt bulabilirz.
*/ 
--                        5) Zaman Serisi Analizi
-- Aylık Gelir Trendi
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    ROUND(SUM(Total_Amount), 2) AS total_revenue
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY month
ORDER BY month;

/*
Gelir artıyor mu?       25 aylık veri olduğu için gelir belirli aylarda yükselik düşüyor. Bu veri setinde aylık trendlere bakılması daha doğru yaklaşım olur.
Sezonsallık var mı?  
						Haziran 2023'te düşüş var.
						Temmuz 2023'te belirgin yükseliş var.
						Aralık 2023 en yüksek aylardan biri.
						2024 Ocak-Mart döneminde düşüş görülüyor.       
En iyi ay hangisi?      2023-12    
*/

-- Aylık Sipariş Trendi
SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    COUNT(*) AS total_orders
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY month
ORDER BY month;

-- Sipariş hacmi zamanla değişiyor mu?


-- Aylık Ortalama Sipariş Tutarı (AOV)
SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY month
ORDER BY month;

-- Müşteriler zamanla daha fazla mı harcıyor?

-- Aylık Müşteri Memnuniyeti
SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    ROUND(AVG(Customer_Rating), 2) AS avg_rating
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY month
ORDER BY month;

-- Memnuniyet zamanla değişiyor mu?

-- Aylık Benzersiz Müşteri Sayısı
SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    COUNT(DISTINCT Customer_ID) AS unique_customers
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY month
ORDER BY month;

-- Müşteri tabanı büyüyor mu?

-- Birleştirilmiş Zaman Serisi Analizi 
SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    ROUND(SUM(Total_Amount), 2) AS total_revenue,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value,
    ROUND(AVG(Customer_Rating), 2) AS avg_rating
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY month
ORDER BY month;

--                       Orta Seviye Sorgu
WITH monthly_stats AS (
    SELECT
        DATE_FORMAT(Date, '%Y-%m') AS month,
        ROUND(SUM(Total_Amount), 2) AS total_revenue
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY DATE_FORMAT(Date, '%Y-%m')
)
SELECT
    month,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
	ROUND(SUM(total_revenue) OVER (ORDER BY month), 2) AS running_total_revenue
FROM monthly_stats;

/* Bu sorgu ile ; 
gelir artıyor mu azalıyor mu?
hangi ay en iyi performans?
hangi ay kampanya etkisi var?
Ay ay gelir artışını birikimli şekilde göster?
*/
--                                     6) Müşteri Sadakati
--  Geri dönen müşteri oranı
SELECT
    Is_Returning_Customer,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),2) AS percentage
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Is_Returning_Customer;

-- Müşterilerin ne kadarı tekrar alışveriş yapıyor? %88 

-- Sadık müşteri katkısı (gelir bazlı)
SELECT
    Is_Returning_Customer,
    ROUND(SUM(Total_Amount), 2) AS total_revenue,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Is_Returning_Customer;

-- Sadık müşteriler daha çok mu harcıyor?  Evet

--  Müşteri başına sipariş sayısı
SELECT
    Customer_ID,
    COUNT(*) AS total_orders
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Customer_ID
ORDER BY total_orders DESC;

-- Sadık müşteri segmentasyonu
SELECT
    Customer_ID,
    COUNT(*) AS total_orders,
    ROUND(SUM(Total_Amount), 2) AS total_spent
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Customer_ID
HAVING COUNT(*) > 1
ORDER BY total_spent DESC;

-- 1’den fazla alışveriş yapan müşteriler

-- 
/*
Müşterilerin ne kadarı tekrar alışveriş yapıyor?
Tekrar eden müşteriler daha fazla mı harcıyor?
En değerli müşteriler kim?
Sadık müşteri segmenti ne kadar gelir getiriyor?
*/

SELECT
    Customer_ID,
    COUNT(*) AS order_count,
    ROUND(SUM(Total_Amount),2) AS total_spent,
    ROUND(AVG(Total_Amount), 2) AS avg_order_value,
    MAX(Is_Returning_Customer) AS returning_flag
FROM ecommerce_customer_behavior_dataset_v2
GROUP BY Customer_ID
ORDER BY total_spent DESC;

--                    Orta Seviye Sorgu
/*
müşteri segmentasyonu (CASE WHEN)
ranking (RANK)
harcama payı (window function)
CTE yapısı
*/

WITH customer_summary AS (
    SELECT
        Customer_ID,
        COUNT(*) AS order_count,
        SUM(Total_Amount) AS total_spent,
        AVG(Total_Amount) AS avg_order_value,
        MAX(Is_Returning_Customer) AS returning_flag
    FROM ecommerce_customer_behavior_dataset_v2
    GROUP BY Customer_ID
)
SELECT
    Customer_ID,
    order_count,
    ROUND(total_spent, 2) AS total_spent,
    ROUND(avg_order_value, 2) AS avg_order_value,
    returning_flag,

    -- toplam gelir içindeki pay
    ROUND(total_spent * 100 /
        SUM(total_spent) OVER(), 2) AS revenue_share,

    -- müşteri sıralaması
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank,

    -- müşteri segmenti
    CASE
        WHEN total_spent >= 30000 THEN 'High Value'
        WHEN total_spent >= 10000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS customer_segment

FROM customer_summary
ORDER BY spending_rank;










