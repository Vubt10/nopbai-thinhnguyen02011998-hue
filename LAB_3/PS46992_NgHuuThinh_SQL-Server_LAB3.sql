use QLDA
GO
--LAB 3:

select * from PHANCONG

------CÂU 1:
-- Với mỗi câu truy vấn cần thực hiện bằng 2 cách, dùng cast và convert.
/* Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên 
tham dự đề án đó.  
o Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân. 
o Xuất định dạng “tổng số giờ làm việc” kiểu varchar */

-- CAST
SELECT 
    DA.TENDEAN,
    CAST(SUM(PC.THOIGIAN) AS DECIMAL(10,2)) AS TongGio_Decimal,
    CAST(SUM(PC.THOIGIAN) AS VARCHAR(20)) AS TongGio_Varchar
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
--JOIN CONGVIEC CV ON DA.MADA = CV.MADA
--JOIN PHANCONG PC ON CV.MADA = PC.MADA AND CV.STT = PC.STT
GROUP BY DA.TENDEAN;


--CONVERT
SELECT 
    DA.TENDEAN,
    CONVERT(DECIMAL(10,2), SUM(PC.THOIGIAN)) AS TongGio_Decimal,
    CONVERT(VARCHAR(20), SUM(PC.THOIGIAN)) AS TongGio_Varchar
FROM DEAN DA
JOIN PHANCONG PC ON DA.MADA = PC.MADA
--JOIN CONGVIEC CV ON DA.MADA = CV.MADA
--JOIN PHANCONG PC ON CV.MADA = PC.MADA AND CV.STT = PC.STT
GROUP BY DA.TENDEAN;


/*Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm 
việc cho phòng ban đó. 
o Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu 
phẩy để phân biệt phần nguyên và phần thập phân. 
o Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3 
chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace */

--CAST
SELECT 
    PB.TENPHG,
    CAST(AVG(NV.LUONG) AS DECIMAL(10,2)) AS LuongTB_Decimal,
    -- format varchar có phân cách nghìn và dấu phẩy thập phân
    REPLACE(CONVERT(VARCHAR, CAST(AVG(NV.LUONG) AS MONEY),1), '.00', '') AS LuongTB_Varchar
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;

--CONVERT
SELECT 
    PB.TENPHG,
    CONVERT(DECIMAL(10,2), AVG(NV.LUONG)) AS LuongTB_Decimal,
    -- xuất dạng varchar, có dấu phân cách hàng nghìn
    REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, AVG(NV.LUONG)), 1), '.00', '') AS LuongTB_Varchar
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;



------CÂU 2:
--Sử dụng các hàm toán học 
/* ➢ Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên 
tham dự đề án đó. 
o Xuất định dạng “tổng số giờ làm việc” với hàm CEILING 
o Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR 
o Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân */
SELECT 
    DA.TENDEAN,
    CEILING(SUM(PC.THOIGIAN)) AS TongGio_Ceiling,
    FLOOR(SUM(PC.THOIGIAN))   AS TongGio_Floor,
    ROUND(SUM(PC.THOIGIAN), 2) AS TongGio_Round2
FROM DEAN DA
JOIN PHANCONG PC ON PC.MADA = DA.MADA
--JOIN CONGVIEC CV ON DA.MADA = CV.MADA
--JOIN PHANCONG PC ON CV.MADA = PC.MADA AND CV.STT = PC.STT
GROUP BY DA.TENDEAN;


/* ➢ Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương 
trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu" */
SELECT 
    PB.TENPHG, NV.HONV, NV.TENLOT, NV.TENNV, NV.LUONG
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
WHERE NV.LUONG > (
    SELECT ROUND(AVG(NV.LUONG), 2)
    FROM NHANVIEN NV
    JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
    WHERE PB.TENPHG = N'Nghiên cứu'
)
AND PB.TENPHG = N'Nghiên cứu';



-----CÂU 3:
--Sử dụng các hàm xử lý chuỗi 
/* ➢ Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân, 
thỏa các yêu cầu 
o Dữ liệu cột HONV được viết in hoa toàn bộ 
o Dữ liệu cột TENLOT được viết chữ thường toàn bộ 
o Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết 
thường( ví dụ: kHanh) 
o Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác 
như số nhà hay thành phố. */


SELECT 
    UPPER(NV.HONV) AS HoNV,
    LOWER(NV.TENLOT) AS TenLot,
    LOWER(LEFT(NV.TENNV,1)) 
        + UPPER(SUBSTRING(NV.TENNV,2,1)) 
        + LOWER(SUBSTRING(NV.TENNV,3,LEN(NV.TENNV)-2)) AS TenNV,
    LTRIM(
        SUBSTRING(
            NV.DCHI, 
            CHARINDEX(' ', NV.DCHI) + 1, 
            CHARINDEX(',', NV.DCHI) - CHARINDEX(' ', NV.DCHI) - 1
        )
    ) AS TenDuong
FROM NHANVIEN NV
WHERE NV.MANV IN (
    SELECT TN.MA_NVIEN
    FROM THANNHAN TN
    GROUP BY TN.MA_NVIEN
    HAVING COUNT(*) > 2
);



/* ➢ Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất, 
hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly” */
SELECT TOP 1
    PB.TENPHG,
    NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS TruongPhong,
    'Fpoly' AS TenThayThe
FROM PHONGBAN PB
JOIN NHANVIEN NV ON PB.TRPHG = NV.MANV
JOIN (
    SELECT PHG, COUNT(*) AS SoNV
    FROM NHANVIEN
    GROUP BY PHG
    ) AS T ON PB.MAPHG = T.PHG
    ORDER BY T.SoNV DESC;


------CÂU 4:
--Sử dụng các hàm ngày tháng năm 

--➢ Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
SELECT MANV, HONV, TENLOT, TENNV, NGSINH
FROM NHANVIEN
WHERE YEAR(NGSINH) BETWEEN 1960 AND 1965;

--➢ Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại. 
SELECT MANV, HONV, TENLOT, TENNV, NGSINH,
       DATEDIFF(YEAR, NGSINH, GETDATE()) 
       - CASE WHEN (MONTH(NGSINH) > MONTH(GETDATE())) 
                OR (MONTH(NGSINH) = MONTH(GETDATE()) AND DAY(NGSINH) > DAY(GETDATE()))
              THEN 1 ELSE 0 END AS Tuoi
FROM NHANVIEN;


--➢ Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy. 
SELECT MANV, HONV, TENLOT, TENNV, NGSINH,
       DATENAME(WEEKDAY, NGSINH) AS ThuSinh
FROM NHANVIEN;


--➢ Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng và ngày 
--nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)
SELECT 
    PB.TENPHG,
    COUNT(NV.MANV) AS SoLuongNV,
    TP.HONV + ' ' + TP.TENLOT + ' ' + TP.TENNV AS TruongPhong,
    FORMAT(PB.NG_NHANCHUC, 'dd-MM-yy') AS NgayNhanChuc
FROM PHONGBAN PB
JOIN NHANVIEN TP ON PB.TRPHG = TP.MANV
LEFT JOIN NHANVIEN NV ON NV.PHG = PB.MAPHG
GROUP BY PB.TENPHG, TP.HONV, TP.TENLOT, TP.TENNV, PB.NG_NHANCHUC;
