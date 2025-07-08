CREATE DATABASE company_db;

USE company_db;

-- T?o b?ng [dbo].[Divisions]
CREATE TABLE [dbo].[Divisions] (
    division_id INT PRIMARY KEY IDENTITY(1,1),
    division_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    created_at DATETIME DEFAULT GETDATE()
);

-- T?o b?ng [dbo].[Roles]
CREATE TABLE [dbo].[Roles] (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT GETDATE()
);

-- T?o b?ng [dbo].[Employees]
CREATE TABLE [dbo].[Employees] (
    employee_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
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

-- T?o b?ng [dbo].[LoginAccounts]
CREATE TABLE [dbo].[LoginAccounts] (
    account_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    last_login DATETIME,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (employee_id) REFERENCES [dbo].[Employees](employee_id)
);

-- Thêm d? li?u m?u cho b?ng [dbo].[Divisions]
INSERT INTO [dbo].[Divisions] (division_name, location) VALUES
('IT', 'T?ng 2, Tòa B'),
('QA', 'T?ng 3, Tòa B'),
('Sale', 'T?ng 4, Tòa B');

-- Thêm d? li?u m?u cho b?ng [dbo].[Roles]
INSERT INTO [dbo].[Roles] (role_name, description) VALUES
('Division Leader', 'Ng??i lãnh ??o toàn công ty'),
('Tr??ng nhóm', 'Qu?n lý nhóm nhân viên'),
('Nhân viên', 'Thành viên nhóm');

-- Thêm d? li?u m?u cho b?ng [dbo].[Employees]
-- A là Division Leader c?a toàn công ty
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id) VALUES
('A', '', 'a.mr@company.com', '2023-01-15', NULL, 1);

-- B là Tr??ng nhóm qu?n lý IT d??i A
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
('B', '', 'b.mr@company.com', '2023-02-10', 1, 2, 1);

-- C là Tr??ng nhóm qu?n lý Sale d??i A
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
('C', '', 'c.mr@company.com', '2023-02-15', 3, 2, 1);

-- Nguy?n Hoàng Bách là Tr??ng nhóm QA d??i A, không qu?n lý ai
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
('Hoàng Bách', 'Nguy?n', 'hoangbach.nguyen@company.com', '2025-07-08', 2, 2, 1);

-- D, E, F là Nhân viên d??i B (IT)
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
('D', '', 'd.mr@company.com', '2023-03-01', 1, 3, 2),
('E', '', 'e.mr@company.com', '2023-03-05', 1, 3, 2),
('F', '', 'f.mr@company.com', '2023-03-10', 1, 3, 2);

-- G, H là Nhân viên d??i C (Sale)
INSERT INTO [dbo].[Employees] (first_name, last_name, email, hire_date, division_id, role_id, manager_id) VALUES
('G', '', 'g.mr@company.com', '2023-04-01', 3, 3, 3),
('H', '', 'h.mr@company.com', '2023-04-05', 3, 3, 3);

-- Thêm tài kho?n ??ng nh?p cho t?t c? nhân viên v?i m?t kh?u
INSERT INTO [dbo].[LoginAccounts] (employee_id, username, password_hash, last_login) VALUES
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'a.mr@company.com'), 'mra', '123', '2025-07-01 09:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'b.mr@company.com'), 'mrb', '123', '2025-07-02 10:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'c.mr@company.com'), 'mrc', '123', '2025-07-03 11:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'd.mr@company.com'), 'mrd', '123', '2025-07-04 13:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'e.mr@company.com'), 'mre', '123', '2025-07-04 14:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'f.mr@company.com'), 'mrf', '123', '2025-07-04 15:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'g.mr@company.com'), 'mrg', '123', '2025-07-05 09:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'h.mr@company.com'), 'mrh', '123', '2025-07-05 10:00:00'),
((SELECT employee_id FROM [dbo].[Employees] WHERE email = 'hoangbach.nguyen@company.com'), 'hoangbach', '123', '2025-07-09 01:59:00');