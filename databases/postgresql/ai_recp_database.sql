--
-- PostgreSQL database dump
--

\restrict J1ThQSsK7rehcgcU0JHed4D2qdeXoRHjvi1L6Jr9I8qQeGb2GoR5YrwLtQvlcU5

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
-- Name: Call; Type: TABLE; Schema: public; Owner: ai_recp_user
--

CREATE TABLE public."Call" (
    id text NOT NULL,
    channel text DEFAULT 'simulator'::text NOT NULL,
    transcript jsonb DEFAULT '[]'::jsonb NOT NULL,
    duration integer,
    outcome text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Call" OWNER TO ai_recp_user;

--
-- Name: Client; Type: TABLE; Schema: public; Owner: ai_recp_user
--

CREATE TABLE public."Client" (
    id text NOT NULL,
    name text NOT NULL,
    niche text DEFAULT 'general'::text NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Client" OWNER TO ai_recp_user;

--
-- Name: Script; Type: TABLE; Schema: public; Owner: ai_recp_user
--

CREATE TABLE public."Script" (
    id text NOT NULL,
    name text NOT NULL,
    niche text DEFAULT 'general'::text NOT NULL,
    nodes jsonb DEFAULT '{}'::jsonb NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Script" OWNER TO ai_recp_user;

--
-- Name: Trigger; Type: TABLE; Schema: public; Owner: ai_recp_user
--

CREATE TABLE public."Trigger" (
    id text NOT NULL,
    name text NOT NULL,
    words text[],
    action text NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Trigger" OWNER TO ai_recp_user;

--
-- Data for Name: Call; Type: TABLE DATA; Schema: public; Owner: ai_recp_user
--

COPY public."Call" (id, channel, transcript, duration, outcome, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Client; Type: TABLE DATA; Schema: public; Owner: ai_recp_user
--

COPY public."Client" (id, name, niche, config, "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Script; Type: TABLE DATA; Schema: public; Owner: ai_recp_user
--

COPY public."Script" (id, name, niche, nodes, "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Trigger; Type: TABLE DATA; Schema: public; Owner: ai_recp_user
--

COPY public."Trigger" (id, name, words, action, config, "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Call Call_pkey; Type: CONSTRAINT; Schema: public; Owner: ai_recp_user
--

ALTER TABLE ONLY public."Call"
    ADD CONSTRAINT "Call_pkey" PRIMARY KEY (id);


--
-- Name: Client Client_pkey; Type: CONSTRAINT; Schema: public; Owner: ai_recp_user
--

ALTER TABLE ONLY public."Client"
    ADD CONSTRAINT "Client_pkey" PRIMARY KEY (id);


--
-- Name: Script Script_pkey; Type: CONSTRAINT; Schema: public; Owner: ai_recp_user
--

ALTER TABLE ONLY public."Script"
    ADD CONSTRAINT "Script_pkey" PRIMARY KEY (id);


--
-- Name: Trigger Trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: ai_recp_user
--

ALTER TABLE ONLY public."Trigger"
    ADD CONSTRAINT "Trigger_pkey" PRIMARY KEY (id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO ai_recp_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO ai_recp_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO ai_recp_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO ai_recp_user;


--
-- PostgreSQL database dump complete
--

\unrestrict J1ThQSsK7rehcgcU0JHed4D2qdeXoRHjvi1L6Jr9I8qQeGb2GoR5YrwLtQvlcU5

