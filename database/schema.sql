--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Database should be created manually or via separate script

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
-- Name: update_dashboard_stats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_dashboard_stats() RETURNS void
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


ALTER FUNCTION public.update_dashboard_stats() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: authorization_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authorization_documents (
    id integer NOT NULL,
    authorization_id integer NOT NULL,
    document_type character varying(100) NOT NULL,
    document_name character varying(255) NOT NULL,
    file_path character varying(500),
    file_size integer,
    mime_type character varying(100),
    uploaded_by integer,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.authorization_documents OWNER TO postgres;

--
-- Name: authorization_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authorization_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authorization_documents_id_seq OWNER TO postgres;

--
-- Name: authorization_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authorization_documents_id_seq OWNED BY public.authorization_documents.id;


--
-- Name: authorization_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authorization_history (
    id integer NOT NULL,
    authorization_id integer NOT NULL,
    status_from character varying(50),
    status_to character varying(50) NOT NULL,
    changed_by integer,
    change_reason text,
    notes text,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.authorization_history OWNER TO postgres;

--
-- Name: authorization_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authorization_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authorization_history_id_seq OWNER TO postgres;

--
-- Name: authorization_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authorization_history_id_seq OWNED BY public.authorization_history.id;


--
-- Name: authorization_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authorization_notes (
    id integer NOT NULL,
    authorization_id integer NOT NULL,
    note_type character varying(50) NOT NULL,
    note_text text NOT NULL,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_private boolean DEFAULT false
);


ALTER TABLE public.authorization_notes OWNER TO postgres;

--
-- Name: authorization_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authorization_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authorization_notes_id_seq OWNER TO postgres;

--
-- Name: authorization_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authorization_notes_id_seq OWNED BY public.authorization_notes.id;


--
-- Name: authorizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authorizations (
    id integer NOT NULL,
    authorization_number character varying(50) NOT NULL,
    member_id integer NOT NULL,
    provider_id integer NOT NULL,
    diagnosis_id integer,
    drg_code_id integer,
    request_type character varying(50) NOT NULL,
    review_type character varying(50) NOT NULL,
    priority character varying(20) DEFAULT 'Medium'::character varying NOT NULL,
    received_date timestamp without time zone NOT NULL,
    admission_date date,
    requested_los integer,
    approved_days integer DEFAULT 0,
    next_review_date timestamp without time zone,
    last_review_date timestamp without time zone,
    status character varying(50) DEFAULT 'Pending'::character varying NOT NULL,
    pos character varying(10),
    medical_necessity text,
    clinical_notes text,
    denial_reason text,
    appeal_notes text,
    created_by integer,
    assigned_to integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.authorizations OWNER TO postgres;

--
-- Name: diagnoses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diagnoses (
    id integer NOT NULL,
    diagnosis_code character varying(20) NOT NULL,
    diagnosis_name character varying(255) NOT NULL,
    description text,
    icd_10_code character varying(20),
    category character varying(100),
    severity character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.diagnoses OWNER TO postgres;

--
-- Name: drg_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drg_codes (
    id integer NOT NULL,
    drg_code character varying(10) NOT NULL,
    drg_description text,
    category character varying(100),
    weight numeric(5,3),
    los_geometric_mean numeric(5,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.drg_codes OWNER TO postgres;

--
-- Name: members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.members (
    id integer NOT NULL,
    member_number character varying(50) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    date_of_birth date,
    gender character varying(10),
    phone character varying(20),
    email character varying(255),
    address text,
    insurance_group character varying(100),
    policy_number character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.members OWNER TO postgres;

--
-- Name: providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.providers (
    id integer NOT NULL,
    provider_code character varying(50) NOT NULL,
    provider_name character varying(255) NOT NULL,
    provider_type character varying(100),
    address text,
    phone character varying(20),
    fax character varying(20),
    email character varying(255),
    npi character varying(20),
    tax_id character varying(20),
    contract_status character varying(50) DEFAULT 'Active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.providers OWNER TO postgres;

--
-- Name: authorization_summary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.authorization_summary AS
 SELECT a.id,
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
    concat(m.first_name, ', ', m.last_name) AS member_name,
    m.member_number,
    p.provider_name,
    p.provider_code,
    d.diagnosis_code,
    d.diagnosis_name,
    drg.drg_code,
    drg.drg_description,
        CASE
            WHEN ((a.next_review_date)::date = CURRENT_DATE) THEN 'Due Today'::text
            WHEN ((a.next_review_date)::date < CURRENT_DATE) THEN 'Overdue'::text
            WHEN ((a.next_review_date)::date <= (CURRENT_DATE + '7 days'::interval)) THEN 'Due This Week'::text
            ELSE 'Future'::text
        END AS review_status,
    (EXTRACT(epoch FROM (a.next_review_date - a.received_date)) / (86400)::numeric) AS days_pending
   FROM ((((public.authorizations a
     LEFT JOIN public.members m ON ((a.member_id = m.id)))
     LEFT JOIN public.providers p ON ((a.provider_id = p.id)))
     LEFT JOIN public.diagnoses d ON ((a.diagnosis_id = d.id)))
     LEFT JOIN public.drg_codes drg ON ((a.drg_code_id = drg.id)));


ALTER VIEW public.authorization_summary OWNER TO postgres;

--
-- Name: authorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authorizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authorizations_id_seq OWNER TO postgres;

--
-- Name: authorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authorizations_id_seq OWNED BY public.authorizations.id;


--
-- Name: dashboard_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_stats (
    id integer NOT NULL,
    stat_date date DEFAULT CURRENT_DATE NOT NULL,
    due_today_count integer DEFAULT 0,
    high_priority_count integer DEFAULT 0,
    reminders_count integer DEFAULT 0,
    start_this_week_count integer DEFAULT 0,
    total_pending_count integer DEFAULT 0,
    total_in_review_count integer DEFAULT 0,
    total_approved_count integer DEFAULT 0,
    total_denied_count integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dashboard_stats OWNER TO postgres;

--
-- Name: dashboard_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboard_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dashboard_stats_id_seq OWNER TO postgres;

--
-- Name: dashboard_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboard_stats_id_seq OWNED BY public.dashboard_stats.id;


--
-- Name: diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diagnoses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diagnoses_id_seq OWNER TO postgres;

--
-- Name: diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diagnoses_id_seq OWNED BY public.diagnoses.id;


--
-- Name: drg_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.drg_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.drg_codes_id_seq OWNER TO postgres;

--
-- Name: drg_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.drg_codes_id_seq OWNED BY public.drg_codes.id;


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.members_id_seq OWNER TO postgres;

--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;


--
-- Name: priority_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.priority_levels (
    id integer NOT NULL,
    priority_code character varying(20) NOT NULL,
    priority_name character varying(50) NOT NULL,
    description text,
    color_code character varying(10),
    sort_order integer,
    is_active boolean DEFAULT true
);


ALTER TABLE public.priority_levels OWNER TO postgres;

--
-- Name: priority_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.priority_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.priority_levels_id_seq OWNER TO postgres;

--
-- Name: priority_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.priority_levels_id_seq OWNED BY public.priority_levels.id;


--
-- Name: providers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.providers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.providers_id_seq OWNER TO postgres;

--
-- Name: providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.providers_id_seq OWNED BY public.providers.id;


--
-- Name: review_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_types (
    id integer NOT NULL,
    review_code character varying(50) NOT NULL,
    review_name character varying(100) NOT NULL,
    description text,
    typical_duration_hours integer,
    is_active boolean DEFAULT true
);


ALTER TABLE public.review_types OWNER TO postgres;

--
-- Name: review_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_types_id_seq OWNER TO postgres;

--
-- Name: review_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_types_id_seq OWNED BY public.review_types.id;


--
-- Name: status_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_types (
    id integer NOT NULL,
    status_code character varying(50) NOT NULL,
    status_name character varying(100) NOT NULL,
    description text,
    color_code character varying(10),
    is_final boolean DEFAULT false,
    sort_order integer,
    is_active boolean DEFAULT true
);


ALTER TABLE public.status_types OWNER TO postgres;

--
-- Name: status_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.status_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.status_types_id_seq OWNER TO postgres;

--
-- Name: status_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_types_id_seq OWNED BY public.status_types.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(100) NOT NULL,
    role character varying(20) DEFAULT 'user'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: authorization_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_documents ALTER COLUMN id SET DEFAULT nextval('public.authorization_documents_id_seq'::regclass);


--
-- Name: authorization_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_history ALTER COLUMN id SET DEFAULT nextval('public.authorization_history_id_seq'::regclass);


--
-- Name: authorization_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_notes ALTER COLUMN id SET DEFAULT nextval('public.authorization_notes_id_seq'::regclass);


--
-- Name: authorizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations ALTER COLUMN id SET DEFAULT nextval('public.authorizations_id_seq'::regclass);


--
-- Name: dashboard_stats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_stats ALTER COLUMN id SET DEFAULT nextval('public.dashboard_stats_id_seq'::regclass);


--
-- Name: diagnoses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diagnoses ALTER COLUMN id SET DEFAULT nextval('public.diagnoses_id_seq'::regclass);


--
-- Name: drg_codes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drg_codes ALTER COLUMN id SET DEFAULT nextval('public.drg_codes_id_seq'::regclass);


--
-- Name: members id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


--
-- Name: priority_levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.priority_levels ALTER COLUMN id SET DEFAULT nextval('public.priority_levels_id_seq'::regclass);


--
-- Name: providers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.providers ALTER COLUMN id SET DEFAULT nextval('public.providers_id_seq'::regclass);


--
-- Name: review_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_types ALTER COLUMN id SET DEFAULT nextval('public.review_types_id_seq'::regclass);


--
-- Name: status_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_types ALTER COLUMN id SET DEFAULT nextval('public.status_types_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: authorization_documents authorization_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_documents
    ADD CONSTRAINT authorization_documents_pkey PRIMARY KEY (id);


--
-- Name: authorization_history authorization_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_history
    ADD CONSTRAINT authorization_history_pkey PRIMARY KEY (id);


--
-- Name: authorization_notes authorization_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_notes
    ADD CONSTRAINT authorization_notes_pkey PRIMARY KEY (id);


--
-- Name: authorizations authorizations_authorization_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations
    ADD CONSTRAINT authorizations_authorization_number_key UNIQUE (authorization_number);


--
-- Name: authorizations authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations
    ADD CONSTRAINT authorizations_pkey PRIMARY KEY (id);


--
-- Name: dashboard_stats dashboard_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_stats
    ADD CONSTRAINT dashboard_stats_pkey PRIMARY KEY (id);


--
-- Name: diagnoses diagnoses_diagnosis_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT diagnoses_diagnosis_code_key UNIQUE (diagnosis_code);


--
-- Name: diagnoses diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT diagnoses_pkey PRIMARY KEY (id);


--
-- Name: drg_codes drg_codes_drg_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drg_codes
    ADD CONSTRAINT drg_codes_drg_code_key UNIQUE (drg_code);


--
-- Name: drg_codes drg_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drg_codes
    ADD CONSTRAINT drg_codes_pkey PRIMARY KEY (id);


--
-- Name: members members_member_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_member_number_key UNIQUE (member_number);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: priority_levels priority_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.priority_levels
    ADD CONSTRAINT priority_levels_pkey PRIMARY KEY (id);


--
-- Name: priority_levels priority_levels_priority_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.priority_levels
    ADD CONSTRAINT priority_levels_priority_code_key UNIQUE (priority_code);


--
-- Name: providers providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: providers providers_provider_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_provider_code_key UNIQUE (provider_code);


--
-- Name: review_types review_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_types
    ADD CONSTRAINT review_types_pkey PRIMARY KEY (id);


--
-- Name: review_types review_types_review_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_types
    ADD CONSTRAINT review_types_review_code_key UNIQUE (review_code);


--
-- Name: status_types status_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_types
    ADD CONSTRAINT status_types_pkey PRIMARY KEY (id);


--
-- Name: status_types status_types_status_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_types
    ADD CONSTRAINT status_types_status_code_key UNIQUE (status_code);


--
-- Name: dashboard_stats unique_stat_date; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_stats
    ADD CONSTRAINT unique_stat_date UNIQUE (stat_date);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_auth_admission_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_admission_date ON public.authorizations USING btree (admission_date);


--
-- Name: idx_auth_documents_auth_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_documents_auth_id ON public.authorization_documents USING btree (authorization_id);


--
-- Name: idx_auth_history_auth_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_history_auth_id ON public.authorization_history USING btree (authorization_id);


--
-- Name: idx_auth_history_changed_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_history_changed_at ON public.authorization_history USING btree (changed_at);


--
-- Name: idx_auth_member; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_member ON public.authorizations USING btree (member_id);


--
-- Name: idx_auth_next_review; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_next_review ON public.authorizations USING btree (next_review_date);


--
-- Name: idx_auth_notes_auth_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_notes_auth_id ON public.authorization_notes USING btree (authorization_id);


--
-- Name: idx_auth_notes_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_notes_created_at ON public.authorization_notes USING btree (created_at);


--
-- Name: idx_auth_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_number ON public.authorizations USING btree (authorization_number);


--
-- Name: idx_auth_priority; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_priority ON public.authorizations USING btree (priority);


--
-- Name: idx_auth_provider; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_provider ON public.authorizations USING btree (provider_id);


--
-- Name: idx_auth_received_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_received_date ON public.authorizations USING btree (received_date);


--
-- Name: idx_auth_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_status ON public.authorizations USING btree (status);


--
-- Name: idx_dashboard_stats_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_stats_date ON public.dashboard_stats USING btree (stat_date);


--
-- Name: idx_diagnoses_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_diagnoses_code ON public.diagnoses USING btree (diagnosis_code);


--
-- Name: idx_drg_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_drg_code ON public.drg_codes USING btree (drg_code);


--
-- Name: idx_members_last_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_last_name ON public.members USING btree (last_name);


--
-- Name: idx_members_member_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_member_number ON public.members USING btree (member_number);


--
-- Name: idx_priority_levels_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_priority_levels_code ON public.priority_levels USING btree (priority_code);


--
-- Name: idx_providers_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_providers_code ON public.providers USING btree (provider_code);


--
-- Name: idx_providers_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_providers_name ON public.providers USING btree (provider_name);


--
-- Name: idx_review_types_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_review_types_code ON public.review_types USING btree (review_code);


--
-- Name: idx_status_types_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_status_types_code ON public.status_types USING btree (status_code);


--
-- Name: authorization_documents authorization_documents_authorization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_documents
    ADD CONSTRAINT authorization_documents_authorization_id_fkey FOREIGN KEY (authorization_id) REFERENCES public.authorizations(id);


--
-- Name: authorization_documents authorization_documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_documents
    ADD CONSTRAINT authorization_documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: authorization_history authorization_history_authorization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_history
    ADD CONSTRAINT authorization_history_authorization_id_fkey FOREIGN KEY (authorization_id) REFERENCES public.authorizations(id);


--
-- Name: authorization_history authorization_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_history
    ADD CONSTRAINT authorization_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: authorization_notes authorization_notes_authorization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_notes
    ADD CONSTRAINT authorization_notes_authorization_id_fkey FOREIGN KEY (authorization_id) REFERENCES public.authorizations(id);


--
-- Name: authorization_notes authorization_notes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorization_notes
    ADD CONSTRAINT authorization_notes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: authorizations authorizations_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations
    ADD CONSTRAINT authorizations_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: authorizations authorizations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations
    ADD CONSTRAINT authorizations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: authorizations authorizations_diagnosis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations
    ADD CONSTRAINT authorizations_diagnosis_id_fkey FOREIGN KEY (diagnosis_id) REFERENCES public.diagnoses(id);


--
-- Name: authorizations authorizations_drg_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations
    ADD CONSTRAINT authorizations_drg_code_id_fkey FOREIGN KEY (drg_code_id) REFERENCES public.drg_codes(id);


--
-- Name: authorizations authorizations_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations
    ADD CONSTRAINT authorizations_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id);


--
-- Name: authorizations authorizations_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorizations
    ADD CONSTRAINT authorizations_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id);


--
-- PostgreSQL database dump complete
--

