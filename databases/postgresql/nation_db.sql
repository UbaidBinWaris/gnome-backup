--
-- PostgreSQL database dump
--

\restrict txJUNSFjrfeQntqgxwRciXelBSv3RU7v63VHSIYo8xFbvpyg2NJOIKEuW5OVAFC

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
-- Name: ContactMessage; Type: TABLE; Schema: public; Owner: nation_wide
--

CREATE TABLE public."ContactMessage" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    company text,
    message text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    browser text,
    device text,
    ip text,
    os text,
    "isRead" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."ContactMessage" OWNER TO nation_wide;

--
-- Data for Name: ContactMessage; Type: TABLE DATA; Schema: public; Owner: nation_wide
--

COPY public."ContactMessage" (id, name, email, phone, company, message, "createdAt", browser, device, ip, os, "isRead") FROM stdin;
61ad433a-5ce4-4fa8-8762-1df61b663e6c	Hasad Bates	lojokubyta@mailinator.com	+1 (724) 985-1659	Harper Tate Traders	Deleniti vero aut qu	2026-04-30 18:03:08.256	Firefox 150.0	Desktop	::ffff:127.0.0.1	Linux	t
6b655f23-56d1-4cb2-bd83-aeec228711d4	Grace Nixon	lodyfa@mailinator.com	+1 (946) 885-7873	Sexton Graham Co	At aspernatur volupt	2026-04-30 17:52:05.383	Firefox 150.0	Desktop	::ffff:127.0.0.1	Linux	t
\.


--
-- Name: ContactMessage ContactMessage_pkey; Type: CONSTRAINT; Schema: public; Owner: nation_wide
--

ALTER TABLE ONLY public."ContactMessage"
    ADD CONSTRAINT "ContactMessage_pkey" PRIMARY KEY (id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO nation_wide;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO nation_wide;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO nation_wide;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO nation_wide;


--
-- PostgreSQL database dump complete
--

\unrestrict txJUNSFjrfeQntqgxwRciXelBSv3RU7v63VHSIYo8xFbvpyg2NJOIKEuW5OVAFC

