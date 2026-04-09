--
-- PostgreSQL database dump
--

\restrict Jd4hK9BB51WIZgzh9zcWFtfToB359nddETlU1uZzmD9jhesaa6khdEoxlbL86VZ

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: spring_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO spring_user;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: spring_user
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO spring_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: user_info; Type: TABLE; Schema: public; Owner: spring_user
--

CREATE TABLE public.user_info (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255),
    email character varying(255) NOT NULL,
    father_name character varying(100),
    reset_token character varying(255),
    reset_token_expiry timestamp without time zone,
    status character varying(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
    failed_login_attempts integer DEFAULT 0 NOT NULL,
    last_failed_login timestamp without time zone,
    lock_until timestamp without time zone,
    role character varying(20) DEFAULT 'USER'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    oauth_id character varying(255),
    oauth_provider character varying(50),
    CONSTRAINT chk_role CHECK (((role)::text = ANY ((ARRAY['USER'::character varying, 'ADMIN'::character varying])::text[]))),
    CONSTRAINT chk_status CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'SUSPENDED'::character varying, 'BLOCKED'::character varying, 'LOCKED'::character varying, 'INACTIVE'::character varying, 'PENDING'::character varying])::text[])))
);


ALTER TABLE public.user_info OWNER TO spring_user;

--
-- Name: user_info_id_seq; Type: SEQUENCE; Schema: public; Owner: spring_user
--

CREATE SEQUENCE public.user_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_info_id_seq OWNER TO spring_user;

--
-- Name: user_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: spring_user
--

ALTER SEQUENCE public.user_info_id_seq OWNED BY public.user_info.id;


--
-- Name: user_info id; Type: DEFAULT; Schema: public; Owner: spring_user
--

ALTER TABLE ONLY public.user_info ALTER COLUMN id SET DEFAULT nextval('public.user_info_id_seq'::regclass);


--
-- Data for Name: user_info; Type: TABLE DATA; Schema: public; Owner: spring_user
--

COPY public.user_info (id, name, username, password, email, father_name, reset_token, reset_token_expiry, status, failed_login_attempts, last_failed_login, lock_until, role, created_at, updated_at, oauth_id, oauth_provider) FROM stdin;
26	Test User New	testuser99	$2a$12$pvkLYl6.VjShTJjpii84XeRLiPmeJru.eLDZejDNcXnDb3w0GwDOS	test99@example.com	Test Father	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 00:14:16.543722	2025-12-20 00:14:16.543787	\N	\N
27	John Smith	testuser1	$2a$12$1/XevXDjo/exTh8Fzr8WTOxvKBuGOEZma/q5COcsLJlPXhP1k4D4u	test1@example.com	John Smith Sr	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 00:15:44.349826	2025-12-20 00:15:44.34988	\N	\N
28	Ahmed Khan	testuser2	$2a$12$b3L.zmeonXJWVWMa0BVYN.GIvTZFYDZXa5TWdR2PJ1IwC8CujImEi	test2@example.com	Ahmed Khan Sr	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 00:15:44.854234	2025-12-20 00:15:44.854278	\N	\N
29	Demo User	demouser	$2a$12$wSTznirJqRpc3ijMOacxvuWD9rqqFoq7yGvtgElGuisbv27g2ctQK	demo@example.com	Demo Father	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 00:15:45.307645	2025-12-20 00:15:45.307683	\N	\N
30	Uriel Jimenez	wabunip	$2a$12$BpdCbDNw0DXrCmE61t5svOHW5/GWSzG80xlfKUUywNuPPIVjA80se	maridonyf@mailinator.com	Nissim Pittman	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 00:20:25.100762	2025-12-20 00:20:25.100804	\N	\N
31	Admin User	admin2	$2a$12$WHsGoZwpN3gLQO4P5lHG..yiI5wAISC5vCyAwe5/Zts37FN1dRB2y	admin2@example.com	Admin Father	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 00:22:31.192344	2025-12-20 00:22:31.192431	\N	\N
2	John Doe	johndoe	$2a$12$1/XevXDjo/exTh8Fzr8WTOxvKBuGOEZma/q5COcsLJlPXhP1k4D4u	john.doe@example.com	John Senior	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-19 23:13:03.946832	2025-12-20 00:22:41.720282	\N	\N
1	System Admin	admin	$2a$12$1/XevXDjo/exTh8Fzr8WTOxvKBuGOEZma/q5COcsLJlPXhP1k4D4u	admin@example.com	\N	b8586048-0c60-4b77-974c-6714033b5b71	2025-12-21 00:27:09.733906	ACTIVE	0	\N	\N	ADMIN	2025-12-19 23:13:03.944479	2025-12-20 00:27:09.730541	\N	\N
32	Tasha Lara	haider	$2a$12$bPG2elzLSwO71RsOVGzmG..8Gpi7Mgtgpc4IgKMr1dA.AcgzQSlWC	juqanuf@mailinator.com	Malik Barr	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 00:29:50.779396	2025-12-20 00:29:50.779432	\N	\N
3	UBAID BIN WARIS	ubaid	$2a$12$1/XevXDjo/exTh8Fzr8WTOxvKBuGOEZma/q5COcsLJlPXhP1k4D4u	ubaidwaris34@gmail.com	Waris Ali	eaa5a90f-427f-4b08-b2e0-6b6b1d0f9eea	2025-12-21 00:18:38.375972	ACTIVE	0	\N	\N	USER	2025-12-19 23:20:18.188421	2025-12-20 04:20:27.454531	111576590241021639788	google
34	Saifullah Shaukat	saifisthetic@gmail.com	\N	saifisthetic@gmail.com	\N	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 04:22:45.628533	2025-12-20 04:22:45.628615	110901967356544553551	google
35	lead4s New	leadsnew04@gmail.com	\N	leadsnew04@gmail.com	\N	\N	\N	ACTIVE	0	\N	\N	USER	2025-12-20 04:23:01.66982	2025-12-20 04:23:01.669865	112115015889330653611	google
\.


