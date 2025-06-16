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

COPY public.diagnoses (id, diagnosis_code, diagnosis_name, description, icd_10_code, category, severity, created_at) FROM stdin;
1	DKA	Diabetic Ketoacidosis	A serious complication of diabetes	\N	Endocrine	High	2025-06-16 11:38:41.698017
2	CHF	Congestive Heart Failure	Heart cannot pump blood effectively	\N	Cardiovascular	High	2025-06-16 11:38:41.698017
3	CKD	Chronic Kidney Disease	Long-term kidney damage	\N	Renal	High	2025-06-16 11:38:41.698017
4	COPD	Chronic Obstructive Pulmonary Disease	Lung disease that blocks airflow	\N	Respiratory	Medium	2025-06-16 11:38:41.698017
5	UTI	Urinary Tract Infection	Infection in urinary system	\N	Genitourinary	Medium	2025-06-16 11:38:41.698017
6	CELLULITIS	Cellulitis	Bacterial skin infection	\N	Dermatologic	Medium	2025-06-16 11:38:41.698017
\.


--
-- Data for Name: drg_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drg_codes (id, drg_code, drg_description, category, weight, los_geometric_mean, created_at) FROM stdin;
1	637	Diabetes with complications	Endocrine	1.245	4.20	2025-06-16 11:38:41.698017
2	291	Heart failure and shock with MCC	Cardiovascular	1.678	5.80	2025-06-16 11:38:41.698017
3	687	Kidney and urinary tract infections with MCC	Renal	1.234	4.50	2025-06-16 11:38:41.698017
4	688	Kidney and urinary tract infections without MCC	Renal	0.987	3.20	2025-06-16 11:38:41.698017
5	638	Diabetes with complications and comorbidities	Endocrine	1.345	4.80	2025-06-16 11:38:41.698017
6	602	Cellulitis without MCC	Dermatologic	0.876	3.50	2025-06-16 11:38:41.698017
7	191	Chronic obstructive pulmonary disease with MCC	Respiratory	1.456	5.10	2025-06-16 11:38:41.698017
8	690	Kidney and urinary tract infections with complications	Renal	1.123	3.80	2025-06-16 11:38:41.698017
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.members (id, member_number, first_name, last_name, date_of_birth, gender, phone, email, address, insurance_group, policy_number, created_at, updated_at) FROM stdin;
1	MEM001	Robert	Abbott	1985-03-15	M	\N	\N	\N	Silvermine	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
2	MEM002	Samuel	Perry	1978-07-22	M	\N	\N	\N	Evernorth	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
3	MEM003	Kate	Sawyer	1992-11-08	F	\N	\N	\N	Cascade I	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
4	MEM004	Laura	Smith	1981-05-30	F	\N	\N	\N	Palicade R	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
5	MEM005	Renee	Rutherford	1975-09-12	F	\N	\N	\N	Trinity Oal	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
6	MEM006	Mike	Andrews	1988-12-04	M	\N	\N	\N	LumenPoi	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
7	MEM007	James	Oliver	1973-04-18	M	\N	\N	\N	St. Aureliu	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
8	MEM008	John	Emerson	1990-08-25	M	\N	\N	\N	Cobalt Bay	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
9	MEM009	Samuel	Perry	1982-01-14	M	\N	\N	\N	Trinity Oal	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
10	MEM010	Laura	Smith	1987-06-09	F	\N	\N	\N	St. Aureliu	\N	2025-06-16 11:38:23.494639	2025-06-16 11:38:23.494639
\.


