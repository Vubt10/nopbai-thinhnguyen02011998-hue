-- Chuyển sang master để không còn đứng trong QLNhaTroThinhNg
USE master;
GO

-- Ngắt tất cả kết nối tới database
ALTER DATABASE QLNhaTroThinhNg SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Xóa database
DROP DATABASE QLNhaTroThinhNg;
GO

-- Tạo lại database
CREATE DATABASE QLNhaTroThinhNg;
GO
USE QLNhaTroThinhNg;
GO

-- Tạo bảng LOAINHA
CREATE TABLE LOAINHA (
    MaLoai INT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL
);
GO

-- Tạo bảng NGUOIDUNG
CREATE TABLE NGUOIDUNG (
    MaND INT IDENTITY(1,1) PRIMARY KEY,
    TenND NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác')),
    DienThoai VARCHAR(15) NOT NULL,
    Diachi NVARCHAR(100),
    Quan NVARCHAR(100),
    Email VARCHAR(100) NOT NULL UNIQUE
);
GO

-- Tạo bảng NHATRO
CREATE TABLE NHATRO (
    MaTro INT IDENTITY(1,1) PRIMARY KEY,
    MaLoai INT NOT NULL,
    DienTich FLOAT CHECK (DienTich > 0),
    GiaPhong DECIMAL(18,2) CHECK (GiaPhong > 0),
    Diachi NVARCHAR(100),
    Quan NVARCHAR(100),
    MoTa NVARCHAR(MAX),
    NgayDang DATE DEFAULT GETDATE(),
    MaNguoiLienHe INT NOT NULL,
    FOREIGN KEY (MaLoai) REFERENCES LOAINHA(MaLoai),
    FOREIGN KEY (MaNguoiLienHe) REFERENCES NGUOIDUNG(MaND)
);
GO

-- Tạo bảng DANHGIA
CREATE TABLE DANHGIA (
    MaDG INT IDENTITY(1,1) PRIMARY KEY,
    MaNgDG INT NOT NULL,       -- Người đánh giá
    MaTro INT NOT NULL,        -- Nhà trọ được đánh giá
    LikeDislike BIT NOT NULL,  -- 1 = Like, 0 = Dislike
    NoiDung NVARCHAR(MAX),
    NgayDG DATE DEFAULT GETDATE(),
    FOREIGN KEY (MaNgDG) REFERENCES NGUOIDUNG(MaND),
    FOREIGN KEY (MaTro) REFERENCES NHATRO(MaTro)
);
GO


-- Nhập dữ liệu cho LOAINHA (tối thiểu 3)
INSERT INTO LOAINHA (TenLoai)
VALUES (N'Nhà nguyên căn'),
       (N'Phòng trọ'),
       (N'Chung cư mini'),
       (N'Ký túc xá');

-- Nhập dữ liệu cho NGUOIDUNG (10 bản ghi)
INSERT INTO NGUOIDUNG (TenND, GioiTinh, DienThoai, Diachi, Quan, Email)
VALUES 
(N'Nguyễn Văn A', N'Nam', '0905123456', N'12 Lý Thường Kiệt', N'Tân Bình', 'vana@gmail.com'),
(N'Trần Thị B', N'Nữ', '0905123457', N'34 Cách Mạng Tháng 8', N'Quận 3', 'thib@gmail.com'),
(N'Lê Văn C', N'Nam', '0905123458', N'56 Nguyễn Trãi', N'Quận 5', 'vanc@gmail.com'),
(N'Phạm Thị D', N'Nữ', '0905123459', N'78 Lê Lợi', N'Quận 1', 'thid@gmail.com'),
(N'Hoàng Văn E', N'Nam', '0905123460', N'90 Hai Bà Trưng', N'Quận 3', 'vane@gmail.com'),
(N'Võ Thị F', N'Nữ', '0905123461', N'11 Nguyễn Đình Chiểu', N'Quận 1', 'thif@gmail.com'),
(N'Đỗ Văn G', N'Nam', '0905123462', N'22 Trần Hưng Đạo', N'Quận 5', 'vang@gmail.com'),
(N'Nguyễn Thị H', N'Nữ', '0905123463', N'33 Điện Biên Phủ', N'Bình Thạnh', 'thih@gmail.com'),
(N'Phan Văn I', N'Nam', '0905123464', N'44 Nguyễn Văn Cừ', N'Quận 10', 'vani@gmail.com'),
(N'Bùi Thị K', N'Nữ', '0905123465', N'55 Võ Văn Tần', N'Quận 3', 'thik@gmail.com');

-- Nhập dữ liệu cho NHATRO (10 bản ghi)
INSERT INTO NHATRO (MaLoai, DienTich, GiaPhong, Diachi, Quan, MoTa, MaNguoiLienHe)
VALUES
(1, 60, 6000000, N'101 Lê Hồng Phong', N'Quận 10', N'Nhà nguyên căn rộng rãi, gần chợ', 1),
(2, 20, 2500000, N'202 CMT8', N'Quận 3', N'Phòng trọ sạch sẽ, có gác lửng', 2),
(3, 35, 3500000, N'303 Nguyễn Đình Chiểu', N'Quận 3', N'Chung cư mini tiện nghi', 3),
(2, 18, 2200000, N'404 Trần Hưng Đạo', N'Quận 5', N'Phòng giá rẻ, gần trường học', 4),
(1, 70, 7000000, N'505 Lý Thái Tổ', N'Quận 10', N'Nhà nguyên căn 2 tầng', 5),
(3, 40, 4000000, N'606 Điện Biên Phủ', N'Bình Thạnh', N'Chung cư mini có thang máy', 6),
(2, 22, 2700000, N'707 Võ Văn Tần', N'Quận 3', N'Phòng thoáng mát, có ban công', 7),
(1, 80, 8000000, N'808 Nguyễn Văn Cừ', N'Quận 5', N'Nhà nguyên căn 3 tầng', 8),
(2, 25, 3000000, N'909 Hai Bà Trưng', N'Quận 1', N'Phòng trọ mới xây, có wifi', 9),
(3, 38, 3800000, N'1001 Nguyễn Trãi', N'Quận 5', N'Chung cư mini đầy đủ nội thất', 10);

-- Nhập dữ liệu cho DANHGIA (10 bản ghi)
INSERT INTO DANHGIA (MaNgDG, MaTro, LikeDislike, NoiDung)
VALUES
(1, 1, 1, N'Nhà đẹp, rộng rãi, chủ thân thiện'),
(2, 2, 1, N'Phòng sạch sẽ, giá hợp lý'),
(3, 3, 0, N'Chung cư hơi ồn, nhưng tiện nghi'),
(4, 4, 1, N'Phòng giá rẻ, phù hợp sinh viên'),
(5, 5, 1, N'Nhà rộng, thoáng mát, rất ưng ý'),
(6, 6, 0, N'Chung cư mini nhỏ, hơi chật'),
(7, 7, 1, N'Phòng đẹp, ban công thoáng'),
(8, 8, 0, N'Nhà nguyên căn nhưng hơi cũ'),
(9, 9, 1, N'Phòng mới xây, có wifi mạnh'),
(10, 10, 1, N'Chung cư nội thất đầy đủ, an ninh tốt');