--
-- Name: user_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: spring_user
--

SELECT pg_catalog.setval('public.user_info_id_seq', 35, true);


--
-- Name: user_info user_info_email_key; Type: CONSTRAINT; Schema: public; Owner: spring_user
--

ALTER TABLE ONLY public.user_info
    ADD CONSTRAINT user_info_email_key UNIQUE (email);


--
-- Name: user_info user_info_pkey; Type: CONSTRAINT; Schema: public; Owner: spring_user
--

ALTER TABLE ONLY public.user_info
    ADD CONSTRAINT user_info_pkey PRIMARY KEY (id);


--
-- Name: user_info user_info_username_key; Type: CONSTRAINT; Schema: public; Owner: spring_user
--

ALTER TABLE ONLY public.user_info
    ADD CONSTRAINT user_info_username_key UNIQUE (username);


--
-- Name: idx_email; Type: INDEX; Schema: public; Owner: spring_user
--

CREATE UNIQUE INDEX idx_email ON public.user_info USING btree (email);


--
-- Name: idx_reset_token; Type: INDEX; Schema: public; Owner: spring_user
--

CREATE INDEX idx_reset_token ON public.user_info USING btree (reset_token) WHERE (reset_token IS NOT NULL);


--
-- Name: idx_status; Type: INDEX; Schema: public; Owner: spring_user
--

CREATE INDEX idx_status ON public.user_info USING btree (status);


--
-- Name: idx_username; Type: INDEX; Schema: public; Owner: spring_user
--

CREATE UNIQUE INDEX idx_username ON public.user_info USING btree (username);


--
-- Name: user_info update_user_info_updated_at; Type: TRIGGER; Schema: public; Owner: spring_user
--

CREATE TRIGGER update_user_info_updated_at BEFORE UPDATE ON public.user_info FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: user_info; Type: ROW SECURITY; Schema: public; Owner: spring_user
--

ALTER TABLE public.user_info ENABLE ROW LEVEL SECURITY;

--
-- Name: user_info user_info_delete_policy; Type: POLICY; Schema: public; Owner: spring_user
--

CREATE POLICY user_info_delete_policy ON public.user_info FOR DELETE USING (((CURRENT_USER IN ( SELECT user_info_1.username
   FROM public.user_info user_info_1
  WHERE ((user_info_1.role)::text = 'ADMIN'::text))) OR (CURRENT_USER = 'spring_user'::name)));


--
-- Name: user_info user_info_insert_policy; Type: POLICY; Schema: public; Owner: spring_user
--

CREATE POLICY user_info_insert_policy ON public.user_info FOR INSERT WITH CHECK (((CURRENT_USER = 'spring_user'::name) OR (NOT (EXISTS ( SELECT 1
   FROM public.user_info user_info_1
  WHERE ((user_info_1.username)::text = CURRENT_USER))))));


--
-- Name: user_info user_info_select_policy; Type: POLICY; Schema: public; Owner: spring_user
--

CREATE POLICY user_info_select_policy ON public.user_info FOR SELECT USING ((((username)::text = CURRENT_USER) OR (CURRENT_USER IN ( SELECT user_info_1.username
   FROM public.user_info user_info_1
  WHERE ((user_info_1.role)::text = 'ADMIN'::text))) OR (CURRENT_USER = 'spring_user'::name)));


--
-- Name: user_info user_info_update_policy; Type: POLICY; Schema: public; Owner: spring_user
--

CREATE POLICY user_info_update_policy ON public.user_info FOR UPDATE USING ((((username)::text = CURRENT_USER) OR (CURRENT_USER IN ( SELECT user_info_1.username
   FROM public.user_info user_info_1
  WHERE ((user_info_1.role)::text = 'ADMIN'::text))) OR (CURRENT_USER = 'spring_user'::name)));


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO spring_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO spring_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO spring_user;


--
-- PostgreSQL database dump complete
--

\unrestrict Jd4hK9BB51WIZgzh9zcWFtfToB359nddETlU1uZzmD9jhesaa6khdEoxlbL86VZ