--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.providers (id, provider_code, provider_name, provider_type, address, phone, fax, email, npi, tax_id, contract_status, created_at, updated_at) FROM stdin;
1	SILV001	Silvermine Medical Center	Hospital	\N	\N	\N	\N	\N	\N	Active	2025-06-16 11:38:33.405104	2025-06-16 11:38:33.405104
2	EVER001	Evernorth Healthcare	Hospital	\N	\N	\N	\N	\N	\N	Active	2025-06-16 11:38:33.405104	2025-06-16 11:38:33.405104
3	CASC001	Cascade I Medical	Hospital	\N	\N	\N	\N	\N	\N	Active	2025-06-16 11:38:33.405104	2025-06-16 11:38:33.405104
4	PALI001	Palicade Regional	Hospital	\N	\N	\N	\N	\N	\N	Active	2025-06-16 11:38:33.405104	2025-06-16 11:38:33.405104
5	TRIN001	Trinity Oal Hospital	Hospital	\N	\N	\N	\N	\N	\N	Active	2025-06-16 11:38:33.405104	2025-06-16 11:38:33.405104
6	LUME001	LumenPoi Medical Center	Hospital	\N	\N	\N	\N	\N	\N	Active	2025-06-16 11:38:33.405104	2025-06-16 11:38:33.405104
7	SAUR001	St. Aurelius Hospital	Hospital	\N	\N	\N	\N	\N	\N	Active	2025-06-16 11:38:33.405104	2025-06-16 11:38:33.405104
8	COBA001	Cobalt Bay Medical	Hospital	\N	\N	\N	\N	\N	\N	Active	2025-06-16 11:38:33.405104	2025-06-16 11:38:33.405104
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, full_name, role, created_at, updated_at) FROM stdin;
1	maria.hartsell	maria.hartsell@myhealthplan.com	$2b$10$rQZ5vEd8.5J5K5Jn5xJ5Ke5J5K5J5K5J5K5J5K5J5K5J5K5J5K5J5K	Maria Hartsell	admin	2025-06-16 11:38:05.214214	2025-06-16 11:38:05.214214
2	john.doe	john.doe@myhealthplan.com	$2b$10$rQZ5vEd8.5J5K5Jn5xJ5Ke5J5K5J5K5J5K5J5K5J5K5J5K5J5K5J5K	John Doe	user	2025-06-16 11:38:05.214214	2025-06-16 11:38:05.214214
3	jane.smith	jane.smith@myhealthplan.com	$2b$10$rQZ5vEd8.5J5K5Jn5xJ5Ke5J5K5J5K5J5K5J5K5J5K5J5K5J5K5J5K	Jane Smith	user	2025-06-16 11:38:05.214214	2025-06-16 11:38:05.214214
4	admin	admin@myhealthplan.com	$2b$10$rQZ5vEd8.5J5K5Jn5xJ5Ke5J5K5J5K5J5K5J5K5J5K5J5K5J5K5J5K	System Administrator	admin	2025-06-16 11:38:05.214214	2025-06-16 11:38:05.214214
\.


