-- Providers table to store healthcare provider information
CREATE TABLE IF NOT EXISTS providers (
    id SERIAL PRIMARY KEY,
    provider_code VARCHAR(50) UNIQUE NOT NULL,
    provider_name VARCHAR(255) NOT NULL,
    provider_type VARCHAR(100), -- Hospital, Clinic, etc.
    address TEXT,
    phone VARCHAR(20),
    fax VARCHAR(20),
    email VARCHAR(255),
    npi VARCHAR(20),
    tax_id VARCHAR(20),
    contract_status VARCHAR(50) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample providers from the dashboard
INSERT INTO providers (provider_code, provider_name, provider_type, contract_status) VALUES
('SILV001', 'Silvermine Medical Center', 'Hospital', 'Active'),
('EVER001', 'Evernorth Healthcare', 'Hospital', 'Active'),
('CASC001', 'Cascade I Medical', 'Hospital', 'Active'),
('PALI001', 'Palicade Regional', 'Hospital', 'Active'),
('TRIN001', 'Trinity Oal Hospital', 'Hospital', 'Active'),
('LUME001', 'LumenPoi Medical Center', 'Hospital', 'Active'),
('SAUR001', 'St. Aurelius Hospital', 'Hospital', 'Active'),
('COBA001', 'Cobalt Bay Medical', 'Hospital', 'Active');

-- Create index for faster lookups
CREATE INDEX idx_providers_code ON providers(provider_code);
CREATE INDEX idx_providers_name ON providers(provider_name);
