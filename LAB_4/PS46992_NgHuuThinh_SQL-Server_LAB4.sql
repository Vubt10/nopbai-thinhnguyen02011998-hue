USE QLDA
GO
--LAB 4:
-----CÂU 1:
--Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng 
--if…else và case 


/* ➢ Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là 
TenNV, cột thứ 2 nhận giá trị 
o “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong 
phòng mà nhân viên đó đang làm việc.  
o “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương 
trong phòng mà nhân viên đó đang làm việc. */
SELECT 
    NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS TenNV,
    CASE 
        WHEN NV.LUONG < (SELECT AVG(LUONG) FROM NHANVIEN WHERE PHG = NV.PHG)
            THEN 'TangLuong'
        ELSE 'KhongTangLuong'
    END AS XemXetTangLuong
FROM NHANVIEN NV;



/* ➢ Viết chương trình phân loại nhân viên dựa vào mức lương. 
o Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì 
xếp loại “nhanvien”, ngược lại xếp loại “truongphong” */
SELECT 
    CASE 
        WHEN NV.LUONG < (SELECT AVG(LUONG) FROM NHANVIEN WHERE PHG = NV.PHG) 
            THEN 'nhanvien'
        ELSE 'truongphong'
    END AS ChucVu,
    NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTenNV,
    NV.LUONG
FROM NHANVIEN NV;


--➢ .Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên 
SELECT 
    CASE 
        WHEN NV.PHAI = N'Nữ' THEN 'Ms. ' + NV.TENNV
        WHEN NV.PHAI = N'Nam' THEN 'Mr. ' + NV.TENNV
        ELSE NV.TENNV
    END AS TenHienThi
FROM NHANVIEN NV;


/* ➢ Viết chương trình tính thuế mà nhân viên phải đóng theo công thức: 
o 0<luong<25000 thì đóng 10% tiền lương 
o 25000<luong<30000 thì đóng 12% tiền lương 
o 30000<luong<40000 thì đóng 15% tiền lương 
o 40000<luong<50000 thì đóng 20% tiền lương 
o Luong>50000 đóng 25% tiền lương */
SELECT 
    NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTenNV,
    NV.LUONG,
    CASE 
        WHEN NV.LUONG > 0 AND NV.LUONG < 25000 THEN NV.LUONG * 0.10
        WHEN NV.LUONG >= 25000 AND NV.LUONG < 30000 THEN NV.LUONG * 0.12
        WHEN NV.LUONG >= 30000 AND NV.LUONG < 40000 THEN NV.LUONG * 0.15
        WHEN NV.LUONG >= 40000 AND NV.LUONG < 50000 THEN NV.LUONG * 0.20
        WHEN NV.LUONG >= 50000 THEN NV.LUONG * 0.25
        ELSE 0
    END AS ThuePhaiDong
FROM NHANVIEN NV;

-----CÂU 2:
--Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng vòng lặp 
--➢ Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn. 
DECLARE @i INT = 1
DECLARE @max INT

SELECT @max = MAX(MANV) FROM NHANVIEN

WHILE @i <= @max
BEGIN
    IF @i % 2 = 0
    BEGIN
        SELECT HONV, TENLOT, TENNV 
        FROM NHANVIEN
        WHERE MANV = @i
    END
    SET @i = @i + 1
END


--➢ Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng 
--không tính nhân viên có MaNV là 4.
DECLARE @i INT = 1
DECLARE @max INT

SELECT @max = MAX(MANV) FROM NHANVIEN

WHILE @i <= @max
BEGIN
    IF @i % 2 = 0 AND @i <> 4
    BEGIN
        SELECT HONV, TENLOT, TENNV 
        FROM NHANVIEN
        WHERE MANV = @i
    END
    SET @i = @i + 1
END


------CÂU 4:
--Quản lý lỗi chương trình  
/* ➢ Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước  
o Nhận thông báo “ thêm dư lieu thành cong” từ khối Try 
o Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Them dư lieu that bai” 
từ khối Catch */
BEGIN TRY
    INSERT INTO PhongBan (MaPHG, TenPHG, TRPHG, NG_NHANCHUC)
    VALUES (10, N'Phòng CNTT', '001', GETDATE());

    PRINT N'Thêm dữ liệu thành công';
END TRY
BEGIN CATCH
    PRINT N'Thêm dữ liệu thất bại';
    PRINT ERROR_MESSAGE();  -- hiển thị chi tiết lỗi
END CATCH;


--CÁCH 2:
BEGIN TRY
    INSERT INTO PhongBan (MaPHG, TenPHG, TRPHG, NG_NHANCHUC)
    VALUES ('ABC', N'Phòng Test', '002', GETDATE());  -- lỗi do 'ABC' không phải INT
    PRINT N'Thêm dữ liệu thành công';
END TRY
BEGIN CATCH
    PRINT N'Thêm dữ liệu thất bại';
    PRINT ERROR_MESSAGE();
END CATCH;



/* ➢ Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng 
RAISERROR để thông báo lỗi. */
DECLARE @chia INT = 10;
DECLARE @mau INT = 0;
DECLARE @ketqua INT;

BEGIN TRY
    SET @ketqua = @chia / @mau;
    PRINT 'Kết quả = ' + CAST(@ketqua AS VARCHAR);
END TRY
BEGIN CATCH
    RAISERROR('Lỗi: Không thể chia cho 0!', 16, 1);
END CATCH;
