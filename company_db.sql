
CREATE DATABASE company_db

USE company_db;

-- Tạo bảng [dbo].[Divisions]
CREATE TABLE [dbo].[Divisions] (
    division_id INT PRIMARY KEY IDENTITY(1,1),
    division_name NVARCHAR(100) NOT NULL,
    location NVARCHAR(100),
    created_at DATETIME DEFAULT GETDATE()
);

-- Tạo bảng [dbo].[Roles]
CREATE TABLE [dbo].[Roles] (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255), -- Thay TEXT bằng NVARCHAR cho nhất quán
    created_at DATETIME DEFAULT GETDATE()
);

-- Tạo bảng [dbo].[Employees]
CREATE TABLE [dbo].[Employees] (
    employee_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    division_id INT,
    role_id INT,
    manager_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (division_id) REFERENCES [dbo].[Divisions](division_id),
    FOREIGN KEY (role_id) REFERENCES [dbo].[Roles](role_id),
    FOREIGN KEY (manager_id) REFERENCES [dbo].[Employees](employee_id)
);

-- Tạo bảng [dbo].[Accounts] (đổi tên từ LoginAccounts cho khớp)
CREATE TABLE [dbo].[Accounts] (
    account_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    last_login DATETIME,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (employee_id) REFERENCES [dbo].[Employees](employee_id)
);

-- Thêm dữ liệu mẫu cho bảng [dbo].[Divisions]
INSERT INTO [dbo].[Divisions] (division_name, location) VALUES
(N'IT', N'Tầng 2, Tòa B'),
(N'QA', N'Tầng 3, Tòa B'),
(N'Sale', N'Tầng 4, Tòa B');

-- Thêm dữ liệu mẫu cho bảng [dbo].[Roles]
INSERT INTO [dbo].[Roles] (role_name, description) VALUES
(N'Division Leader', N'Người lãnh đạo toàn công ty'),
(N'Trưởng nhóm', N'Quản lý nhóm nhân viên'),
(N'Nhân viên', N'Thành viên nhóm');

-- Thêm dữ liệu mẫu cho bảng [dbo].[Employees]
-- A là Division Leader của toàn công ty
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id) VALUES
(N'A', N'', 'a.mr@company.com', '2023-01-15', NULL, 1);

-- B là Trưởng nhóm quản lý IT dưới A
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
(N'B', N'', 'b.mr@company.com', '2023-02-10', 1, 2, 1);

-- C là Trưởng nhóm quản lý Sale dưới A
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
(N'C', N'', 'c.mr@company.com', '2023-02-15', 3, 2, 1);

-- Nguyễn Hoàng Bách là Trưởng nhóm QA dưới A, không quản lý ai
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
(N'Hoàng Bách', N'Nguyễn', 'hoangbach.nguyen@company.com', '2025-07-08', 2, 2, 1);

-- D, E, F là Nhân viên dưới B (IT)
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
(N'D', N'', 'd.mr@company.com', '2023-03-01', 1, 3, 2),
(N'E', N'', 'e.mr@company.com', '2023-03-05', 1, 3, 2),
(N'F', N'', 'f.mr@company.com', '2023-03-10', 1, 3, 2);

-- G, H là Nhân viên dưới C (Sale)
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
(N'G', N'', 'g.mr@company.com', '2023-04-01', 3, 3, 3),
(N'H', N'', 'h.mr@company.com', '2023-04-05', 3, 3, 3);

-- Thêm tài khoản đăng nhập cho tất cả nhân viên với mật khẩu
INSERT INTO [dbo].[Accounts] (employee_id, username, password_hash, last_login) VALUES
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'a.mr@company.com'), 'mra', '123', '2025-07-01 09:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'b.mr@company.com'), 'mrb', '123', '2025-07-02 10:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'c.mr@company.com'), 'mrc', '123', '2025-07-03 11:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'd.mr@company.com'), 'mrd', '123', '2025-07-04 13:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'e.mr@company.com'), 'mre', '123', '2025-07-04 14:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'f.mr@company.com'), 'mrf', '123', '2025-07-04 15:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'g.mr@company.com'), 'mrg', '123', '2025-07-05 09:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'h.mr@company.com'), 'mrh', '123', '2025-07-05 10:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'hoangbach.nguyen@company.com'), 'hoangbach', '123', '2025-07-09 01:59:00');

CREATE TABLE [dbo].[LeaveRequests] (
    id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason NVARCHAR(255) NOT NULL,
    status NVARCHAR(50) DEFAULT 'Inprogress',
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (employee_id) REFERENCES [dbo].[Employees](employee_id)
);