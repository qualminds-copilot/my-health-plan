-- Migration: Initial Schema Setup
-- Created: 2024-12-17T00:00:00.000Z
-- Description: Initial database schema for MyHealthPlan application

-- Remove PostgreSQL dump headers and ownership changes
-- Set up database configuration
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Create dashboard stats update function
CREATE OR REPLACE FUNCTION update_dashboard_stats() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO dashboard_stats (
        stat_date,
        due_today_count,
        high_priority_count,
        reminders_count,
        start_this_week_count,
        total_pending_count,
        total_in_review_count,
        total_approved_count,
        total_denied_count
    )
    SELECT 
        CURRENT_DATE,
        COUNT(*) FILTER (WHERE next_review_date::date = CURRENT_DATE),
        COUNT(*) FILTER (WHERE priority = 'High'),
        COUNT(*) FILTER (WHERE next_review_date::date = CURRENT_DATE),
        COUNT(*) FILTER (WHERE admission_date >= date_trunc('week', CURRENT_DATE) 
                          AND admission_date < date_trunc('week', CURRENT_DATE) + INTERVAL '1 week'),
        COUNT(*) FILTER (WHERE status = 'Pending'),
        COUNT(*) FILTER (WHERE status = 'In Review'),
        COUNT(*) FILTER (WHERE status = 'Approved'),
        COUNT(*) FILTER (WHERE status = 'Denied')
    FROM authorizations
    WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
    ON CONFLICT (stat_date) DO UPDATE SET
        due_today_count = EXCLUDED.due_today_count,
        high_priority_count = EXCLUDED.high_priority_count,
        reminders_count = EXCLUDED.reminders_count,
        start_this_week_count = EXCLUDED.start_this_week_count,
        total_pending_count = EXCLUDED.total_pending_count,
        total_in_review_count = EXCLUDED.total_in_review_count,
        total_approved_count = EXCLUDED.total_approved_count,
        total_denied_count = EXCLUDED.total_denied_count;
END;
$$;

