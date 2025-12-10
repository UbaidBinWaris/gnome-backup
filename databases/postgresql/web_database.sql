--
-- PostgreSQL database dump
--

\restrict lp79mrvheOqQGATuWzeDhAgesM4hrRkJb2cNrfF4dZCEACQtU4LVBo82a5ZPgD7

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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
-- Name: users; Type: TABLE; Schema: public; Owner: web_user
--

CREATE TABLE public.users (
    iduser integer NOT NULL,
    user_name character varying(100) NOT NULL,
    pass character varying(255) NOT NULL,
    email character varying(150) NOT NULL,
    fname character varying(100) NOT NULL
);


ALTER TABLE public.users OWNER TO web_user;

--
-- Name: users_iduser_seq; Type: SEQUENCE; Schema: public; Owner: web_user
--

CREATE SEQUENCE public.users_iduser_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_iduser_seq OWNER TO web_user;

--
-- Name: users_iduser_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: web_user
--

ALTER SEQUENCE public.users_iduser_seq OWNED BY public.users.iduser;


--
-- Name: users iduser; Type: DEFAULT; Schema: public; Owner: web_user
--

ALTER TABLE ONLY public.users ALTER COLUMN iduser SET DEFAULT nextval('public.users_iduser_seq'::regclass);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: web_user
--

COPY public.users (iduser, user_name, pass, email, fname) FROM stdin;
1	ubaid	ubaid123	ubaid@don.bigdon	Ubaid
2	ali	ali123	Ali@gmail.haider	Ali
3	love	love123	love@lovely.cute	Love
4	muskan	muskan123	muskan@gmail.com	muskan
\.


--
-- Name: users_iduser_seq; Type: SEQUENCE SET; Schema: public; Owner: web_user
--

SELECT pg_catalog.setval('public.users_iduser_seq', 4, true);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: web_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: web_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (iduser);


--
-- PostgreSQL database dump complete
--

\unrestrict lp79mrvheOqQGATuWzeDhAgesM4hrRkJb2cNrfF4dZCEACQtU4LVBo82a5ZPgD7

