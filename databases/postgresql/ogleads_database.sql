--
-- PostgreSQL database dump
--

\restrict PDdp6DBa089H2OlFzULSQWwUdRPnuwzrSKVQgxxQGgFdhCwit0FZKWmF1VgfJpB

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
-- Name: AdminUser; Type: TABLE; Schema: public; Owner: ogleads_user
--

CREATE TABLE public."AdminUser" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    username text NOT NULL,
    password text NOT NULL
);


ALTER TABLE public."AdminUser" OWNER TO ogleads_user;

--
-- Name: Inquiry; Type: TABLE; Schema: public; Owner: ogleads_user
--

CREATE TABLE public."Inquiry" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    company text,
    phone text,
    subject text,
    message text NOT NULL,
    type text DEFAULT 'General'::text NOT NULL
);


ALTER TABLE public."Inquiry" OWNER TO ogleads_user;

--
-- Name: PartnerApplication; Type: TABLE; Schema: public; Owner: ogleads_user
--

CREATE TABLE public."PartnerApplication" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type text NOT NULL,
    "companyName" text NOT NULL,
    "contactName" text NOT NULL,
    email text NOT NULL,
    phone text,
    website text,
    vertical text NOT NULL,
    volume text,
    notes text,
    status text DEFAULT 'Pending'::text NOT NULL
);


ALTER TABLE public."PartnerApplication" OWNER TO ogleads_user;

--
-- Name: PublisherApplication; Type: TABLE; Schema: public; Owner: ogleads_user
--

CREATE TABLE public."PublisherApplication" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    company text,
    website text NOT NULL,
    verticals text NOT NULL,
    "trafficSources" text NOT NULL,
    notes text,
    status text DEFAULT 'Pending'::text NOT NULL
);


ALTER TABLE public."PublisherApplication" OWNER TO ogleads_user;

--
-- Name: Subscriber; Type: TABLE; Schema: public; Owner: ogleads_user
--

CREATE TABLE public."Subscriber" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email text NOT NULL
);


ALTER TABLE public."Subscriber" OWNER TO ogleads_user;

--
-- Data for Name: AdminUser; Type: TABLE DATA; Schema: public; Owner: ogleads_user
--

COPY public."AdminUser" (id, "createdAt", username, password) FROM stdin;
9d0f3eda-717a-4787-87aa-efb2c0e57396	2026-07-16 14:11:18.039	admin	1607570a90414a03bd3770971297d8bf75bedfe9f74c9293762da7e79a3ad639
\.


--
-- Data for Name: Inquiry; Type: TABLE DATA; Schema: public; Owner: ogleads_user
--

COPY public."Inquiry" (id, "createdAt", name, email, company, phone, subject, message, type) FROM stdin;
\.


--
-- Data for Name: PartnerApplication; Type: TABLE DATA; Schema: public; Owner: ogleads_user
--

COPY public."PartnerApplication" (id, "createdAt", type, "companyName", "contactName", email, phone, website, vertical, volume, notes, status) FROM stdin;
\.


--
-- Data for Name: PublisherApplication; Type: TABLE DATA; Schema: public; Owner: ogleads_user
--

COPY public."PublisherApplication" (id, "createdAt", name, email, company, website, verticals, "trafficSources", notes, status) FROM stdin;
\.


--
-- Data for Name: Subscriber; Type: TABLE DATA; Schema: public; Owner: ogleads_user
--

COPY public."Subscriber" (id, "createdAt", email) FROM stdin;
\.


--
-- Name: AdminUser AdminUser_pkey; Type: CONSTRAINT; Schema: public; Owner: ogleads_user
--

ALTER TABLE ONLY public."AdminUser"
    ADD CONSTRAINT "AdminUser_pkey" PRIMARY KEY (id);


--
-- Name: Inquiry Inquiry_pkey; Type: CONSTRAINT; Schema: public; Owner: ogleads_user
--

ALTER TABLE ONLY public."Inquiry"
    ADD CONSTRAINT "Inquiry_pkey" PRIMARY KEY (id);


--
-- Name: PartnerApplication PartnerApplication_pkey; Type: CONSTRAINT; Schema: public; Owner: ogleads_user
--

ALTER TABLE ONLY public."PartnerApplication"
    ADD CONSTRAINT "PartnerApplication_pkey" PRIMARY KEY (id);


--
-- Name: PublisherApplication PublisherApplication_pkey; Type: CONSTRAINT; Schema: public; Owner: ogleads_user
--

ALTER TABLE ONLY public."PublisherApplication"
    ADD CONSTRAINT "PublisherApplication_pkey" PRIMARY KEY (id);


--
-- Name: Subscriber Subscriber_pkey; Type: CONSTRAINT; Schema: public; Owner: ogleads_user
--

ALTER TABLE ONLY public."Subscriber"
    ADD CONSTRAINT "Subscriber_pkey" PRIMARY KEY (id);


--
-- Name: AdminUser_username_key; Type: INDEX; Schema: public; Owner: ogleads_user
--

CREATE UNIQUE INDEX "AdminUser_username_key" ON public."AdminUser" USING btree (username);


--
-- Name: PublisherApplication_email_key; Type: INDEX; Schema: public; Owner: ogleads_user
--

CREATE UNIQUE INDEX "PublisherApplication_email_key" ON public."PublisherApplication" USING btree (email);


--
-- Name: Subscriber_email_key; Type: INDEX; Schema: public; Owner: ogleads_user
--

CREATE UNIQUE INDEX "Subscriber_email_key" ON public."Subscriber" USING btree (email);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO ogleads_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO ogleads_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO ogleads_user;


--
-- PostgreSQL database dump complete
--

\unrestrict PDdp6DBa089H2OlFzULSQWwUdRPnuwzrSKVQgxxQGgFdhCwit0FZKWmF1VgfJpB