--
-- Data for Name: authorizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authorizations (id, authorization_number, member_id, provider_id, diagnosis_id, drg_code_id, request_type, review_type, priority, received_date, admission_date, requested_los, approved_days, next_review_date, last_review_date, status, pos, medical_necessity, clinical_notes, denial_reason, appeal_notes, created_by, assigned_to, created_at, updated_at) FROM stdin;
1	2025OP000389	1	1	1	1	Inpatient	Initial Review	High	2025-06-16 01:15:00	2025-06-15	\N	3	2025-06-16 01:15:00	\N	Pending	637	\N	\N	\N	\N	\N	\N	2025-06-15 00:00:00	2025-06-16 11:39:47.378164
2	2025OP000387	2	2	2	2	Inpatient	Initial Review	High	2025-06-16 02:30:00	2025-06-16	\N	3	2025-06-16 02:30:00	\N	Pending	291	\N	\N	\N	\N	\N	\N	2025-06-14 00:00:00	2025-06-16 11:39:47.378164
3	2025OP000928	3	3	3	3	Inpatient	Concurrent Review	High	2025-06-16 03:45:00	2025-06-15	\N	3	2025-06-16 03:45:00	\N	Pending	687	\N	\N	\N	\N	\N	\N	2025-06-13 00:00:00	2025-06-16 11:39:47.378164
4	2025OP000278	4	4	3	4	Inpatient	Initial Review	High	2025-06-16 04:00:00	2025-06-16	\N	3	2025-06-16 04:00:00	\N	Pending	688	\N	\N	\N	\N	\N	\N	2025-06-12 00:00:00	2025-06-16 11:39:47.378164
5	2025OP000378	5	5	1	1	Inpatient	Initial Review	High	2025-06-16 05:15:00	2025-06-15	\N	3	2025-06-16 05:15:00	\N	Pending	637	\N	\N	\N	\N	\N	\N	2025-06-11 00:00:00	2025-06-16 11:39:47.378164
6	2025OP000312	6	6	1	5	Inpatient	Concurrent Review	High	2025-06-16 06:30:00	2025-06-16	\N	3	2025-06-16 06:30:00	\N	Appeal	638	\N	\N	\N	\N	\N	\N	2025-06-10 00:00:00	2025-06-16 11:39:47.378164
7	2025OP000152	7	7	6	6	Inpatient	Concurrent Review	Medium	2025-06-16 07:45:00	2025-06-15	\N	3	2025-06-16 07:45:00	\N	In Review	602	\N	\N	\N	\N	\N	\N	2025-06-16 00:00:00	2025-06-16 11:39:47.378164
8	2025OP000369	8	8	4	7	Inpatient	Initial Review	Medium	2025-06-16 08:00:00	2025-06-16	\N	3	2025-06-16 08:00:00	\N	Pending	191	\N	\N	\N	\N	\N	\N	2025-06-15 00:00:00	2025-06-16 11:39:47.378164
9	2025OP000189	9	5	5	8	Inpatient	Concurrent Review	Medium	2025-06-16 09:15:00	2025-06-15	\N	3	2025-06-17 09:00:00	\N	Pending	690	\N	\N	\N	\N	\N	\N	2025-06-14 00:00:00	2025-06-16 11:39:47.378164
10	2025OP000390	10	7	1	1	Inpatient	Initial Review	Medium	2025-06-16 10:30:00	2025-06-16	\N	3	2025-06-18 10:00:00	\N	In Review	637	\N	\N	\N	\N	\N	\N	2025-06-13 00:00:00	2025-06-16 11:39:47.378164
\.


--
-- Data for Name: authorization_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authorization_documents (id, authorization_id, document_type, document_name, file_path, file_size, mime_type, uploaded_by, uploaded_at) FROM stdin;
\.


--
-- Data for Name: authorization_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authorization_history (id, authorization_id, status_from, status_to, changed_by, change_reason, notes, changed_at) FROM stdin;
\.


--
-- Data for Name: authorization_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authorization_notes (id, authorization_id, note_type, note_text, created_by, created_at, is_private) FROM stdin;
\.


--
-- Data for Name: dashboard_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_stats (id, stat_date, due_today_count, high_priority_count, reminders_count, start_this_week_count, total_pending_count, total_in_review_count, total_approved_count, total_denied_count, created_at) FROM stdin;
\.


--
-- Data for Name: priority_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.priority_levels (id, priority_code, priority_name, description, color_code, sort_order, is_active) FROM stdin;
1	HIGH	High	Urgent cases requiring immediate attention	#dc3545	1	t
2	MEDIUM	Medium	Standard priority cases	#ffc107	2	t
3	LOW	Low	Low priority cases	#198754	3	t
\.


--
-- Data for Name: review_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review_types (id, review_code, review_name, description, typical_duration_hours, is_active) FROM stdin;
1	INITIAL	Initial Review	First review of authorization request	24	t
2	CONCURRENT	Concurrent Review	Ongoing review during treatment	8	t
3	RETROSPECTIVE	Retrospective Review	Review after treatment completion	72	t
4	APPEAL	Appeal Review	Review of appealed decision	48	t
\.


--
-- Data for Name: status_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_types (id, status_code, status_name, description, color_code, is_final, sort_order, is_active) FROM stdin;
1	PENDING	Pending	Awaiting review	#ffc107	f	1	t
2	IN_REVIEW	In Review	Currently being reviewed	#0dcaf0	f	2	t
3	APPROVED	Approved	Authorization approved	#198754	t	3	t
4	DENIED	Denied	Authorization denied	#dc3545	t	4	t
5	APPEAL	Appeal	Under appeal process	#dc3545	f	5	t
6	EXPIRED	Expired	Authorization expired	#6c757d	t	6	t
\.


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

