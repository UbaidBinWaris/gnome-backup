--
-- PostgreSQL database dump
--

\restrict xVapHlHCa9cIMuuBeewQNIRxfZeJXkWc9HSNer80UTVs2neCqZgFVWG2NKNzySr

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
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


--
-- Name: ContactStatus; Type: TYPE; Schema: public; Owner: linkedindatabase
--

CREATE TYPE public."ContactStatus" AS ENUM (
    'NEW',
    'READY_TO_MESSAGE',
    'MESSAGED',
    'FOLLOW_UP_DUE',
    'REPLIED',
    'CLOSED'
);


ALTER TYPE public."ContactStatus" OWNER TO linkedindatabase;

--
-- Name: ContactTag; Type: TYPE; Schema: public; Owner: linkedindatabase
--

CREATE TYPE public."ContactTag" AS ENUM (
    'RECRUITER',
    'DEVELOPER',
    'FOUNDER'
);


ALTER TYPE public."ContactTag" OWNER TO linkedindatabase;

--
-- Name: DraftStatus; Type: TYPE; Schema: public; Owner: linkedindatabase
--

CREATE TYPE public."DraftStatus" AS ENUM (
    'DRAFT',
    'APPROVED',
    'SCHEDULED',
    'PUBLISHED',
    'REJECTED'
);


ALTER TYPE public."DraftStatus" OWNER TO linkedindatabase;

--
-- Name: DraftType; Type: TYPE; Schema: public; Owner: linkedindatabase
--

CREATE TYPE public."DraftType" AS ENUM (
    'POST',
    'COMMENT'
);


