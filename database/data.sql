--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: diagnoses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.diagnoses (id, diagnosis_code, diagnosis_name, description, icd_10_code, category, severity, created_at) VALUES
(1, 'DKA', 'Diabetic Ketoacidosis', 'A serious complication of diabetes', NULL, 'Endocrine', 'High', '2025-06-16 11:38:41.698017'),
(2, 'CHF', 'Congestive Heart Failure', 'Heart cannot pump blood effectively', NULL, 'Cardiovascular', 'High', '2025-06-16 11:38:41.698017'),
(3, 'CKD', 'Chronic Kidney Disease', 'Long-term kidney damage', NULL, 'Renal', 'High', '2025-06-16 11:38:41.698017'),
(4, 'COPD', 'Chronic Obstructive Pulmonary Disease', 'Lung disease that blocks airflow', NULL, 'Respiratory', 'Medium', '2025-06-16 11:38:41.698017'),
(5, 'UTI', 'Urinary Tract Infection', 'Infection in urinary system', NULL, 'Genitourinary', 'Medium', '2025-06-16 11:38:41.698017'),
(6, 'CELLULITIS', 'Cellulitis', 'Bacterial skin infection', NULL, 'Dermatologic', 'Medium', '2025-06-16 11:38:41.698017');


--
-- Data for Name: drg_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.drg_codes (id, drg_code, drg_description, category, weight, los_geometric_mean, created_at) VALUES
(1, '637', 'Diabetes with complications', 'Endocrine', 1.245, 4.20, '2025-06-16 11:38:41.698017'),
(2, '291', 'Heart failure and shock with MCC', 'Cardiovascular', 1.678, 5.80, '2025-06-16 11:38:41.698017'),
(3, '687', 'Kidney and urinary tract infections with MCC', 'Renal', 1.234, 4.50, '2025-06-16 11:38:41.698017'),
(4, '688', 'Kidney and urinary tract infections without MCC', 'Renal', 0.987, 3.20, '2025-06-16 11:38:41.698017'),
(5, '638', 'Diabetes with complications and comorbidities', 'Endocrine', 1.345, 4.80, '2025-06-16 11:38:41.698017'),
(6, '602', 'Cellulitis without MCC', 'Dermatologic', 0.876, 3.50, '2025-06-16 11:38:41.698017'),
(7, '191', 'Chronic obstructive pulmonary disease with MCC', 'Respiratory', 1.456, 5.10, '2025-06-16 11:38:41.698017'),
(8, '690', 'Kidney and urinary tract infections with complications', 'Renal', 1.123, 3.80, '2025-06-16 11:38:41.698017');


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.members (id, member_number, first_name, last_name, date_of_birth, gender, phone, email, address, insurance_group, policy_number, created_at, updated_at) VALUES
(1, 'MEM001', 'Robert', 'Abbott', '1985-03-15', 'M', NULL, NULL, NULL, 'Silvermine', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(2, 'MEM002', 'Samuel', 'Perry', '1978-07-22', 'M', NULL, NULL, NULL, 'Evernorth', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(3, 'MEM003', 'Kate', 'Sawyer', '1992-11-08', 'F', NULL, NULL, NULL, 'Cascade I', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(4, 'MEM004', 'Laura', 'Smith', '1981-05-30', 'F', NULL, NULL, NULL, 'Palicade R', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(5, 'MEM005', 'Renee', 'Rutherford', '1975-09-12', 'F', NULL, NULL, NULL, 'Trinity Oal', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(6, 'MEM006', 'Mike', 'Andrews', '1988-12-04', 'M', NULL, NULL, NULL, 'LumenPoi', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(7, 'MEM007', 'James', 'Oliver', '1973-04-18', 'M', NULL, NULL, NULL, 'St. Aureliu', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(8, 'MEM008', 'John', 'Emerson', '1990-08-25', 'M', NULL, NULL, NULL, 'Cobalt Bay', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(9, 'MEM009', 'Samuel', 'Perry', '1982-01-14', 'M', NULL, NULL, NULL, 'Trinity Oal', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639'),
(10, 'MEM010', 'Laura', 'Smith', '1987-06-09', 'F', NULL, NULL, NULL, 'St. Aureliu', NULL, '2025-06-16 11:38:23.494639', '2025-06-16 11:38:23.494639');


--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.providers (id, provider_code, provider_name, provider_type, address, phone, fax, email, npi, tax_id, contract_status, created_at, updated_at) VALUES
(1, 'SILV001', 'Silvermine Medical Center', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-06-16 11:38:33.405104', '2025-06-16 11:38:33.405104'),
(2, 'EVER001', 'Evernorth Healthcare', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-06-16 11:38:33.405104', '2025-06-16 11:38:33.405104'),
(3, 'CASC001', 'Cascade I Medical', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-06-16 11:38:33.405104', '2025-06-16 11:38:33.405104'),
(4, 'PALI001', 'Palicade Regional', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-06-16 11:38:33.405104', '2025-06-16 11:38:33.405104'),
(5, 'TRIN001', 'Trinity Oal Hospital', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-06-16 11:38:33.405104', '2025-06-16 11:38:33.405104'),
(6, 'LUME001', 'LumenPoi Medical Center', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-06-16 11:38:33.405104', '2025-06-16 11:38:33.405104'),
(7, 'SAUR001', 'St. Aurelius Hospital', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-06-16 11:38:33.405104', '2025-06-16 11:38:33.405104'),
(8, 'COBA001', 'Cobalt Bay Medical', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-06-16 11:38:33.405104', '2025-06-16 11:38:33.405104');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--


INSERT INTO public.users (id, username, email, password_hash, full_name, role, created_at, updated_at) VALUES
(1, 'admin', 'admin@myhealthplan.com', '$2b$10$UkbPFVCy7mrJrOjaQ4V4OeVkH7.i6/IAML2k1n9o.7efwpUScN.VW', 'System Administrator', 'admin', '2025-06-16 11:38:05.214214', '2025-06-16 11:38:05.214214'),
(2, 'maria.hartsell', 'maria.hartsell@myhealthplan.com', '$2b$10$UkbPFVCy7mrJrOjaQ4V4OeVkH7.i6/IAML2k1n9o.7efwpUScN.VW', 'Maria Hartsell', 'admin', '2025-06-16 11:38:05.214214', '2025-06-16 11:38:05.214214'),
(3, 'john.doe', 'john.doe@myhealthplan.com', '$2b$10$UkbPFVCy7mrJrOjaQ4V4OeVkH7.i6/IAML2k1n9o.7efwpUScN.VW', 'John Doe', 'user', '2025-06-16 11:38:05.214214', '2025-06-16 11:38:05.214214'),
(4, 'jane.smith', 'jane.smith@myhealthplan.com', '$2b$10$UkbPFVCy7mrJrOjaQ4V4OeVkH7.i6/IAML2k1n9o.7efwpUScN.VW', 'Jane Smith', 'user', '2025-06-16 11:38:05.214214', '2025-06-16 11:38:05.214214');


--
-- Data for Name: authorizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.authorizations (id, authorization_number, member_id, provider_id, diagnosis_id, drg_code_id, request_type, review_type, priority, received_date, admission_date, requested_los, approved_days, next_review_date, last_review_date, status, pos, medical_necessity, clinical_notes, denial_reason, appeal_notes, created_by, assigned_to, created_at, updated_at) VALUES
(1, '2025OP000389', 1, 1, 1, 1, 'Inpatient', 'Initial Review', 'High', '2025-06-16 01:15:00', '2025-06-15', NULL, 3, '2025-06-16 01:15:00', NULL, 'Pending', '637', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-15 00:00:00', '2025-06-16 11:39:47.378164'),
(2, '2025OP000387', 2, 2, 2, 2, 'Inpatient', 'Initial Review', 'High', '2025-06-16 02:30:00', '2025-06-16', NULL, 3, '2025-06-16 02:30:00', NULL, 'Pending', '291', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-14 00:00:00', '2025-06-16 11:39:47.378164'),
(3, '2025OP000928', 3, 3, 3, 3, 'Inpatient', 'Concurrent Review', 'High', '2025-06-16 03:45:00', '2025-06-15', NULL, 3, '2025-06-16 03:45:00', NULL, 'Pending', '687', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-13 00:00:00', '2025-06-16 11:39:47.378164'),
(4, '2025OP000278', 4, 4, 3, 4, 'Inpatient', 'Initial Review', 'High', '2025-06-16 04:00:00', '2025-06-16', NULL, 3, '2025-06-16 04:00:00', NULL, 'Pending', '688', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-12 00:00:00', '2025-06-16 11:39:47.378164'),
(5, '2025OP000378', 5, 5, 1, 1, 'Inpatient', 'Initial Review', 'High', '2025-06-16 05:15:00', '2025-06-15', NULL, 3, '2025-06-16 05:15:00', NULL, 'Pending', '637', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-11 00:00:00', '2025-06-16 11:39:47.378164'),
(6, '2025OP000312', 6, 6, 1, 5, 'Inpatient', 'Concurrent Review', 'High', '2025-06-16 06:30:00', '2025-06-16', NULL, 3, '2025-06-16 06:30:00', NULL, 'Appeal', '638', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-10 00:00:00', '2025-06-16 11:39:47.378164'),
(7, '2025OP000152', 7, 7, 6, 6, 'Inpatient', 'Concurrent Review', 'Medium', '2025-06-16 07:45:00', '2025-06-15', NULL, 3, '2025-06-16 07:45:00', NULL, 'In Review', '602', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-16 00:00:00', '2025-06-16 11:39:47.378164'),
(8, '2025OP000369', 8, 8, 4, 7, 'Inpatient', 'Initial Review', 'Medium', '2025-06-16 08:00:00', '2025-06-16', NULL, 3, '2025-06-16 08:00:00', NULL, 'Pending', '191', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-15 00:00:00', '2025-06-16 11:39:47.378164'),
(9, '2025OP000189', 9, 5, 5, 8, 'Inpatient', 'Concurrent Review', 'Medium', '2025-06-16 09:15:00', '2025-06-15', NULL, 3, '2025-06-17 09:00:00', NULL, 'Pending', '690', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-14 00:00:00', '2025-06-16 11:39:47.378164'),
(10, '2025OP000390', 10, 7, 1, 1, 'Inpatient', 'Initial Review', 'Medium', '2025-06-16 10:30:00', '2025-06-16', NULL, 3, '2025-06-18 10:00:00', NULL, 'In Review', '637', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-13 00:00:00', '2025-06-16 11:39:47.378164');


--
-- Data for Name: authorization_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- No data for authorization_documents table


--
-- Data for Name: authorization_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- No data for authorization_history table


--
-- Data for Name: authorization_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- No data for authorization_notes table


--
-- Data for Name: dashboard_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- No data for dashboard_stats table


--
-- Data for Name: priority_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.priority_levels (id, priority_code, priority_name, description, color_code, sort_order, is_active) VALUES
(1, 'HIGH', 'High', 'Urgent cases requiring immediate attention', '#dc3545', 1, true),
(2, 'MEDIUM', 'Medium', 'Standard priority cases', '#ffc107', 2, true),
(3, 'LOW', 'Low', 'Low priority cases', '#198754', 3, true);


--
-- Data for Name: review_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.review_types (id, review_code, review_name, description, typical_duration_hours, is_active) VALUES
(1, 'INITIAL', 'Initial Review', 'First review of authorization request', 24, true),
(2, 'CONCURRENT', 'Concurrent Review', 'Ongoing review during treatment', 8, true),
(3, 'RETROSPECTIVE', 'Retrospective Review', 'Review after treatment completion', 72, true),
(4, 'APPEAL', 'Appeal Review', 'Review of appealed decision', 48, true);


--
-- Data for Name: status_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.status_types (id, status_code, status_name, description, color_code, is_final, sort_order, is_active) VALUES
(1, 'PENDING', 'Pending', 'Awaiting review', '#ffc107', false, 1, true),
(2, 'IN_REVIEW', 'In Review', 'Currently being reviewed', '#0dcaf0', false, 2, true),
(3, 'APPROVED', 'Approved', 'Authorization approved', '#198754', true, 3, true),
(4, 'DENIED', 'Denied', 'Authorization denied', '#dc3545', true, 4, true),
(5, 'APPEAL', 'Appeal', 'Under appeal process', '#dc3545', false, 5, true),
(6, 'EXPIRED', 'Expired', 'Authorization expired', '#6c757d', true, 6, true);


--
-- Name: authorization_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authorization_documents_id_seq', 1, false);


--
-- Name: authorization_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authorization_history_id_seq', 1, false);


--
-- Name: authorization_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authorization_notes_id_seq', 1, false);


--
-- Name: authorizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authorizations_id_seq', 10, true);


--
-- Name: dashboard_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboard_stats_id_seq', 1, false);


--
-- Name: diagnoses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.diagnoses_id_seq', 6, true);


--
-- Name: drg_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.drg_codes_id_seq', 8, true);


--
-- Name: members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.members_id_seq', 10, true);


--
-- Name: priority_levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.priority_levels_id_seq', 3, true);


--
-- Name: providers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.providers_id_seq', 8, true);


--
-- Name: review_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_types_id_seq', 4, true);


--
-- Name: status_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_types_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- PostgreSQL database dump complete
--

