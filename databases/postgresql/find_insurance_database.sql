--
-- PostgreSQL database dump
--

\restrict fCKZ6L9ztE3SSkCZEobX6xLmeKP97rQ9j5fnPffUrGGdCfHmWGp5bQ9LzgBuFf8

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: QuoteLead; Type: TABLE; Schema: public; Owner: find_insurance_user
--

CREATE TABLE public."QuoteLead" (
    id integer NOT NULL,
    "firstName" text,
    "lastName" text,
    phone text,
    email text,
    consent boolean DEFAULT true NOT NULL,
    reason text,
    state text,
    "sexAtBirth" text,
    "birthMonth" text,
    "birthDay" text,
    "birthYear" text,
    "coverageAmount" integer,
    "heightFeet" text,
    "heightInches" text,
    weight text,
    "cigarettesUse" text,
    "cigarettesFrequency" text,
    "cigarettesLastUsed" text,
    "cigarsUse" text,
    "cigarsFrequency" text,
    "cigarsLastUsed" text,
    "pipeUse" text,
    "pipeLastUsed" text,
    "chewingUse" text,
    "chewingLastUsed" text,
    "nicotineUse" text,
    "nicotineLastUsed" text,
    "bloodPressureTreated" text,
    "bloodPressureLastTreated" text,
    "cholesterolTreated" text,
    "cholesterolLastTreated" text,
    "quoteId" text,
    "quoteProvider" text,
    "quoteAmBestRating" text,
    "quoteMonthlyPremium" double precision,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."QuoteLead" OWNER TO find_insurance_user;

--
-- Name: QuoteLead_id_seq; Type: SEQUENCE; Schema: public; Owner: find_insurance_user
--

CREATE SEQUENCE public."QuoteLead_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."QuoteLead_id_seq" OWNER TO find_insurance_user;

--
-- Name: QuoteLead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: find_insurance_user
--

ALTER SEQUENCE public."QuoteLead_id_seq" OWNED BY public."QuoteLead".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: find_insurance_user
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    username text NOT NULL,
    "passwordHash" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."User" OWNER TO find_insurance_user;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: find_insurance_user
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO find_insurance_user;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: find_insurance_user
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: QuoteLead id; Type: DEFAULT; Schema: public; Owner: find_insurance_user
--

ALTER TABLE ONLY public."QuoteLead" ALTER COLUMN id SET DEFAULT nextval('public."QuoteLead_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: find_insurance_user
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Data for Name: QuoteLead; Type: TABLE DATA; Schema: public; Owner: find_insurance_user
--

COPY public."QuoteLead" (id, "firstName", "lastName", phone, email, consent, reason, state, "sexAtBirth", "birthMonth", "birthDay", "birthYear", "coverageAmount", "heightFeet", "heightInches", weight, "cigarettesUse", "cigarettesFrequency", "cigarettesLastUsed", "cigarsUse", "cigarsFrequency", "cigarsLastUsed", "pipeUse", "pipeLastUsed", "chewingUse", "chewingLastUsed", "nicotineUse", "nicotineLastUsed", "bloodPressureTreated", "bloodPressureLastTreated", "cholesterolTreated", "cholesterolLastTreated", "quoteId", "quoteProvider", "quoteAmBestRating", "quoteMonthlyPremium", "createdAt") FROM stdin;
1	wqefe	werf	1212121212	dewfrt@efg.dfewr	t	I want to reduce funeral burden	Arkansas	Male	4	4	1955	50000	5	3	21	Yes	6 - 10	Within the Last 12 Months	No			Yes	1 - 2 years ago	No		Yes	Within the Last 12 Months	Yes	2 - 3 years ago	No		royal-neighbors-ensured-legacy	Royal Neighbors	A	85.86	2026-06-11 17:04:08.143
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: find_insurance_user
--

COPY public."User" (id, username, "passwordHash", "createdAt") FROM stdin;
1	admin_is_my_userName	60467646d0f8798214f262d1f66f21c6:47e4fa795e2d40799d6bd5088be6d6417989d1b673ad74b10e4d4f9ccbc54f8f188cc1b6a9c6d33c76f75e14cbcc2855f465d34060d03f5deea26bc3dab8ef01	2026-06-11 17:17:13.388
\.


--
-- Name: QuoteLead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: find_insurance_user
--

SELECT pg_catalog.setval('public."QuoteLead_id_seq"', 1, true);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: find_insurance_user
--

SELECT pg_catalog.setval('public."User_id_seq"', 1, true);


--
-- Name: QuoteLead QuoteLead_pkey; Type: CONSTRAINT; Schema: public; Owner: find_insurance_user
--

ALTER TABLE ONLY public."QuoteLead"
    ADD CONSTRAINT "QuoteLead_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: find_insurance_user
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: User_username_key; Type: INDEX; Schema: public; Owner: find_insurance_user
--

CREATE UNIQUE INDEX "User_username_key" ON public."User" USING btree (username);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO find_insurance_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO find_insurance_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO find_insurance_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO find_insurance_user;


--
-- PostgreSQL database dump complete
--

\unrestrict fCKZ6L9ztE3SSkCZEobX6xLmeKP97rQ9j5fnPffUrGGdCfHmWGp5bQ9LzgBuFf8