-- Core Tables

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Members table
CREATE TABLE members (
    id SERIAL PRIMARY KEY,
    member_number VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(255),
    address TEXT,
    insurance_group VARCHAR(100),
    policy_number VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Providers table
CREATE TABLE providers (
    id SERIAL PRIMARY KEY,
    provider_code VARCHAR(50) NOT NULL UNIQUE,
    provider_name VARCHAR(255) NOT NULL,
    provider_type VARCHAR(100),
    address TEXT,
    phone VARCHAR(20),
    fax VARCHAR(20),
    email VARCHAR(255),
    npi VARCHAR(20),
    tax_id VARCHAR(20),
    contract_status VARCHAR(50) DEFAULT 'Active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Diagnoses table
CREATE TABLE diagnoses (
    id SERIAL PRIMARY KEY,
    diagnosis_code VARCHAR(20) NOT NULL UNIQUE,
    diagnosis_name VARCHAR(255) NOT NULL,
    description TEXT,
    icd_10_code VARCHAR(20),
    category VARCHAR(100),
    severity VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- DRG Codes table
CREATE TABLE drg_codes (
    id SERIAL PRIMARY KEY,
    drg_code VARCHAR(10) NOT NULL UNIQUE,
    drg_description TEXT,
    category VARCHAR(100),
    weight NUMERIC(5,3),
    los_geometric_mean NUMERIC(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Priority Levels table
CREATE TABLE priority_levels (
    id SERIAL PRIMARY KEY,
    priority_code VARCHAR(20) NOT NULL UNIQUE,
    priority_name VARCHAR(50) NOT NULL,
    description TEXT,
    color_code VARCHAR(10),
    sort_order INTEGER,
    is_active BOOLEAN DEFAULT true
);

-- Review Types table
CREATE TABLE review_types (
    id SERIAL PRIMARY KEY,
    review_code VARCHAR(50) NOT NULL UNIQUE,
    review_name VARCHAR(100) NOT NULL,
    description TEXT,
    typical_duration_hours INTEGER,
    is_active BOOLEAN DEFAULT true
);

-- Status Types table
CREATE TABLE status_types (
    id SERIAL PRIMARY KEY,
    status_code VARCHAR(50) NOT NULL UNIQUE,
    status_name VARCHAR(100) NOT NULL,
    description TEXT,
    color_code VARCHAR(10),
    is_final BOOLEAN DEFAULT false,
    sort_order INTEGER,
    is_active BOOLEAN DEFAULT true
);

-- Authorizations table
CREATE TABLE authorizations (
    id SERIAL PRIMARY KEY,
    authorization_number VARCHAR(50) NOT NULL UNIQUE,
    member_id INTEGER NOT NULL,
    provider_id INTEGER NOT NULL,
    diagnosis_id INTEGER,
    drg_code_id INTEGER,
    request_type VARCHAR(50) NOT NULL,
    review_type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'Medium' NOT NULL,
    received_date TIMESTAMP WITH TIME ZONE NOT NULL,
    admission_date DATE,
    requested_los INTEGER,
    approved_days INTEGER DEFAULT 0,
    next_review_date TIMESTAMP WITH TIME ZONE,
    last_review_date TIMESTAMP WITH TIME ZONE,
    status VARCHAR(50) DEFAULT 'Pending' NOT NULL,
    pos VARCHAR(10),
    medical_necessity TEXT,
    clinical_notes TEXT,
    denial_reason TEXT,
    appeal_notes TEXT,
    created_by INTEGER,
    assigned_to INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (provider_id) REFERENCES providers(id),
    FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(id),
    FOREIGN KEY (drg_code_id) REFERENCES drg_codes(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (assigned_to) REFERENCES users(id)
);

-- Authorization Documents table
CREATE TABLE authorization_documents (
    id SERIAL PRIMARY KEY,
    authorization_id INTEGER NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    document_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500),
    file_size INTEGER,
    mime_type VARCHAR(100),
    uploaded_by INTEGER,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (authorization_id) REFERENCES authorizations(id),
    FOREIGN KEY (uploaded_by) REFERENCES users(id)
);

-- Authorization History table
CREATE TABLE authorization_history (
    id SERIAL PRIMARY KEY,
    authorization_id INTEGER NOT NULL,
    status_from VARCHAR(50),
    status_to VARCHAR(50) NOT NULL,
    changed_by INTEGER,
    change_reason TEXT,
    notes TEXT,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (authorization_id) REFERENCES authorizations(id),
    FOREIGN KEY (changed_by) REFERENCES users(id)
);

-- Authorization Notes table
CREATE TABLE authorization_notes (
    id SERIAL PRIMARY KEY,
    authorization_id INTEGER NOT NULL,
    note_type VARCHAR(50) NOT NULL,
    note_text TEXT NOT NULL,
    created_by INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_private BOOLEAN DEFAULT false,
    FOREIGN KEY (authorization_id) REFERENCES authorizations(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Dashboard Stats table
CREATE TABLE dashboard_stats (
    id SERIAL PRIMARY KEY,
    stat_date DATE DEFAULT CURRENT_DATE NOT NULL UNIQUE,
    due_today_count INTEGER DEFAULT 0,
    high_priority_count INTEGER DEFAULT 0,
    reminders_count INTEGER DEFAULT 0,
    start_this_week_count INTEGER DEFAULT 0,
    total_pending_count INTEGER DEFAULT 0,
    total_in_review_count INTEGER DEFAULT 0,
    total_approved_count INTEGER DEFAULT 0,
    total_denied_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create Authorization Summary View
CREATE VIEW authorization_summary AS
SELECT 
    a.id,
    a.authorization_number,
    a.priority,
    a.status,
    a.request_type,
    a.review_type,
    a.received_date,
    a.admission_date,
    a.approved_days,
    a.next_review_date,
    a.pos,
    CONCAT(m.first_name, ', ', m.last_name) AS member_name,
    m.member_number,
    p.provider_name,
    p.provider_code,
    d.diagnosis_code,
    d.diagnosis_name,
    drg.drg_code,
    drg.drg_description,
    CASE
        WHEN a.next_review_date::date = CURRENT_DATE THEN 'Due Today'
        WHEN a.next_review_date::date < CURRENT_DATE THEN 'Overdue'
        WHEN a.next_review_date::date <= CURRENT_DATE + INTERVAL '7 days' THEN 'Due This Week'
        ELSE 'Future'
    END AS review_status,
    EXTRACT(epoch FROM (a.next_review_date - a.received_date)) / 86400 AS days_pending
FROM authorizations a
    LEFT JOIN members m ON a.member_id = m.id
    LEFT JOIN providers p ON a.provider_id = p.id
    LEFT JOIN diagnoses d ON a.diagnosis_id = d.id
    LEFT JOIN drg_codes drg ON a.drg_code_id = drg.id;

-- Create Indexes for Performance
CREATE INDEX idx_auth_member ON authorizations(member_id);
CREATE INDEX idx_auth_provider ON authorizations(provider_id);
CREATE INDEX idx_auth_status ON authorizations(status);
CREATE INDEX idx_auth_priority ON authorizations(priority);
CREATE INDEX idx_auth_next_review ON authorizations(next_review_date);
CREATE INDEX idx_auth_received_date ON authorizations(received_date);
CREATE INDEX idx_auth_admission_date ON authorizations(admission_date);
CREATE INDEX idx_auth_number ON authorizations(authorization_number);

CREATE INDEX idx_members_member_number ON members(member_number);
CREATE INDEX idx_members_last_name ON members(last_name);

CREATE INDEX idx_providers_code ON providers(provider_code);
CREATE INDEX idx_providers_name ON providers(provider_name);

CREATE INDEX idx_diagnoses_code ON diagnoses(diagnosis_code);
CREATE INDEX idx_drg_code ON drg_codes(drg_code);

CREATE INDEX idx_priority_levels_code ON priority_levels(priority_code);
CREATE INDEX idx_review_types_code ON review_types(review_code);
CREATE INDEX idx_status_types_code ON status_types(status_code);

CREATE INDEX idx_auth_documents_auth_id ON authorization_documents(authorization_id);
CREATE INDEX idx_auth_history_auth_id ON authorization_history(authorization_id);
CREATE INDEX idx_auth_history_changed_at ON authorization_history(changed_at);
CREATE INDEX idx_auth_notes_auth_id ON authorization_notes(authorization_id);
CREATE INDEX idx_auth_notes_created_at ON authorization_notes(created_at);

CREATE INDEX idx_dashboard_stats_date ON dashboard_stats(stat_date);