ALTER TYPE public."DraftType" OWNER TO linkedindatabase;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agent_memories; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.agent_memories (
    id text NOT NULL,
    category text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    confidence double precision DEFAULT 1.0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.agent_memories OWNER TO linkedindatabase;

--
-- Name: commented_posts; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.commented_posts (
    id integer NOT NULL,
    "postId" text NOT NULL,
    "postUrl" text,
    "authorName" text,
    "commentText" text,
    "commentedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.commented_posts OWNER TO linkedindatabase;

--
-- Name: commented_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: linkedindatabase
--

CREATE SEQUENCE public.commented_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commented_posts_id_seq OWNER TO linkedindatabase;

--
-- Name: commented_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: linkedindatabase
--

ALTER SEQUENCE public.commented_posts_id_seq OWNED BY public.commented_posts.id;


--
-- Name: competitor_tracks; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.competitor_tracks (
    id text NOT NULL,
    name text NOT NULL,
    "linkedinUrl" text NOT NULL,
    headline text,
    "avgReactions" double precision DEFAULT 0,
    "avgComments" double precision DEFAULT 0,
    "topTopics" text[] DEFAULT ARRAY[]::text[],
    "lastAnalyzed" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.competitor_tracks OWNER TO linkedindatabase;

--
-- Name: contacts; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.contacts (
    id text NOT NULL,
    name text NOT NULL,
    role text NOT NULL,
    company text NOT NULL,
    location text NOT NULL,
    "linkedinUrl" text NOT NULL,
    notes text,
    status public."ContactStatus" DEFAULT 'NEW'::public."ContactStatus" NOT NULL,
    tag public."ContactTag",
    "firstMessage" text,
    "followUpMessage" text,
    "lastMessageAt" timestamp(3) without time zone,
    "followUpDueAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.contacts OWNER TO linkedindatabase;

--
-- Name: linkedin_comments; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.linkedin_comments (
    id text NOT NULL,
    "postId" text NOT NULL,
    "commenterName" text,
    "commenterUrl" text,
    "commentText" text,
    likes integer DEFAULT 0,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP,
    emotion text,
    "hasCTA" boolean DEFAULT false NOT NULL,
    "hasQuestion" boolean DEFAULT false NOT NULL,
    intent text,
    "isSpam" boolean DEFAULT false NOT NULL,
    "qualityScore" double precision,
    sentiment text
);


ALTER TABLE public.linkedin_comments OWNER TO linkedindatabase;

--
-- Name: linkedin_posts; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.linkedin_posts (
    id text NOT NULL,
    "profileId" text,
    "postText" text,
    "postType" text,
    reactions integer DEFAULT 0,
    comments integer DEFAULT 0,
    reposts integer DEFAULT 0,
    "postedAt" timestamp(3) without time zone,
    "scrapedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "authorFollowers" integer,
    "authorHeadline" text,
    "authorName" text,
    hashtags text[] DEFAULT ARRAY[]::text[],
    industry text,
    language text DEFAULT 'en'::text,
    mentions text[] DEFAULT ARRAY[]::text[],
    "postId" text,
    "postUrl" text,
    "sentimentScore" double precision,
    topic text,
    "viralScore" double precision
);


ALTER TABLE public.linkedin_posts OWNER TO linkedindatabase;

--
-- Name: linkedin_profiles; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.linkedin_profiles (
    id text NOT NULL,
    "linkedinUrl" text NOT NULL,
    "fullName" text,
    headline text,
    about text,
    followers integer,
    connections integer,
    location text,
    "scrapedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.linkedin_profiles OWNER TO linkedindatabase;

--
-- Name: post_drafts; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.post_drafts (
    id text NOT NULL,
    type public."DraftType" DEFAULT 'COMMENT'::public."DraftType" NOT NULL,
    "targetPostId" text,
    "targetPostUrl" text,
    "authorName" text,
    content text NOT NULL,
    style text,
    "predictedScore" double precision,
    status public."DraftStatus" DEFAULT 'DRAFT'::public."DraftStatus" NOT NULL,
    "scheduledFor" timestamp(3) without time zone,
    "publishedAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.post_drafts OWNER TO linkedindatabase;

--
-- Name: raw_snapshots; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.raw_snapshots (
    id text NOT NULL,
    "sourceType" text NOT NULL,
    "sourceUrl" text NOT NULL,
    "htmlContent" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.raw_snapshots OWNER TO linkedindatabase;

--
-- Name: viral_patterns; Type: TABLE; Schema: public; Owner: linkedindatabase
--

CREATE TABLE public.viral_patterns (
    id text NOT NULL,
    topic text NOT NULL,
    "contentType" text NOT NULL,
    "bestPostingHour" integer,
    "bestDayOfWeek" integer,
    "avgEngagement" double precision NOT NULL,
    "sampleSize" integer DEFAULT 1 NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.viral_patterns OWNER TO linkedindatabase;

--
-- Name: commented_posts id; Type: DEFAULT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.commented_posts ALTER COLUMN id SET DEFAULT nextval('public.commented_posts_id_seq'::regclass);


--
-- Data for Name: agent_memories; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.agent_memories (id, category, key, value, confidence, "createdAt") FROM stdin;
\.


--
-- Data for Name: commented_posts; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.commented_posts (id, "postId", "postUrl", "authorName", "commentText", "commentedAt") FROM stdin;
1	9927834686997611390	https://www.linkedin.com/feed/update/urn:li:activity:9927834686997611390	Mohammed Faiq Ali	Adopting AI in small businesses feels like agile in software—both enable rapid adaptation and a competitive edge. How do you see AI changing decision-making processes traditionally hampered by hierarchy?	2026-04-10 20:46:11.858
2	6246104138894415511	https://www.linkedin.com/feed/update/urn:li:activity:6246104138894415511	Sheharyar K.	Intriguing take on AI in development. How do you see AI's role evolving in handling complex system architecture decisions?	2026-04-10 20:47:07.018
3	8206379166402130979	https://www.linkedin.com/feed/update/urn:li:activity:8206379166402130979	Hakim Siddiki	Running AI models locally is a game-changer for control and cost, but how do you balance this with the infrastructure complexity? What strategies are you considering for scaling?	2026-04-10 20:47:57.188
4	7870962038263856701	https://www.linkedin.com/feed/update/urn:li:activity:7870962038263856701	Michael B. Zimmerman commented	Your mom's perspective is enlightening and a good reminder of how crucial transparency is in business models. Have you found any specific ways to communicate value to customers that help manage these expectations?	2026-04-10 20:49:35.743
5	7157106485004508555	https://www.linkedin.com/feed/update/urn:li:activity:7157106485004508555	Muhammad Hanzala	Mapping processes often uncovers gaps that teams miss. When you find undocumented exceptions, how do you ensure they're effectively integrated into the automation design?	2026-04-10 20:51:36.495
6	7142643752034348563	https://www.linkedin.com/feed/update/urn:li:activity:7142643752034348563	Hanzla Sadaqat	Interesting work, Hanzla. How do you ensure that automation maintains a personal touch in communications like onboarding emails?	2026-04-10 21:08:58.627
7	7850142120596360301	https://www.linkedin.com/feed/update/urn:li:activity:7850142120596360301	Sazzad Hussain Farhaan	About choosing the right AI for the job. Often overlooked is that even specialized models need tailored inputs to truly shine. How do you ensure data quality in diverse AI applications?	2026-04-10 21:10:03.536
8	6066672671251131944	https://www.linkedin.com/feed/update/urn:li:activity:6066672671251131944	Ikram Rana	Focusing on problems before products is crucial, but how do you ensure the automation process enhances the user experience and not just functionality?	2026-04-10 21:18:24.591
9	7855155770560245242	https://www.linkedin.com/feed/update/urn:li:activity:7855155770560245242	Emma Shad	The shift to AI orchestration feels like when scalable microservices replaced monolithic apps. How do you see this influencing team structures in tech?	2026-04-10 21:20:07.538
10	7399082211043172502	https://www.linkedin.com/feed/update/urn:li:activity:7399082211043172502	Hamda Shafique commented	Finding leads is indeed challenging! While automating booking systems, ensuring they engage correctly with users was key. How do you tackle unexpected user scenarios?	2026-04-10 21:20:50.588
11	7774103100601139895	https://www.linkedin.com/feed/update/urn:li:activity:7774103100601139895	JavaScript Mastery commented	With AI becoming a hiring focus, how do you see developers best integrating AI skills into traditional full-stack roles like MERN or ReactNative?	2026-04-10 21:21:34.792
12	9622236603990172451	https://www.linkedin.com/feed/update/urn:li:activity:9622236603990172451	Shankar M	When considering these AI tools, how do you think they handle scalability in high-demand environments, especially with complex data sets? Curious about any insights on potential limitations.	2026-04-10 21:23:39.051
13	7053145060358104819	https://www.linkedin.com/feed/update/urn:li:activity:7053145060358104819	Mohamed Rifaath celebrates this	Foundational systems are key, but don't you think AI can help streamline the messiness if integrated thoughtfully? How do you see it enhancing daily workflows if the basics are set?	2026-04-11 23:27:11.268
14	9125802536792430158	https://www.linkedin.com/feed/update/urn:li:activity:9125802536792430158	Alexander Shartsis	Larry's instinct reminds me of systems that trigger alerts at crucial times. How do you see this innate alertness translating into automated processes for startups?	2026-04-11 23:27:57.058
15	7149181171400720898	https://www.linkedin.com/feed/update/urn:li:activity:7149181171400720898	Hamda Shafique commented	Integrating AI tools in web systems can dramatically enhance functionality. When I embedded a retrieval API for dynamic content updates, it transformed user engagement. How do you see AI agents further evolving in web applications?	2026-04-11 23:29:54.489
16	6265863132281661566	https://www.linkedin.com/feed/update/urn:li:activity:6265863132281661566	Ahmad Sajjad	AI’s power in automation is undeniable, but it can magnify errors exponentially. How can we better educate users on the ethical boundaries before diving into automation?	2026-04-11 23:31:53.263
17	8430927334893462889	https://www.linkedin.com/feed/update/urn:li:activity:8430927334893462889	Julius Farin	Building your own infrastructure is bold, especially with zero vendor lock-in. Curious about the challenges you faced with real-time interface deployment on edge nodes?	2026-04-11 23:32:34.276
18	7079042833897311785	https://www.linkedin.com/feed/update/urn:li:activity:7079042833897311785	Kenneth T. Hertz FACMPE	The focus on consistency is spot on. How do you suggest leaders can better ensure their actions align with their stated values to build trust?	2026-04-11 23:33:20.366
19	9876757573007256821	https://www.linkedin.com/feed/update/urn:li:activity:9876757573007256821	Charles Antis	Your creative approach to representing impact is commendable! While visual storytelling is powerful, how do you plan to sustain and scale the impact beyond the initial moments of engagement?	2026-04-11 23:34:14.106
20	6471703698585865222	https://www.linkedin.com/feed/update/urn:li:activity:6471703698585865222	Muhammad Usman Subhani	Just like building scalable web apps, integrating AI effectively into workflows means designing systems that enhance processes, not just using tools. How do you see these AI systems evolving in terms of developer roles?	2026-04-11 23:36:03.646
21	8236714312552429291	https://www.linkedin.com/feed/update/urn:li:activity:8236714312552429291	Khubaib Haider	When developing a client dashboard, we used Next.js to integrate real-time data updates, dramatically improving decision-making speed and accuracy. How do you ensure the data remains actionable and not overwhelming for users?	2026-04-11 23:36:54.148
22	6157099556133000266	https://www.linkedin.com/feed/update/urn:li:activity:6157099556133000266	Mike Schindler	In tech, like leadership, the unseen code reviews and late-night debugging are what build resilient systems. How do you see 'Human 10.0' applying to tech teams dealing with constant change?	2026-04-11 23:37:36.018
23	9973085715320666178	https://www.linkedin.com/feed/update/urn:li:activity:9973085715320666178	Alexander Shartsis commented	How do you ensure that automation at Lightfield enhances rather than hinders the authentic connections you emphasize? Balancing these elements can be tricky.	2026-04-11 23:38:32.875
24	7442931585366204416	https://www.linkedin.com/feed/update/urn:li:share:7442931585366204416	Arman Suleimenov	Arman, the focus on prompt engineering and efficient context management is intriguing. How are learners applying these skills in real-world projects during the program?	2026-04-11 23:42:06.241
25	7447541776791339008	https://www.linkedin.com/feed/update/urn:li:share:7447541776791339008	Cem Onur	Katrina's story is indeed inspiring, especially in leadership. However, I'd love to hear more about the tangible ways her influence has shaped industry practices. What strategies has she implemented that others might adopt?	2026-04-11 23:44:38.151
26	7447540249758662656	https://www.linkedin.com/feed/update/urn:li:activity:7447540249758662656	Most people see the title CEO.	Katrina's journey echoes the iterative nature of software development—constant learning, adapting, and building from setbacks define true progress. How did these experiences shape her leadership approach?	2026-04-11 23:46:53.563
27	7399147753570130505	https://www.linkedin.com/feed/update/urn:li:activity:7399147753570130505	Rana Zia UL Din	Experienced this firsthand when integrating Next.js into our stack; the turning point was getting everyone on board with experimentation and continuous learning. How do you ensure leaders actively engage with new tech?	2026-04-11 23:48:39.916
28	9231806622498665436	https://www.linkedin.com/feed/update/urn:li:activity:9231806622498665436	Arslan Akbar	Viewing AI as a teammate is insightful, but how do we ensure these AI agents align with business goals without human oversight becoming a bottleneck?	2026-04-12 20:57:57.798
29	6179019622560581523	https://www.linkedin.com/feed/update/urn:li:activity:6179019622560581523	Mike Schindler	In tech, rapid shifts can make decision architecture a moving target. How can leaders ensure their frameworks stay adaptive without constant overhauls?	2026-04-12 20:58:52.96
30	6176434910696721803	https://www.linkedin.com/feed/update/urn:li:activity:6176434910696721803	Alexander Shartsis commented	While building a web app for a startup, we assumed a high valuation based on features, but market feedback shifted our focus to user experience to match real value. How do you balance founder vision with market demands?	2026-04-12 20:59:40.723
31	8363424777429628358	https://www.linkedin.com/feed/update/urn:li:activity:8363424777429628358	Alexander Shartsis	While hands-on AI learning is crucial, how do you see AI tools reshaping daily workflows to ensure genuine adoption beyond just email rewrites?	2026-04-12 21:00:19.066
32	7448866993199267843	https://www.linkedin.com/feed/update/urn:li:share:7448866993199267843	Evan Chi	Jumping into the market early has its merits. When we launched our latest platform, consistent visibility was key, driving a 30% lift in engagement within months. How do you prioritize content themes to maintain that visibility?	2026-04-12 21:01:43.372
33	9986494303096257861	https://www.linkedin.com/feed/update/urn:li:activity:9986494303096257861	Sami Ullah	Balancing AI efficiency with code quality reminds me of when automation meets software scalability—speed doesn't replace the need for a solid foundation. How do you ensure your team keeps up with these rapid changes?	2026-04-12 21:03:33.633
34	8180814139327881785	https://www.linkedin.com/feed/update/urn:li:activity:8180814139327881785	Syed Farjaad Raza Rizvi	AI-driven automation definitely streamlines tasks like data processing. However, ensuring a human touch in customer inquiries can enhance trust and engagement. How do you see AI maintaining personalization in customer service?	2026-04-12 21:04:09.19
35	6244184469433854211	https://www.linkedin.com/feed/update/urn:li:activity:6244184469433854211	Abdul Manan	It's crucial to balance AI's convenience with a strong grasp of basics like Local Storage. How do you suggest integrating foundational learning into fast-paced AI environments?	2026-04-12 21:04:48.19
36	6489318816659468353	https://www.linkedin.com/feed/update/urn:li:activity:6489318816659468353	Naveed Ur Rehman	Implementing AI-driven features in web apps, I've seen how anticipating user needs can transform engagement. How do you see this proactive approach evolving in multilingual contexts?	2026-04-12 21:05:26.784
37	9440016715349385923	https://www.linkedin.com/feed/update/urn:li:activity:9440016715349385923	Raj Wadhwani	It's fascinating how technology like ATMs didn't eliminate bank branches. With AI in contact centers, could we see a similar evolution in agent roles rather than a replacement?	2026-04-12 21:09:42.857
38	7896789336139182353	https://www.linkedin.com/feed/update/urn:li:activity:7896789336139182353	Vitali Brunovski	Caught a 'Shadow API' issue last quarter that was leaking sensitive data. A real eye-opener on how undocumented APIs can fly under the radar. How do you prioritize which APIs to audit first?	2026-04-12 21:11:38.931
39	7193889136136989685	https://www.linkedin.com/feed/update/urn:li:activity:7193889136136989685	James Compton	Identifying career dysmorphia feels akin to spotting technical debt in a project. It’s crucial to address it early to avoid stalling growth. How do you suggest balancing this awareness with daily responsibilities?	2026-04-12 21:13:22.367
40	7652609161820315253	https://www.linkedin.com/feed/update/urn:li:activity:7652609161820315253	Muzammil Mehdi	Intriguing take on AI's impact! While AI speeds up prototyping, how do you ensure the generated code maintains quality and aligns with project goals?	2026-04-12 21:15:16.552
41	7446096697363095552	https://www.linkedin.com/feed/update/urn:li:activity:7446096697363095552	JavaScript Mastery	Interesting challenge! It's crucial to remember that the second condition in a logical AND operation isn't evaluated if the first returns false. This short-circuits the evaluation. How might this behavior impact more complex logic in larger codebases?	2026-04-12 21:18:26.265
42	6481472941689067567	https://www.linkedin.com/feed/update/urn:li:activity:6481472941689067567	Hassan Ali	When integrating AI into a web app for SEO optimization, I faced similar issues with disconnected tools. Streamlining the data flow first made AI enhancements truly impactful. How do you prioritize system redesign before introducing AI?	2026-04-12 21:23:57.866
43	7444086760097915095	https://www.linkedin.com/feed/update/urn:li:activity:7444086760097915095	Kevin McBeth	When I built a feature scaling tool using Next.js, optimizing API responses to handle concurrency was key. Have you considered API batching to improve speed in version 3?	2026-04-15 18:11:31.794
44	9418213476796347942	https://www.linkedin.com/feed/update/urn:li:activity:9418213476796347942	Saifullah Shaukat supports this	AI that automates backlog tasks could seriously streamline operations. Curious how Ovren scales for larger projects with complex workflows?	2026-04-15 18:13:08.177
45	7365233716536168346	https://www.linkedin.com/feed/update/urn:li:activity:7365233716536168346	Clyvo AI	Curious about what specific AI tools you see as most effective for scaling smarter and reducing manual tasks?	2026-04-15 18:13:51.867
46	8070820941887604942	https://www.linkedin.com/feed/update/urn:li:activity:8070820941887604942	Alexander Shartsis commented	Diving into these signals is exciting, Alexander. Yet, it's crucial to also recognize how atypical successes might skew perceptions. How do you discern which signals are truly scalable?	2026-04-15 18:15:35.539
47	8803982810020143461	https://www.linkedin.com/feed/update/urn:li:activity:8803982810020143461	Ehtasham Ali	The shift towards AI-native workflows reminds me of designing scalable systems in web development. It's crucial to rethink architecture for seamless execution. How are you seeing companies tackle manual handoffs effectively?	2026-04-15 18:17:39.312
48	6294756297021969559	https://www.linkedin.com/feed/update/urn:li:activity:6294756297021969559	Micheal Ifeanyi	Balancing accuracy with latency and cost is an ongoing challenge. Have you found specific strategies effective in adapting AI systems to varying operational demands?	2026-04-15 18:18:40.51
49	6633279292668822523	https://www.linkedin.com/feed/update/urn:li:activity:6633279292668822523	Troy Hiltbrand	In one project, AI helped us automate testing but needed human oversight for edge cases. How do you see leaders balancing AI efficiency with human judgment?	2026-04-15 18:20:19.226
50	8114872812343780447	https://www.linkedin.com/feed/update/urn:li:activity:8114872812343780447	Emily Meehan	Choosing the right tools over more tools really resonates. Last quarter, I saw a project thrive when we focused on one robust AI tool that aligned with our workflow. How do you ensure your teams identify their best-fit tools effectively?	2026-04-15 18:22:10.272
51	8863141968515754505	https://www.linkedin.com/feed/update/urn:li:activity:8863141968515754505	Nicholas Simpson	It's inspiring to see how AI is democratizing tech development, allowing small teams to innovate rapidly. How do you see this trend affecting the competitive landscape in PropTech?	2026-04-15 18:23:10.732
52	7700023392774443529	https://www.linkedin.com/feed/update/urn:li:activity:7700023392774443529	Mehedi H.	While AI as cognitive infrastructure is compelling, could the scalability failures also be tied to fundamental gaps in cross-functional collaboration? How do you see this aspect evolving?	2026-04-15 18:24:57.933
53	6095077933626015492	https://www.linkedin.com/feed/update/urn:li:activity:6095077933626015492	Saif Razzaq	The creator marketplace and automated monetization model remind me of the complexities in scaling web applications. How did you ensure seamless integration across all these diverse components?	2026-04-15 18:26:01.467
54	8557310626218950656	https://www.linkedin.com/feed/update/urn:li:activity:8557310626218950656	Mohammed Faiq Ali commented	Building frameworks that scale across diverse AI applications is intriguing. How do you envision ensuring these tools remain robust and adaptable as AI tech rapidly evolves?	2026-04-15 18:26:52.051
55	8522872329146071908	https://www.linkedin.com/feed/update/urn:li:activity:8522872329146071908	Timi Adeleke	Building reliable automation systems is a real challenge. I once worked on an API integration where the timing and data flow needed meticulous attention to ensure seamless operation. How do you handle unexpected data errors in your pipelines?	2026-04-15 18:27:53.18
56	7988059942279945025	https://www.linkedin.com/feed/update/urn:li:activity:7988059942279945025	JavaScript Mastery commented	Clear separation and modular components definitely boost team collaboration. Curious, how does this structure handle rapid feature additions in real-world scenarios?	2026-04-15 18:29:34.11
57	6890947478577843724	https://www.linkedin.com/feed/update/urn:li:activity:6890947478577843724	Unknown	With managed automation routines reducing the need to build from scratch, how do you see this affecting the creative input of developers in decision-making and innovation?	2026-04-17 16:17:57.261
58	7460134540670443520	https://www.linkedin.com/feed/update/urn:li:ugcPost:7460134540670443520	Apt.Residential	Shipped a similar mid-rise BTR project last year — the real challenge was coordinating the multiple building façades alongside retail fit-outs, not just topping out the structure. Seeing the 2,500sqm Coles Local integrated seamlessly is a solid win for resident convenience and project flow.	2026-05-14 02:49:14.949
59	6484494245126928793	https://www.linkedin.com/feed/update/urn:li:activity:6484494245126928793	Alexander Shartsis commented	Curious how Ownify structures the fractional ownership for organizations like Jonathan's Path — is it a shared-equity model or more like a revolving investment fund? Understanding this would help clarify how scalability works for similar nonprofit housing projects.	2026-05-14 02:50:37.344
60	9711286121173646920	https://www.linkedin.com/feed/update/urn:li:activity:9711286121173646920	Nabeel Yousaf	This mirrors a core systems design principle: tools are becoming interchangeable commodities, while orchestration and workflow architecture are the real differentiators. In software engineering, the teams that win are rarely the ones with the biggest stack — they’re the ones designing resilient integrations, automation layers, and feedback loops around it.	2026-05-16 16:35:45.458
61	6444205380478745522	https://www.linkedin.com/feed/update/urn:li:activity:6444205380478745522	Abhii Dabas	The point about the gap between what gets promised and what gets delivered in cross-border real estate is spot on — though in my experience, technology alone rarely fixes that gap without aligned incentives and operational transparency between all parties involved. Sellers and buyers may share uncertainty, but they often experience completely different information asymmetries.	2026-05-16 16:36:50.31
62	7155945990966066894	https://www.linkedin.com/feed/update/urn:li:activity:7155945990966066894	Nikki Fogden-Moore	When I built an AI-driven operations workflow for a small service business, the hardest part wasn’t the automation itself — it was helping the team create clarity around cashflow, staffing, and decision-making before introducing tools like n8n and GPT-based assistants. The interactive format you’re doing in Cairns is usually where the real transformation happens because people can map frameworks directly to the operational chaos they’re facing.	2026-05-16 16:38:11.475
63	7169209249452723212	https://www.linkedin.com/feed/update/urn:li:activity:7169209249452723212	Md Rakibul Hasan Hridoy	The AI reply detection and intent classification layer is the part that stood out most to me because that’s usually where automation quality breaks down in real outreach systems. Curious how you handled edge cases where replies are ambiguous or contain mixed intent signals.	2026-05-16 16:39:07.522
64	7143513399359762090	https://www.linkedin.com/feed/update/urn:li:activity:7143513399359762090	Ali Awan	{\n"comment": "The shift from just shipping UI to owning performance, accessibility, and product thinking is very real especially once applications start handling real-time personalization at scale. The developers standing out now are the ones who can balance AI-assisted speed with solid architecture and debugging discipline.",\n"best_angle": "Provided an insightful reaction reinforcing the evolution of frontend responsibilities without forcing an unnecessary question."	2026-05-16 16:42:59.949
65	6106799773475130951	https://www.linkedin.com/feed/update/urn:li:activity:6106799773475130951	Rachel League	When I was building a LinkedIn automation and scraping pipeline recently, most of the breakthroughs came from conversations with other builders who had already solved scaling and data consistency issues. That kind of ecosystem energy you described around the 90+ Philly Tech Week events is what accelerates products from side projects into real systems.	2026-05-16 16:45:50.158
66	8959674592258370355	https://www.linkedin.com/feed/update/urn:li:activity:8959674592258370355	Alex Claudovich	How does the extension benchmark profiles against top freelancers without direct access to Upwork ranking signals?	2026-05-16 16:54:14.334
67	9939859002325407752	https://www.linkedin.com/feed/update/urn:li:activity:9939859002325407752	Adham Elhelaly	When I built an n8n Instagram pipeline, long-term memory consistency across retries was the hardest production issue.	2026-05-16 16:56:02.752
68	7569775856443737671	https://www.linkedin.com/feed/update/urn:li:activity:7569775856443737671	Talha Tariq	This mirrors DevOps evolution tooling alone never mattered without engineers understanding orchestration, control layers, and system boundaries.	2026-05-16 16:57:11.115
69	6548487986710257150	https://www.linkedin.com/feed/update/urn:li:activity:6548487986710257150	Aneeqa Tahir	Real-time calendar syncing scales well until conflicting edits and WhatsApp delivery failures introduce silent scheduling inconsistencies.	2026-05-16 16:58:08.275
70	8754862032682038705	https://www.linkedin.com/feed/update/urn:li:activity:8754862032682038705	Janet Ofejiro John	Consistency matters, though n8n version changes and integration updates often cause more debugging than forgotten skills alone.	2026-05-16 16:59:07.351
71	6344920928195785099	https://www.linkedin.com/feed/update/urn:li:activity:6344920928195785099	Jessie Glew	Shipped a rebrand last quarter public criticism faded fast once the product consistently activated local community engagement.	2026-05-16 17:00:23.985
72	6009238110240517532	https://www.linkedin.com/feed/update/urn:li:activity:6009238110240517532	DataZoro	How is the Trust Score validated against actual supplier fulfillment performance rather than scraped profile completeness?	2026-05-16 17:01:17.468
73	7459875021390446592	https://www.linkedin.com/feed/update/urn:li:share:7459875021390446592	Stephan Rind	When integrating blockchain settlement logic, regulatory compliance workflows consumed more engineering time than smart contract development.	2026-05-16 17:03:40.811
74	7940395032299091181	https://www.linkedin.com/feed/update/urn:li:activity:7940395032299091181	Abu Bakar Aslam	This mirrors distributed systems debugging confidence matters because production incidents rarely arrive with complete observability.	2026-05-16 17:05:11.162
75	7851831453716482702	https://www.linkedin.com/feed/update/urn:li:activity:7851831453716482702	komal c	Modern frameworks accelerate shipping, but abstraction layers also make root-cause debugging and performance attribution significantly harder.	2026-05-16 17:08:34.791
76	8422378091386057427	https://www.linkedin.com/feed/update/urn:li:activity:8422378091386057427	Steve P.	Frontend-backend tension is real, though missing observability usually causes more panic than failed APIs themselves.	2026-05-16 17:09:30.764
77	6284191138235345647	https://www.linkedin.com/feed/update/urn:li:activity:6284191138235345647	Abderahmane Abdellani	How did the Gemini classifier handle ambiguous support emails without incorrectly auto-replying or mislabeling conversations?	2026-05-25 19:27:00.739
78	7025160558744296218	https://www.linkedin.com/feed/update/urn:li:activity:7025160558744296218	Nikki Fogden-Moore commented	Shipped multiple AI automations recently; deliberate offline planning blocks consistently produced better architectural decisions than nonstop execution.	2026-05-25 19:28:20.872
79	9849906963548471262	https://www.linkedin.com/feed/update/urn:li:activity:9849906963548471262	Adam Flynn	Built a property automation platform recently; sustaining innovation momentum past year two was harder than initial product-market fit.	2026-05-25 19:30:13.63
80	7919107671602958270	https://www.linkedin.com/feed/update/urn:li:activity:7919107671602958270	Osama Ameer	AI accelerates shipping, though senior engineers still prevent costly architectural and scaling mistakes juniors rarely anticipate.	2026-05-25 19:32:09.408
81	7427951702856142049	https://www.linkedin.com/feed/update/urn:li:activity:7427951702856142049	Nishan Mahbubani	Local Ollama inference reduces API costs, though workflow reliability becomes tightly coupled to single-machine hardware availability.	2026-05-25 19:33:03.995
82	6791429318948850414	https://www.linkedin.com/feed/update/urn:li:activity:6791429318948850414	Syton Tang	This mirrors search-engine discovery problems fragmented indexing often hides high-value nodes behind low visibility signals.	2026-05-25 19:34:07.987
83	9487880571839432293	https://www.linkedin.com/feed/update/urn:li:activity:9487880571839432293	Justin Welsh commented	The “no-code killing developers” prediction ignored how quickly integration complexity and edge-case debugging compound at scale.	2026-05-25 19:36:02.237
84	6466617298578011507	https://www.linkedin.com/feed/update/urn:li:activity:6466617298578011507	Rahul Choudhary	Shipped a GraphQL-heavy dashboard last quarter; resolver performance and caching became bigger production bottlenecks than frontend queries.	2026-05-25 19:36:51.513
85	9571884512288680880	https://www.linkedin.com/feed/update/urn:li:activity:9571884512288680880	Alexander Shartsis commented	When launching an AI scheduling tool, conversion improved after replacing feature lists with reduced missed-meeting outcomes.	2026-05-25 19:37:39.863
86	8286185047807628540	https://www.linkedin.com/feed/update/urn:li:activity:8286185047807628540	Ather Jawad	Blockchain depth matters, though long-term demand still depends heavily on solving practical scalability and regulatory adoption challenges.	2026-05-25 19:41:59.646
87	6361944125716525639	https://www.linkedin.com/feed/update/urn:li:activity:6361944125716525639	Zohaib Mujtaba	AI-generated stacks scale until observability, deployment rollback, and distributed failure handling become unavoidable operational bottlenecks.	2026-05-25 19:43:06.119
88	9843958457302222002	https://www.linkedin.com/feed/update/urn:li:activity:9843958457302222002	Jacki Choo	This mirrors event-driven automation pipelines unstructured inputs becoming real-time actionable data through orchestrated AI workflows.	2026-05-25 19:45:01.815
89	7463135314664972288	https://www.linkedin.com/feed/update/urn:li:activity:7463135314664972288	Jacki Choo commented	Shipped AI-driven marketing automations recently; market expansion proved harder than building the underlying intelligence layer.	2026-05-30 11:59:15.842
90	7466412928141778945	https://www.linkedin.com/feed/update/urn:li:share:7466412928141778945	EZOrder Live	This mirrors workflow orchestration systems reducing context-switching often delivers bigger productivity gains than adding more staff.	2026-05-30 12:01:27.838
91	9136999771527878713	https://www.linkedin.com/feed/update/urn:li:activity:9136999771527878713	Sidra Tul Muntaha	Instant responses help, though complex bookings and edge-case intent often still benefit from human escalation paths.	2026-05-30 12:04:29.852
92	6895563790754173286	https://www.linkedin.com/feed/update/urn:li:activity:6895563790754173286	Alexander Shartsis	Curious how Skyp's MCP integration drives adoption compared to the traditional interface among active customers?	2026-05-30 12:06:27.485
93	6660171382479919808	https://www.linkedin.com/feed/update/urn:li:activity:6660171382479919808	New comment in your group	When building AI automations in n8n, unclear requirements caused far more delays than implementation speed ever solved.	2026-05-30 12:07:33.206
94	9763536432927848785	https://www.linkedin.com/feed/update/urn:li:activity:9763536432927848785	Nikki Fogden-Moore	Clarity scales decisions, but excessive clarity-seeking can become a bottleneck when rapid iteration is the advantage.	2026-05-30 12:09:33.059
95	9591270949681568533	https://www.linkedin.com/feed/update/urn:li:activity:9591270949681568533	w3schools.com commented	Built multiple AI automations; integrating RAG and APIs exposed more learning gaps than Python fundamentals ever did.	2026-05-30 12:11:39.923
96	8633151380167837745	https://www.linkedin.com/feed/update/urn:li:activity:8633151380167837745	malomatia celebrates this	AI Accelerate mirrors hackathon-driven prototyping rapid experimentation often uncovers breakthrough ideas before formal roadmaps do.	2026-05-30 12:12:36.163
97	9656898790546046175	https://www.linkedin.com/feed/update/urn:li:activity:9656898790546046175	Nicholas Simpson celebrates this	Skills matter enormously, though strong academic foundations often compound opportunities when paired with real-world execution.	2026-05-30 12:14:49.038
98	9205668038495625472	https://www.linkedin.com/feed/update/urn:li:activity:9205668038495625472	Usama Arshad Jadoon	The shift from Rs. 55,000 in loss to Rs. 700,000 in support shows community trust still scales.	2026-05-30 12:20:36.202
99	9481816745801688622	https://www.linkedin.com/feed/update/urn:li:activity:9481816745801688622	Brad Pilgrim	When building backend automations, customers cared far more about measurable outcomes than dashboard features or workflows.	2026-05-30 12:21:22.658
100	9285297123607772169	https://www.linkedin.com/feed/update/urn:li:activity:9285297123607772169	Nathaniel Groleau	Remote work exposes management issues, though some collaboration and mentorship challenges genuinely become harder asynchronously.	2026-06-01 15:30:18.284
101	6726460772524833740	https://www.linkedin.com/feed/update/urn:li:activity:6726460772524833740	Elaine Roberts	The shift from inbox-driven execution to three-year priorities is often where strong managers become effective leaders.	2026-06-01 15:31:22.444
102	8802606099234702251	https://www.linkedin.com/feed/update/urn:li:activity:8802606099234702251	Tayyab Bajwa	When pitching automation projects, tailored problem-focused proposals consistently outperformed generic outreach despite lower application volume.	2026-06-01 15:32:21.06
103	7122376726928776717	https://www.linkedin.com/feed/update/urn:li:activity:7122376726928776717	Upamanyu Deka	Shipped multiple React products; debugging event loop behavior and stale closures consumed more time than UI implementation.	2026-06-01 15:34:42.037
104	7281042003538339783	https://www.linkedin.com/feed/update/urn:li:activity:7281042003538339783	JavaScript	This mirrors CPU scheduling automating low-priority maintenance frees scarce engineering cycles for high-impact strategic workloads.	2026-06-01 15:35:25.888
105	6777248894934029306	https://www.linkedin.com/feed/update/urn:li:activity:6777248894934029306	Md Rakibul Hasan Hridoy	Multi-agent systems scale capability, but coordination failures and memory consistency often become the dominant bottlenecks.	2026-06-01 15:36:11.109
106	8264172050276540124	https://www.linkedin.com/feed/update/urn:li:activity:8264172050276540124	Saasinator	Understanding RAG and embeddings helps, though real value often comes from applying them to business problems.	2026-06-01 15:37:04.146
107	9265787978285944883	https://www.linkedin.com/feed/update/urn:li:activity:9265787978285944883	Rashmi Priya (ICF PCC)	The point about change dying in the middle highlights where execution discipline often matters more than strategy.	2026-06-01 15:38:13.15
108	9866982234031855964	https://www.linkedin.com/feed/update/urn:li:activity:9866982234031855964	Abdur Rehman	When building a RAG document system, OCR quality impacted retrieval accuracy more than model selection.	2026-06-01 15:39:03.456
109	8162532657434862530	https://www.linkedin.com/feed/update/urn:li:activity:8162532657434862530	Charles Vincent Kaluwasha	Shipped client acquisition automations last quarter; consistency in one channel outperformed constantly switching strategies.	2026-06-01 15:39:59.996
110	9582282553266572738	https://www.linkedin.com/feed/update/urn:li:activity:9582282553266572738	Ahsan Mumtaz	This mirrors platform engineering optimizing for long-term scalability and reliability instead of short-term feature delivery.	2026-06-01 15:40:43.824
111	7409768273179340108	https://www.linkedin.com/feed/update/urn:li:activity:7409768273179340108	Hamidullah Khan, PhD	RemoteOK and similar platforms scale access, but increased applicant volume often reduces signal-to-noise for candidates.	2026-06-01 15:41:33.848
112	9912725130684415662	https://www.linkedin.com/feed/update/urn:li:activity:9912725130684415662	Muzammil Shehzad	Technical literacy matters, though leading AI projects eventually requires hands-on implementation experience beyond tool proficiency.	2026-06-01 15:42:15.822
113	7274591820345350615	https://www.linkedin.com/feed/update/urn:li:activity:7274591820345350615	Abhii Dabas	What ownership model have you seen consistently reduce that 70 80% pilot-to-production failure rate?	2026-06-01 15:43:09.311
114	6201116329217549066	https://www.linkedin.com/feed/update/urn:li:activity:6201116329217549066	Alex Mamaev	When building AI automations with Claude, debugging production edge cases took far longer than initial prototyping.	2026-06-01 15:44:19.391
115	7693414740175307796	https://www.linkedin.com/feed/update/urn:li:activity:7693414740175307796	Max Honcharuk	Shipped products with small teams; cross-functional ownership accelerated delivery more than adding specialized headcount.	2026-06-01 15:45:24.588
116	9773070451493894471	https://www.linkedin.com/feed/update/urn:li:activity:9773070451493894471	Andrew Nelson	This mirrors queue optimization automating ticket triage and status updates removes bottlenecks before core systems work.	2026-06-01 15:46:07.775
117	9695820005180737449	https://www.linkedin.com/feed/update/urn:li:activity:9695820005180737449	Evgeny Lishnevsky	Prototype speed compounds value, but unchecked AI-generated code can silently increase long-term maintenance costs.	2026-06-01 15:48:17.218
118	6599446860584297207	https://www.linkedin.com/feed/update/urn:li:activity:6599446860584297207	Louis Wharmby	This mirrors higher-level programming languages abstraction boosts output, but architecture and systems thinking remain essential.	2026-06-09 19:42:55.038
119	8293146903239282508	https://www.linkedin.com/feed/update/urn:li:activity:8293146903239282508	Surinder Sahni	When converting AI-generated layouts, Core Web Vitals optimization consistently took longer than initial implementation.	2026-06-09 19:43:54.078
120	6195338878634610229	https://www.linkedin.com/feed/update/urn:li:activity:6195338878634610229	JavaScript Mastery commented	Architecture matters, though premature structure can slow teams before product requirements are fully understood.	2026-06-09 19:44:57.568
121	9435017710188098770	https://www.linkedin.com/feed/update/urn:li:activity:9435017710188098770	Tariqul Islam Mikail	Sharing knowledge scales teams, but effective leaders also build systems preventing mentorship from becoming a bottleneck.	2026-06-09 19:45:41.66
122	9305134707475981308	https://www.linkedin.com/feed/update/urn:li:activity:9305134707475981308	Salem Njejimana	How does the Document Optimizer preserve founder intent while improving investor-readiness across different startup stages?	2026-06-09 19:47:41.559
123	8406751478357207567	https://www.linkedin.com/feed/update/urn:li:activity:8406751478357207567	Ahmed Raza commented	Shipped workflow automations recently; root-cause visibility reduced recurring issues far more than faster incident response.	2026-06-09 19:49:33.024
124	6333289559278922966	https://www.linkedin.com/feed/update/urn:li:activity:6333289559278922966	Ahmed Raza finds this insightful	This mirrors iterative system design scalable architectures emerge through consistent refinement, not one-time planning.	2026-06-09 19:51:56.452
125	8993025745747960886	https://www.linkedin.com/feed/update/urn:li:activity:8993025745747960886	Ankit Singh	When building n8n automations, system design decisions delivered bigger gains than individual AI model upgrades.	2026-06-09 19:52:37.066
126	9748359171418016293	https://www.linkedin.com/feed/update/urn:li:activity:9748359171418016293	Vaibhav Tripathi	Simple workflows drive ROI, though agent loops become valuable once processes span multiple systems and decisions.	2026-06-09 19:54:27.825
127	8915160247522726571	https://www.linkedin.com/feed/update/urn:li:activity:8915160247522726571	Arijit Ghosh	Chunking impacts retrieval quality, but metadata strategy often determines scalability and filtering accuracy.	2026-06-09 19:56:14.181
128	9423964602625768087	https://www.linkedin.com/feed/update/urn:li:activity:9423964602625768087	Atta Ur Rehman Shah commented	How do you prevent MEMORY.md from accumulating outdated context and degrading agent decisions over time?	2026-06-09 19:58:19.936
129	8680210188332464508	https://www.linkedin.com/feed/update/urn:li:activity:8680210188332464508	Emma Shad	Shipped multi-agent workflows recently; orchestration failures caused more issues than individual model performance.	2026-06-09 19:59:59.47
130	7258434213676244953	https://www.linkedin.com/feed/update/urn:li:activity:7258434213676244953	Ramsha Anwar	This mirrors data normalization mapping four supplier formats removes operational friction and enables reliable automation.	2026-06-09 20:01:08.678
131	6356028436618418912	https://www.linkedin.com/feed/update/urn:li:activity:6356028436618418912	ARYAN RAJ	Small branches reduce conflicts, but excessive fragmentation can increase integration overhead and review complexity.	2026-06-11 18:51:51.501
132	8518753774617512492	https://www.linkedin.com/feed/update/urn:li:activity:8518753774617512492	Dean Ogude	What cost-control safeguards would you consider mandatory before launching a public-facing AWS side project?	2026-06-11 18:52:58.086
133	7564003264588003163	https://www.linkedin.com/feed/update/urn:li:activity:7564003264588003163	Md Rakibul Hasan Hridoy	Shipped multi-agent automations; memory synchronization and task handoffs proved harder than agent implementation.	2026-06-11 18:53:58.175
134	6333021900885694605	https://www.linkedin.com/feed/update/urn:li:activity:6333021900885694605	Moses O (OMCP. DMI. GDMC)	Faster development is thriving, though maintaining systems long-term still demands expertise beyond rapid AI-assisted shipping.	2026-06-11 18:54:52.835
135	7336919813526581250	https://www.linkedin.com/feed/update/urn:li:activity:7336919813526581250	Post	This mirrors predictive caching Google Ads smart bidding uses historical patterns to optimize decisions before execution.	2026-06-11 18:57:18.77
136	7558481389564007062	https://www.linkedin.com/feed/update/urn:li:activity:7558481389564007062	akkad ouail	No response found	2026-06-15 13:51:40.78
137	7119794354900376925	https://www.linkedin.com/feed/update/urn:li:activity:7119794354900376925	Shaikh Faizan Ahmed	Agent-to-human transfer improves accessibility, but scaling live-call availability becomes the real operational bottleneck.	2026-06-15 13:52:52.925
138	7083540956105991356	https://www.linkedin.com/feed/update/urn:li:activity:7083540956105991356	Vishakha Singhal	For PATCH, how do you handle partial updates safely when multiple clients modify the same resource?	2026-06-15 13:55:02.188
139	8955762140474286983	https://www.linkedin.com/feed/update/urn:li:activity:8955762140474286983	New comment in your group	Less code is valuable, though overly aggressive reduction can obscure intent and increase maintenance risk.	2026-06-15 13:57:05.314
140	9666207689766983628	https://www.linkedin.com/feed/update/urn:li:activity:9666207689766983628	Faiq Ahmad commented	<the comment>	2026-06-15 13:58:09.69
141	6127886262300776938	https://www.linkedin.com/feed/update/urn:li:activity:6127886262300776938	Alexander Shartsis	<the comment>	2026-06-15 14:00:23.118
142	6186520439871637926	https://www.linkedin.com/feed/update/urn:li:activity:6186520439871637926	Eashan J.	<the comment>	2026-06-18 15:47:54.402
143	7446214883632229303	https://www.linkedin.com/feed/update/urn:li:activity:7446214883632229303	Maryam Bahrami	CRAG is powerful for retrieval efficiency, though access control and data freshness often remain the harder problems.	2026-06-18 15:53:53.554
144	8075970650508158978	https://www.linkedin.com/feed/update/urn:li:activity:8075970650508158978	Nicholas Simpson commented	Built lead automation handling 200+ weekly conversations; preserving agent voice mattered more than response speed.	2026-06-18 15:54:57.593
145	6626414845734562309	https://www.linkedin.com/feed/update/urn:li:activity:6626414845734562309	Muhammad Sufyan Zahid	When I demoed an n8n lead system, explaining saved hours closed more conversations than code details.	2026-06-18 15:57:02.66
146	6978769900305115170	https://www.linkedin.com/feed/update/urn:li:activity:6978769900305115170	Lavanya Lanka	The real test is whether the sales story survives new hires without conversion rates degrading.	2026-06-18 15:59:31.64
147	9135700791362040743	https://www.linkedin.com/feed/update/urn:li:activity:9135700791362040743	Saurabh Dubey	This mirrors microservice design; memory, tools, and triggers matter only when interfaces stay reliable.	2026-06-18 16:01:41.452
148	9622956195270266959	https://www.linkedin.com/feed/update/urn:li:activity:9622956195270266959	Krupal Chaudhary	Knowledge transfer becomes technical debt when architectural decisions exist only in prompts, not documentation.	2026-06-18 16:03:31.453
149	7472993209195880449	https://www.linkedin.com/feed/update/urn:li:share:7472993209195880449	Michael Lee	Execution matters most, though the right strategy still determines which last mile is worth scaling.	2026-06-18 16:04:58.229
150	8346175212942338908	https://www.linkedin.com/feed/update/urn:li:activity:8346175212942338908	Muhammad Usman	Built similar n8n agents; context handling worked, but tool reliability caused most production failures.	2026-06-18 16:06:53.14
151	7657830587299560966	https://www.linkedin.com/feed/update/urn:li:activity:7657830587299560966	Muhammad Nouman Rashid	When I built a healthcare booking workflow, WhatsApp reminders alone reduced missed appointments significantly.	2026-06-18 16:07:35.276
152	8910119839864341688	https://www.linkedin.com/feed/update/urn:li:activity:8910119839864341688	Premkumar Arumugam commented	Buying Committee Mapper scales outreach, but inaccurate role inference can quietly compound across downstream workflows.	2026-06-18 16:08:33.061
153	9317814289002797780	https://www.linkedin.com/feed/update/urn:li:activity:9317814289002797780	Taimoor Ul Hassan	Built similar n8n pipelines; deduplication looked easy, but maintaining lead quality consumed most debugging time.	2026-06-28 16:09:59.346
154	8131439409943546770	https://www.linkedin.com/feed/update/urn:li:activity:8131439409943546770	SUHEB MOHAMMED commented	When building automation systems, most downtime was prevented by safeguards designed before deployment, not fixes afterward.	2026-06-28 16:10:45.857
155	8917285699511438810	https://www.linkedin.com/feed/update/urn:li:activity:8917285699511438810	Dinesh Prajapati	WhatsApp booking assistants help response times, though complex bookings still benefit from seamless human escalation.	2026-06-28 16:13:04.128
156	9761404296189461584	https://www.linkedin.com/feed/update/urn:li:activity:9761404296189461584	Suranjith Prasad	Component-based development mirrors microservices; clear boundaries enable reuse, scaling, and independent team ownership.	2026-06-28 16:14:18.365
157	8816150382058671148	https://www.linkedin.com/feed/update/urn:li:activity:8816150382058671148	Christian Espinosa	AI Overviews reduce clicks, but stronger brand authority increasingly determines which sources models cite.	2026-06-28 16:16:42.771
158	6829537814879793112	https://www.linkedin.com/feed/update/urn:li:activity:6829537814879793112	Tehmina Fatima	The strict database-only boundaries are key; reliable automation depends more on guardrails than model intelligence.	2026-06-28 16:17:49.563
159	7358632141317849463	https://www.linkedin.com/feed/update/urn:li:activity:7358632141317849463	Manthan Patel commented	Built GTM automations this quarter; curated inspiration sources improved execution far more than chasing new tactics.	2026-06-28 16:18:41.494
160	7944184907375865475	https://www.linkedin.com/feed/update/urn:li:activity:7944184907375865475	Lavanya Lanka	When I launched an AI receptionist, a hybrid PLG-sales motion converted better than self-serve alone.	2026-06-28 16:20:55.841
161	8698118825104817640	https://www.linkedin.com/feed/update/urn:li:activity:8698118825104817640	Nimantha Baranasuriya, PhD commented	Ownership accelerates growth, though some initial domain interest often makes deep learning curves far more sustainable.	2026-06-28 16:21:51.332
162	6746775090181218240	https://www.linkedin.com/feed/update/urn:li:activity:6746775090181218240	Arslan Hameed	Provider failover mirrors resilient microservices; abstraction layers matter most when dependencies inevitably fail.	2026-06-28 16:23:55.985
163	6324861903277730587	https://www.linkedin.com/feed/update/urn:li:activity:6324861903277730587	Zohaib A. Ahmad	Hours saved matter, but poorly defined processes often automate inefficiency instead of eliminating it.	2026-07-07 14:02:59.948
164	8494643333509123492	https://www.linkedin.com/feed/update/urn:li:activity:8494643333509123492	Shreeram Das	When I built an AI receptionist, reliable tool execution mattered far more than conversational quality.	2026-07-07 14:05:21.558
165	6833391757337193288	https://www.linkedin.com/feed/update/urn:li:activity:6833391757337193288	KOMAL SHARMA	Google Sheets as a knowledge base mirrors event-driven systems; simple components often scale through clean orchestration.	2026-07-07 14:07:03.714
166	8162811630652292716	https://www.linkedin.com/feed/update/urn:li:activity:8162811630652292716	Muhammad Zubair Zair	The human handoff boundary is the strongest design choice; reliable escalation usually determines customer trust.	2026-07-07 14:07:44.841
167	7586932017460017348	https://www.linkedin.com/feed/update/urn:li:activity:7586932017460017348	Shuaib Khan	Built similar tool-calling agents; conversation memory stayed easy, but reliable tool execution consumed most debugging time.	2026-07-07 14:09:49.538
168	8136600917204758336	https://www.linkedin.com/feed/update/urn:li:activity:8136600917204758336	Djan Cano	n8n excels at deterministic workflows, though AI guardrails can reliably automate more judgment tasks than many expect.	2026-07-07 14:13:28.593
169	7778741646254665214	https://www.linkedin.com/feed/update/urn:li:activity:7778741646254665214	Atta Ur Rehman Shah commented	MCP simplifies integration, but permission boundaries become the real scaling challenge as connected tools multiply.	2026-07-07 14:15:16.78
170	7461324938249699560	https://www.linkedin.com/feed/update/urn:li:activity:7461324938249699560	ZAIN KHAN	When I built an n8n content pipeline, JavaScript filtering improved relevance more than prompt tuning.	2026-07-07 14:17:12.654
171	6522894518303035340	https://www.linkedin.com/feed/update/urn:li:activity:6522894518303035340	Md. Ahsan Khan	Last-20-message context mirrors sliding-window caching; bounded state improves efficiency without sacrificing responsiveness.	2026-07-07 14:19:16.206
172	6460714431275401430	https://www.linkedin.com/feed/update/urn:li:activity:6460714431275401430	Muhammad Burhan Khan	How are you handling email deliverability and domain reputation while sending follow-ups after 3 and 8 days?	2026-07-07 14:20:13.936
173	9570679422970109374	https://www.linkedin.com/feed/update/urn:li:activity:9570679422970109374	JavaScript Mastery commented	Shipped a Next.js dashboard; architecture changes mattered less than enforcing consistent boundaries between modules.	2026-07-07 14:21:21.663
\.


--
-- Data for Name: competitor_tracks; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.competitor_tracks (id, name, "linkedinUrl", headline, "avgReactions", "avgComments", "topTopics", "lastAnalyzed") FROM stdin;
\.


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.contacts (id, name, role, company, location, "linkedinUrl", notes, status, tag, "firstMessage", "followUpMessage", "lastMessageAt", "followUpDueAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: linkedin_comments; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.linkedin_comments (id, "postId", "commenterName", "commenterUrl", "commentText", likes, "createdAt", emotion, "hasCTA", "hasQuestion", intent, "isSpam", "qualityScore", sentiment) FROM stdin;
\.


--
-- Data for Name: linkedin_posts; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.linkedin_posts (id, "profileId", "postText", "postType", reactions, comments, reposts, "postedAt", "scrapedAt", "authorFollowers", "authorHeadline", "authorName", hashtags, industry, language, mentions, "postId", "postUrl", "sentimentScore", topic, "viralScore") FROM stdin;
\.


--
-- Data for Name: linkedin_profiles; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.linkedin_profiles (id, "linkedinUrl", "fullName", headline, about, followers, connections, location, "scrapedAt") FROM stdin;
d721b316-4628-40cc-85b8-6ba44c395d24	https://www.linkedin.com/in/williamhgates	Join LinkedIn	Not you?Remove photo		0	\N		2026-05-14 03:31:02.239
\.


--
-- Data for Name: post_drafts; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.post_drafts (id, type, "targetPostId", "targetPostUrl", "authorName", content, style, "predictedScore", status, "scheduledFor", "publishedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: raw_snapshots; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.raw_snapshots (id, "sourceType", "sourceUrl", "htmlContent", "createdAt") FROM stdin;
c8db6054-1fff-4b59-bba0-8e6449badc32	profile	https://www.linkedin.com/in/williamhgates	<!DOCTYPE html><html lang="en"><head>\n        <meta name="pageKey" content="auth_wall_desktop_profile">\n<!----><!----><!---->        <meta name="locale" content="en_US">\n<!---->        <meta id="config" data-app-version="2.1.1253" data-call-tree-id="AAZRvrmM8AngNIey07Is7Q==" data-multiproduct-name="seo-directory-frontend" data-service-name="seo-directory-frontend" data-browser-id="da27f096-a9c7-487f-8326-5287f7a0186f" data-is-bot="false" data-enable-page-view-heartbeat-tracking="" data-page-instance="urn:li:page:auth_wall_desktop_profile;WslihCLRRaeMeWPpVnFUIg==" data-disable-jsbeacon-pagekey-suffix="false" data-member-id="0" data-msafdf-lib="https://static.licdn.com/aero-v1/sc/h/80ndnja80f2uvg4l8sj2su82m" data-should-use-full-url-in-pve-path="true" data-dna-member-lix-treatment="enabled" data-human-member-lix-treatment="enabled" data-dfp-member-lix-treatment="control" data-sync-apfc-headers-lix-treatment="control" data-sync-apfc-cb-lix-treatment="control" data-recaptcha-v3-integration-lix-value="control" data-network-interceptor-lix-value="control" data-is-epd-audit-event-enabled="false" data-is-feed-sponsored-tracking-kill-switch-enabled="false" data-sequence-auto-redirect-before-request-enabled="true">\n\n        <link rel="canonical" href="/authwall">\n<!----><!---->\n<!---->\n<!---->\n<!---->\n<!---->\n          <link rel="icon" href="https://static.licdn.com/aero-v1/sc/h/al2o9zrvru7aqj8e1x2rzsrca">\n\n\n        <script>\n          function getDfd() {let yFn,nFn;const p=new Promise(function(y, n){yFn=y;nFn=n;});p.resolve=yFn;p.reject=nFn;return p;}\n          window.lazyloader = getDfd();\n          window.tracking = getDfd();\n          window.impressionTracking = getDfd();\n          window.ingraphTracking = getDfd();\n          window.appDetection = getDfd();\n          window.pemTracking = getDfd();\n          window.appRedirectCompleted = getDfd();\n        </script>\n\n<!---->\n        \n      <title>\n        Sign Up | LinkedIn\n      </title>\n      <link rel="canonical" href="/authwall">\n      <meta name="description" content="750 million+ members | Manage your professional identity. Build and engage with your professional network. Access knowledge, insights and opportunities.">\n      <meta name="robots" content="noindex, noarchive">\n      <meta name="viewport" content="width=device-width, minimum-scale=1.0">\n      <meta name="locale" content="en_US">\n\n      <meta property="og:title" content="Sign Up | LinkedIn">\n      <meta property="og:image" content="https://static.licdn.com/aero-v1/scds/common/u/images/logos/favicons/v1/favicon.ico">\n      <meta property="og:type" content="website">\n      <meta property="og:url" content="/authwall">\n      <meta name="twitter:card" content="summary">\n      <meta name="twitter:site" content="@Linkedin">\n      <meta name="twitter:title" content="Sign Up | LinkedIn">\n      <meta name="twitter:image" content="https://static.licdn.com/aero-v1/scds/common/u/images/logos/favicons/v1/favicon.ico">\n      <meta name="platform-worker" content="https://static.licdn.com/aero-v1/sc/h/bxullzz73p3hhf78t6sj3w6pb">\n      <meta name="litmsProfileName" content="seo-directory-frontend">\n      <meta name="clientSideIngraphs" content="1" data-gauge-metric-endpoint="/directory/api/ingraphs/gauge" data-counter-metric-endpoint="/directory/api/ingraphs/counter">\n      <script src="https://static.licdn.com/aero-v1/sc/h/95dn6qmfiqsklhxazp0jn20zg"></script>\n\n      <link rel="stylesheet" href="https://static.licdn.com/aero-v1/sc/h/b5vydpik9slh5mwqap0g5jq59">\n    \n<!---->      <script type="text/javascript" src="https://static.licdn.com/aero-v1/sc/h/80ndnja80f2uvg4l8sj2su82m" data-test-id="msafdf"></script><script type="text/javascript" src="https://platform.linkedin.com/litms/utag/seo-directory-frontend/utag.js?cb=1778729400000" async=""></script></head>\n      <body dir="ltr">\n<!----><!----><!---->\n        \n      \n    \n    \n    \n    <form class="google-auth" action="/uas/login-submit" method="post">\n      <input name="loginCsrfParam" value="da27f096-a9c7-487f-8326-5287f7a0186f" type="hidden">\n        <input name="session_redirect" value="/authwall" type="hidden">\n      <input name="trk" value="seo-authwall-base_google-one-tap-submit" type="hidden">\n        <div class="google-one-tap__module fixed flex flex-col items-center top-[20px] right-[20px] z-[9999]">\n          <div class="google-auth__tnc-container relative top-2 bg-color-background-container-tint pl-2 pr-1 pt-2 pb-3 w-[375px] rounded-md shadow-2xl">\n            <p class="text-md font-bold text-color-text">\n              Agree &amp; Join LinkedIn\n            </p>\n            \n    \n    \n    \n    <p class="linkedin-tc__text text-color-text-low-emphasis text-xs pb-2 !text-sm !text-color-text">\n      By clicking Continue to join or sign in, you agree to LinkedIn’s <a href="/legal/user-agreement?trk=linkedin-tc_auth-button_user-agreement" target="_blank" data-tracking-control-name="linkedin-tc_auth-button_user-agreement" data-tracking-will-navigate="true">User Agreement</a>, <a href="/legal/privacy-policy?trk=linkedin-tc_auth-button_privacy-policy" target="_blank" data-tracking-control-name="linkedin-tc_auth-button_privacy-policy" data-tracking-will-navigate="true">Privacy Policy</a>, and <a href="/legal/cookie-policy?trk=linkedin-tc_auth-button_cookie-policy" target="_blank" data-tracking-control-name="linkedin-tc_auth-button_cookie-policy" data-tracking-will-navigate="true">Cookie Policy</a>.\n    </p>\n  \n          </div>\n          <div data-tracking-control-name="seo-authwall-base_google-one-tap" id="google-one-tap__container"><div id="credential_picker_container" style="position: relative; z-index: 9999; top: 0px; left: 0px; height: 148px; width: auto;"><iframe src="https://accounts.google.com/gsi/iframe/select?client_id=990339570472-k6nqn1tpmitg8pui82bfaun3jrpmiuhs.apps.googleusercontent.com&amp;auto_select=true&amp;ux_mode=popup&amp;ui_mode=card&amp;context=signin&amp;as=X6Rsg7a%2FSSp7RvSdnZddaA&amp;channel_id=3fc005a2b053c89bf5ec9a4604fc39ece95b7ac443a71eed3c17ceb9d8235ec8&amp;origin=https%3A%2F%2Fwww.linkedin.com&amp;hl=en_US" title="Sign in with Google Dialog" style="height: 148px; width: 391px; overflow: hidden;"></iframe></div></div>\n        </div>\n      \n    <div class="loader loader--full-screen">\n      <div class="loader__container mb-2 overflow-hidden">\n        <icon class="loader__icon inline-block loader__icon--default text-color-progress-loading lazy-loaded" data-svg-class-name="loader__icon-svg--large fill-currentColor h-[60px] min-h-[60px] w-[60px] min-w-[60px]" aria-hidden="true" aria-busy="false"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60" width="60" height="60" focusable="false" class="loader__icon-svg--large fill-currentColor h-[60px] min-h-[60px] w-[60px] min-w-[60px] lazy-loaded" aria-busy="false">\n  <g>\n    <path opacity="1" d="M30.1,16.1L30.1,16.1c-0.6,0-1-0.5-1-1V1c0-0.6,0.5-1,1-1l0,0c0.6,0,1,0.5,1,1v14.1C31.1,15.7,30.6,16.1,30.1,16.1z"></path>\n    <path opacity="0.85" d="M23.1,18.1L23.1,18.1c-0.5,0.3-1.1,0.1-1.4-0.4L14.5,5.6c-0.3-0.5-0.2-1.1,0.4-1.4l0,0C15.4,3.9,16,4,16.3,4.6l7.2,12.1C23.8,17.2,23.6,17.8,23.1,18.1z"></path>\n    <path opacity="0.77" d="M17.9,23.1L17.9,23.1c-0.3,0.5-0.9,0.7-1.4,0.4l-12.2-7c-0.5-0.3-0.7-0.9-0.4-1.4l0,0c0.3-0.5,0.9-0.7,1.4-0.4l12.2,7C18,22,18.2,22.7,17.9,23.1z"></path>\n    <path opacity="0.69" d="M16.1,30.1L16.1,30.1c0,0.6-0.5,1-1,1L1,31.2c-0.6,0-1-0.5-1-1l0,0c0-0.6,0.5-1,1-1l14.1-0.1C15.7,29.1,16.1,29.5,16.1,30.1z"></path>\n    <path opacity="0.61" d="M18,36.9L18,36.9c0.3,0.5,0.2,1.1-0.4,1.4L5.5,45.6c-0.5,0.3-1.1,0.2-1.4-0.4l0,0c-0.3-0.5-0.2-1.1,0.4-1.4l12.1-7.3C17.1,36.2,17.7,36.4,18,36.9z"></path>\n    <path opacity="0.53" d="M23.3,42.1L23.3,42.1c0.5,0.3,0.6,0.9,0.4,1.4l-7.3,12.1c-0.3,0.5-0.9,0.6-1.4,0.4l0,0c-0.5-0.3-0.6-0.9-0.4-1.4l7.3-12.1C22.1,41.9,22.8,41.8,23.3,42.1z"></path>\n    <path opacity="0.45" d="M30.1,43.9L30.1,43.9c0.6,0,1,0.5,1,1V59c0,0.6-0.5,1-1,1l0,0c-0.6,0-1-0.5-1-1V44.9C29,44.4,29.5,43.9,30.1,43.9z"></path>\n    <path opacity="0.37" d="M37,41.9L37,41.9c0.5-0.3,1.1-0.2,1.4,0.4l7.2,12.1c0.3,0.5,0.2,1.1-0.4,1.4l0,0c-0.5,0.3-1.1,0.2-1.4-0.4l-7.2-12.1C36.4,42.8,36.6,42.2,37,41.9z"></path>\n    <path opacity="0.29" d="M42.2,36.8L42.2,36.8c0.3-0.5,0.9-0.7,1.4-0.4l12.2,7c0.5,0.3,0.7,0.9,0.4,1.4l0,0c-0.3,0.5-0.9,0.7-1.4,0.4l-12.2-7C42.1,38,41.9,37.4,42.2,36.8z"></path>\n    <path opacity="0.21 " d="M44,29.9L44,29.9c0-0.6,0.5-1,1-1h14.1c0.6,0,1,0.5,1,1l0,0c0,0.6-0.5,1-1,1L45,31C44.4,31,44,30.5,44,29.9z"></path>\n    <path opacity="0.13" d="M42.1,23.1L42.1,23.1c-0.3-0.5-0.2-1.1,0.4-1.4l12.1-7.3c0.5-0.3,1.1-0.2,1.4,0.4l0,0c0.3,0.4,0.1,1.1-0.4,1.3l-12.1,7.3C43.1,23.7,42.4,23.6,42.1,23.1z"></path>\n    <path opacity="0.05" d="M36.9,17.9L36.9,17.9c-0.5-0.3-0.6-0.9-0.4-1.4l7.3-12.1c0.3-0.5,0.9-0.6,1.4-0.4l0,0c0.5,0.3,0.6,0.9,0.4,1.4l-7.4,12.2C38,18.1,37.3,18.2,36.9,17.9z"></path>\n    <animateTransform attributeName="transform" attributeType="XML" type="rotate" begin="0s" dur="1s" repeatCount="indefinite" calcMode="discrete" keyTimes="0;.0833;.166;.25;.3333;.4166;.5;.5833;.6666;.75;.8333;.9166;1" values="0,30,30;30,30,30;60,30,30;90,30,30;120,30,30;150,30,30;180,30,30;210,30,30;240,30,30;270,30,30;300,30,30;330,30,30;360,30,30"></animateTransform>\n  </g>\n</svg></icon>\n      </div>\n    </div>\n  \n    </form>\n      <script data-module-id="google-gsi-lib" data-track-latency="" src="https://static.licdn.com/aero-v1/sc/h/29rdkxlvag0d3cpj96fiilbju" class="lazy-loaded"></script>\n    \n    \n    \n    \n    \n      \n      \n  \n      \n<!---->\n    <div class="focus-page">\n        \n    \n\n    <a href="#main-content" class="skip-link btn-md btn-primary absolute z-11 -top-[100vh] focus:top-0">\n      Skip to main content\n    </a>\n  \n      <header class="focus-page__header global-alert-offset">\n          \n\n    \n    \n    \n    \n\n    \n\n    <nav class="nav pt-1.5 pb-2 flex items-center justify-between relative flex-nowrap babymamabear:py-1.5\n        \n        \n         focus-page__nav" aria-label="Primary">\n\n      <a href="/?trk=seo-authwall-base_nav-header-logo" class="nav__logo-link link-no-visited-state z-1 mr-auto min-h-[52px] flex items-center babybear:z-0 hover:no-underline focus:no-underline active:no-underline\n          " data-tracking-control-name="seo-authwall-base_nav-header-logo" data-tracking-will-navigate="">\n          \n                \n    \n    <span class="sr-only">LinkedIn</span>\n<!---->      <icon class="block text-color-brand w-[102px] h-[26px] lazy-loaded" data-test-id="nav-logo" aria-hidden="true" aria-busy="false"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 84 21" preserveAspectRatio="xMinYMin meet" version="1.1" focusable="false" class="lazy-loaded" aria-busy="false">\n  <g class="inbug" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">\n    <path d="M19.479,0 L1.583,0 C0.727,0 0,0.677 0,1.511 L0,19.488 C0,20.323 0.477,21 1.333,21 L19.229,21 C20.086,21 21,20.323 21,19.488 L21,1.511 C21,0.677 20.336,0 19.479,0" class="bug-text-color" transform="translate(63.000000, 0.000000)"></path>\n    <path d="M82.479,0 L64.583,0 C63.727,0 63,0.677 63,1.511 L63,19.488 C63,20.323 63.477,21 64.333,21 L82.229,21 C83.086,21 84,20.323 84,19.488 L84,1.511 C84,0.677 83.336,0 82.479,0 Z M71,8 L73.827,8 L73.827,9.441 L73.858,9.441 C74.289,8.664 75.562,7.875 77.136,7.875 C80.157,7.875 81,9.479 81,12.45 L81,18 L78,18 L78,12.997 C78,11.667 77.469,10.5 76.227,10.5 C74.719,10.5 74,11.521 74,13.197 L74,18 L71,18 L71,8 Z M66,18 L69,18 L69,8 L66,8 L66,18 Z M69.375,4.5 C69.375,5.536 68.536,6.375 67.5,6.375 C66.464,6.375 65.625,5.536 65.625,4.5 C65.625,3.464 66.464,2.625 67.5,2.625 C68.536,2.625 69.375,3.464 69.375,4.5 Z" class="background" fill="currentColor"></path>\n  </g>\n  <g class="linkedin-text">\n    <path d="M60,18 L57.2,18 L57.2,16.809 L57.17,16.809 C56.547,17.531 55.465,18.125 53.631,18.125 C51.131,18.125 48.978,16.244 48.978,13.011 C48.978,9.931 51.1,7.875 53.725,7.875 C55.35,7.875 56.359,8.453 56.97,9.191 L57,9.191 L57,3 L60,3 L60,18 Z M54.479,10.125 C52.764,10.125 51.8,11.348 51.8,12.974 C51.8,14.601 52.764,15.875 54.479,15.875 C56.196,15.875 57.2,14.634 57.2,12.974 C57.2,11.268 56.196,10.125 54.479,10.125 L54.479,10.125 Z" fill="currentColor"></path>\n    <path d="M47.6611,16.3889 C46.9531,17.3059 45.4951,18.1249 43.1411,18.1249 C40.0001,18.1249 38.0001,16.0459 38.0001,12.7779 C38.0001,9.8749 39.8121,7.8749 43.2291,7.8749 C46.1801,7.8749 48.0001,9.8129 48.0001,13.2219 C48.0001,13.5629 47.9451,13.8999 47.9451,13.8999 L40.8311,13.8999 L40.8481,14.2089 C41.0451,15.0709 41.6961,16.1249 43.1901,16.1249 C44.4941,16.1249 45.3881,15.4239 45.7921,14.8749 L47.6611,16.3889 Z M45.1131,11.9999 C45.1331,10.9449 44.3591,9.8749 43.1391,9.8749 C41.6871,9.8749 40.9121,11.0089 40.8311,11.9999 L45.1131,11.9999 Z" fill="currentColor"></path>\n    <polygon fill="currentColor" points="38 8 34.5 8 31 12 31 3 28 3 28 18 31 18 31 13 34.699 18 38.241 18 34 12.533"></polygon>\n    <path d="M16,8 L18.827,8 L18.827,9.441 L18.858,9.441 C19.289,8.664 20.562,7.875 22.136,7.875 C25.157,7.875 26,9.792 26,12.45 L26,18 L23,18 L23,12.997 C23,11.525 22.469,10.5 21.227,10.5 C19.719,10.5 19,11.694 19,13.197 L19,18 L16,18 L16,8 Z" fill="currentColor"></path>\n    <path d="M11,18 L14,18 L14,8 L11,8 L11,18 Z M12.501,6.3 C13.495,6.3 14.3,5.494 14.3,4.5 C14.3,3.506 13.495,2.7 12.501,2.7 C11.508,2.7 10.7,3.506 10.7,4.5 C10.7,5.494 11.508,6.3 12.501,6.3 Z" fill="currentColor"></path>\n    <polygon fill="currentColor" points="3 3 0 3 0 18 9 18 9 15 3 15"></polygon>\n  </g>\n</svg></icon>\n  \n            \n      </a>\n\n<!---->\n<!---->\n      <div class="nav__cta-container order-3 flex gap-x-1 justify-end min-w-[100px] flex-nowrap flex-shrink-0 babybear:flex-wrap flex-2\n          ">\n<!---->\n          \n    \n              \n              \n            \n            \n            \n\n\n<!---->\n          \n  \n  \n\n      \n              \n              \n            \n            \n            \n\n\n<!---->      </div>\n\n<!---->\n<!---->    </nav>\n  \n\n        \n      </header>\n\n<!---->\n      \n      <main id="main-content" class="focus-page__core-rail" tabindex="-1">\n        \n              <div class="flip-card  flex-grow min-w-[300px] max-w-[416px]">\n                \n\n  \n  \n  \n  \n  \n\n  \n  \n\n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n\n    <code id="dust-var-fpLixTreatment" style="display: none"><!--""--></code>\n    <code id="dust-var-disableBotDetectionInput" style="display: none"><!--false--></code>\n    \n    \n\n    \n    <code id="i18n_continue" style="display: none"><!--"Continue"--></code>\n\n    <code id="dust-var-cancelOnboardingRedirect" style="display: none"><!--false--></code>\n    <code id="dust-var-postOnboardingRedirectUrl" style="display: none"><!--""--></code>\n    <code id="dust-var-source" style="display: none"><!--""--></code>\n\n    \n\n    \n\n    <code id="dust-var-invitationId" style="display: none"><!--""--></code>\n    <code id="dust-var-sharedKey" style="display: none"><!--""--></code>\n\n    <code id="dust-var-sendConfirmationEmail" style="display: none"><!--true--></code>\n\n    \n\n    <code id="dust-var-hasMultipleSocialJoin" style="display: none"><!--false--></code>\n\n    \n\n    \n    <code id="dust-var-loginCsrfParam" style="display: none"><!--"da27f096-a9c7-487f-8326-5287f7a0186f"--></code>\n    \n\n    <code id="dust-var-apfcDf" style="display: none"><!--"enabled"--></code>\n    <code id="apfcDfPK" style="display: none"><!--""--></code>\n    <code id="apfcDfPKV" style="display: none"><!---1--></code>\n\n    \n    \n\n    <code id="trackingPrefix" style="display: none"><!--"seo-authwall-base"--></code>\n\n<!---->\n    \n    \n    \n    \n    \n    \n    \n    \n\n    <form class="join-form" action="/signup/api/cors/createAccount" method="post">\n        \n      <h1 class="authwall-join-form__title">Join LinkedIn</h1>\n<!---->    \n\n          <div class="profile-card hidden">\n            <div class="profile-card__content">\n              <img class="profile-card__photo" alt="Profile photo">\n              <button class="profile-card__edit-icon" aria-label="Edit profile photo" data-tracking-control-name="seo-authwall-base_join-form-profile-card-edit-photo" title="Edit profile photo" type="button">\n                <icon aria-hidden="true" class="lazy-loaded" aria-busy="false"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="16px" width="16px" fill="currentColor" focusable="false" class="lazy-loaded" aria-busy="false">\n  <path d="M14.71,4L12,1.29a1,1,0,0,0-1.41,0L3,8.85,1,15l6.15-2,7.55-7.55A1,1,0,0,0,15,4.71,1,1,0,0,0,14.71,4Zm-8.84,7.6-1.5-1.5L9.42,5.07l1.5,1.5Zm5.72-5.72-1.5-1.5,1.17-1.17,1.5,1.5Z" class="small-icon" style="fill-opacity: 1" id="pencil-icon-small"></path>\n</svg></icon>\n              </button>\n              <div class="profile-card__info">\n                <h3 class="profile-card__info-name"></h3>\n                <p class="profile-card__info-email"></p>\n              </div>\n              <button class="profile-card__not-you" data-tracking-control-name="seo-authwall-base_join-form-profile-card-not-you" type="button">\n                      Not you?\n              </button>\n            </div>\n            <div class="profile-card__edit-photo-modal hidden">\n              <div class="profile-card__edit-photo-content">\n                <div class="profile-card__edit-photo-remove">\n                  <button class="profile-card__edit-photo-text" data-tracking-control-name="seo-authwall-base_join-form-profile-card-remove-photo" type="button">\n                    Remove photo\n                  </button>\n                </div>\n                <div class="profile-card__edit-photo-cancel">\n                  <button aria-label="Cancel" class="profile-card__edit-photo-cancel-icon" data-tracking-control-name="seo-authwall-base_join-form-profile-card-edit-photo-cancel" title="Cancel" type="button">\n                    <icon aria-hidden="true" class="lazy-loaded" aria-busy="false"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" class="artdeco-icon lazy-loaded" focusable="false" aria-busy="false">\n  <path d="M20,5.32L13.32,12,20,18.68,18.66,20,12,13.33,5.34,20,4,18.68,10.68,12,4,5.32,5.32,4,12,10.69,18.68,4Z" fill="currentColor"></path>\n</svg></icon>\n                  </button>\n                </div>\n              </div>\n            </div>\n          </div>\n\n<!---->\n      \n    <div class="alert hidden" role="alert" tabindex="-1" aria-live="polite">\n      <div class="wrapper">\n        <p class="alert-content">\n          \n        </p>\n      </div>\n    </div>\n  \n\n      <section class="join-form__form-body  join-form__form-body--gsi">\n<!---->\n        <div class="join-form__form-input-container join-form__form-input-container--email-phone join-form__form-input-container--is-section-1">\n            \n      <div class="input ">\n        \n    <!---->\n    <input class="input__input" data-tracking-control-name="seo-authwall-base_join-form-email-or-phone_email-or-phone" data-tracking-client-ingraph="" required="" id="email-or-phone" name="email-or-phone" placeholder=" ">\n    <datalist id="email-domains"></datalist>\n    <label class="input__label " for="email-or-phone">Email</label>\n  \n        \n      </div>\n  \n\n                  \n\n    \n    \n    \n    \n    \n\n    <code id="i18n_hide_password_aria_label" style="display: none"><!--"Hide your LinkedIn password"--></code>\n    <code id="i18n_show_password_aria_label" style="display: none"><!--"Show your LinkedIn password"--></code>\n\n      \n      <div class="input ">\n        \n    <!---->\n    <input class="input__input" autocomplete="new-password" data-tracking-control-name="seo-authwall-base_join-form-password_password" data-tracking-client-ingraph="" required="" id="password" name="password" placeholder=" " type="password">\n    <!---->\n    <label class="input__label " for="password">Password (6+ characters)</label>\n  \n        \n      </div>\n  \n  \n\n<!---->        </div>\n\n        <div class="join-form__form-input-container join-form__form-input-container--name join-form__form-input-container--is-last-section join-form__form-input-container--is-hidden join-form__form-input-container--is-section-2">\n<!---->\n            \n\n    \n    \n    \n    \n    \n    \n\n      \n      <div class="input ">\n        \n    <!---->\n    <input class="input__input" autocomplete="on" data-tracking-control-name="seo-authwall-base_join-form-name_first-name" data-tracking-client-ingraph="" id="first-name" name="first-name" placeholder=" " type="text">\n    <!---->\n    <label class="input__label " for="first-name">First name</label>\n  \n        \n      </div>\n  \n      \n      <div class="input ">\n        \n    <!---->\n    <input class="input__input" autocomplete="on" data-tracking-control-name="seo-authwall-base_join-form-name_last-name" data-tracking-client-ingraph="" id="last-name" name="last-name" placeholder=" " type="text">\n    <!---->\n    <label class="input__label " for="last-name">Last name</label>\n  \n        \n      </div>\n  \n      \n\n<!---->        </div>\n\n          \n    \n    \n    \n    \n    \n\n<!---->\n        <p data-is-not-yielded="true" class="join-form__form-body-agreement">\n          By clicking Agree &amp; Join, you agree to the LinkedIn <a href="https://www.linkedin.com/legal/user-agreement?trk=seo-authwall-base_join-form-user-agreement" class="join-form__form-body-agreement-item-link" target="_blank" data-tracking-control-name="seo-authwall-base_join-form-user-agreement" data-tracking-will-navigate="true">User Agreement</a>, <a href="https://www.linkedin.com/legal/privacy-policy?trk=seo-authwall-base_join-form-privacy-policy" class="join-form__form-body-agreement-item-link" target="_blank" data-tracking-control-name="seo-authwall-base_join-form-privacy-policy" data-tracking-will-navigate="true">Privacy Policy</a>, and <a href="https://www.linkedin.com/legal/cookie-policy?trk=seo-authwall-base_join-form-cookie-policy" class="join-form__form-body-agreement-item-link" target="_blank" data-tracking-control-name="seo-authwall-base_join-form-cookie-policy" data-tracking-will-navigate="true">Cookie Policy</a>.\n        </p>\n  \n\n          <button class="join-form__form-body-submit-button " data-tracking-control-name="seo-authwall-base_join-form-submit" data-tracking-client-ingraph="" id="join-form-submit" value="Agree &amp; Join" type="submit">\n            Agree &amp; Join\n          </button>\n\n              \n\n    \n    \n    \n    \n    \n    \n    \n    \n\n\n    <code id="dust-var-callbackUrl" style="display: none"><!--""--></code>\n    <code id="dust-var-authUrl" style="display: none"><!--""--></code>\n    \n    \n    \n\n    <code id="i18n_third_party_join_error-message-facebook" style="display: none"><!--"Sorry, we were unable to pull in your Facebook information. Please try again."--></code>\n    <code id="i18n_third_party_join_error-message-google" style="display: none"><!--"Sorry, we were unable to pull in your Google information. Please try again."--></code>\n    <code id="i18n_third_party_join_error-message-wechat" style="display: none"><!--"Sorry, we were unable to pull in your Wechat information. Please try again."--></code>\n\n    <div class="third-party-join__container">\n          <div class="third-party-join__reg-option">\n            <span class="third-party-join__line-wrapper">\n              <span class="third-party-join__line"></span>\n            </span>\n            <span class="third-party-join__content">\n              <span class="third-party-join__or-span">or</span>\n            </span>\n          </div>\n<!---->\n          <div class="third-party-join__gsi-btn-container" style="max-width: 325px;" data-lib-src-path="https://static.licdn.com/aero-v1/sc/h/29rdkxlvag0d3cpj96fiilbju" role="button" aria-label="Continue with google"><div class="S9gUrf-YoZ4jf" style="position: relative;"><div></div><iframe src="https://accounts.google.com/gsi/button?locale=null&amp;logo_alignment=center&amp;shape=pill&amp;size=large&amp;text=continue_with&amp;theme=undefined&amp;type=undefined&amp;width=325px&amp;client_id=990339570472-k6nqn1tpmitg8pui82bfaun3jrpmiuhs.apps.googleusercontent.com&amp;iframe_id=gsi_460120_586685&amp;as=X6Rsg7a%2FSSp7RvSdnZddaA" allow="identity-credentials-get" id="gsi_460120_586685" title="Sign in with Google Button" style="display: block; position: relative; top: 0px; left: 0px; height: 44px; width: 345px; border: 0px; margin: -2px -10px;"></iframe></div></div>\n\n<!---->\n<!---->\n<!---->    </div>\n  \n      </section>\n\n<!---->\n        \n      <p class="authwall-join-form__swap-cta">\n        Already on Linkedin? <button class="authwall-join-form__form-toggle--bottom form-toggle" data-tracking-control-name="auth_wall_desktop_profile-login-toggle" data-tracking-client-ingraph=""> Sign in </button>\n      </p>\n\n<!---->    \n    </form>\n\n    \n    \n\n    \n    <div class="">\n        <button class="modal__outlet " data-tracking-control-name="seo-authwall-base_modal_outlet" data-modal="default-outlet" aria-hidden="true" tabindex="-1">\n          \n        </button>\n\n      <div id="challenge-dialog" class="modal challenge-dialog " data-outlet="default-outlet">\n<!---->        <div class="modal__overlay flex items-center bg-color-background-scrim justify-center fixed bottom-0 left-0 right-0 top-0 opacity-0 invisible pointer-events-none z-[1000] transition-[opacity] ease-[cubic-bezier(0.25,0.1,0.25,1.0)] duration-[0.17s]\n            py-4\n            " aria-hidden="true">\n          <section aria-modal="true" role="dialog" aria-labelledby="challenge-dialog-modal-header" tabindex="-1" class="max-h-full modal__wrapper overflow-auto p-0 bg-color-surface max-w-[1128px] min-h-[160px] relative scale-[0.25] shadow-sm shadow-color-border-faint transition-[transform] ease-[cubic-bezier(0.25,0.1,0.25,1.0)] duration-[0.33s] focus:outline-0\n              \n              w-[774px] babybear:w-[360px]\n              \n              rounded-md">\n              <header class="modal__header flex items-center justify-between py-1.5 px-3\n                  ">\n                  <h2 id="challenge-dialog-modal-header" class="modal__title font-normal leading-open text-color-text text-lg">Security verification</h2>\n                  <button class="modal__dismiss modal__dismiss--with-icon btn-tertiary h-[40px] w-[40px] p-0 rounded-full indent-0\n                      " aria-label="Dismiss" data-tracking-control-name="seo-authwall-base_modal_dismiss" type="button">\n                      <icon class="modal__dismiss-icon relative top-[2px] lazy-loaded" aria-hidden="true" aria-busy="false"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" class="artdeco-icon lazy-loaded" focusable="false" aria-busy="false">\n  <path d="M20,5.32L13.32,12,20,18.68,18.66,20,12,13.33,5.34,20,4,18.68,10.68,12,4,5.32,5.32,4,12,10.69,18.68,4Z" fill="currentColor"></path>\n</svg></icon>\n                                      </button>\n<!---->              </header>\n            <div class="modal__main w-full">\n              \n        <div class="flex">\n          <iframe tabindex="0" title="Security verification" class="challenge-dialog__iframe" src="about:blank" frameborder="0" scrolling="auto" allowtransparency="true"></iframe>\n          <div id="focus-capture" tabindex="0" class="sr-only"></div>\n        </div>\n      \n            </div>\n\n<!---->          </section>\n        </div>\n      </div>\n    </div>\n  \n  \n\n    \n\n\n    \n\n\n    \n    \n    \n\n    <code id="i18n_required_email-or-phone" style="display: none"><!--"Please enter your email address or mobile number."--></code>\n    <code id="i18n_tooLong_email-or-phone" style="display: none"><!--"Email or mobile number must be between 3 to 128 characters."--></code>\n    <code id="i18n_invalidFormat_email-or-phone" style="display: none"><!--"Please enter a valid email address or mobile number."--></code>\n\n\n    \n    \n    \n    \n\n    <code id="i18n_required_password" style="display: none"><!--"Please enter your password."--></code>\n    <code id="i18n_tooShort_password" style="display: none"><!--"Password must be 6 characters or more."--></code>\n    <code id="i18n_tooLong_password" style="display: none"><!--"Your password cannot exceed a maximum of 200 characters."--></code>\n    <code id="i18n_invalid_password" style="display: none"><!--"Please enter a more secure password and use 6 or more characters."--></code>\n\n    \n    <code id="i18n_server_generic_error" style="display: none"><!--"Sorry, something went wrong. Please try again."--></code>\n  \n\n    \n    \n    \n    \n    \n    \n\n    <code id="i18n_required_first-name" style="display: none"><!--"Please enter your first name."--></code>\n    <code id="i18n_tooLong_first-name" style="display: none"><!--"First name can not exceed 50 characters."--></code>\n    <code id="i18n_noForbiddenCharacters_first-name" style="display: none"><!--"Please enter a valid first name."--></code>\n    <code id="i18n_noConsecutiveDigits_first-name" style="display: none"><!--"Please enter a valid first name."--></code>\n    <code id="i18n_noFourConsecutiveDuplicates_first-name" style="display: none"><!--"Please enter a valid first name."--></code>\n    <code id="i18n_noLinkedIn_first-name" style="display: none"><!--"Please enter a valid first name."--></code>\n    <code id="i18n_noUrl_first-name" style="display: none"><!--"Please enter a valid first name."--></code>\n    <code id="i18n_onlyPhonetic_phonetic-first-name" style="display: none"><!--"Please use phonetic characters for your phonetic first name."--></code>\n    <code id="i18n_tooLong_phonetic-first-name" style="display: none"><!--"Phonetic first name can not exceed 50 characters."--></code>\n    <code id="i18n_noFourConsecutiveDuplicates_phonetic-first-name" style="display: none"><!--"Please enter a valid phonetic first name."--></code>\n\n\n    \n    \n    \n    \n    \n    \n\n    <code id="i18n_required_last-name" style="display: none"><!--"Please enter your last name."--></code>\n    <code id="i18n_tooLong_last-name" style="display: none"><!--"Last name can not exceed 50 characters."--></code>\n    <code id="i18n_noForbiddenCharacters_last-name" style="display: none"><!--"Please enter a valid last name."--></code>\n    <code id="i18n_noConsecutiveDigits_last-name" style="display: none"><!--"Please enter a valid last name."--></code>\n    <code id="i18n_noFourConsecutiveDuplicates_last-name" style="display: none"><!--"Please enter a valid last name."--></code>\n    <code id="i18n_noLinkedIn_last-name" style="display: none"><!--"Please enter a valid last name."--></code>\n    <code id="i18n_noUrl_last-name" style="display: none"><!--"Please enter a valid last name."--></code>\n    <code id="i18n_onlyPhonetic_phonetic-last-name" style="display: none"><!--"Please use phonetic characters for your phonetic last name."--></code>\n    <code id="i18n_tooLong_phonetic-last-name" style="display: none"><!--"Phonetic last name can not exceed 50 characters."--></code>\n    <code id="i18n_noFourConsecutiveDuplicates_phonetic-last-name" style="display: none"><!--"Please enter a valid phonetic last name."--></code>\n\n    \n    \n    \n    \n\n    <code id="i18n_onlyChinese_real-name" style="display: none"><!--"Please use only Chinese characters for real name."--></code>\n    <code id="i18n_tooLong_real-name" style="display: none"><!--"Real name should be 2-4 characters long."--></code>\n    <code id="i18n_tooShort_real-name" style="display: none"><!--"Real name should be 2-4 characters long."--></code>\n    <code id="i18n_required_real-name" style="display: none"><!--"Please enter your real name."--></code>\n\n    \n    \n    <code id="i18n_required_koreaConsentData" style="display: none"><!--"To proceed, you must confirm you understand and consent to the items above by checking each box."--></code>\n    <code id="i18n_required_koreaConsentShare" style="display: none"><!--"To proceed, you must confirm you understand and consent to the items above by checking each box."--></code>\n    \n\n      <script class="lazy-loaded" data-module-id="abuse-features-lib" src="https://static.licdn.com/aero-v1/sc/h/3lm6jmtzdyw0hlonhje0bbsjf"></script>\n<!----><!---->  \n\n\n                \n\n  \n  \n  \n  \n  \n\n  <div class="authwall-sign-in-form">\n    <h2 class="authwall-sign-in-form__header-title">Sign in</h2>\n\n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n\n    \n    \n    \n    \n\n    \n    <code id="i18n_username_error_empty" style="display: none"><!--"Please enter an email address or phone number"--></code>\n    \n    <code id="i18n_username_error_too_long" style="display: none"><!--"Email or phone number must be between 3 to 128 characters"--></code>\n    <code id="i18n_username_error_too_short" style="display: none"><!--"Email or phone number must be between 3 to 128 characters"--></code>\n\n    \n    <code id="i18n_password_error_empty" style="display: none"><!--"Please enter a password"--></code>\n    \n    <code id="i18n_password_error_too_short" style="display: none"><!--"The password you provided must have at least 6 characters"--></code>\n    \n    <code id="i18n_password_error_too_long" style="display: none"><!--"The password you provided must have at most 400 characters"--></code>\n\n<!---->    <form data-id="sign-in-form" action="https://www.linkedin.com/uas/login-submit" method="post" novalidate="" class="authwall-sign-in-form__body">\n      <input name="loginCsrfParam" value="da27f096-a9c7-487f-8326-5287f7a0186f" type="hidden">\n\n      <div class="flex flex-col">\n        \n    <div class="mt-1.5" data-js-module-id="guest-input">\n      <div class="flex flex-col">\n        <label class="input-label mb-1" for="session_key">\n          Email or phone\n        </label>\n        <div class="text-input flex">\n          <input class="text-color-text font-sans text-md outline-0 bg-color-transparent w-full" autocomplete="username" id="session_key" name="session_key" required="" data-tracking-control-name="seo-authwall-base_sign-in-session-key" data-tracking-client-ingraph="" type="text">\n          \n        </div>\n      </div>\n\n      <p class="input-helper mt-1.5" for="session_key" role="alert" data-js-module-id="guest-input__message"></p>\n    </div>\n  \n\n        \n    <div class="mt-1.5" data-js-module-id="guest-input">\n      <div class="flex flex-col">\n        <label class="input-label mb-1" for="session_password">\n          Password\n        </label>\n        <div class="text-input flex">\n          <input class="text-color-text font-sans text-md outline-0 bg-color-transparent w-full" autocomplete="current-password" id="session_password" name="session_password" required="" data-tracking-control-name="seo-authwall-base_sign-in-password" data-tracking-client-ingraph="" type="password">\n          \n            <button aria-live="assertive" aria-relevant="text" data-id="sign-in-form__password-visibility-toggle" class="font-sans text-md font-bold text-color-action z-10 ml-[12px] hover:cursor-pointer" aria-label="Show your LinkedIn password" data-tracking-control-name="seo-authwall-base_sign-in-password-visibility-toggle-btn" type="button">Show</button>\n          \n        </div>\n      </div>\n\n      <p class="input-helper mt-1.5" for="session_password" role="alert" data-js-module-id="guest-input__message"></p>\n    </div>\n  \n\n        <input name="session_redirect" type="hidden">\n\n<!---->      </div>\n\n      <div data-id="sign-in-form__footer" class="flex justify-between\n          sign-in-form__footer--full-width">\n        <a data-id="sign-in-form__forgot-password" class="font-sans text-md font-bold link leading-regular\n            sign-in-form__forgot-password--full-width" href="https://www.linkedin.com/uas/request-password-reset?trk=seo-authwall-base_forgot_password" data-tracking-control-name="seo-authwall-base_forgot_password" data-tracking-will-navigate="">Forgot password?</a>\n\n<!---->\n        <input name="trk" value="seo-authwall-base_sign-in-submit" type="hidden">\n        <button class="btn-md btn-primary flex-shrink-0 cursor-pointer\n            sign-in-form__submit-btn--full-width" data-id="sign-in-form__submit-btn" data-tracking-control-name="seo-authwall-base_sign-in-submit-btn" data-tracking-client-ingraph="" data-tracking-litms="" type="submit">\n          Sign in\n        </button>\n      </div>\n          <div class="sign-in-form__divider left-right-divider pt-2 pb-3">\n            <p class="sign-in-form__divider-text font-sans text-sm text-color-text px-2">\n              or\n            </p>\n          </div>\n    <input type="hidden" name="controlId" value="auth_wall_desktop_profile-seo-authwall-base_sign-in-submit-btn"><input type="hidden" name="pageInstance" value="urn:li:page:auth_wall_desktop_profile_jsbeacon;cJqskLGITQyJTVMjhAhCcA=="></form>\n        <div class="w-full max-w-[400px] mx-auto">\n          \n    \n\n    <div class="google-auth-button" data-tracking-control-name="seo-authwall-base_google-auth-button" data-tracking-client-ingraph="" data-google-auth-iframe-initialized="">\n        \n    \n    \n    \n    <p class="linkedin-tc__text text-color-text-low-emphasis text-xs pb-2" data-impression-id="seo-authwall-base__button-skip-tc-text">\n      By clicking Continue to join or sign in, you agree to LinkedIn’s <a href="/legal/user-agreement?trk=seo-authwall-base_auth-button_user-agreement" target="_blank" data-tracking-control-name="seo-authwall-base_auth-button_user-agreement" data-tracking-will-navigate="true">User Agreement</a>, <a href="/legal/privacy-policy?trk=seo-authwall-base_auth-button_privacy-policy" target="_blank" data-tracking-control-name="seo-authwall-base_auth-button_privacy-policy" data-tracking-will-navigate="true">Privacy Policy</a>, and <a href="/legal/cookie-policy?trk=seo-authwall-base_auth-button_cookie-policy" target="_blank" data-tracking-control-name="seo-authwall-base_auth-button_cookie-policy" data-tracking-will-navigate="true">Cookie Policy</a>.\n    </p>\n  \n      <div class="google-auth-button__placeholder mx-auto\n          google-auth-button__placeholder--black-border" data-theme="outline" data-logo-alignment="center" data-locale="en_US" style="max-width: 325px;" role="button" aria-label="Continue with google" data-safe-to-skip-tnc-redirect=""><div class="S9gUrf-YoZ4jf" style="position: relative;"><div><div tabindex="0" role="button" aria-labelledby="button-label" class="nsm7Bb-HzV7m-LgbsSe  hJDwNd-SxQuSe i5vt6e-Ia7Qfc JGcpL-RbRzK" style="width:325px; max-width:400px; min-width:min-content;"><div class="nsm7Bb-HzV7m-LgbsSe-MJoBVe"></div><div class="nsm7Bb-HzV7m-LgbsSe-bN97Pc-sM5MNb oXtfBe-l4eHX"><div class="nsm7Bb-HzV7m-LgbsSe-Bz112c"><svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" class="LgbsSe-Bz112c"><g><path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"></path><path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"></path><path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"></path><path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"></path><path fill="none" d="M0 0h48v48H0z"></path></g></svg></div><span class="nsm7Bb-HzV7m-LgbsSe-BPrWId">Continue with Google</span><span class="L6cTce" id="button-label">Continue with Google</span></div></div></div><iframe src="https://accounts.google.com/gsi/button?logo_alignment=center&amp;shape=pill&amp;size=large&amp;text=continue_with&amp;theme=outline&amp;type=undefined&amp;width=325px&amp;client_id=990339570472-k6nqn1tpmitg8pui82bfaun3jrpmiuhs.apps.googleusercontent.com&amp;iframe_id=gsi_460125_244110&amp;as=X6Rsg7a%2FSSp7RvSdnZddaA&amp;hl=en_US" allow="identity-credentials-get" id="gsi_460125_244110" title="Sign in with Google Button" style="display: block; position: relative; top: 0px; left: 0px; height: 0px; width: 0px; border: 0px;"></iframe></div></div>\n<!---->    </div>\n  \n        </div>\n        \n        <p class="authwall-sign-in-form__swap-cta">\n          New to Linkedin? <button class="authwall-sign-in-form__form-toggle--bottom form-toggle" data-tracking-control-name="auth_wall_desktop_profile-login-toggle" data-tracking-client-ingraph=""> Join now </button>\n        </p>\n      \n  \n  </div>\n\n              </div>\n\n<!---->\n<!---->\n              <code id="isPreloadDuoEnabled" style="display: none"><!--true--></code>\n\n              \n              \n            \n      </main>\n\n<!---->\n        \n\n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n    \n\n    \n    \n    \n    \n    \n    \n    \n    \n    \n\n    \n    \n    \n    \n\n    <footer class="li-footer bg-transparent w-full ">\n      <ul class="li-footer__list flex flex-wrap flex-row items-start justify-start w-full h-auto min-h-[50px] my-[0px] mx-auto py-3 px-2 papabear:p-0">\n        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        \n          <span class="sr-only">LinkedIn</span>\n          <icon class="li-footer__copy-logo text-color-logo-brand-alt inline-block self-center h-[14px] w-[56px] mr-1 lazy-loaded" aria-hidden="true" aria-busy="false"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 56 14" id="linkedin-logo-xxsmall" aria-hidden="true" role="none" data-supported-dps="56x14" fill="currentColor" width="56" height="14" focusable="false" class="lazy-loaded" aria-busy="false">\n  <g>\n    <path class="background-mercado" d="M22.1 8.2l3.09 3.8h-2.44L20 8.51V12h-2V2h2v5.88L22.54 5h2.55zm-8-3.4A2.71 2.71 0 0011.89 6V5H10v7h2V8.73a1.74 1.74 0 011.66-1.93C14.82 6.8 15 7.94 15 8.73V12h2V8.29c0-2.2-.73-3.49-2.86-3.49zM32 8.66a4.22 4.22 0 010 .44h-5.25v.07a1.79 1.79 0 001.83 1.43 2.51 2.51 0 001.84-.69l1.33 1a4.31 4.31 0 01-3.25 1.29 3.49 3.49 0 01-3.7-3.75 3.58 3.58 0 013.76-3.65C30.44 4.8 32 6.13 32 8.66zm-1.86-.86a1.46 1.46 0 00-1.59-1.4 1.64 1.64 0 00-1.8 1.4zM2 2H0v10h6v-2H2zm36 0h2v10h-1.89v-.7a2.44 2.44 0 01-2 .9 3.41 3.41 0 01-3.31-3.7 3.36 3.36 0 013.3-3.7 2.62 2.62 0 011.9.7zm.15 6.5a1.63 1.63 0 00-1.62-1.85A1.76 1.76 0 0034.9 8.5a1.76 1.76 0 001.63 1.85 1.63 1.63 0 001.62-1.85zM8 1.8A1.27 1.27 0 006.75 3a1.25 1.25 0 002.5 0A1.27 1.27 0 008 1.8zM7 12h2V5H7zM56 1v12a1 1 0 01-1 1H43a1 1 0 01-1-1V1a1 1 0 011-1h12a1 1 0 011 1zM46 5h-2v7h2zm.25-2a1.25 1.25 0 00-2.5 0 1.25 1.25 0 002.5 0zM54 8.29c0-2.2-.73-3.49-2.86-3.49A2.71 2.71 0 0048.89 6V5H47v7h2V8.73a1.74 1.74 0 011.66-1.93C51.82 6.8 52 7.94 52 8.73V12h2z"></path>\n  </g>\n</svg></icon>\n          <span class="li-footer__copy-text flex items-center">© 2026</span>\n        \n  </li>\n\n        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://about.linkedin.com?trk=seo-authwall-base_footer-about" data-tracking-control-name="seo-authwall-base_footer-about" data-tracking-will-navigate="">\n          \n          About\n        \n        </a>\n  </li>\n\n        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://www.linkedin.com/accessibility?trk=seo-authwall-base_footer-accessibility" data-tracking-control-name="seo-authwall-base_footer-accessibility" data-tracking-will-navigate="">\n          \n          Accessibility\n        \n        </a>\n  </li>\n\n        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://www.linkedin.com/legal/user-agreement?trk=seo-authwall-base_footer-user-agreement" data-tracking-control-name="seo-authwall-base_footer-user-agreement" data-tracking-will-navigate="">\n          \n          User Agreement\n        \n        </a>\n  </li>\n\n        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://www.linkedin.com/legal/privacy-policy?trk=seo-authwall-base_footer-privacy-policy" data-tracking-control-name="seo-authwall-base_footer-privacy-policy" data-tracking-will-navigate="">\n          \n          Privacy Policy\n        \n        </a>\n  </li>\n\n<!---->        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://www.linkedin.com/legal/cookie-policy?trk=seo-authwall-base_footer-cookie-policy" data-tracking-control-name="seo-authwall-base_footer-cookie-policy" data-tracking-will-navigate="">\n          \n          Cookie Policy\n        \n        </a>\n  </li>\n\n        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://www.linkedin.com/legal/copyright-policy?trk=seo-authwall-base_footer-copyright-policy" data-tracking-control-name="seo-authwall-base_footer-copyright-policy" data-tracking-will-navigate="">\n          \n          Copyright Policy\n        \n        </a>\n  </li>\n\n        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://brand.linkedin.com/policies?trk=seo-authwall-base_footer-brand-policy" data-tracking-control-name="seo-authwall-base_footer-brand-policy" data-tracking-will-navigate="">\n          \n          Brand Policy\n        \n        </a>\n  </li>\n\n          \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://www.linkedin.com/psettings/guest-controls?trk=seo-authwall-base_footer-guest-controls" data-tracking-control-name="seo-authwall-base_footer-guest-controls" data-tracking-will-navigate="">\n          \n            Guest Controls\n          \n        </a>\n  </li>\n\n        \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        <a class="li-footer__item-link flex items-center font-sans text-xs font-bold text-color-text-solid-secondary hover:text-color-link-hover focus:text-color-link-focus" href="https://www.linkedin.com/legal/professional-community-policies?trk=seo-authwall-base_footer-community-guide" data-tracking-control-name="seo-authwall-base_footer-community-guide" data-tracking-will-navigate="">\n          \n          Community Guidelines\n        \n        </a>\n  </li>\n\n        \n<!---->\n          \n          \n  <li class="li-footer__item font-sans text-xs text-color-text-solid-secondary flex flex-shrink-0 justify-start p-1 relative w-50% papabear:justify-center papabear:w-auto">\n        \n              \n\n    \n    \n\n    \n\n    \n\n    <div class="collapsible-dropdown collapsible-dropdown--footer collapsible-dropdown--up flex items-center relative hyphens-auto language-selector z-2">\n<!---->\n        <ul class="collapsible-dropdown__list hidden container-raised absolute w-auto overflow-y-auto flex-col items-stretch z-[9999] bottom-[100%] top-auto" role="menu" tabindex="-1">\n          \n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="العربية (Arabic)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-ar_AE" data-locale="ar_AE" role="menuitem" lang="ar_AE">\n                العربية (Arabic)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="বাংলা (Bangla)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-bn_IN" data-locale="bn_IN" role="menuitem" lang="bn_IN">\n                বাংলা (Bangla)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Čeština (Czech)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-cs_CZ" data-locale="cs_CZ" role="menuitem" lang="cs_CZ">\n                Čeština (Czech)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Dansk (Danish)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-da_DK" data-locale="da_DK" role="menuitem" lang="da_DK">\n                Dansk (Danish)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Deutsch (German)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-de_DE" data-locale="de_DE" role="menuitem" lang="de_DE">\n                Deutsch (German)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Ελληνικά (Greek)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-el_GR" data-locale="el_GR" role="menuitem" lang="el_GR">\n                Ελληνικά (Greek)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="English (English) selected" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link--selected" data-tracking-control-name="language-selector-en_US" data-locale="en_US" role="menuitem" lang="en_US">\n                <strong>English (English)</strong>\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Español (Spanish)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-es_ES" data-locale="es_ES" role="menuitem" lang="es_ES">\n                Español (Spanish)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="فارسی (Persian)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-fa_IR" data-locale="fa_IR" role="menuitem" lang="fa_IR">\n                فارسی (Persian)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Suomi (Finnish)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-fi_FI" data-locale="fi_FI" role="menuitem" lang="fi_FI">\n                Suomi (Finnish)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Français (French)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-fr_FR" data-locale="fr_FR" role="menuitem" lang="fr_FR">\n                Français (French)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="हिंदी (Hindi)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-hi_IN" data-locale="hi_IN" role="menuitem" lang="hi_IN">\n                हिंदी (Hindi)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Magyar (Hungarian)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-hu_HU" data-locale="hu_HU" role="menuitem" lang="hu_HU">\n                Magyar (Hungarian)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Bahasa Indonesia (Indonesian)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-in_ID" data-locale="in_ID" role="menuitem" lang="in_ID">\n                Bahasa Indonesia (Indonesian)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Italiano (Italian)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-it_IT" data-locale="it_IT" role="menuitem" lang="it_IT">\n                Italiano (Italian)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="עברית (Hebrew)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-iw_IL" data-locale="iw_IL" role="menuitem" lang="iw_IL">\n                עברית (Hebrew)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="日本語 (Japanese)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-ja_JP" data-locale="ja_JP" role="menuitem" lang="ja_JP">\n                日本語 (Japanese)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="한국어 (Korean)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-ko_KR" data-locale="ko_KR" role="menuitem" lang="ko_KR">\n                한국어 (Korean)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="मराठी (Marathi)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-mr_IN" data-locale="mr_IN" role="menuitem" lang="mr_IN">\n                मराठी (Marathi)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Bahasa Malaysia (Malay)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-ms_MY" data-locale="ms_MY" role="menuitem" lang="ms_MY">\n                Bahasa Malaysia (Malay)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Nederlands (Dutch)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-nl_NL" data-locale="nl_NL" role="menuitem" lang="nl_NL">\n                Nederlands (Dutch)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Norsk (Norwegian)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-no_NO" data-locale="no_NO" role="menuitem" lang="no_NO">\n                Norsk (Norwegian)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="ਪੰਜਾਬੀ (Punjabi)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-pa_IN" data-locale="pa_IN" role="menuitem" lang="pa_IN">\n                ਪੰਜਾਬੀ (Punjabi)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Polski (Polish)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-pl_PL" data-locale="pl_PL" role="menuitem" lang="pl_PL">\n                Polski (Polish)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Português (Portuguese)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-pt_BR" data-locale="pt_BR" role="menuitem" lang="pt_BR">\n                Português (Portuguese)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Română (Romanian)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-ro_RO" data-locale="ro_RO" role="menuitem" lang="ro_RO">\n                Română (Romanian)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Русский (Russian)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-ru_RU" data-locale="ru_RU" role="menuitem" lang="ru_RU">\n                Русский (Russian)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Svenska (Swedish)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-sv_SE" data-locale="sv_SE" role="menuitem" lang="sv_SE">\n                Svenska (Swedish)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="తెలుగు (Telugu)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-te_IN" data-locale="te_IN" role="menuitem" lang="te_IN">\n                తెలుగు (Telugu)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="ภาษาไทย (Thai)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-th_TH" data-locale="th_TH" role="menuitem" lang="th_TH">\n                ภาษาไทย (Thai)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Tagalog (Tagalog)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-tl_PH" data-locale="tl_PH" role="menuitem" lang="tl_PH">\n                Tagalog (Tagalog)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Türkçe (Turkish)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-tr_TR" data-locale="tr_TR" role="menuitem" lang="tr_TR">\n                Türkçe (Turkish)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Українська (Ukrainian)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-uk_UA" data-locale="uk_UA" role="menuitem" lang="uk_UA">\n                Українська (Ukrainian)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="Tiếng Việt (Vietnamese)" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-vi_VN" data-locale="vi_VN" role="menuitem" lang="vi_VN">\n                Tiếng Việt (Vietnamese)\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="简体中文 (Chinese (Simplified))" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-zh_CN" data-locale="zh_CN" role="menuitem" lang="zh_CN">\n                简体中文 (Chinese (Simplified))\n            </button>\n          </li>\n          <li class="language-selector__item" role="presentation">\n            <!-- Adding aria-label to both the li and the button because screen reader focus goes to button on desktop and li on mobile-->\n            <button aria-label="正體中文 (Chinese (Traditional))" class="font-sans text-xs link block py-[5px] px-2 w-full hover:cursor-pointer hover:bg-color-action hover:text-color-text-on-dark focus:bg-color-action focus:text-color-text-on-dark\n                language-selector__link !font-regular" data-tracking-control-name="language-selector-zh_TW" data-locale="zh_TW" role="menuitem" lang="zh_TW">\n                正體中文 (Chinese (Traditional))\n            </button>\n          </li>\n<!---->      \n        </ul>\n\n          \n        <button class="language-selector__button select-none relative pr-2 font-sans text-xs font-bold text-color-text-low-emphasis hover:text-color-link-hover hover:cursor-pointer focus:text-color-link-focus focus:outline-dotted focus:outline-1" aria-expanded="false" data-tracking-control-name="footer-lang-dropdown_trigger">\n          <span class="language-selector__label-text mr-0.5 break-words">\n            Language\n          </span>\n          <icon class="language-selector__label-chevron w-2 h-2 absolute top-0 right-0 lazy-loaded" aria-hidden="true" aria-busy="false"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" preserveAspectRatio="xMinYMin meet" focusable="false" class="lazy-loaded" aria-busy="false"><path d="M8 9l5.93-4L15 6.54l-6.15 4.2a1.5 1.5 0 01-1.69 0L1 6.54 2.07 5z" fill="currentColor"></path></svg></icon>\n        </button>\n      \n    </div>\n  \n  \n          \n  </li>\n\n      </ul>\n\n<!---->    </footer>\n  \n    </div>\n  \n    \n\n            <script src="https://static.licdn.com/aero-v1/sc/h/e69gtg8c61dzqklxridy0htl9" async=""></script>\n<!---->          \n            <script data-module-id="apfc-lib" src="https://static.licdn.com/aero-v1/sc/h/3lm6jmtzdyw0hlonhje0bbsjf" class="lazy-loaded"></script>\n          <code id="apfcLix" style="display: none"><!--true--></code>\n          <code id="dust-var-apfcDf" style="display: none"><!--"enabled"--></code>\n\n      <script src="https://static.licdn.com/aero-v1/sc/h/3kgy5ay8f0k9viv1cd9y344x2" async="" defer=""></script>\n    \n          \n<!----><!---->  \n      \n    \n  \n<iframe id="humanThirdPartyIframe" src="https://li.protechts.net/index.html?ts=1778729460003&amp;r_id=AAZRvrmM8AngNIey07Is7Q%3D%3D&amp;app_id=PXdOjV695v&amp;uc=scraping&amp;d_id=57fb3b5e3a141b0d8b9674fa18fab19099c5ad1dbcdcd795965d4c3347594bd4" sandbox="allow-same-origin allow-scripts" aria-hidden="true" style="height: 0px; width: 0px; border-width: medium; border-style: none; border-color: currentcolor; border-image: initial; position: absolute; left: -9999px;"></iframe></body></html>	2026-05-14 03:31:02.091
\.


--
-- Data for Name: viral_patterns; Type: TABLE DATA; Schema: public; Owner: linkedindatabase
--

COPY public.viral_patterns (id, topic, "contentType", "bestPostingHour", "bestDayOfWeek", "avgEngagement", "sampleSize", "updatedAt") FROM stdin;
\.


--
-- Name: commented_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: linkedindatabase
--

SELECT pg_catalog.setval('public.commented_posts_id_seq', 173, true);


--
-- Name: agent_memories agent_memories_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.agent_memories
    ADD CONSTRAINT agent_memories_pkey PRIMARY KEY (id);


--
-- Name: commented_posts commented_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.commented_posts
    ADD CONSTRAINT commented_posts_pkey PRIMARY KEY (id);


--
-- Name: competitor_tracks competitor_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.competitor_tracks
    ADD CONSTRAINT competitor_tracks_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: linkedin_comments linkedin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.linkedin_comments
    ADD CONSTRAINT linkedin_comments_pkey PRIMARY KEY (id);


--
-- Name: linkedin_posts linkedin_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.linkedin_posts
    ADD CONSTRAINT linkedin_posts_pkey PRIMARY KEY (id);


--
-- Name: linkedin_profiles linkedin_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.linkedin_profiles
    ADD CONSTRAINT linkedin_profiles_pkey PRIMARY KEY (id);


--
-- Name: post_drafts post_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.post_drafts
    ADD CONSTRAINT post_drafts_pkey PRIMARY KEY (id);


--
-- Name: raw_snapshots raw_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.raw_snapshots
    ADD CONSTRAINT raw_snapshots_pkey PRIMARY KEY (id);


--
-- Name: viral_patterns viral_patterns_pkey; Type: CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.viral_patterns
    ADD CONSTRAINT viral_patterns_pkey PRIMARY KEY (id);


--
-- Name: agent_memories_category_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX agent_memories_category_idx ON public.agent_memories USING btree (category);


--
-- Name: commented_posts_commentedAt_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "commented_posts_commentedAt_idx" ON public.commented_posts USING btree ("commentedAt");


--
-- Name: commented_posts_postId_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "commented_posts_postId_idx" ON public.commented_posts USING btree ("postId");


--
-- Name: commented_posts_postId_key; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE UNIQUE INDEX "commented_posts_postId_key" ON public.commented_posts USING btree ("postId");


--
-- Name: competitor_tracks_linkedinUrl_key; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE UNIQUE INDEX "competitor_tracks_linkedinUrl_key" ON public.competitor_tracks USING btree ("linkedinUrl");


--
-- Name: contacts_createdAt_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "contacts_createdAt_idx" ON public.contacts USING btree ("createdAt");


--
-- Name: contacts_followUpDueAt_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "contacts_followUpDueAt_idx" ON public.contacts USING btree ("followUpDueAt");


--
-- Name: contacts_linkedinUrl_key; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE UNIQUE INDEX "contacts_linkedinUrl_key" ON public.contacts USING btree ("linkedinUrl");


--
-- Name: contacts_status_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX contacts_status_idx ON public.contacts USING btree (status);


--
-- Name: linkedin_comments_postId_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "linkedin_comments_postId_idx" ON public.linkedin_comments USING btree ("postId");


--
-- Name: linkedin_comments_qualityScore_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "linkedin_comments_qualityScore_idx" ON public.linkedin_comments USING btree ("qualityScore");


--
-- Name: linkedin_posts_postId_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "linkedin_posts_postId_idx" ON public.linkedin_posts USING btree ("postId");


--
-- Name: linkedin_posts_postId_key; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE UNIQUE INDEX "linkedin_posts_postId_key" ON public.linkedin_posts USING btree ("postId");


--
-- Name: linkedin_posts_topic_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX linkedin_posts_topic_idx ON public.linkedin_posts USING btree (topic);


--
-- Name: linkedin_posts_viralScore_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "linkedin_posts_viralScore_idx" ON public.linkedin_posts USING btree ("viralScore");


--
-- Name: linkedin_profiles_linkedinUrl_key; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE UNIQUE INDEX "linkedin_profiles_linkedinUrl_key" ON public.linkedin_profiles USING btree ("linkedinUrl");


--
-- Name: post_drafts_scheduledFor_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX "post_drafts_scheduledFor_idx" ON public.post_drafts USING btree ("scheduledFor");


--
-- Name: post_drafts_status_idx; Type: INDEX; Schema: public; Owner: linkedindatabase
--

CREATE INDEX post_drafts_status_idx ON public.post_drafts USING btree (status);


--
-- Name: linkedin_comments linkedin_comments_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.linkedin_comments
    ADD CONSTRAINT "linkedin_comments_postId_fkey" FOREIGN KEY ("postId") REFERENCES public.linkedin_posts(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: linkedin_posts linkedin_posts_profileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: linkedindatabase
--

ALTER TABLE ONLY public.linkedin_posts
    ADD CONSTRAINT "linkedin_posts_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES public.linkedin_profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO linkedindatabase;


--
-- Name: FUNCTION halfvec_in(cstring, oid, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_in(cstring, oid, integer) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_out(public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_out(public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_recv(internal, oid, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_recv(internal, oid, integer) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_send(public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_send(public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_typmod_in(cstring[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_typmod_in(cstring[]) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_in(cstring, oid, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_in(cstring, oid, integer) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_out(public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_out(public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_recv(internal, oid, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_recv(internal, oid, integer) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_send(public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_send(public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_typmod_in(cstring[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_typmod_in(cstring[]) TO linkedindatabase;


--
-- Name: FUNCTION vector_in(cstring, oid, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_in(cstring, oid, integer) TO linkedindatabase;


--
-- Name: FUNCTION vector_out(public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_out(public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_recv(internal, oid, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_recv(internal, oid, integer) TO linkedindatabase;


--
-- Name: FUNCTION vector_send(public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_send(public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_typmod_in(cstring[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_typmod_in(cstring[]) TO linkedindatabase;


--
-- Name: FUNCTION array_to_halfvec(real[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_halfvec(real[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_sparsevec(real[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_sparsevec(real[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_vector(real[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_vector(real[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_halfvec(double precision[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_halfvec(double precision[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_sparsevec(double precision[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_sparsevec(double precision[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_vector(double precision[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_vector(double precision[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_halfvec(integer[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_halfvec(integer[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_sparsevec(integer[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_sparsevec(integer[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_vector(integer[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_vector(integer[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_halfvec(numeric[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_halfvec(numeric[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_sparsevec(numeric[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_sparsevec(numeric[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION array_to_vector(numeric[], integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.array_to_vector(numeric[], integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_to_float4(public.halfvec, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_to_float4(public.halfvec, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION halfvec(public.halfvec, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec(public.halfvec, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_to_sparsevec(public.halfvec, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_to_sparsevec(public.halfvec, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_to_vector(public.halfvec, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_to_vector(public.halfvec, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_to_halfvec(public.sparsevec, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_to_halfvec(public.sparsevec, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec(public.sparsevec, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec(public.sparsevec, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_to_vector(public.sparsevec, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_to_vector(public.sparsevec, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION vector_to_float4(public.vector, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_to_float4(public.vector, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION vector_to_halfvec(public.vector, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_to_halfvec(public.vector, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION vector_to_sparsevec(public.vector, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_to_sparsevec(public.vector, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION vector(public.vector, integer, boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector(public.vector, integer, boolean) TO linkedindatabase;


--
-- Name: FUNCTION binary_quantize(public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.binary_quantize(public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION binary_quantize(public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.binary_quantize(public.vector) TO linkedindatabase;


--
-- Name: FUNCTION cosine_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cosine_distance(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION cosine_distance(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cosine_distance(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION cosine_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cosine_distance(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_accum(double precision[], public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_accum(double precision[], public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_add(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_add(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_avg(double precision[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_avg(double precision[]) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_cmp(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_cmp(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_combine(double precision[], double precision[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_combine(double precision[], double precision[]) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_concat(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_concat(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_eq(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_eq(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_ge(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_ge(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_gt(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_gt(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_l2_squared_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_l2_squared_distance(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_le(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_le(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_lt(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_lt(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_mul(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_mul(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_ne(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_ne(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_negative_inner_product(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_negative_inner_product(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_spherical_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_spherical_distance(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION halfvec_sub(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.halfvec_sub(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION hamming_distance(bit, bit); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hamming_distance(bit, bit) TO linkedindatabase;


--
-- Name: FUNCTION hnsw_bit_support(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hnsw_bit_support(internal) TO linkedindatabase;


--
-- Name: FUNCTION hnsw_halfvec_support(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hnsw_halfvec_support(internal) TO linkedindatabase;


--
-- Name: FUNCTION hnsw_sparsevec_support(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hnsw_sparsevec_support(internal) TO linkedindatabase;


--
-- Name: FUNCTION hnswhandler(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hnswhandler(internal) TO linkedindatabase;


--
-- Name: FUNCTION inner_product(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.inner_product(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION inner_product(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.inner_product(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION inner_product(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.inner_product(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION ivfflat_bit_support(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ivfflat_bit_support(internal) TO linkedindatabase;


--
-- Name: FUNCTION ivfflat_halfvec_support(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ivfflat_halfvec_support(internal) TO linkedindatabase;


--
-- Name: FUNCTION ivfflathandler(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ivfflathandler(internal) TO linkedindatabase;


--
-- Name: FUNCTION jaccard_distance(bit, bit); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.jaccard_distance(bit, bit) TO linkedindatabase;


--
-- Name: FUNCTION l1_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l1_distance(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION l1_distance(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l1_distance(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION l1_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l1_distance(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION l2_distance(public.halfvec, public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l2_distance(public.halfvec, public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION l2_distance(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l2_distance(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION l2_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l2_distance(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION l2_norm(public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l2_norm(public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION l2_norm(public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l2_norm(public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION l2_normalize(public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l2_normalize(public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION l2_normalize(public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l2_normalize(public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION l2_normalize(public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.l2_normalize(public.vector) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_cmp(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_cmp(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_eq(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_eq(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_ge(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_ge(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_gt(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_gt(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_l2_squared_distance(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_l2_squared_distance(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_le(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_le(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_lt(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_lt(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_ne(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_ne(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION sparsevec_negative_inner_product(public.sparsevec, public.sparsevec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sparsevec_negative_inner_product(public.sparsevec, public.sparsevec) TO linkedindatabase;


--
-- Name: FUNCTION subvector(public.halfvec, integer, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.subvector(public.halfvec, integer, integer) TO linkedindatabase;


--
-- Name: FUNCTION subvector(public.vector, integer, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.subvector(public.vector, integer, integer) TO linkedindatabase;


--
-- Name: FUNCTION vector_accum(double precision[], public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_accum(double precision[], public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_add(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_add(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_avg(double precision[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_avg(double precision[]) TO linkedindatabase;


--
-- Name: FUNCTION vector_cmp(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_cmp(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_combine(double precision[], double precision[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_combine(double precision[], double precision[]) TO linkedindatabase;


--
-- Name: FUNCTION vector_concat(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_concat(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_dims(public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_dims(public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION vector_dims(public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_dims(public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_eq(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_eq(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_ge(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_ge(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_gt(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_gt(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_l2_squared_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_l2_squared_distance(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_le(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_le(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_lt(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_lt(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_mul(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_mul(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_ne(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_ne(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_negative_inner_product(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_negative_inner_product(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_norm(public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_norm(public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_spherical_distance(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_spherical_distance(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION vector_sub(public.vector, public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.vector_sub(public.vector, public.vector) TO linkedindatabase;


--
-- Name: FUNCTION avg(public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.avg(public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION avg(public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.avg(public.vector) TO linkedindatabase;


--
-- Name: FUNCTION sum(public.halfvec); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sum(public.halfvec) TO linkedindatabase;


--
-- Name: FUNCTION sum(public.vector); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sum(public.vector) TO linkedindatabase;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO linkedindatabase;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO linkedindatabase;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO linkedindatabase;


--
-- PostgreSQL database dump complete
--

\unrestrict xVapHlHCa9cIMuuBeewQNIRxfZeJXkWc9HSNer80UTVs2neCqZgFVWG2NKNzySr

