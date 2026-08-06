--
-- PostgreSQL database dump
--

\restrict BWpqPfpNDGlcD3Ohjn1XI3mlIbafEFbTqzkzyGUoRpgtKPy1JZgh3C1YkQghUxH

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

--
-- Name: AdminRole; Type: TYPE; Schema: public; Owner: voice_agent_user
--

CREATE TYPE public."AdminRole" AS ENUM (
    'SUPER_ADMIN',
    'ADMIN'
);


ALTER TYPE public."AdminRole" OWNER TO voice_agent_user;

--
-- Name: TeamRole; Type: TYPE; Schema: public; Owner: voice_agent_user
--

CREATE TYPE public."TeamRole" AS ENUM (
    'TEAM_ADMIN',
    'TEAM_DEVELOPER',
    'TEAM_INTEGRATION',
    'TEAM_MEMBER'
);


ALTER TYPE public."TeamRole" OWNER TO voice_agent_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Admin; Type: TABLE; Schema: public; Owner: voice_agent_user
--

CREATE TABLE public."Admin" (
    id integer NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role public."AdminRole" DEFAULT 'ADMIN'::public."AdminRole" NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Admin" OWNER TO voice_agent_user;

--
-- Name: Admin_id_seq; Type: SEQUENCE; Schema: public; Owner: voice_agent_user
--

CREATE SEQUENCE public."Admin_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Admin_id_seq" OWNER TO voice_agent_user;

--
-- Name: Admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voice_agent_user
--

ALTER SEQUENCE public."Admin_id_seq" OWNED BY public."Admin".id;


--
-- Name: ApiKey; Type: TABLE; Schema: public; Owner: voice_agent_user
--

CREATE TABLE public."ApiKey" (
    id integer NOT NULL,
    provider text NOT NULL,
    key text NOT NULL,
    masked text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "encryptedDek" text NOT NULL,
    name text DEFAULT 'Default Connection'::text NOT NULL,
    "teamId" integer NOT NULL
);


ALTER TABLE public."ApiKey" OWNER TO voice_agent_user;

--
-- Name: ApiKey_id_seq; Type: SEQUENCE; Schema: public; Owner: voice_agent_user
--

CREATE SEQUENCE public."ApiKey_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ApiKey_id_seq" OWNER TO voice_agent_user;

--
-- Name: ApiKey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voice_agent_user
--

ALTER SEQUENCE public."ApiKey_id_seq" OWNED BY public."ApiKey".id;


--
-- Name: Team; Type: TABLE; Schema: public; Owner: voice_agent_user
--

CREATE TABLE public."Team" (
    id integer NOT NULL,
    name text NOT NULL,
    "inviteCode" text NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Team" OWNER TO voice_agent_user;

--
-- Name: Team_id_seq; Type: SEQUENCE; Schema: public; Owner: voice_agent_user
--

CREATE SEQUENCE public."Team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Team_id_seq" OWNER TO voice_agent_user;

--
-- Name: Team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voice_agent_user
--

ALTER SEQUENCE public."Team_id_seq" OWNED BY public."Team".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: voice_agent_user
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    role public."TeamRole" DEFAULT 'TEAM_MEMBER'::public."TeamRole" NOT NULL,
    "teamId" integer NOT NULL
);


ALTER TABLE public."User" OWNER TO voice_agent_user;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: voice_agent_user
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO voice_agent_user;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voice_agent_user
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: Admin id; Type: DEFAULT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."Admin" ALTER COLUMN id SET DEFAULT nextval('public."Admin_id_seq"'::regclass);


--
-- Name: ApiKey id; Type: DEFAULT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."ApiKey" ALTER COLUMN id SET DEFAULT nextval('public."ApiKey_id_seq"'::regclass);


--
-- Name: Team id; Type: DEFAULT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."Team" ALTER COLUMN id SET DEFAULT nextval('public."Team_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Data for Name: Admin; Type: TABLE DATA; Schema: public; Owner: voice_agent_user
--

COPY public."Admin" (id, email, password, role, metadata, "createdAt", "updatedAt") FROM stdin;
1	superadmin@voiceagent.com	$2b$10$gJxJ8HsCpjkPm5Z5BOQ6Zu/5TPQthGZO3i1HUv16kGc7rD8KjXtpW	SUPER_ADMIN	{"notes": "Global Super Administrator"}	2026-07-09 16:02:27.35	2026-07-09 16:02:27.35
2	admin@voiceagent.com	$2b$10$jc.pGxviqRGwEbiB3KDD/eqkAHvlnD7Bq4M28vgUijyXzU0U.4a6a	ADMIN	{"notes": "Global Administrator"}	2026-07-09 16:02:27.353	2026-07-09 16:02:27.353
\.


--
-- Data for Name: ApiKey; Type: TABLE DATA; Schema: public; Owner: voice_agent_user
--

COPY public."ApiKey" (id, provider, key, masked, "createdAt", "updatedAt", "encryptedDek", name, "teamId") FROM stdin;
1	openai	bf08994966f497776c87d450:db26aae7d38e1446b32cad77abeb5a09:249819fa02b9a8faab2621b246d0b6c308f48f0fc5364bbfb5836a	sk--****2345	2026-07-09 16:16:58.204	2026-07-09 16:16:58.204	15f588326cdad59679732609:3892b1caad752eeb522526a8320c10cf:5e197534ea250060cde368acb8f78645443d193906887602706107c558dd3d574bedf522d05cb62a06bccf23fddf07c3d66c7c34bf96f45b3a17fff106f02019	Stark OpenAI Key	3
\.


--
-- Data for Name: Team; Type: TABLE DATA; Schema: public; Owner: voice_agent_user
--

COPY public."Team" (id, name, "inviteCode", settings, "createdAt", "updatedAt") FROM stdin;
1	Acme Corp	acme-invite-123	{"plan": "Enterprise", "maxKeys": 10}	2026-07-09 16:02:27.355	2026-07-09 16:02:27.355
2	Globex	globex-invite-456	{"plan": "Pro", "maxKeys": 5}	2026-07-09 16:02:27.357	2026-07-09 16:02:27.357
3	Stark Industries	starkind-403472	{}	2026-07-09 16:16:58.136	2026-07-09 16:16:58.136
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: voice_agent_user
--

COPY public."User" (id, email, password, "createdAt", "updatedAt", metadata, role, "teamId") FROM stdin;
1	acme_admin@voiceagent.com	$2b$10$pSCPlyKniUiWobUBpsKtE.ZP.7tAxHeG2vHVVw.kwxYXFX5tKO2gm	2026-07-09 16:02:27.582	2026-07-09 16:02:27.582	{"name": "John Doe (Acme Admin)"}	TEAM_ADMIN	1
2	acme_dev@voiceagent.com	$2b$10$sfBTPovTH/WH1r75FYnXuOhehSSTvopN8caBX7WkZcoB4cyOOKJl2	2026-07-09 16:02:27.586	2026-07-09 16:02:27.586	{"name": "Jane Dev (Acme Developer)"}	TEAM_DEVELOPER	1
3	acme_member@voiceagent.com	$2b$10$rNhX847yz.XC8dSOYvd9auHcmPUImpSVHJndY0IiHUY126vMwxTYi	2026-07-09 16:02:27.588	2026-07-09 16:02:27.588	{"name": "Bob User (Acme Member)"}	TEAM_MEMBER	1
4	globex_admin@voiceagent.com	$2b$10$udXV.jwD4tLLye5M.ZsiteSAfYuYG/jpM2N2n4KBZ76xcHFB9qQbm	2026-07-09 16:02:27.589	2026-07-09 16:02:27.589	{"name": "Alice Smith (Globex Admin)"}	TEAM_ADMIN	2
5	globex_integrator@voiceagent.com	$2b$10$UN5UJXqBbgt3/Ilq3zBW0u0KUEzyCxt.3bh38iWw6YFtHczPEv6Ym	2026-07-09 16:02:27.59	2026-07-09 16:02:27.59	{"name": "Charlie Integrator (Globex Integration)"}	TEAM_INTEGRATION	2
6	stark_admin@voiceagent.com	$2b$10$ZWfUu3zJAdh70Y.1RmoTSOVFD5pbm0eT2OTkQPEoxvaWv.ISWqxqK	2026-07-09 16:16:58.19	2026-07-09 16:16:58.19	{}	TEAM_ADMIN	3
\.


--
-- Name: Admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voice_agent_user
--

SELECT pg_catalog.setval('public."Admin_id_seq"', 2, true);


--
-- Name: ApiKey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voice_agent_user
--

SELECT pg_catalog.setval('public."ApiKey_id_seq"', 1, true);


--
-- Name: Team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voice_agent_user
--

SELECT pg_catalog.setval('public."Team_id_seq"', 3, true);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voice_agent_user
--

SELECT pg_catalog.setval('public."User_id_seq"', 6, true);


--
-- Name: Admin Admin_pkey; Type: CONSTRAINT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."Admin"
    ADD CONSTRAINT "Admin_pkey" PRIMARY KEY (id);


--
-- Name: ApiKey ApiKey_pkey; Type: CONSTRAINT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."ApiKey"
    ADD CONSTRAINT "ApiKey_pkey" PRIMARY KEY (id);


--
-- Name: Team Team_pkey; Type: CONSTRAINT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."Team"
    ADD CONSTRAINT "Team_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Admin_email_key; Type: INDEX; Schema: public; Owner: voice_agent_user
--

CREATE UNIQUE INDEX "Admin_email_key" ON public."Admin" USING btree (email);


--
-- Name: ApiKey_provider_name_teamId_key; Type: INDEX; Schema: public; Owner: voice_agent_user
--

CREATE UNIQUE INDEX "ApiKey_provider_name_teamId_key" ON public."ApiKey" USING btree (provider, name, "teamId");


--
-- Name: Team_inviteCode_key; Type: INDEX; Schema: public; Owner: voice_agent_user
--

CREATE UNIQUE INDEX "Team_inviteCode_key" ON public."Team" USING btree ("inviteCode");


--
-- Name: Team_name_key; Type: INDEX; Schema: public; Owner: voice_agent_user
--

CREATE UNIQUE INDEX "Team_name_key" ON public."Team" USING btree (name);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: voice_agent_user
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: ApiKey ApiKey_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."ApiKey"
    ADD CONSTRAINT "ApiKey_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: User User_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: voice_agent_user
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO voice_agent_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO voice_agent_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO voice_agent_user;


--
-- PostgreSQL database dump complete
--

\unrestrict BWpqPfpNDGlcD3Ohjn1XI3mlIbafEFbTqzkzyGUoRpgtKPy1JZgh3C1YkQghUxH

