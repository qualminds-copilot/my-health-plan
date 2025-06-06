-- Members table to store member information
CREATE TABLE IF NOT EXISTS members (
    id SERIAL PRIMARY KEY,
    member_number VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(255),
    address TEXT,
    insurance_group VARCHAR(100),
    policy_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample members from the dashboard
INSERT INTO members (member_number, first_name, last_name, date_of_birth, gender, insurance_group) VALUES
('MEM001', 'Robert', 'Abbott', '1985-03-15', 'M', 'Silvermine'),
('MEM002', 'Samuel', 'Perry', '1978-07-22', 'M', 'Evernorth'),
('MEM003', 'Kate', 'Sawyer', '1992-11-08', 'F', 'Cascade I'),
('MEM004', 'Laura', 'Smith', '1981-05-30', 'F', 'Palicade R'),
('MEM005', 'Renee', 'Rutherford', '1975-09-12', 'F', 'Trinity Oal'),
('MEM006', 'Mike', 'Andrews', '1988-12-04', 'M', 'LumenPoi'),
('MEM007', 'James', 'Oliver', '1973-04-18', 'M', 'St. Aureliu'),
('MEM008', 'John', 'Emerson', '1990-08-25', 'M', 'Cobalt Bay'),
('MEM009', 'Samuel', 'Perry', '1982-01-14', 'M', 'Trinity Oal'),
('MEM010', 'Laura', 'Smith', '1987-06-09', 'F', 'St. Aureliu');

-- Create index for faster lookups
CREATE INDEX idx_members_member_number ON members(member_number);
CREATE INDEX idx_members_last_name ON members(last_name);
