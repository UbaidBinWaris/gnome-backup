--
-- PostgreSQL database dump
--

\restrict 9KLNdHc0vjumRNxMgYY7rqzuzkWFiOSnswrPSqukEurqgpD5cXOOacx3eFb0vbv

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: scrap_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO scrap_user;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: scrap_user
--

COMMENT ON SCHEMA public IS '';


--
-- Name: ListingStatus; Type: TYPE; Schema: public; Owner: scrap_user
--

CREATE TYPE public."ListingStatus" AS ENUM (
    'DRAFT',
    'ACTIVE',
    'SCHEDULED'
);


ALTER TYPE public."ListingStatus" OWNER TO scrap_user;

--
-- Name: OfferStatus; Type: TYPE; Schema: public; Owner: scrap_user
--

CREATE TYPE public."OfferStatus" AS ENUM (
    'PENDING',
    'COUNTERED',
    'ACCEPTED',
    'REJECTED',
    'COMPLETED'
);


ALTER TYPE public."OfferStatus" OWNER TO scrap_user;

--
-- Name: Role; Type: TYPE; Schema: public; Owner: scrap_user
--

CREATE TYPE public."Role" AS ENUM (
    'buyer',
    'seller',
    'both',
    'admin'
);


ALTER TYPE public."Role" OWNER TO scrap_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: AnalysisFeedback; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."AnalysisFeedback" (
    id integer NOT NULL,
    "analysisRecordId" integer NOT NULL,
    "userId" integer NOT NULL,
    "isCorrect" boolean NOT NULL,
    "correctedMaterial" character varying(100),
    "feedbackNote" character varying(500),
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."AnalysisFeedback" OWNER TO scrap_user;

--
-- Name: AnalysisFeedback_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."AnalysisFeedback_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."AnalysisFeedback_id_seq" OWNER TO scrap_user;

--
-- Name: AnalysisFeedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."AnalysisFeedback_id_seq" OWNED BY public."AnalysisFeedback".id;


--
-- Name: AnalysisHistory; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."AnalysisHistory" (
    id text NOT NULL,
    "userId" integer NOT NULL,
    material character varying(100) NOT NULL,
    confidence double precision NOT NULL,
    "estimatedSize" double precision NOT NULL,
    "estimatedWeight" double precision NOT NULL,
    "estimatedPrice" double precision,
    "userSize" double precision,
    "userWeight" double precision,
    "userPrice" double precision,
    condition character varying(50),
    description character varying(500),
    images jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."AnalysisHistory" OWNER TO scrap_user;

--
-- Name: AnalysisRecord; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."AnalysisRecord" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "imageRef" character varying(1000),
    brightness double precision,
    variance double precision,
    saturation double precision,
    warmth double precision,
    "metallicScore" double precision,
    "textureScore" double precision,
    "channelBalance" double precision,
    "featureJson" text NOT NULL,
    "predictedMaterial" character varying(100) NOT NULL,
    confidence double precision NOT NULL,
    "secondaryMaterial" character varying(100),
    "alternativesJson" text NOT NULL,
    "qualityScore" double precision NOT NULL,
    "qualityGrade" character varying(10) NOT NULL,
    "estimatedWeightKg" double precision,
    "weightMin" double precision,
    "weightMax" double precision,
    "uncertaintyBand" double precision,
    "pricePerKg" double precision,
    "totalPrice" double precision,
    condition character varying(20),
    city character varying(100),
    "engineVersion" character varying(50),
    "imagesAnalyzed" integer,
    "processingMs" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."AnalysisRecord" OWNER TO scrap_user;

--
-- Name: AnalysisRecord_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."AnalysisRecord_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."AnalysisRecord_id_seq" OWNER TO scrap_user;

--
-- Name: AnalysisRecord_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."AnalysisRecord_id_seq" OWNED BY public."AnalysisRecord".id;


--
-- Name: ChatMessage; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."ChatMessage" (
    id integer NOT NULL,
    "offerId" integer NOT NULL,
    "senderId" integer NOT NULL,
    message character varying(1000) NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."ChatMessage" OWNER TO scrap_user;

--
-- Name: ChatMessage_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."ChatMessage_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ChatMessage_id_seq" OWNER TO scrap_user;

--
-- Name: ChatMessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."ChatMessage_id_seq" OWNED BY public."ChatMessage".id;


--
-- Name: FavoriteDealer; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."FavoriteDealer" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "dealerId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."FavoriteDealer" OWNER TO scrap_user;

--
-- Name: FavoriteDealer_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."FavoriteDealer_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."FavoriteDealer_id_seq" OWNER TO scrap_user;

--
-- Name: FavoriteDealer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."FavoriteDealer_id_seq" OWNED BY public."FavoriteDealer".id;


--
-- Name: Listing; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."Listing" (
    id integer NOT NULL,
    title character varying(150) NOT NULL,
    description character varying(1000),
    material character varying(100) NOT NULL,
    price double precision NOT NULL,
    quantity double precision DEFAULT 0 NOT NULL,
    weight double precision DEFAULT 0 NOT NULL,
    size double precision,
    unit character varying(20) DEFAULT 'kg'::character varying NOT NULL,
    condition character varying(20) DEFAULT 'Good'::character varying NOT NULL,
    "imageUrl" character varying(500),
    images jsonb,
    "isActive" boolean DEFAULT true NOT NULL,
    status public."ListingStatus" DEFAULT 'ACTIVE'::public."ListingStatus" NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    latitude double precision,
    longitude double precision,
    "scheduledAt" timestamp(3) without time zone
);


ALTER TABLE public."Listing" OWNER TO scrap_user;

--
-- Name: Listing_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."Listing_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Listing_id_seq" OWNER TO scrap_user;

--
-- Name: Listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."Listing_id_seq" OWNED BY public."Listing".id;


--
-- Name: Offer; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."Offer" (
    id integer NOT NULL,
    "listingId" integer NOT NULL,
    "buyerId" integer NOT NULL,
    price double precision NOT NULL,
    weight double precision NOT NULL,
    status public."OfferStatus" DEFAULT 'PENDING'::public."OfferStatus" NOT NULL,
    "parentOfferId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Offer" OWNER TO scrap_user;

--
-- Name: Offer_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."Offer_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Offer_id_seq" OWNER TO scrap_user;

--
-- Name: Offer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."Offer_id_seq" OWNED BY public."Offer".id;


--
-- Name: PriceHistory; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."PriceHistory" (
    id integer NOT NULL,
    material character varying(100) NOT NULL,
    city character varying(100),
    condition character varying(20),
    "minPrice" double precision,
    "maxPrice" double precision,
    price double precision,
    unit character varying(20),
    source character varying(100),
    "recordedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."PriceHistory" OWNER TO scrap_user;

--
-- Name: PriceHistory_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."PriceHistory_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PriceHistory_id_seq" OWNER TO scrap_user;

--
-- Name: PriceHistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."PriceHistory_id_seq" OWNED BY public."PriceHistory".id;


--
-- Name: Review; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."Review" (
    id integer NOT NULL,
    "reviewerId" integer NOT NULL,
    "dealerId" integer NOT NULL,
    rating integer NOT NULL,
    comment character varying(500),
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Review" OWNER TO scrap_user;

--
-- Name: Review_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."Review_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Review_id_seq" OWNER TO scrap_user;

--
-- Name: Review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."Review_id_seq" OWNED BY public."Review".id;


--
-- Name: SavedLocation; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."SavedLocation" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    label character varying(100) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."SavedLocation" OWNER TO scrap_user;

--
-- Name: SavedLocation_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."SavedLocation_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."SavedLocation_id_seq" OWNER TO scrap_user;

--
-- Name: SavedLocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."SavedLocation_id_seq" OWNED BY public."SavedLocation".id;


--
-- Name: Scan; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."Scan" (
    id integer NOT NULL,
    "primaryMaterial" character varying(100) NOT NULL,
    "allMaterials" text NOT NULL,
    "anglesCount" integer DEFAULT 0 NOT NULL,
    "imageUrls" text,
    "estimatedMinPrice" double precision,
    "estimatedMaxPrice" double precision,
    "estimatedPrice" double precision,
    "estimationUnit" character varying(20),
    "conditionLevel" character varying(20),
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Scan" OWNER TO scrap_user;

--
-- Name: Scan_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."Scan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Scan_id_seq" OWNER TO scrap_user;

--
-- Name: Scan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."Scan_id_seq" OWNED BY public."Scan".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: scrap_user
--

CREATE TABLE public."User" (
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    "passwordHash" text,
    "isVerified" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "googleId" character varying(100),
    "isActive" boolean DEFAULT true NOT NULL,
    "isPrivateProfile" boolean DEFAULT false NOT NULL,
    "lastLoginAt" timestamp(3) without time zone,
    "lastLoginIp" character varying(50),
    location character varying(200),
    "newsletterOptIn" boolean DEFAULT false NOT NULL,
    "passwordChangedAt" timestamp(3) without time zone,
    phone character varying(20),
    "phoneVerified" boolean DEFAULT false NOT NULL,
    "photoUrl" character varying(500),
    role public."Role" DEFAULT 'buyer'::public."Role" NOT NULL,
    "showEmail" boolean DEFAULT true NOT NULL,
    "showPhone" boolean DEFAULT false NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    "averageRating" double precision DEFAULT 0 NOT NULL,
    latitude double precision,
    longitude double precision,
    "reviewCount" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."User" OWNER TO scrap_user;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: scrap_user
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO scrap_user;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scrap_user
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: AnalysisFeedback id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisFeedback" ALTER COLUMN id SET DEFAULT nextval('public."AnalysisFeedback_id_seq"'::regclass);


--
-- Name: AnalysisRecord id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisRecord" ALTER COLUMN id SET DEFAULT nextval('public."AnalysisRecord_id_seq"'::regclass);


--
-- Name: ChatMessage id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."ChatMessage" ALTER COLUMN id SET DEFAULT nextval('public."ChatMessage_id_seq"'::regclass);


--
-- Name: FavoriteDealer id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."FavoriteDealer" ALTER COLUMN id SET DEFAULT nextval('public."FavoriteDealer_id_seq"'::regclass);


--
-- Name: Listing id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Listing" ALTER COLUMN id SET DEFAULT nextval('public."Listing_id_seq"'::regclass);


--
-- Name: Offer id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Offer" ALTER COLUMN id SET DEFAULT nextval('public."Offer_id_seq"'::regclass);


--
-- Name: PriceHistory id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."PriceHistory" ALTER COLUMN id SET DEFAULT nextval('public."PriceHistory_id_seq"'::regclass);


--
-- Name: Review id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Review" ALTER COLUMN id SET DEFAULT nextval('public."Review_id_seq"'::regclass);


--
-- Name: SavedLocation id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."SavedLocation" ALTER COLUMN id SET DEFAULT nextval('public."SavedLocation_id_seq"'::regclass);


--
-- Name: Scan id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Scan" ALTER COLUMN id SET DEFAULT nextval('public."Scan_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Data for Name: AnalysisFeedback; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."AnalysisFeedback" (id, "analysisRecordId", "userId", "isCorrect", "correctedMaterial", "feedbackNote", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: AnalysisHistory; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."AnalysisHistory" (id, "userId", material, confidence, "estimatedSize", "estimatedWeight", "estimatedPrice", "userSize", "userWeight", "userPrice", condition, description, images, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: AnalysisRecord; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."AnalysisRecord" (id, "userId", "imageRef", brightness, variance, saturation, warmth, "metallicScore", "textureScore", "channelBalance", "featureJson", "predictedMaterial", confidence, "secondaryMaterial", "alternativesJson", "qualityScore", "qualityGrade", "estimatedWeightKg", "weightMin", "weightMax", "uncertaintyBand", "pricePerKg", "totalPrice", condition, city, "engineVersion", "imagesAnalyzed", "processingMs", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ChatMessage; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."ChatMessage" (id, "offerId", "senderId", message, "createdAt") FROM stdin;
\.


--
-- Data for Name: FavoriteDealer; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."FavoriteDealer" (id, "userId", "dealerId", "createdAt") FROM stdin;
\.


--
-- Data for Name: Listing; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."Listing" (id, title, description, material, price, quantity, weight, size, unit, condition, "imageUrl", images, "isActive", status, "userId", "createdAt", "updatedAt", latitude, longitude, "scheduledAt") FROM stdin;
1	STEEL Scrap - 80.89kg - Quality Fair	Sorted and cleaned for easy handling.	steel	2389	42	80.89	\N	bag	Fair	/uploads/products/product_438_1780236054902.jpg	\N	t	ACTIVE	438	2026-05-31 14:00:55.861	2026-05-31 14:00:55.861	30.13137582890977	71.46846271931233	\N
2	ELECTRONICS Scrap - 19.75kg - Quality Good	Collected from industrial facilities. Ready for processing.	electronics	4189	18	19.75	\N	ton	Good	/uploads/products/product_411_1780236055864.jpg	\N	t	ACTIVE	411	2026-05-31 14:00:56.132	2026-05-31 14:00:56.132	31.47014659372316	72.39582991539771	\N
3	PAPER Scrap - 83.29kg - Quality Good	Eco-friendly scrap collection.	paper	1622	5	83.29	\N	kg	Good	/uploads/products/product_446_1780236056134.jpg	\N	t	ACTIVE	446	2026-05-31 14:00:56.373	2026-05-31 14:00:56.373	30.16761043170659	71.48616773495506	\N
4	BRASS Scrap - 109.74kg - Quality Fair	Perfect for manufacturing and industrial use.	brass	1329	31	109.74	\N	kg	Fair	/uploads/products/product_420_1780236056374.jpg	\N	t	ACTIVE	420	2026-05-31 14:00:56.647	2026-05-31 14:00:56.647	24.87583231842836	66.97133443801027	\N
5	CARDBOARD Scrap - 26.82kg - Quality Good	High quality scrap material, ideal for recycling.	cardboard	1938	37	26.82	\N	bundle	Good	/uploads/products/product_416_1780236056648.jpg	\N	t	ACTIVE	416	2026-05-31 14:00:56.948	2026-05-31 14:00:56.948	31.37010655886155	72.34224627742027	\N
6	RUBBER Scrap - 17.87kg - Quality Fair	Eco-friendly scrap collection.	rubber	2175	13	17.87	\N	kg	Fair	/uploads/products/product_427_1780236056949.jpg	\N	t	ACTIVE	427	2026-05-31 14:00:57.19	2026-05-31 14:00:57.19	34.01351604004817	71.54558035694427	\N
7	LEATHER Scrap - 34.49kg - Quality Poor	Recently collected, excellent condition.	leather	296	29	34.49	\N	kg	Poor	/uploads/products/product_448_1780236057191.jpg	\N	t	ACTIVE	448	2026-05-31 14:00:57.43	2026-05-31 14:00:57.43	33.58318477785009	73.21392713395814	\N
8	CARDBOARD Scrap - 66.02kg - Quality Good	Collected from industrial facilities. Ready for processing.	cardboard	2841	40	66.02	\N	kg	Good	/uploads/products/product_412_1780236057431.jpg	\N	t	ACTIVE	412	2026-05-31 14:00:57.67	2026-05-31 14:00:57.67	31.45272017635651	72.37078770823835	\N
9	COMPOSITE Scrap - 55.71kg - Quality Fair	Sorted and cleaned for easy handling.	composite	3771	6	55.71	\N	piece	Fair	/uploads/products/product_426_1780236057671.jpg	\N	t	ACTIVE	426	2026-05-31 14:00:57.973	2026-05-31 14:00:57.973	32.11383613022194	74.11809021842417	\N
10	WOOD Scrap - 107.45kg - Quality Poor	Perfect for manufacturing and industrial use.	wood	3784	25	107.45	\N	bag	Poor	/uploads/products/product_441_1780236057973.jpg	\N	t	ACTIVE	441	2026-05-31 14:00:58.213	2026-05-31 14:00:58.213	25.41790785030356	68.46670417958336	\N
11	CARDBOARD Scrap - 106.17kg - Quality Fair	Verified weight and quality.	cardboard	4667	21	106.17	\N	ton	Fair	/uploads/products/product_452_1780236058214.jpg	\N	t	ACTIVE	452	2026-05-31 14:00:58.49	2026-05-31 14:00:58.49	31.54630571758108	74.35919277523043	\N
12	METAL Scrap - 60.92kg - Quality Fair	Verified weight and quality.	metal	1477	21	60.92	\N	bag	Fair	/uploads/products/product_425_1780236058490.jpg	\N	t	ACTIVE	425	2026-05-31 14:00:58.73	2026-05-31 14:00:58.73	32.11404071654	74.15558321949719	\N
13	CARDBOARD Scrap - 66.96kg - Quality Fair	Recently collected, excellent condition.	cardboard	3495	24	66.96	\N	piece	Fair	/uploads/products/product_450_1780236058730.jpg	\N	t	ACTIVE	450	2026-05-31 14:00:58.996	2026-05-31 14:00:58.996	25.42794367430469	68.48897584844339	\N
14	PAPER Scrap - 64.37kg - Quality Fair	Verified weight and quality.	paper	4315	19	64.37	\N	bag	Fair	/uploads/products/product_442_1780236058997.jpg	\N	t	ACTIVE	442	2026-05-31 14:00:59.236	2026-05-31 14:00:59.236	25.36095439888391	68.43306483365882	\N
15	RUBBER Scrap - 10.30kg - Quality Fair	Bulk quantity available for bulk buyers.	rubber	471	12	10.3	\N	bundle	Fair	/uploads/products/product_413_1780236059237.jpg	\N	t	ACTIVE	413	2026-05-31 14:00:59.512	2026-05-31 14:00:59.512	34.07495018072431	71.5471241810862	\N
16	FOAM Scrap - 47.83kg - Quality Poor	High quality scrap material, ideal for recycling.	foam	2474	28	47.83	\N	bundle	Poor	/uploads/products/product_417_1780236059513.jpg	\N	t	ACTIVE	417	2026-05-31 14:00:59.752	2026-05-31 14:00:59.752	34.04372010902156	71.54286301935882	\N
17	COPPER Scrap - 39.84kg - Quality Good	Collected from industrial facilities. Ready for processing.	copper	717	17	39.84	\N	ton	Good	/uploads/products/product_421_1780236059753.jpg	\N	t	ACTIVE	421	2026-05-31 14:00:59.993	2026-05-31 14:00:59.993	24.86021364374637	67.02972149749836	\N
18	CARDBOARD Scrap - 61.55kg - Quality Fair	Eco-friendly scrap collection.	cardboard	4915	28	61.55	\N	ton	Fair	/uploads/products/product_441_1780236059994.jpg	\N	t	ACTIVE	441	2026-05-31 14:01:00.233	2026-05-31 14:01:00.233	25.46478082247783	68.47685554682444	\N
19	COPPER Scrap - 95.37kg - Quality Good	High quality scrap material, ideal for recycling.	copper	1835	5	95.37	\N	piece	Good	/uploads/products/product_421_1780236060234.jpg	\N	t	ACTIVE	421	2026-05-31 14:01:00.536	2026-05-31 14:01:00.536	24.86697903891153	67.0439980130941	\N
20	WOOD Scrap - 96.78kg - Quality Poor	High quality scrap material, ideal for recycling.	wood	3155	41	96.78	\N	bag	Poor	/uploads/products/product_446_1780236060537.jpg	\N	t	ACTIVE	446	2026-05-31 14:01:00.776	2026-05-31 14:01:00.776	30.17107048966511	71.45048048370184	\N
21	LEATHER Scrap - 92.44kg - Quality Fair	Sorted and cleaned for easy handling.	leather	4876	48	92.44	\N	bag	Fair	/uploads/products/product_425_1780236060777.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:01.048	2026-05-31 14:01:01.048	32.13710807306298	74.13926207469741	\N
22	METAL Scrap - 72.87kg - Quality Poor	Sorted and cleaned for easy handling.	metal	2428	5	72.87	\N	ton	Poor	/uploads/products/product_415_1780236061049.jpg	\N	t	ACTIVE	415	2026-05-31 14:01:01.355	2026-05-31 14:01:01.355	30.14660931844331	67.06350925805721	\N
23	LEATHER Scrap - 31.31kg - Quality Fair	High quality scrap material, ideal for recycling.	leather	2562	33	31.31	\N	ton	Fair	/uploads/products/product_444_1780236061356.jpg	\N	t	ACTIVE	444	2026-05-31 14:01:01.663	2026-05-31 14:01:01.663	25.37968074802034	68.45804579394216	\N
24	CARDBOARD Scrap - 92.99kg - Quality Good	Recently collected, excellent condition.	cardboard	693	9	92.99	\N	bag	Good	/uploads/products/product_425_1780236061664.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:01.903	2026-05-31 14:01:01.903	32.13960037094473	74.14968562288709	\N
25	BRASS Scrap - 40.02kg - Quality Good	High quality scrap material, ideal for recycling.	brass	3975	12	40.02	\N	kg	Good	/uploads/products/product_450_1780236061904.jpg	\N	t	ACTIVE	450	2026-05-31 14:01:02.174	2026-05-31 14:01:02.174	25.44316003539055	68.49517862569977	\N
26	RUBBER Scrap - 81.26kg - Quality Poor	Bulk quantity available for bulk buyers.	rubber	4906	26	81.26	\N	bundle	Poor	/uploads/products/product_426_1780236062175.jpg	\N	t	ACTIVE	426	2026-05-31 14:01:02.482	2026-05-31 14:01:02.482	32.14834664371968	74.15238801921302	\N
27	METAL Scrap - 75.16kg - Quality Poor	Eco-friendly scrap collection.	metal	4194	26	75.16	\N	bundle	Poor	/uploads/products/product_417_1780236062482.jpg	\N	t	ACTIVE	417	2026-05-31 14:01:02.721	2026-05-31 14:01:02.721	34.07492881344115	71.54636946580474	\N
28	CARDBOARD Scrap - 83.39kg - Quality Fair	Perfect for manufacturing and industrial use.	cardboard	4602	48	83.39	\N	bundle	Fair	/uploads/products/product_410_1780236062722.jpg	\N	t	ACTIVE	410	2026-05-31 14:01:02.961	2026-05-31 14:01:02.961	25.44679771901011	68.47396922365898	\N
29	ALUMINUM Scrap - 73.07kg - Quality Fair	Collected from industrial facilities. Ready for processing.	aluminum	4508	21	73.07	\N	kg	Fair	/uploads/products/product_412_1780236062962.jpg	\N	t	ACTIVE	412	2026-05-31 14:01:03.301	2026-05-31 14:01:03.301	31.4380599649347	72.38347822468116	\N
30	METAL Scrap - 99.11kg - Quality Fair	Recently collected, excellent condition.	metal	3945	52	99.11	\N	piece	Fair	/uploads/products/product_423_1780236063302.jpg	\N	t	ACTIVE	423	2026-05-31 14:01:03.608	2026-05-31 14:01:03.608	31.41920031806293	72.3678173474054	\N
31	STEEL Scrap - 43.27kg - Quality Fair	Eco-friendly scrap collection.	steel	1907	44	43.27	\N	bag	Fair	/uploads/products/product_411_1780236063609.jpg	\N	t	ACTIVE	411	2026-05-31 14:01:03.848	2026-05-31 14:01:03.848	31.46918886996776	72.36527503356342	\N
32	GLASS Scrap - 42.45kg - Quality Fair	High quality scrap material, ideal for recycling.	glass	1603	15	42.45	\N	kg	Fair	/uploads/products/product_448_1780236063849.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:05.146	2026-05-31 14:01:05.146	33.57033025642386	73.21658706131151	\N
33	WOOD Scrap - 95.03kg - Quality Poor	Perfect for manufacturing and industrial use.	wood	2387	53	95.03	\N	bag	Poor	/uploads/products/product_427_1780236065147.jpg	\N	t	ACTIVE	427	2026-05-31 14:01:05.454	2026-05-31 14:01:05.454	34.0073372701376	71.51870997372158	\N
34	STEEL Scrap - 54.60kg - Quality Fair	Recently collected, excellent condition.	steel	2797	31	54.6	\N	ton	Fair	/uploads/products/product_439_1780236065454.jpg	\N	t	ACTIVE	439	2026-05-31 14:01:05.759	2026-05-31 14:01:05.759	25.3621898293358	68.45294442195443	\N
35	BRASS Scrap - 109.70kg - Quality Good	Recently collected, excellent condition.	brass	4920	46	109.7	\N	bag	Good	/uploads/products/product_449_1780236065760.jpg	\N	t	ACTIVE	449	2026-05-31 14:01:06	2026-05-31 14:01:06	32.21397631379597	74.22356937939406	\N
36	METAL Scrap - 36.31kg - Quality Good	Eco-friendly scrap collection.	metal	3545	35	36.31	\N	bag	Good	/uploads/products/product_415_1780236066001.jpg	\N	t	ACTIVE	415	2026-05-31 14:01:06.375	2026-05-31 14:01:06.375	30.17570327157127	67.02592119778676	\N
37	STEEL Scrap - 15.26kg - Quality Fair	Collected from industrial facilities. Ready for processing.	steel	1146	42	15.26	\N	kg	Fair	/uploads/products/product_425_1780236066376.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:06.683	2026-05-31 14:01:06.683	32.12678630090565	74.1381185193669	\N
38	GLASS Scrap - 49.16kg - Quality Good	Collected from industrial facilities. Ready for processing.	glass	4080	49	49.16	\N	bundle	Good	/uploads/products/product_414_1780236066684.jpg	\N	t	ACTIVE	414	2026-05-31 14:01:06.925	2026-05-31 14:01:06.925	33.55781854873279	73.24791165119073	\N
39	METAL Scrap - 12.74kg - Quality Good	Perfect for manufacturing and industrial use.	metal	2553	50	12.74	\N	kg	Good	/uploads/products/product_419_1780236066926.jpg	\N	t	ACTIVE	419	2026-05-31 14:01:07.166	2026-05-31 14:01:07.166	31.55291710873457	74.30936768772416	\N
40	STEEL Scrap - 14.38kg - Quality Poor	Recently collected, excellent condition.	steel	4604	14	14.38	\N	bag	Poor	/uploads/products/product_425_1780236067166.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:07.407	2026-05-31 14:01:07.407	32.09603611027562	74.14239600888318	\N
41	CARDBOARD Scrap - 82.65kg - Quality Good	Bulk quantity available for bulk buyers.	cardboard	3278	54	82.65	\N	bundle	Good	/uploads/products/product_411_1780236067407.jpg	\N	t	ACTIVE	411	2026-05-31 14:01:07.708	2026-05-31 14:01:07.708	31.45417284841348	72.37144758403144	\N
42	FOAM Scrap - 106.52kg - Quality Poor	Perfect for manufacturing and industrial use.	foam	2954	34	106.52	\N	bag	Poor	/uploads/products/product_446_1780236067709.jpg	\N	t	ACTIVE	446	2026-05-31 14:01:07.948	2026-05-31 14:01:07.948	30.16135593463186	71.44908744973097	\N
43	ELECTRONICS Scrap - 102.62kg - Quality Good	Recently collected, excellent condition.	electronics	4835	43	102.62	\N	ton	Good	/uploads/products/product_448_1780236067949.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:08.216	2026-05-31 14:01:08.216	33.59707537247578	73.19913669393296	\N
44	GLASS Scrap - 86.87kg - Quality Good	Recently collected, excellent condition.	glass	3215	33	86.87	\N	piece	Good	/uploads/products/product_418_1780236068216.jpg	\N	t	ACTIVE	418	2026-05-31 14:01:08.525	2026-05-31 14:01:08.525	33.6550043184052	73.0319006457138	\N
45	METAL Scrap - 21.98kg - Quality Good	Bulk quantity available for bulk buyers.	metal	5080	37	21.98	\N	ton	Good	/uploads/products/product_415_1780236068525.jpg	\N	t	ACTIVE	415	2026-05-31 14:01:09.445	2026-05-31 14:01:09.445	30.18276454648578	67.02982477732466	\N
46	ELECTRONICS Scrap - 39.65kg - Quality Poor	Sorted and cleaned for easy handling.	electronics	1500	12	39.65	\N	piece	Poor	/uploads/products/product_410_1780236069446.jpg	\N	t	ACTIVE	410	2026-05-31 14:01:09.753	2026-05-31 14:01:09.753	25.417274468827	68.45570860307402	\N
47	LEATHER Scrap - 107.89kg - Quality Fair	Bulk quantity available for bulk buyers.	leather	3959	19	107.89	\N	bag	Fair	/uploads/products/product_423_1780236069754.jpg	\N	t	ACTIVE	423	2026-05-31 14:01:10.572	2026-05-31 14:01:10.572	31.40633668112119	72.34610947179421	\N
48	METAL Scrap - 42.78kg - Quality Poor	Bulk quantity available for bulk buyers.	metal	2462	45	42.78	\N	bundle	Poor	/uploads/products/product_419_1780236070573.jpg	\N	t	ACTIVE	419	2026-05-31 14:01:10.879	2026-05-31 14:01:10.879	31.52954384616746	74.33329879418855	\N
49	ELECTRONICS Scrap - 35.36kg - Quality Good	Recently collected, excellent condition.	electronics	742	16	35.36	\N	bundle	Good	/uploads/products/product_415_1780236070880.jpg	\N	t	ACTIVE	415	2026-05-31 14:01:11.12	2026-05-31 14:01:11.12	30.16477158068534	67.0317095054085	\N
50	ELECTRONICS Scrap - 46.56kg - Quality Fair	Perfect for manufacturing and industrial use.	electronics	950	38	46.56	\N	kg	Fair	/uploads/products/product_412_1780236071121.jpg	\N	t	ACTIVE	412	2026-05-31 14:01:11.392	2026-05-31 14:01:11.392	31.4323880935714	72.36584189475529	\N
51	METAL Scrap - 12.28kg - Quality Fair	High quality scrap material, ideal for recycling.	metal	644	54	12.28	\N	piece	Fair	/uploads/products/product_427_1780236071393.jpg	\N	t	ACTIVE	427	2026-05-31 14:01:11.699	2026-05-31 14:01:11.699	34.00933128620694	71.54900303273554	\N
52	COPPER Scrap - 100.45kg - Quality Fair	Recently collected, excellent condition.	copper	440	33	100.45	\N	kg	Fair	/uploads/products/product_449_1780236071700.jpg	\N	t	ACTIVE	449	2026-05-31 14:01:12.006	2026-05-31 14:01:12.006	32.18341040637698	74.21911201850169	\N
53	PLASTIC Scrap - 43.63kg - Quality Good	Eco-friendly scrap collection.	plastic	4478	44	43.63	\N	ton	Good	/uploads/products/product_442_1780236072006.jpg	\N	t	ACTIVE	442	2026-05-31 14:01:12.245	2026-05-31 14:01:12.245	25.37521690210264	68.45552999821668	\N
54	LEATHER Scrap - 55.12kg - Quality Poor	Collected from industrial facilities. Ready for processing.	leather	3333	27	55.12	\N	ton	Poor	/uploads/products/product_422_1780236072246.jpg	\N	t	ACTIVE	422	2026-05-31 14:01:12.499	2026-05-31 14:01:12.499	24.83130111711666	66.99141232520105	\N
55	ALUMINUM Scrap - 109.17kg - Quality Good	Verified weight and quality.	aluminum	750	7	109.17	\N	kg	Good	/uploads/products/product_414_1780236072500.jpg	\N	t	ACTIVE	414	2026-05-31 14:01:12.824	2026-05-31 14:01:12.824	33.53453632467691	73.2642949522858	\N
56	PLASTIC Scrap - 86.42kg - Quality Good	Perfect for manufacturing and industrial use.	plastic	223	52	86.42	\N	piece	Good	/uploads/products/product_421_1780236072825.jpg	\N	t	ACTIVE	421	2026-05-31 14:01:13.132	2026-05-31 14:01:13.132	24.87249335678768	67.03638824775338	\N
57	BRASS Scrap - 21.59kg - Quality Poor	Bulk quantity available for bulk buyers.	brass	280	30	21.59	\N	bundle	Poor	/uploads/products/product_452_1780236073133.jpg	\N	t	ACTIVE	452	2026-05-31 14:01:13.439	2026-05-31 14:01:13.439	31.52721247872422	74.32907698869717	\N
58	CARDBOARD Scrap - 14.74kg - Quality Fair	Collected from industrial facilities. Ready for processing.	cardboard	2183	46	14.74	\N	bag	Fair	/uploads/products/product_424_1780236073440.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:13.679	2026-05-31 14:01:13.679	34.03965778513651	71.51721436238017	\N
59	METAL Scrap - 68.82kg - Quality Fair	Eco-friendly scrap collection.	metal	4282	21	68.82	\N	bundle	Fair	/uploads/products/product_450_1780236073680.jpg	\N	t	ACTIVE	450	2026-05-31 14:01:13.951	2026-05-31 14:01:13.951	25.40780348881803	68.48916545907059	\N
60	GLASS Scrap - 88.06kg - Quality Poor	Collected from industrial facilities. Ready for processing.	glass	1250	29	88.06	\N	bag	Poor	/uploads/products/product_413_1780236073952.jpg	\N	t	ACTIVE	413	2026-05-31 14:01:14.259	2026-05-31 14:01:14.259	34.07621309924529	71.53610159622268	\N
61	LEATHER Scrap - 29.38kg - Quality Poor	Recently collected, excellent condition.	leather	1659	40	29.38	\N	ton	Poor	/uploads/products/product_425_1780236074259.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:14.565	2026-05-31 14:01:14.565	32.09991756540524	74.14553400282769	\N
62	STEEL Scrap - 56.61kg - Quality Good	Sorted and cleaned for easy handling.	steel	2680	44	56.61	\N	bag	Good	/uploads/products/product_409_1780236074566.jpg	\N	t	ACTIVE	409	2026-05-31 14:01:14.806	2026-05-31 14:01:14.806	24.84005718874963	66.98255156149739	\N
63	PLASTIC Scrap - 60.99kg - Quality Good	Perfect for manufacturing and industrial use.	plastic	2178	41	60.99	\N	piece	Good	/uploads/products/product_425_1780236074806.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:15.061	2026-05-31 14:01:15.061	32.13480593232751	74.13119342988642	\N
64	COMPOSITE Scrap - 27.12kg - Quality Poor	High quality scrap material, ideal for recycling.	composite	1593	20	27.12	\N	bag	Poor	/uploads/products/product_410_1780236075062.jpg	\N	t	ACTIVE	410	2026-05-31 14:01:15.385	2026-05-31 14:01:15.385	25.40817119097413	68.47087205062704	\N
65	RUBBER Scrap - 50.01kg - Quality Poor	Perfect for manufacturing and industrial use.	rubber	2125	34	50.01	\N	kg	Poor	/uploads/products/product_451_1780236075386.jpg	\N	t	ACTIVE	451	2026-05-31 14:01:15.626	2026-05-31 14:01:15.626	24.856445594606	67.0033529384966	\N
66	FOAM Scrap - 75.07kg - Quality Poor	Verified weight and quality.	foam	3264	8	75.07	\N	ton	Poor	/uploads/products/product_448_1780236075627.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:15.897	2026-05-31 14:01:15.897	33.57503993239688	73.19619661303976	\N
67	LEATHER Scrap - 54.56kg - Quality Good	Sorted and cleaned for easy handling.	leather	4382	10	54.56	\N	bundle	Good	/uploads/products/product_425_1780236075898.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:16.204	2026-05-31 14:01:16.204	32.14317211355078	74.13787940964478	\N
68	PAPER Scrap - 68.28kg - Quality Good	Perfect for manufacturing and industrial use.	paper	877	54	68.28	\N	piece	Good	/uploads/products/product_418_1780236076205.jpg	\N	t	ACTIVE	418	2026-05-31 14:01:16.511	2026-05-31 14:01:16.511	33.62245497912504	73.0072752609566	\N
69	ELECTRONICS Scrap - 76.57kg - Quality Poor	Recently collected, excellent condition.	electronics	4420	28	76.57	\N	bag	Poor	/uploads/products/product_440_1780236076512.jpg	\N	t	ACTIVE	440	2026-05-31 14:01:16.818	2026-05-31 14:01:16.818	25.38234194822065	68.4897959021213	\N
70	GLASS Scrap - 98.92kg - Quality Fair	Bulk quantity available for bulk buyers.	glass	2680	8	98.92	\N	bag	Fair	/uploads/products/product_424_1780236076819.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:17.058	2026-05-31 14:01:17.058	34.03795351224029	71.49587872368238	\N
71	ALUMINUM Scrap - 92.26kg - Quality Good	Recently collected, excellent condition.	aluminum	4714	21	92.26	\N	piece	Good	/uploads/products/product_421_1780236077059.jpg	\N	t	ACTIVE	421	2026-05-31 14:01:17.33	2026-05-31 14:01:17.33	24.88535565976034	67.0530394071994	\N
72	ALUMINUM Scrap - 29.13kg - Quality Fair	Verified weight and quality.	aluminum	1213	26	29.13	\N	bag	Fair	/uploads/products/product_438_1780236077331.jpg	\N	t	ACTIVE	438	2026-05-31 14:01:17.637	2026-05-31 14:01:17.637	30.16276131208586	71.42815186694648	\N
73	COPPER Scrap - 67.61kg - Quality Good	Recently collected, excellent condition.	copper	2426	40	67.61	\N	ton	Good	/uploads/products/product_408_1780236077638.jpg	\N	t	ACTIVE	408	2026-05-31 14:01:17.878	2026-05-31 14:01:17.878	34.0329716242234	71.481083954986	\N
74	COMPOSITE Scrap - 23.88kg - Quality Good	High quality scrap material, ideal for recycling.	composite	1393	32	23.88	\N	kg	Good	/uploads/products/product_424_1780236077878.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:18.117	2026-05-31 14:01:18.117	34.07409311140007	71.5233356213239	\N
75	RUBBER Scrap - 11.07kg - Quality Poor	High quality scrap material, ideal for recycling.	rubber	2393	19	11.07	\N	ton	Poor	/uploads/products/product_411_1780236078118.jpg	\N	t	ACTIVE	411	2026-05-31 14:01:18.456	2026-05-31 14:01:18.456	31.4658185099864	72.35946822538237	\N
76	ELECTRONICS Scrap - 94.51kg - Quality Good	Verified weight and quality.	electronics	1664	22	94.51	\N	bundle	Good	/uploads/products/product_409_1780236078457.jpg	\N	t	ACTIVE	409	2026-05-31 14:01:18.765	2026-05-31 14:01:18.765	24.87240735486591	66.9572160914872	\N
77	FOAM Scrap - 17.63kg - Quality Good	Bulk quantity available for bulk buyers.	foam	1789	36	17.63	\N	ton	Good	/uploads/products/product_411_1780236078766.jpg	\N	t	ACTIVE	411	2026-05-31 14:01:19.029	2026-05-31 14:01:19.029	31.47192985995926	72.38475012700948	\N
78	ALUMINUM Scrap - 82.09kg - Quality Fair	Sorted and cleaned for easy handling.	aluminum	1523	44	82.09	\N	bag	Fair	/uploads/products/product_427_1780236079030.jpg	\N	t	ACTIVE	427	2026-05-31 14:01:19.269	2026-05-31 14:01:19.269	34.01924328754045	71.5257325069081	\N
79	CARDBOARD Scrap - 95.20kg - Quality Fair	Perfect for manufacturing and industrial use.	cardboard	5075	12	95.2	\N	ton	Fair	/uploads/products/product_418_1780236079270.jpg	\N	t	ACTIVE	418	2026-05-31 14:01:19.583	2026-05-31 14:01:19.583	33.62478051978191	73.0032035812735	\N
80	BRASS Scrap - 98.61kg - Quality Poor	Verified weight and quality.	brass	314	32	98.61	\N	bag	Poor	/uploads/products/product_447_1780236079584.jpg	\N	t	ACTIVE	447	2026-05-31 14:01:19.823	2026-05-31 14:01:19.823	25.33498473991976	68.49508642761366	\N
81	ELECTRONICS Scrap - 94.37kg - Quality Poor	Eco-friendly scrap collection.	electronics	4183	23	94.37	\N	bag	Poor	/uploads/products/product_423_1780236079823.jpg	\N	t	ACTIVE	423	2026-05-31 14:01:20.064	2026-05-31 14:01:20.064	31.41264814089128	72.3499641974344	\N
82	ALUMINUM Scrap - 20.57kg - Quality Poor	High quality scrap material, ideal for recycling.	aluminum	1564	28	20.57	\N	piece	Poor	/uploads/products/product_410_1780236080065.jpg	\N	t	ACTIVE	410	2026-05-31 14:01:20.403	2026-05-31 14:01:20.403	25.40873978160128	68.45650094014479	\N
83	GLASS Scrap - 36.28kg - Quality Fair	Sorted and cleaned for easy handling.	glass	475	11	36.28	\N	ton	Fair	/uploads/products/product_445_1780236080404.jpg	\N	t	ACTIVE	445	2026-05-31 14:01:20.709	2026-05-31 14:01:20.709	34.01469001881529	71.57719306376268	\N
84	GLASS Scrap - 28.83kg - Quality Fair	High quality scrap material, ideal for recycling.	glass	1610	5	28.83	\N	bundle	Fair	/uploads/products/product_424_1780236080710.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:21.016	2026-05-31 14:01:21.016	34.04707625577174	71.49988220552915	\N
85	STEEL Scrap - 93.53kg - Quality Good	Bulk quantity available for bulk buyers.	steel	2297	7	93.53	\N	bundle	Good	/uploads/products/product_441_1780236081017.jpg	\N	t	ACTIVE	441	2026-05-31 14:01:21.324	2026-05-31 14:01:21.324	25.45450773295438	68.4548867964159	\N
86	GLASS Scrap - 54.32kg - Quality Good	Sorted and cleaned for easy handling.	glass	4529	5	54.32	\N	ton	Good	/uploads/products/product_439_1780236081325.jpg	\N	t	ACTIVE	439	2026-05-31 14:01:21.632	2026-05-31 14:01:21.632	25.38376224601655	68.45843479944938	\N
87	STEEL Scrap - 37.34kg - Quality Good	Perfect for manufacturing and industrial use.	steel	2923	51	37.34	\N	bundle	Good	/uploads/products/product_449_1780236081633.jpg	\N	t	ACTIVE	449	2026-05-31 14:01:21.939	2026-05-31 14:01:21.939	32.21180806277206	74.18609480931539	\N
88	PLASTIC Scrap - 100.34kg - Quality Fair	Recently collected, excellent condition.	plastic	1823	39	100.34	\N	bag	Fair	/uploads/products/product_448_1780236081940.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:22.185	2026-05-31 14:01:22.185	33.59005658832151	73.19035754658715	\N
89	LEATHER Scrap - 15.03kg - Quality Good	High quality scrap material, ideal for recycling.	leather	865	43	15.03	\N	bag	Good	/uploads/products/product_425_1780236082186.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:22.45	2026-05-31 14:01:22.45	32.10946127212965	74.14077595728111	\N
90	COMPOSITE Scrap - 27.26kg - Quality Fair	Collected from industrial facilities. Ready for processing.	composite	1299	52	27.26	\N	kg	Fair	/uploads/products/product_449_1780236082451.jpg	\N	t	ACTIVE	449	2026-05-31 14:01:22.759	2026-05-31 14:01:22.759	32.19639565153348	74.19651238358195	\N
91	STEEL Scrap - 86.55kg - Quality Fair	Sorted and cleaned for easy handling.	steel	2391	13	86.55	\N	piece	Fair	/uploads/products/product_441_1780236082760.jpg	\N	t	ACTIVE	441	2026-05-31 14:01:23.07	2026-05-31 14:01:23.07	25.42481785241613	68.4942357025867	\N
92	COMPOSITE Scrap - 15.26kg - Quality Fair	Verified weight and quality.	composite	1954	30	15.26	\N	kg	Fair	/uploads/products/product_421_1780236083071.jpg	\N	t	ACTIVE	421	2026-05-31 14:01:23.31	2026-05-31 14:01:23.31	24.90852672456536	67.05453463442446	\N
93	ALUMINUM Scrap - 82.75kg - Quality Poor	Bulk quantity available for bulk buyers.	aluminum	3266	51	82.75	\N	bag	Poor	/uploads/products/product_445_1780236083311.jpg	\N	t	ACTIVE	445	2026-05-31 14:01:23.577	2026-05-31 14:01:23.577	34.01112825141502	71.559161102861	\N
94	PAPER Scrap - 100.42kg - Quality Fair	Verified weight and quality.	paper	1627	26	100.42	\N	ton	Fair	/uploads/products/product_448_1780236083578.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:23.817	2026-05-31 14:01:23.817	33.60716183244158	73.21464741400706	\N
95	PLASTIC Scrap - 109.70kg - Quality Fair	Eco-friendly scrap collection.	plastic	357	23	109.7	\N	ton	Fair	/uploads/products/product_440_1780236083818.jpg	\N	t	ACTIVE	440	2026-05-31 14:01:24.089	2026-05-31 14:01:24.089	25.39511638135689	68.48978252387218	\N
96	RUBBER Scrap - 57.69kg - Quality Poor	High quality scrap material, ideal for recycling.	rubber	1389	8	57.69	\N	piece	Poor	/uploads/products/product_446_1780236084090.jpg	\N	t	ACTIVE	446	2026-05-31 14:01:24.329	2026-05-31 14:01:24.329	30.1888329088184	71.4745691641452	\N
97	FOAM Scrap - 102.63kg - Quality Good	Recently collected, excellent condition.	foam	3140	14	102.63	\N	ton	Good	/uploads/products/product_451_1780236084331.jpg	\N	t	ACTIVE	451	2026-05-31 14:01:24.601	2026-05-31 14:01:24.601	24.81428188551904	67.0114719813508	\N
98	METAL Scrap - 49.39kg - Quality Good	High quality scrap material, ideal for recycling.	metal	1028	8	49.39	\N	kg	Good	/uploads/products/product_445_1780236084602.jpg	\N	t	ACTIVE	445	2026-05-31 14:01:24.908	2026-05-31 14:01:24.908	34.00974969247818	71.56102302235209	\N
99	CARDBOARD Scrap - 63.32kg - Quality Poor	Eco-friendly scrap collection.	cardboard	5018	7	63.32	\N	bag	Poor	/uploads/products/product_419_1780236084909.jpg	\N	t	ACTIVE	419	2026-05-31 14:01:25.216	2026-05-31 14:01:25.216	31.57297084274988	74.34121053799706	\N
100	BRASS Scrap - 91.61kg - Quality Good	High quality scrap material, ideal for recycling.	brass	4581	52	91.61	\N	bundle	Good	/uploads/products/product_409_1780236085217.jpg	\N	t	ACTIVE	409	2026-05-31 14:01:25.457	2026-05-31 14:01:25.457	24.83577465371858	66.95134532773285	\N
101	GLASS Scrap - 62.03kg - Quality Poor	Perfect for manufacturing and industrial use.	glass	4539	46	62.03	\N	ton	Poor	/uploads/products/product_417_1780236085458.jpg	\N	t	ACTIVE	417	2026-05-31 14:01:25.725	2026-05-31 14:01:25.725	34.0657824711399	71.52782995662383	\N
102	PAPER Scrap - 62.41kg - Quality Good	Eco-friendly scrap collection.	paper	655	9	62.41	\N	bundle	Good	/uploads/products/product_418_1780236085726.jpg	\N	t	ACTIVE	418	2026-05-31 14:01:26.035	2026-05-31 14:01:26.035	33.62829045792536	73.01178400398372	\N
103	PAPER Scrap - 64.72kg - Quality Poor	Verified weight and quality.	paper	430	31	64.72	\N	ton	Poor	/uploads/products/product_452_1780236086036.jpg	\N	t	ACTIVE	452	2026-05-31 14:01:26.341	2026-05-31 14:01:26.341	31.52851638910554	74.34434779501062	\N
104	ALUMINUM Scrap - 109.33kg - Quality Fair	Collected from industrial facilities. Ready for processing.	aluminum	3672	18	109.33	\N	ton	Fair	/uploads/products/product_424_1780236086342.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:26.649	2026-05-31 14:01:26.649	34.04874305072747	71.52229610149035	\N
105	STEEL Scrap - 33.87kg - Quality Good	Perfect for manufacturing and industrial use.	steel	1827	43	33.87	\N	ton	Good	/uploads/products/product_450_1780236086650.jpg	\N	t	ACTIVE	450	2026-05-31 14:01:26.956	2026-05-31 14:01:26.956	25.40628928767082	68.49247782035106	\N
106	GLASS Scrap - 29.56kg - Quality Good	Collected from industrial facilities. Ready for processing.	glass	4622	14	29.56	\N	kg	Good	/uploads/products/product_422_1780236086957.jpg	\N	t	ACTIVE	422	2026-05-31 14:01:27.196	2026-05-31 14:01:27.196	24.81227767246884	66.99199110021897	\N
107	METAL Scrap - 65.12kg - Quality Poor	Recently collected, excellent condition.	metal	1404	13	65.12	\N	bundle	Poor	/uploads/products/product_439_1780236087197.jpg	\N	t	ACTIVE	439	2026-05-31 14:01:27.436	2026-05-31 14:01:27.436	25.38186896288168	68.47090084265717	\N
108	ELECTRONICS Scrap - 61.76kg - Quality Fair	Perfect for manufacturing and industrial use.	electronics	4113	6	61.76	\N	piece	Fair	/uploads/products/product_425_1780236087437.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:27.677	2026-05-31 14:01:27.677	32.12512534970659	74.13956999505463	\N
109	CARDBOARD Scrap - 87.93kg - Quality Fair	Verified weight and quality.	cardboard	1475	52	87.93	\N	ton	Fair	/uploads/products/product_439_1780236087678.jpg	\N	t	ACTIVE	439	2026-05-31 14:01:27.917	2026-05-31 14:01:27.917	25.39085844243692	68.47003297899221	\N
110	BRASS Scrap - 83.17kg - Quality Poor	Bulk quantity available for bulk buyers.	brass	2606	12	83.17	\N	piece	Poor	/uploads/products/product_447_1780236087918.jpg	\N	t	ACTIVE	447	2026-05-31 14:01:28.157	2026-05-31 14:01:28.157	25.33060040381112	68.49182842199636	\N
111	STEEL Scrap - 85.37kg - Quality Fair	Verified weight and quality.	steel	4486	18	85.37	\N	ton	Fair	/uploads/products/product_419_1780236088158.jpg	\N	t	ACTIVE	419	2026-05-31 14:01:28.493	2026-05-31 14:01:28.493	31.57011943476446	74.33364639007503	\N
112	STEEL Scrap - 49.27kg - Quality Good	Bulk quantity available for bulk buyers.	steel	4446	10	49.27	\N	piece	Good	/uploads/products/product_443_1780236088493.jpg	\N	t	ACTIVE	443	2026-05-31 14:01:28.732	2026-05-31 14:01:28.732	30.20641376280015	67.00059117570235	\N
113	COMPOSITE Scrap - 64.11kg - Quality Poor	Recently collected, excellent condition.	composite	1647	16	64.11	\N	bundle	Poor	/uploads/products/product_420_1780236088733.jpg	\N	t	ACTIVE	420	2026-05-31 14:01:29.004	2026-05-31 14:01:29.004	24.88497004801236	66.96723413067187	\N
114	METAL Scrap - 97.93kg - Quality Good	High quality scrap material, ideal for recycling.	metal	3845	44	97.93	\N	kg	Good	/uploads/products/product_439_1780236089005.jpg	\N	t	ACTIVE	439	2026-05-31 14:01:29.311	2026-05-31 14:01:29.311	25.34538876253474	68.46631283780499	\N
115	GLASS Scrap - 49.66kg - Quality Good	Sorted and cleaned for easy handling.	glass	2997	48	49.66	\N	ton	Good	/uploads/products/product_452_1780236089312.jpg	\N	t	ACTIVE	452	2026-05-31 14:01:29.618	2026-05-31 14:01:29.618	31.54478719717157	74.35851246751808	\N
116	GLASS Scrap - 30.28kg - Quality Fair	Verified weight and quality.	glass	4270	27	30.28	\N	piece	Fair	/uploads/products/product_450_1780236089619.jpg	\N	t	ACTIVE	450	2026-05-31 14:01:29.858	2026-05-31 14:01:29.858	25.45297122133759	68.5343898436521	\N
117	STEEL Scrap - 45.88kg - Quality Poor	Sorted and cleaned for easy handling.	steel	4679	54	45.88	\N	bundle	Poor	/uploads/products/product_422_1780236089859.jpg	\N	t	ACTIVE	422	2026-05-31 14:01:30.131	2026-05-31 14:01:30.131	24.81497068895655	67.03170684480632	\N
118	GLASS Scrap - 69.44kg - Quality Fair	Collected from industrial facilities. Ready for processing.	glass	1108	40	69.44	\N	ton	Fair	/uploads/products/product_441_1780236090132.jpg	\N	t	ACTIVE	441	2026-05-31 14:01:30.419	2026-05-31 14:01:30.419	25.44587246403738	68.45104801631709	\N
119	COMPOSITE Scrap - 96.08kg - Quality Poor	Eco-friendly scrap collection.	composite	3760	34	96.08	\N	bag	Poor	/uploads/products/product_444_1780236090420.jpg	\N	t	ACTIVE	444	2026-05-31 14:01:30.745	2026-05-31 14:01:30.745	25.35275384562698	68.46743616965117	\N
120	WOOD Scrap - 48.37kg - Quality Fair	Collected from industrial facilities. Ready for processing.	wood	3148	54	48.37	\N	ton	Fair	/uploads/products/product_451_1780236090746.jpg	\N	t	ACTIVE	451	2026-05-31 14:01:30.986	2026-05-31 14:01:30.986	24.83127272485124	66.99871498207304	\N
121	METAL Scrap - 48.86kg - Quality Poor	Sorted and cleaned for easy handling.	metal	2545	52	48.86	\N	kg	Poor	/uploads/products/product_438_1780236090987.jpg	\N	t	ACTIVE	438	2026-05-31 14:01:31.257	2026-05-31 14:01:31.257	30.14061017091254	71.42781849158088	\N
122	LEATHER Scrap - 13.34kg - Quality Good	Bulk quantity available for bulk buyers.	leather	427	49	13.34	\N	piece	Good	/uploads/products/product_419_1780236091258.jpg	\N	t	ACTIVE	419	2026-05-31 14:01:31.564	2026-05-31 14:01:31.564	31.56269650226302	74.33078974541762	\N
123	COPPER Scrap - 84.07kg - Quality Good	Perfect for manufacturing and industrial use.	copper	1509	53	84.07	\N	bag	Good	/uploads/products/product_424_1780236091565.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:31.871	2026-05-31 14:01:31.871	34.04147007322226	71.52925126224918	\N
124	COPPER Scrap - 92.63kg - Quality Good	Recently collected, excellent condition.	copper	4781	30	92.63	\N	kg	Good	/uploads/products/product_426_1780236091872.jpg	\N	t	ACTIVE	426	2026-05-31 14:01:32.111	2026-05-31 14:01:32.111	32.11212807475935	74.15129406224541	\N
125	GLASS Scrap - 30.50kg - Quality Good	Sorted and cleaned for easy handling.	glass	438	21	30.5	\N	bag	Good	/uploads/products/product_447_1780236092112.jpg	\N	t	ACTIVE	447	2026-05-31 14:01:32.382	2026-05-31 14:01:32.382	25.36007158966456	68.50348466115923	\N
126	STEEL Scrap - 76.52kg - Quality Good	Eco-friendly scrap collection.	steel	2580	16	76.52	\N	kg	Good	/uploads/products/product_442_1780236092383.jpg	\N	t	ACTIVE	442	2026-05-31 14:01:32.623	2026-05-31 14:01:32.623	25.36692083332747	68.44548104319239	\N
127	BRASS Scrap - 63.91kg - Quality Fair	Collected from industrial facilities. Ready for processing.	brass	1199	33	63.91	\N	bag	Fair	/uploads/products/product_425_1780236092624.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:32.863	2026-05-31 14:01:32.863	32.1225022090229	74.13003341500081	\N
128	COMPOSITE Scrap - 16.01kg - Quality Fair	High quality scrap material, ideal for recycling.	composite	2320	9	16.01	\N	ton	Fair	/uploads/products/product_419_1780236092864.jpg	\N	t	ACTIVE	419	2026-05-31 14:01:33.104	2026-05-31 14:01:33.104	31.56125038802709	74.32046295777316	\N
129	STEEL Scrap - 77.45kg - Quality Good	Eco-friendly scrap collection.	steel	1476	36	77.45	\N	piece	Good	/uploads/products/product_409_1780236093105.jpg	\N	t	ACTIVE	409	2026-05-31 14:01:33.408	2026-05-31 14:01:33.408	24.83570117957122	66.93728317684828	\N
130	LEATHER Scrap - 66.34kg - Quality Good	Recently collected, excellent condition.	leather	4208	48	66.34	\N	bag	Good	/uploads/products/product_441_1780236093411.jpg	\N	t	ACTIVE	441	2026-05-31 14:01:33.714	2026-05-31 14:01:33.714	25.4587813747442	68.45228134442456	\N
131	ALUMINUM Scrap - 17.04kg - Quality Fair	Sorted and cleaned for easy handling.	aluminum	3127	44	17.04	\N	kg	Fair	/uploads/products/product_440_1780236093715.jpg	\N	t	ACTIVE	440	2026-05-31 14:01:34.004	2026-05-31 14:01:34.004	25.36738538731382	68.50619448968922	\N
132	CARDBOARD Scrap - 34.83kg - Quality Fair	Perfect for manufacturing and industrial use.	cardboard	395	23	34.83	\N	bundle	Fair	/uploads/products/product_417_1780236094005.jpg	\N	t	ACTIVE	417	2026-05-31 14:01:34.329	2026-05-31 14:01:34.329	34.05802022650183	71.55151856793407	\N
133	METAL Scrap - 38.43kg - Quality Poor	Sorted and cleaned for easy handling.	metal	1399	51	38.43	\N	ton	Poor	/uploads/products/product_449_1780236094329.jpg	\N	t	ACTIVE	449	2026-05-31 14:01:34.636	2026-05-31 14:01:34.636	32.20351052480151	74.22533747916711	\N
134	PLASTIC Scrap - 18.38kg - Quality Good	Perfect for manufacturing and industrial use.	plastic	3760	40	18.38	\N	bag	Good	/uploads/products/product_424_1780236094637.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:34.944	2026-05-31 14:01:34.944	34.04965924783485	71.52357995153415	\N
135	COPPER Scrap - 20.03kg - Quality Good	Collected from industrial facilities. Ready for processing.	copper	493	45	20.03	\N	bag	Good	/uploads/products/product_443_1780236094944.jpg	\N	t	ACTIVE	443	2026-05-31 14:01:35.763	2026-05-31 14:01:35.763	30.23513326417445	67.02302239028658	\N
136	RUBBER Scrap - 70.67kg - Quality Good	Bulk quantity available for bulk buyers.	rubber	4889	41	70.67	\N	ton	Good	/uploads/products/product_441_1780236095764.jpg	\N	t	ACTIVE	441	2026-05-31 14:01:36.069	2026-05-31 14:01:36.069	25.44732830305914	68.47695923223434	\N
137	STEEL Scrap - 96.91kg - Quality Good	Collected from industrial facilities. Ready for processing.	steel	2635	7	96.91	\N	kg	Good	/uploads/products/product_441_1780236096070.jpg	\N	t	ACTIVE	441	2026-05-31 14:01:36.377	2026-05-31 14:01:36.377	25.42778848423435	68.49158840796144	\N
138	METAL Scrap - 102.31kg - Quality Fair	Sorted and cleaned for easy handling.	metal	2927	34	102.31	\N	bag	Fair	/uploads/products/product_450_1780236096377.jpg	\N	t	ACTIVE	450	2026-05-31 14:01:36.684	2026-05-31 14:01:36.684	25.40908392846879	68.51802601434758	\N
139	BRASS Scrap - 93.84kg - Quality Good	Bulk quantity available for bulk buyers.	brass	3761	29	93.84	\N	ton	Good	/uploads/products/product_424_1780236096685.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:36.991	2026-05-31 14:01:36.991	34.02946791962207	71.53609646248199	\N
140	COPPER Scrap - 29.04kg - Quality Fair	Recently collected, excellent condition.	copper	4437	33	29.04	\N	piece	Fair	/uploads/products/product_449_1780236096992.jpg	\N	t	ACTIVE	449	2026-05-31 14:01:37.298	2026-05-31 14:01:37.298	32.18289048012246	74.22207986272144	\N
141	TEXTILE Scrap - 73.90kg - Quality Fair	Collected from industrial facilities. Ready for processing.	textile	418	24	73.9	\N	kg	Fair	/uploads/products/product_408_1780236097299.jpg	\N	t	ACTIVE	408	2026-05-31 14:01:37.587	2026-05-31 14:01:37.587	34.07687447234536	71.50977354101431	\N
142	ALUMINUM Scrap - 35.91kg - Quality Poor	Bulk quantity available for bulk buyers.	aluminum	4714	39	35.91	\N	piece	Poor	/uploads/products/product_425_1780236097588.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:37.912	2026-05-31 14:01:37.912	32.136821187719	74.13384869066543	\N
143	COMPOSITE Scrap - 68.89kg - Quality Fair	Bulk quantity available for bulk buyers.	composite	4829	5	68.89	\N	ton	Fair	/uploads/products/product_421_1780236097914.jpg	\N	t	ACTIVE	421	2026-05-31 14:01:38.22	2026-05-31 14:01:38.22	24.88620370891367	67.03366774939964	\N
144	TEXTILE Scrap - 15.69kg - Quality Fair	Recently collected, excellent condition.	textile	4855	19	15.69	\N	ton	Fair	/uploads/products/product_445_1780236098221.jpg	\N	t	ACTIVE	445	2026-05-31 14:01:38.527	2026-05-31 14:01:38.527	34.02303300511735	71.56639845055425	\N
145	GLASS Scrap - 58.01kg - Quality Fair	Bulk quantity available for bulk buyers.	glass	644	10	58.01	\N	bundle	Fair	/uploads/products/product_421_1780236098528.jpg	\N	t	ACTIVE	421	2026-05-31 14:01:38.768	2026-05-31 14:01:38.768	24.86657817724725	67.03148992264303	\N
146	BRASS Scrap - 55.84kg - Quality Fair	Sorted and cleaned for easy handling.	brass	4861	5	55.84	\N	piece	Fair	/uploads/products/product_451_1780236098768.jpg	\N	t	ACTIVE	451	2026-05-31 14:01:39.039	2026-05-31 14:01:39.039	24.83802179798318	67.0126354524938	\N
147	FOAM Scrap - 100.53kg - Quality Poor	Sorted and cleaned for easy handling.	foam	1425	40	100.53	\N	kg	Poor	/uploads/products/product_440_1780236099040.jpg	\N	t	ACTIVE	440	2026-05-31 14:01:39.346	2026-05-31 14:01:39.346	25.37212291242413	68.50205749151729	\N
148	BRASS Scrap - 67.34kg - Quality Poor	Verified weight and quality.	brass	2328	29	67.34	\N	kg	Poor	/uploads/products/product_419_1780236099347.jpg	\N	t	ACTIVE	419	2026-05-31 14:01:39.636	2026-05-31 14:01:39.636	31.5311870678654	74.34044230321943	\N
149	STEEL Scrap - 70.98kg - Quality Poor	High quality scrap material, ideal for recycling.	steel	3987	25	70.98	\N	piece	Poor	/uploads/products/product_412_1780236099637.jpg	\N	t	ACTIVE	412	2026-05-31 14:01:39.876	2026-05-31 14:01:39.876	31.45396927844916	72.37262392031744	\N
150	METAL Scrap - 47.80kg - Quality Good	Eco-friendly scrap collection.	metal	3716	6	47.8	\N	piece	Good	/uploads/products/product_414_1780236099877.jpg	\N	t	ACTIVE	414	2026-05-31 14:01:40.166	2026-05-31 14:01:40.166	33.5534966297847	73.23874055898143	\N
151	ELECTRONICS Scrap - 35.24kg - Quality Good	Collected from industrial facilities. Ready for processing.	electronics	4738	10	35.24	\N	kg	Good	/uploads/products/product_447_1780236100166.jpg	\N	t	ACTIVE	447	2026-05-31 14:01:40.473	2026-05-31 14:01:40.473	25.35399438468986	68.49257616321708	\N
152	TEXTILE Scrap - 107.00kg - Quality Fair	Collected from industrial facilities. Ready for processing.	textile	4437	42	107	\N	bag	Fair	/uploads/products/product_412_1780236100474.jpg	\N	t	ACTIVE	412	2026-05-31 14:01:40.78	2026-05-31 14:01:40.78	31.4513709871283	72.40106049217903	\N
153	CARDBOARD Scrap - 47.57kg - Quality Poor	High quality scrap material, ideal for recycling.	cardboard	2335	25	47.57	\N	ton	Poor	/uploads/products/product_449_1780236100781.jpg	\N	t	ACTIVE	449	2026-05-31 14:01:41.087	2026-05-31 14:01:41.087	32.20269448327964	74.19752300295869	\N
154	METAL Scrap - 64.29kg - Quality Good	High quality scrap material, ideal for recycling.	metal	484	54	64.29	\N	piece	Good	/uploads/products/product_425_1780236101088.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:41.395	2026-05-31 14:01:41.395	32.09465672070894	74.14822470775685	\N
155	FOAM Scrap - 70.19kg - Quality Fair	High quality scrap material, ideal for recycling.	foam	3076	38	70.19	\N	bag	Fair	/uploads/products/product_414_1780236101395.jpg	\N	t	ACTIVE	414	2026-05-31 14:01:41.702	2026-05-31 14:01:41.702	33.53562620754856	73.24443443054528	\N
156	ALUMINUM Scrap - 97.98kg - Quality Fair	High quality scrap material, ideal for recycling.	aluminum	3119	7	97.98	\N	ton	Fair	/uploads/products/product_417_1780236101703.jpg	\N	t	ACTIVE	417	2026-05-31 14:01:42.008	2026-05-31 14:01:42.008	34.06059805537431	71.54714685165288	\N
157	CARDBOARD Scrap - 33.30kg - Quality Good	Verified weight and quality.	cardboard	847	11	33.3	\N	piece	Good	/uploads/products/product_416_1780236102010.jpg	\N	t	ACTIVE	416	2026-05-31 14:01:42.249	2026-05-31 14:01:42.249	31.36075849870241	72.356823852009	\N
158	PLASTIC Scrap - 25.08kg - Quality Fair	Sorted and cleaned for easy handling.	plastic	2801	50	25.08	\N	piece	Fair	/uploads/products/product_416_1780236102250.jpg	\N	t	ACTIVE	416	2026-05-31 14:01:42.521	2026-05-31 14:01:42.521	31.38307225649371	72.38580341335675	\N
159	RUBBER Scrap - 43.51kg - Quality Fair	Collected from industrial facilities. Ready for processing.	rubber	4563	16	43.51	\N	bag	Fair	/uploads/products/product_425_1780236102522.jpg	\N	t	ACTIVE	425	2026-05-31 14:01:42.828	2026-05-31 14:01:42.828	32.11814307118852	74.15663103230384	\N
160	ALUMINUM Scrap - 101.02kg - Quality Poor	Recently collected, excellent condition.	aluminum	3712	31	101.02	\N	kg	Poor	/uploads/products/product_415_1780236102829.jpg	\N	t	ACTIVE	415	2026-05-31 14:01:43.135	2026-05-31 14:01:43.135	30.1524534743689	67.0496847893295	\N
161	PLASTIC Scrap - 93.28kg - Quality Good	Perfect for manufacturing and industrial use.	plastic	1754	44	93.28	\N	piece	Good	/uploads/products/product_448_1780236103137.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:43.443	2026-05-31 14:01:43.443	33.57288180388278	73.19236785634583	\N
162	GLASS Scrap - 33.94kg - Quality Good	Collected from industrial facilities. Ready for processing.	glass	4982	38	33.94	\N	bag	Good	/uploads/products/product_411_1780236103443.jpg	\N	t	ACTIVE	411	2026-05-31 14:01:43.732	2026-05-31 14:01:43.732	31.45246317232509	72.36227563096104	\N
163	CARDBOARD Scrap - 72.95kg - Quality Poor	Collected from industrial facilities. Ready for processing.	cardboard	4571	27	72.95	\N	bag	Poor	/uploads/products/product_412_1780236103733.jpg	\N	t	ACTIVE	412	2026-05-31 14:01:44.057	2026-05-31 14:01:44.057	31.45032378170544	72.39946383277913	\N
164	FOAM Scrap - 79.67kg - Quality Good	Bulk quantity available for bulk buyers.	foam	524	46	79.67	\N	kg	Good	/uploads/products/product_424_1780236104057.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:44.297	2026-05-31 14:01:44.297	34.05717195176173	71.52957933974002	\N
165	PAPER Scrap - 55.96kg - Quality Poor	Collected from industrial facilities. Ready for processing.	paper	3516	23	55.96	\N	bundle	Poor	/uploads/products/product_410_1780236104298.jpg	\N	t	ACTIVE	410	2026-05-31 14:01:45.081	2026-05-31 14:01:45.081	25.42799277001899	68.43648852354099	\N
166	WOOD Scrap - 86.40kg - Quality Poor	Collected from industrial facilities. Ready for processing.	wood	718	5	86.4	\N	piece	Poor	/uploads/products/product_448_1780236105082.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:45.321	2026-05-31 14:01:45.321	33.5963999996659	73.20784776584817	\N
167	BRASS Scrap - 72.11kg - Quality Good	Verified weight and quality.	brass	4495	23	72.11	\N	bag	Good	/uploads/products/product_451_1780236105322.jpg	\N	t	ACTIVE	451	2026-05-31 14:01:45.593	2026-05-31 14:01:45.593	24.81725871219319	67.00864390769398	\N
168	PLASTIC Scrap - 23.80kg - Quality Poor	Bulk quantity available for bulk buyers.	plastic	1115	31	23.8	\N	kg	Poor	/uploads/products/product_450_1780236105594.jpg	\N	t	ACTIVE	450	2026-05-31 14:01:45.833	2026-05-31 14:01:45.833	25.40592754910857	68.52573936774915	\N
169	TEXTILE Scrap - 66.96kg - Quality Fair	Bulk quantity available for bulk buyers.	textile	2847	13	66.96	\N	bag	Fair	/uploads/products/product_424_1780236105834.jpg	\N	t	ACTIVE	424	2026-05-31 14:01:46.105	2026-05-31 14:01:46.105	34.06945115435316	71.53424569869814	\N
170	BRASS Scrap - 78.07kg - Quality Fair	Collected from industrial facilities. Ready for processing.	brass	4506	15	78.07	\N	ton	Fair	/uploads/products/product_414_1780236106106.jpg	\N	t	ACTIVE	414	2026-05-31 14:01:46.344	2026-05-31 14:01:46.344	33.55795292727233	73.23998310104308	\N
171	METAL Scrap - 91.86kg - Quality Poor	Recently collected, excellent condition.	metal	1832	32	91.86	\N	ton	Poor	/uploads/products/product_441_1780236106345.jpg	\N	t	ACTIVE	441	2026-05-31 14:01:46.616	2026-05-31 14:01:46.616	25.45648005332922	68.4713524190975	\N
172	TEXTILE Scrap - 58.43kg - Quality Poor	Collected from industrial facilities. Ready for processing.	textile	4999	14	58.43	\N	ton	Poor	/uploads/products/product_443_1780236106617.jpg	\N	t	ACTIVE	443	2026-05-31 14:01:46.857	2026-05-31 14:01:46.857	30.24107650325002	66.99504793301212	\N
173	WOOD Scrap - 51.69kg - Quality Poor	Perfect for manufacturing and industrial use.	wood	1730	27	51.69	\N	kg	Poor	/uploads/products/product_443_1780236106857.jpg	\N	t	ACTIVE	443	2026-05-31 14:01:47.128	2026-05-31 14:01:47.128	30.20404192299934	67.03762922843238	\N
174	PLASTIC Scrap - 21.87kg - Quality Fair	Sorted and cleaned for easy handling.	plastic	3784	44	21.87	\N	kg	Fair	/uploads/products/product_448_1780236107129.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:47.369	2026-05-31 14:01:47.369	33.59000881216529	73.22093095722688	\N
175	GLASS Scrap - 85.02kg - Quality Good	Recently collected, excellent condition.	glass	3706	13	85.02	\N	piece	Good	/uploads/products/product_420_1780236107369.jpg	\N	t	ACTIVE	420	2026-05-31 14:01:47.641	2026-05-31 14:01:47.641	24.85353710785296	66.991868428463	\N
176	ELECTRONICS Scrap - 11.73kg - Quality Good	Sorted and cleaned for easy handling.	electronics	3895	43	11.73	\N	piece	Good	/uploads/products/product_416_1780236107642.jpg	\N	t	ACTIVE	416	2026-05-31 14:01:47.948	2026-05-31 14:01:47.948	31.3778335083577	72.38144919115338	\N
177	COMPOSITE Scrap - 52.81kg - Quality Fair	Sorted and cleaned for easy handling.	composite	3445	29	52.81	\N	kg	Fair	/uploads/products/product_420_1780236107949.jpg	\N	t	ACTIVE	420	2026-05-31 14:01:48.255	2026-05-31 14:01:48.255	24.84290041582626	66.97096452763253	\N
178	LEATHER Scrap - 18.94kg - Quality Poor	Collected from industrial facilities. Ready for processing.	leather	4799	8	18.94	\N	piece	Poor	/uploads/products/product_411_1780236108256.jpg	\N	t	ACTIVE	411	2026-05-31 14:01:48.495	2026-05-31 14:01:48.495	31.42721416840016	72.37058102842866	\N
179	COPPER Scrap - 96.46kg - Quality Poor	Verified weight and quality.	copper	1157	43	96.46	\N	kg	Poor	/uploads/products/product_416_1780236108496.jpg	\N	t	ACTIVE	416	2026-05-31 14:01:48.767	2026-05-31 14:01:48.767	31.37936274388005	72.382912025841	\N
180	RUBBER Scrap - 41.94kg - Quality Fair	Bulk quantity available for bulk buyers.	rubber	1429	18	41.94	\N	ton	Fair	/uploads/products/product_411_1780236108768.jpg	\N	t	ACTIVE	411	2026-05-31 14:01:49.075	2026-05-31 14:01:49.075	31.45053522644557	72.37747840676221	\N
181	FOAM Scrap - 105.79kg - Quality Fair	High quality scrap material, ideal for recycling.	foam	2822	25	105.79	\N	ton	Fair	/uploads/products/product_410_1780236109075.jpg	\N	t	ACTIVE	410	2026-05-31 14:01:49.364	2026-05-31 14:01:49.364	25.43434767295777	68.45054885794448	\N
182	STEEL Scrap - 101.55kg - Quality Good	Collected from industrial facilities. Ready for processing.	steel	3155	26	101.55	\N	bag	Good	/uploads/products/product_423_1780236109365.jpg	\N	t	ACTIVE	423	2026-05-31 14:01:49.604	2026-05-31 14:01:49.604	31.41152585646997	72.37688817053049	\N
183	STEEL Scrap - 50.72kg - Quality Poor	Verified weight and quality.	steel	270	36	50.72	\N	piece	Poor	/uploads/products/product_419_1780236109605.jpg	\N	t	ACTIVE	419	2026-05-31 14:01:49.844	2026-05-31 14:01:49.844	31.53922356387633	74.3109958862576	\N
184	CARDBOARD Scrap - 59.85kg - Quality Fair	Bulk quantity available for bulk buyers.	cardboard	4614	32	59.85	\N	bag	Fair	/uploads/products/product_427_1780236109845.jpg	\N	t	ACTIVE	427	2026-05-31 14:01:50.098	2026-05-31 14:01:50.098	34.00576817557794	71.53508850317583	\N
185	ELECTRONICS Scrap - 52.18kg - Quality Fair	Sorted and cleaned for easy handling.	electronics	2999	50	52.18	\N	bundle	Fair	/uploads/products/product_417_1780236110099.jpg	\N	t	ACTIVE	417	2026-05-31 14:01:50.406	2026-05-31 14:01:50.406	34.06155142367484	71.55138158739038	\N
217	COMPOSITE Scrap - 44.07kg - Quality Poor	Verified weight and quality.	composite	4086	5	44.07	\N	bundle	Poor	/uploads/products/product_458_1780236216779.jpg	\N	t	ACTIVE	458	2026-05-31 14:03:37.02	2026-05-31 14:03:37.02	32.11477577005378	74.14887162526463	\N
186	PLASTIC Scrap - 87.77kg - Quality Good	Perfect for manufacturing and industrial use.	plastic	4928	5	87.77	\N	ton	Good	/uploads/products/product_448_1780236110407.jpg	\N	t	ACTIVE	448	2026-05-31 14:01:50.646	2026-05-31 14:01:50.646	33.61497376855934	73.22707551804353	\N
187	ALUMINUM Scrap - 80.53kg - Quality Poor	High quality scrap material, ideal for recycling.	aluminum	3755	25	80.53	\N	ton	Poor	/uploads/products/product_422_1780236110647.jpg	\N	t	ACTIVE	422	2026-05-31 14:01:50.886	2026-05-31 14:01:50.886	24.82805693780335	67.00865291347783	\N
188	METAL Scrap - 90.05kg - Quality Fair	Recently collected, excellent condition.	metal	3407	29	90.05	\N	piece	Fair	/uploads/products/product_451_1780236110887.jpg	\N	t	ACTIVE	451	2026-05-31 14:01:51.225	2026-05-31 14:01:51.225	24.85704328595392	67.0210223121257	\N
189	BRASS Scrap - 40.26kg - Quality Fair	High quality scrap material, ideal for recycling.	brass	1384	49	40.26	\N	kg	Fair	/uploads/products/product_427_1780236111226.jpg	\N	t	ACTIVE	427	2026-05-31 14:01:51.532	2026-05-31 14:01:51.532	34.00476152879062	71.50825214866774	\N
190	GLASS Scrap - 90.75kg - Quality Poor	Recently collected, excellent condition.	glass	2341	13	90.75	\N	bag	Poor	/uploads/products/product_422_1780236111533.jpg	\N	t	ACTIVE	422	2026-05-31 14:01:51.82	2026-05-31 14:01:51.82	24.84602190435482	66.9882916712802	\N
191	COPPER Scrap - 100.44kg - Quality Fair	Recently collected, excellent condition.	copper	2040	28	100.44	\N	kg	Fair	/uploads/products/product_452_1780236111821.jpg	\N	t	ACTIVE	452	2026-05-31 14:01:52.147	2026-05-31 14:01:52.147	31.54295548696649	74.34651394496603	\N
192	STEEL Scrap - 78.42kg - Quality Poor	Collected from industrial facilities. Ready for processing.	steel	2985	31	78.42	\N	piece	Poor	/uploads/products/product_414_1780236112147.jpg	\N	t	ACTIVE	414	2026-05-31 14:01:52.454	2026-05-31 14:01:52.454	33.54088698501261	73.21982277692068	\N
193	BRASS Scrap - 28.13kg - Quality Poor	Eco-friendly scrap collection.	brass	4341	7	28.13	\N	ton	Poor	/uploads/products/product_418_1780236112455.jpg	\N	t	ACTIVE	418	2026-05-31 14:01:52.761	2026-05-31 14:01:52.761	33.62611661909236	73.02521824093637	\N
194	TEXTILE Scrap - 11.04kg - Quality Good	Recently collected, excellent condition.	textile	4178	54	11.04	\N	ton	Good	/uploads/products/product_451_1780236112762.jpg	\N	t	ACTIVE	451	2026-05-31 14:01:53.001	2026-05-31 14:01:53.001	24.83370424178971	67.02325051807263	\N
195	COMPOSITE Scrap - 61.93kg - Quality Good	Recently collected, excellent condition.	composite	1445	28	61.93	\N	piece	Good	/uploads/products/product_447_1780236113002.jpg	\N	t	ACTIVE	447	2026-05-31 14:01:53.273	2026-05-31 14:01:53.273	25.33950252788964	68.51181769668122	\N
196	PAPER Scrap - 54.13kg - Quality Poor	Eco-friendly scrap collection.	paper	3799	54	54.13	\N	piece	Poor	/uploads/products/product_442_1780236113274.jpg	\N	t	ACTIVE	442	2026-05-31 14:01:53.58	2026-05-31 14:01:53.58	25.37659830473769	68.45644011960053	\N
197	BRASS Scrap - 52.91kg - Quality Fair	High quality scrap material, ideal for recycling.	brass	3255	39	52.91	\N	ton	Fair	/uploads/products/product_423_1780236113581.jpg	\N	t	ACTIVE	423	2026-05-31 14:01:53.887	2026-05-31 14:01:53.887	31.45465911502658	72.3494324866837	\N
198	BRASS Scrap - 103.97kg - Quality Poor	Bulk quantity available for bulk buyers.	brass	1465	22	103.97	\N	ton	Poor	/uploads/products/product_409_1780236113888.jpg	\N	t	ACTIVE	409	2026-05-31 14:01:54.195	2026-05-31 14:01:54.195	24.84907375833083	66.93833838550873	\N
199	RUBBER Scrap - 35.69kg - Quality Fair	Bulk quantity available for bulk buyers.	rubber	1973	33	35.69	\N	bundle	Fair	/uploads/products/product_413_1780236114196.jpg	\N	t	ACTIVE	413	2026-05-31 14:01:54.502	2026-05-31 14:01:54.502	34.0386552051772	71.57285247478735	\N
200	ELECTRONICS Scrap - 82.91kg - Quality Good	Sorted and cleaned for easy handling.	electronics	447	15	82.91	\N	bag	Good	/uploads/products/product_446_1780236114503.jpg	\N	t	ACTIVE	446	2026-05-31 14:01:54.809	2026-05-31 14:01:54.809	30.15633389346723	71.43944231128724	\N
201	CARDBOARD Scrap - 39.62kg - Quality Poor	Perfect for manufacturing and industrial use.	cardboard	1822	23	39.62	\N	bundle	Poor	/uploads/products/product_496_1780236211683.jpg	\N	t	ACTIVE	496	2026-05-31 14:03:32.886	2026-05-31 14:03:32.886	33.99999859324942	71.47613230115081	\N
202	RUBBER Scrap - 56.24kg - Quality Fair	Collected from industrial facilities. Ready for processing.	rubber	1240	20	56.24	\N	bundle	Fair	/uploads/products/product_456_1780236212888.jpg	\N	t	ACTIVE	456	2026-05-31 14:03:33.13	2026-05-31 14:03:33.13	32.19670431053238	74.18012005784865	\N
203	TEXTILE Scrap - 93.67kg - Quality Fair	Eco-friendly scrap collection.	textile	3664	39	93.67	\N	piece	Fair	/uploads/products/product_463_1780236213136.jpg	\N	t	ACTIVE	463	2026-05-31 14:03:33.378	2026-05-31 14:03:33.378	25.41731753734938	68.42524285248597	\N
204	ELECTRONICS Scrap - 101.84kg - Quality Fair	Sorted and cleaned for easy handling.	electronics	3829	15	101.84	\N	ton	Fair	/uploads/products/product_490_1780236213379.jpg	\N	t	ACTIVE	490	2026-05-31 14:03:33.627	2026-05-31 14:03:33.627	31.61747841798608	74.3237513733592	\N
205	STEEL Scrap - 74.12kg - Quality Fair	Collected from industrial facilities. Ready for processing.	steel	2362	47	74.12	\N	kg	Fair	/uploads/products/product_456_1780236213627.jpg	\N	t	ACTIVE	456	2026-05-31 14:03:33.869	2026-05-31 14:03:33.869	32.18892856761016	74.19194847614673	\N
206	ALUMINUM Scrap - 77.23kg - Quality Good	High quality scrap material, ideal for recycling.	aluminum	505	39	77.23	\N	piece	Good	/uploads/products/product_457_1780236213869.jpg	\N	t	ACTIVE	457	2026-05-31 14:03:34.139	2026-05-31 14:03:34.139	24.8609329109738	66.98885199292376	\N
207	GLASS Scrap - 101.46kg - Quality Good	Sorted and cleaned for easy handling.	glass	414	27	101.46	\N	piece	Good	/uploads/products/product_487_1780236214140.jpg	\N	t	ACTIVE	487	2026-05-31 14:03:34.446	2026-05-31 14:03:34.446	33.98507326225889	71.46699746509898	\N
208	STEEL Scrap - 11.84kg - Quality Poor	Collected from industrial facilities. Ready for processing.	steel	659	29	11.84	\N	bundle	Poor	/uploads/products/product_456_1780236214447.jpg	\N	t	ACTIVE	456	2026-05-31 14:03:34.688	2026-05-31 14:03:34.688	32.17700815745113	74.14732643099741	\N
209	WOOD Scrap - 59.87kg - Quality Fair	Recently collected, excellent condition.	wood	561	16	59.87	\N	ton	Fair	/uploads/products/product_492_1780236214689.jpg	\N	t	ACTIVE	492	2026-05-31 14:03:34.93	2026-05-31 14:03:34.93	30.18542519715693	67.05235189834734	\N
210	COMPOSITE Scrap - 107.01kg - Quality Poor	Verified weight and quality.	composite	411	5	107.01	\N	kg	Poor	/uploads/products/product_471_1780236214931.jpg	\N	t	ACTIVE	471	2026-05-31 14:03:35.172	2026-05-31 14:03:35.172	31.45808132417514	72.35556840878841	\N
211	BRASS Scrap - 66.39kg - Quality Good	Perfect for manufacturing and industrial use.	brass	3101	22	66.39	\N	bundle	Good	/uploads/products/product_468_1780236215173.jpg	\N	t	ACTIVE	468	2026-05-31 14:03:35.415	2026-05-31 14:03:35.415	33.66067930528246	73.08845445291757	\N
212	CARDBOARD Scrap - 21.12kg - Quality Fair	Eco-friendly scrap collection.	cardboard	989	48	21.12	\N	bundle	Fair	/uploads/products/product_459_1780236215416.jpg	\N	t	ACTIVE	459	2026-05-31 14:03:35.675	2026-05-31 14:03:35.675	31.40854539454498	72.33462867225296	\N
213	ELECTRONICS Scrap - 15.09kg - Quality Good	High quality scrap material, ideal for recycling.	electronics	4887	28	15.09	\N	ton	Good	/uploads/products/product_491_1780236215675.jpg	\N	t	ACTIVE	491	2026-05-31 14:03:35.982	2026-05-31 14:03:35.982	25.37303890470185	68.41503515336352	\N
214	ALUMINUM Scrap - 82.32kg - Quality Poor	Eco-friendly scrap collection.	aluminum	711	34	82.32	\N	bag	Poor	/uploads/products/product_486_1780236215982.jpg	\N	t	ACTIVE	486	2026-05-31 14:03:36.29	2026-05-31 14:03:36.29	31.37805959425107	72.31213878803969	\N
215	FOAM Scrap - 59.31kg - Quality Fair	Collected from industrial facilities. Ready for processing.	foam	2247	24	59.31	\N	piece	Fair	/uploads/products/product_492_1780236216291.jpg	\N	t	ACTIVE	492	2026-05-31 14:03:36.533	2026-05-31 14:03:36.533	30.19231512415362	67.05772900836232	\N
216	BRASS Scrap - 74.69kg - Quality Poor	Collected from industrial facilities. Ready for processing.	brass	2480	21	74.69	\N	bag	Poor	/uploads/products/product_489_1780236216534.jpg	\N	t	ACTIVE	489	2026-05-31 14:03:36.778	2026-05-31 14:03:36.778	24.87751188374407	66.98600808551866	\N
218	RUBBER Scrap - 50.97kg - Quality Poor	Collected from industrial facilities. Ready for processing.	rubber	972	46	50.97	\N	kg	Poor	/uploads/products/product_463_1780236217021.jpg	\N	t	ACTIVE	463	2026-05-31 14:03:37.262	2026-05-31 14:03:37.262	25.38491300959188	68.43003040800642	\N
219	COMPOSITE Scrap - 51.73kg - Quality Poor	Perfect for manufacturing and industrial use.	composite	4444	24	51.73	\N	piece	Poor	/uploads/products/product_495_1780236217263.jpg	\N	t	ACTIVE	495	2026-05-31 14:03:37.518	2026-05-31 14:03:37.518	25.37768967832929	68.48201386636416	\N
220	ALUMINUM Scrap - 81.04kg - Quality Good	Eco-friendly scrap collection.	aluminum	5013	28	81.04	\N	kg	Good	/uploads/products/product_497_1780236217519.jpg	\N	t	ACTIVE	497	2026-05-31 14:03:37.825	2026-05-31 14:03:37.825	32.2014665323553	74.1729226309904	\N
221	FOAM Scrap - 106.77kg - Quality Poor	Eco-friendly scrap collection.	foam	2539	52	106.77	\N	bag	Poor	/uploads/products/product_470_1780236217826.jpg	\N	t	ACTIVE	470	2026-05-31 14:03:38.067	2026-05-31 14:03:38.067	25.45192292866279	68.44421569220097	\N
222	PLASTIC Scrap - 105.97kg - Quality Good	Bulk quantity available for bulk buyers.	plastic	636	28	105.97	\N	bundle	Good	/uploads/products/product_483_1780236218068.jpg	\N	t	ACTIVE	483	2026-05-31 14:03:38.31	2026-05-31 14:03:38.31	33.60210609977893	73.1809337052528	\N
223	COPPER Scrap - 89.55kg - Quality Poor	Recently collected, excellent condition.	copper	2932	17	89.55	\N	kg	Poor	/uploads/products/product_455_1780236218311.jpg	\N	t	ACTIVE	455	2026-05-31 14:03:38.552	2026-05-31 14:03:38.552	33.6190293080415	73.1360176140075	\N
224	CARDBOARD Scrap - 96.59kg - Quality Fair	Recently collected, excellent condition.	cardboard	4150	40	96.59	\N	ton	Fair	/uploads/products/product_496_1780236218553.jpg	\N	t	ACTIVE	496	2026-05-31 14:03:38.849	2026-05-31 14:03:38.849	33.97743219987488	71.47950650907062	\N
225	PAPER Scrap - 16.44kg - Quality Fair	Bulk quantity available for bulk buyers.	paper	4260	49	16.44	\N	kg	Fair	/uploads/products/product_495_1780236218850.jpg	\N	t	ACTIVE	495	2026-05-31 14:03:39.156	2026-05-31 14:03:39.156	25.40750892339689	68.47196955774281	\N
226	CARDBOARD Scrap - 79.28kg - Quality Good	Verified weight and quality.	cardboard	593	17	79.28	\N	ton	Good	/uploads/products/product_458_1780236219157.jpg	\N	t	ACTIVE	458	2026-05-31 14:03:39.464	2026-05-31 14:03:39.464	32.11598032041688	74.12488998476891	\N
227	METAL Scrap - 103.69kg - Quality Fair	Bulk quantity available for bulk buyers.	metal	193	45	103.69	\N	piece	Fair	/uploads/products/product_471_1780236219464.jpg	\N	t	ACTIVE	471	2026-05-31 14:03:39.771	2026-05-31 14:03:39.771	31.4406385824572	72.35603783715302	\N
228	WOOD Scrap - 95.67kg - Quality Fair	Bulk quantity available for bulk buyers.	wood	645	30	95.67	\N	bundle	Fair	/uploads/products/product_468_1780236219772.jpg	\N	t	ACTIVE	468	2026-05-31 14:03:40.078	2026-05-31 14:03:40.078	33.65278342741068	73.08241700749667	\N
229	ELECTRONICS Scrap - 68.76kg - Quality Fair	Bulk quantity available for bulk buyers.	electronics	3568	46	68.76	\N	piece	Fair	/uploads/products/product_468_1780236220079.jpg	\N	t	ACTIVE	468	2026-05-31 14:03:40.385	2026-05-31 14:03:40.385	33.64370586728086	73.08854148152095	\N
230	WOOD Scrap - 88.68kg - Quality Fair	Eco-friendly scrap collection.	wood	2229	17	88.68	\N	piece	Fair	/uploads/products/product_469_1780236220386.jpg	\N	t	ACTIVE	469	2026-05-31 14:03:40.627	2026-05-31 14:03:40.627	32.19046835359558	74.13503680000296	\N
231	RUBBER Scrap - 51.94kg - Quality Fair	Recently collected, excellent condition.	rubber	4752	46	51.94	\N	piece	Fair	/uploads/products/product_458_1780236220628.jpg	\N	t	ACTIVE	458	2026-05-31 14:03:40.87	2026-05-31 14:03:40.87	32.14045197212722	74.12632030773507	\N
232	PLASTIC Scrap - 32.04kg - Quality Fair	Recently collected, excellent condition.	plastic	2592	45	32.04	\N	kg	Fair	/uploads/products/product_468_1780236220871.jpg	\N	t	ACTIVE	468	2026-05-31 14:03:41.112	2026-05-31 14:03:41.112	33.66843594277687	73.05739156755163	\N
233	PLASTIC Scrap - 40.56kg - Quality Poor	Bulk quantity available for bulk buyers.	plastic	3693	41	40.56	\N	ton	Poor	/uploads/products/product_454_1780236221114.jpg	\N	t	ACTIVE	454	2026-05-31 14:03:41.409	2026-05-31 14:03:41.409	32.12647895278032	74.11768909354639	\N
234	BRASS Scrap - 41.90kg - Quality Good	Sorted and cleaned for easy handling.	brass	1982	51	41.9	\N	bundle	Good	/uploads/products/product_485_1780236221410.jpg	\N	t	ACTIVE	485	2026-05-31 14:03:41.651	2026-05-31 14:03:41.651	33.61370887140146	73.2487683288018	\N
235	PLASTIC Scrap - 37.85kg - Quality Good	Sorted and cleaned for easy handling.	plastic	795	22	37.85	\N	ton	Good	/uploads/products/product_471_1780236221652.jpg	\N	t	ACTIVE	471	2026-05-31 14:03:41.921	2026-05-31 14:03:41.921	31.46321088286725	72.38943007570452	\N
236	COPPER Scrap - 48.04kg - Quality Good	Sorted and cleaned for easy handling.	copper	2435	50	48.04	\N	piece	Good	/uploads/products/product_491_1780236221922.jpg	\N	t	ACTIVE	491	2026-05-31 14:03:42.191	2026-05-31 14:03:42.191	25.33063247851474	68.42662154956193	\N
237	RUBBER Scrap - 56.82kg - Quality Poor	Recently collected, excellent condition.	rubber	2883	8	56.82	\N	bundle	Poor	/uploads/products/product_459_1780236222191.jpg	\N	t	ACTIVE	459	2026-05-31 14:03:42.433	2026-05-31 14:03:42.433	31.41388546440595	72.33632244004224	\N
238	COMPOSITE Scrap - 52.05kg - Quality Fair	High quality scrap material, ideal for recycling.	composite	2785	33	52.05	\N	ton	Fair	/uploads/products/product_488_1780236222434.jpg	\N	t	ACTIVE	488	2026-05-31 14:03:42.676	2026-05-31 14:03:42.676	24.884542648417	67.0326446005464	\N
239	ELECTRONICS Scrap - 95.72kg - Quality Poor	Perfect for manufacturing and industrial use.	electronics	425	32	95.72	\N	bundle	Poor	/uploads/products/product_492_1780236222676.jpg	\N	t	ACTIVE	492	2026-05-31 14:03:42.92	2026-05-31 14:03:42.92	30.1781782699582	67.06123651888288	\N
240	FOAM Scrap - 69.38kg - Quality Fair	Eco-friendly scrap collection.	foam	642	47	69.38	\N	kg	Fair	/uploads/products/product_486_1780236222921.jpg	\N	t	ACTIVE	486	2026-05-31 14:03:43.162	2026-05-31 14:03:43.162	31.38777300430315	72.29988079032111	\N
241	FOAM Scrap - 23.09kg - Quality Fair	Perfect for manufacturing and industrial use.	foam	612	7	23.09	\N	bag	Fair	/uploads/products/product_459_1780236223163.jpg	\N	t	ACTIVE	459	2026-05-31 14:03:43.404	2026-05-31 14:03:43.404	31.39608819149096	72.32383280912515	\N
242	LEATHER Scrap - 50.68kg - Quality Fair	Recently collected, excellent condition.	leather	4570	31	50.68	\N	bag	Fair	/uploads/products/product_454_1780236223404.jpg	\N	t	ACTIVE	454	2026-05-31 14:03:43.663	2026-05-31 14:03:43.663	32.14645859177308	74.15283352784662	\N
243	RUBBER Scrap - 89.01kg - Quality Fair	Bulk quantity available for bulk buyers.	rubber	2704	8	89.01	\N	bundle	Fair	/uploads/products/product_465_1780236223664.jpg	\N	t	ACTIVE	465	2026-05-31 14:03:43.969	2026-05-31 14:03:43.969	30.10043664126042	71.39955970297244	\N
244	PAPER Scrap - 99.78kg - Quality Poor	Recently collected, excellent condition.	paper	2312	42	99.78	\N	kg	Poor	/uploads/products/product_471_1780236223970.jpg	\N	t	ACTIVE	471	2026-05-31 14:03:44.212	2026-05-31 14:03:44.212	31.43794216711008	72.38028673602723	\N
245	ELECTRONICS Scrap - 28.45kg - Quality Good	Perfect for manufacturing and industrial use.	electronics	141	32	28.45	\N	bundle	Good	/uploads/products/product_487_1780236224213.jpg	\N	t	ACTIVE	487	2026-05-31 14:03:44.481	2026-05-31 14:03:44.481	33.9849444789026	71.51208699874863	\N
246	BRASS Scrap - 101.22kg - Quality Good	Collected from industrial facilities. Ready for processing.	brass	1279	39	101.22	\N	kg	Good	/uploads/products/product_472_1780236224482.jpg	\N	t	ACTIVE	472	2026-05-31 14:03:44.723	2026-05-31 14:03:44.723	25.37609243147619	68.4207391329307	\N
247	TEXTILE Scrap - 73.93kg - Quality Good	Eco-friendly scrap collection.	textile	2481	50	73.93	\N	bag	Good	/uploads/products/product_471_1780236224724.jpg	\N	t	ACTIVE	471	2026-05-31 14:03:44.993	2026-05-31 14:03:44.993	31.4354737536335	72.38981766768255	\N
248	GLASS Scrap - 34.84kg - Quality Fair	High quality scrap material, ideal for recycling.	glass	4827	25	34.84	\N	bundle	Fair	/uploads/products/product_454_1780236224994.jpg	\N	t	ACTIVE	454	2026-05-31 14:03:45.301	2026-05-31 14:03:45.301	32.11915571347767	74.14550831562345	\N
249	PAPER Scrap - 71.04kg - Quality Fair	High quality scrap material, ideal for recycling.	paper	286	28	71.04	\N	kg	Fair	/uploads/products/product_486_1780236225301.jpg	\N	t	ACTIVE	486	2026-05-31 14:03:45.608	2026-05-31 14:03:45.608	31.4060559925253	72.30729307979855	\N
250	CARDBOARD Scrap - 16.48kg - Quality Good	High quality scrap material, ideal for recycling.	cardboard	150	44	16.48	\N	ton	Good	/uploads/products/product_458_1780236225609.jpg	\N	t	ACTIVE	458	2026-05-31 14:03:45.85	2026-05-31 14:03:45.85	32.12878696198252	74.12590145811062	\N
251	GLASS Scrap - 101.49kg - Quality Poor	Perfect for manufacturing and industrial use.	glass	4781	46	101.49	\N	ton	Poor	/uploads/products/product_453_1780236225851.jpg	\N	t	ACTIVE	453	2026-05-31 14:03:46.091	2026-05-31 14:03:46.091	24.87613902024077	67.02313167916536	\N
252	METAL Scrap - 104.58kg - Quality Poor	Verified weight and quality.	metal	1975	27	104.58	\N	piece	Poor	/uploads/products/product_490_1780236226092.jpg	\N	t	ACTIVE	490	2026-05-31 14:03:46.427	2026-05-31 14:03:46.427	31.59749318495885	74.33485241815079	\N
253	LEATHER Scrap - 41.35kg - Quality Poor	Eco-friendly scrap collection.	leather	3983	9	41.35	\N	bag	Poor	/uploads/products/product_483_1780236226428.jpg	\N	t	ACTIVE	483	2026-05-31 14:03:46.669	2026-05-31 14:03:46.669	33.58836401082451	73.17609179959057	\N
254	PLASTIC Scrap - 88.25kg - Quality Good	Sorted and cleaned for easy handling.	plastic	2594	47	88.25	\N	bag	Good	/uploads/products/product_485_1780236226670.jpg	\N	t	ACTIVE	485	2026-05-31 14:03:46.911	2026-05-31 14:03:46.911	33.59392128194308	73.23490754661351	\N
255	WOOD Scrap - 50.48kg - Quality Fair	Bulk quantity available for bulk buyers.	wood	575	7	50.48	\N	kg	Fair	/uploads/products/product_492_1780236226912.jpg	\N	t	ACTIVE	492	2026-05-31 14:03:47.211	2026-05-31 14:03:47.211	30.20235020799791	67.05588775833914	\N
256	COMPOSITE Scrap - 65.42kg - Quality Good	Verified weight and quality.	composite	3053	14	65.42	\N	bag	Good	/uploads/products/product_496_1780236227212.jpg	\N	t	ACTIVE	496	2026-05-31 14:03:47.553	2026-05-31 14:03:47.553	34.00603372659557	71.50270750815815	\N
257	PAPER Scrap - 41.47kg - Quality Good	Recently collected, excellent condition.	paper	1733	20	41.47	\N	bundle	Good	/uploads/products/product_492_1780236227554.jpg	\N	t	ACTIVE	492	2026-05-31 14:03:47.794	2026-05-31 14:03:47.794	30.18823688106392	67.05325515356472	\N
258	LEATHER Scrap - 34.74kg - Quality Poor	Recently collected, excellent condition.	leather	805	17	34.74	\N	bundle	Poor	/uploads/products/product_496_1780236227795.jpg	\N	t	ACTIVE	496	2026-05-31 14:03:48.036	2026-05-31 14:03:48.036	33.99329827326572	71.49689575921896	\N
259	RUBBER Scrap - 61.22kg - Quality Poor	Bulk quantity available for bulk buyers.	rubber	4157	12	61.22	\N	kg	Poor	/uploads/products/product_472_1780236228037.jpg	\N	t	ACTIVE	472	2026-05-31 14:03:48.37	2026-05-31 14:03:48.37	25.35677383625254	68.42077085859415	\N
260	ALUMINUM Scrap - 101.12kg - Quality Poor	Eco-friendly scrap collection.	aluminum	198	27	101.12	\N	bundle	Poor	/uploads/products/product_458_1780236228370.jpg	\N	t	ACTIVE	458	2026-05-31 14:03:48.612	2026-05-31 14:03:48.612	32.13392019275768	74.13588065485523	\N
261	LEATHER Scrap - 23.02kg - Quality Fair	Recently collected, excellent condition.	leather	1555	35	23.02	\N	piece	Fair	/uploads/products/product_467_1780236228613.jpg	\N	t	ACTIVE	467	2026-05-31 14:03:48.884	2026-05-31 14:03:48.884	24.92057966038906	66.99378170120949	\N
262	PLASTIC Scrap - 24.90kg - Quality Poor	Collected from industrial facilities. Ready for processing.	plastic	1227	45	24.9	\N	kg	Poor	/uploads/products/product_457_1780236228885.jpg	\N	t	ACTIVE	457	2026-05-31 14:03:49.147	2026-05-31 14:03:49.147	24.87686424972068	66.98912060524094	\N
263	LEATHER Scrap - 78.07kg - Quality Poor	Sorted and cleaned for easy handling.	leather	2998	50	78.07	\N	kg	Poor	/uploads/products/product_461_1780236229148.jpg	\N	t	ACTIVE	461	2026-05-31 14:03:49.396	2026-05-31 14:03:49.396	31.56685079695574	74.28674244695432	\N
264	STEEL Scrap - 90.67kg - Quality Poor	Bulk quantity available for bulk buyers.	steel	347	38	90.67	\N	piece	Poor	/uploads/products/product_489_1780236229397.jpg	\N	t	ACTIVE	489	2026-05-31 14:03:49.704	2026-05-31 14:03:49.704	24.86862072397721	66.99717173363638	\N
265	METAL Scrap - 62.12kg - Quality Fair	Verified weight and quality.	metal	352	41	62.12	\N	piece	Fair	/uploads/products/product_466_1780236229705.jpg	\N	t	ACTIVE	466	2026-05-31 14:03:50.011	2026-05-31 14:03:50.011	32.17491383788536	74.19661719879291	\N
266	METAL Scrap - 90.38kg - Quality Good	High quality scrap material, ideal for recycling.	metal	2722	35	90.38	\N	kg	Good	/uploads/products/product_461_1780236230012.jpg	\N	t	ACTIVE	461	2026-05-31 14:03:50.304	2026-05-31 14:03:50.304	31.58792157748752	74.2790219922555	\N
267	TEXTILE Scrap - 47.36kg - Quality Good	Recently collected, excellent condition.	textile	1300	38	47.36	\N	piece	Good	/uploads/products/product_458_1780236230305.jpg	\N	t	ACTIVE	458	2026-05-31 14:03:50.546	2026-05-31 14:03:50.546	32.12264663369348	74.15895272978275	\N
268	COPPER Scrap - 101.12kg - Quality Fair	Bulk quantity available for bulk buyers.	copper	2810	53	101.12	\N	bag	Fair	/uploads/products/product_464_1780236230547.jpg	\N	t	ACTIVE	464	2026-05-31 14:03:50.788	2026-05-31 14:03:50.788	33.69294152319971	72.99122605590073	\N
269	LEATHER Scrap - 27.17kg - Quality Poor	Eco-friendly scrap collection.	leather	4473	46	27.17	\N	piece	Poor	/uploads/products/product_492_1780236230789.jpg	\N	t	ACTIVE	492	2026-05-31 14:03:51.035	2026-05-31 14:03:51.035	30.18865815275761	67.0416782350377	\N
270	PAPER Scrap - 31.85kg - Quality Poor	Recently collected, excellent condition.	paper	2230	9	31.85	\N	ton	Poor	/uploads/products/product_483_1780236231035.jpg	\N	t	ACTIVE	483	2026-05-31 14:03:51.276	2026-05-31 14:03:51.276	33.59250270038264	73.15891728389735	\N
271	WOOD Scrap - 103.00kg - Quality Fair	Sorted and cleaned for easy handling.	wood	3339	49	103	\N	bundle	Fair	/uploads/products/product_489_1780236231277.jpg	\N	t	ACTIVE	489	2026-05-31 14:03:51.546	2026-05-31 14:03:51.546	24.87822571094651	66.96845143990548	\N
272	STEEL Scrap - 49.88kg - Quality Fair	Eco-friendly scrap collection.	steel	1483	15	49.88	\N	piece	Fair	/uploads/products/product_491_1780236231547.jpg	\N	t	ACTIVE	491	2026-05-31 14:03:51.854	2026-05-31 14:03:51.854	25.32529228409346	68.41697672130975	\N
273	CARDBOARD Scrap - 95.50kg - Quality Fair	Sorted and cleaned for easy handling.	cardboard	3931	35	95.5	\N	kg	Fair	/uploads/products/product_488_1780236231855.jpg	\N	t	ACTIVE	488	2026-05-31 14:03:52.096	2026-05-31 14:03:52.096	24.8995525062256	66.99582085868032	\N
274	STEEL Scrap - 103.90kg - Quality Poor	Collected from industrial facilities. Ready for processing.	steel	3182	26	103.9	\N	kg	Poor	/uploads/products/product_471_1780236232097.jpg	\N	t	ACTIVE	471	2026-05-31 14:03:52.34	2026-05-31 14:03:52.34	31.47493003835651	72.36278840353962	\N
275	PLASTIC Scrap - 17.86kg - Quality Fair	Perfect for manufacturing and industrial use.	plastic	3720	30	17.86	\N	kg	Fair	/uploads/products/product_468_1780236232341.jpg	\N	t	ACTIVE	468	2026-05-31 14:03:52.676	2026-05-31 14:03:52.676	33.63869569933028	73.072543609335	\N
276	LEATHER Scrap - 17.09kg - Quality Poor	High quality scrap material, ideal for recycling.	leather	1912	14	17.09	\N	piece	Poor	/uploads/products/product_485_1780236232678.jpg	\N	t	ACTIVE	485	2026-05-31 14:03:52.92	2026-05-31 14:03:52.92	33.62515516234351	73.21802065323872	\N
277	ELECTRONICS Scrap - 43.81kg - Quality Fair	Verified weight and quality.	electronics	1847	19	43.81	\N	kg	Fair	/uploads/products/product_472_1780236232921.jpg	\N	t	ACTIVE	472	2026-05-31 14:03:53.164	2026-05-31 14:03:53.164	25.39274898752093	68.46388336217589	\N
278	STEEL Scrap - 74.43kg - Quality Poor	Sorted and cleaned for easy handling.	steel	3478	35	74.43	\N	kg	Poor	/uploads/products/product_493_1780236233165.jpg	\N	t	ACTIVE	493	2026-05-31 14:03:53.407	2026-05-31 14:03:53.407	30.21766463197193	67.04075618877312	\N
279	FOAM Scrap - 14.20kg - Quality Poor	Verified weight and quality.	foam	1310	5	14.2	\N	bag	Poor	/uploads/products/product_462_1780236233408.jpg	\N	t	ACTIVE	462	2026-05-31 14:03:53.649	2026-05-31 14:03:53.649	24.86261993893095	66.9865818592559	\N
280	PLASTIC Scrap - 30.54kg - Quality Fair	Collected from industrial facilities. Ready for processing.	plastic	4625	22	30.54	\N	ton	Fair	/uploads/products/product_454_1780236233651.jpg	\N	t	ACTIVE	454	2026-05-31 14:03:53.893	2026-05-31 14:03:53.893	32.15496931338888	74.14980142322976	\N
281	METAL Scrap - 29.29kg - Quality Fair	Verified weight and quality.	metal	2772	10	29.29	\N	bag	Fair	/uploads/products/product_467_1780236233894.jpg	\N	t	ACTIVE	467	2026-05-31 14:03:54.136	2026-05-31 14:03:54.136	24.90523370772791	67.00493336532222	\N
282	ELECTRONICS Scrap - 93.28kg - Quality Poor	Recently collected, excellent condition.	electronics	2293	29	93.28	\N	ton	Poor	/uploads/products/product_455_1780236234137.jpg	\N	t	ACTIVE	455	2026-05-31 14:03:54.415	2026-05-31 14:03:54.415	33.60566447601224	73.17781741249046	\N
283	STEEL Scrap - 102.53kg - Quality Fair	Recently collected, excellent condition.	steel	453	46	102.53	\N	piece	Fair	/uploads/products/product_487_1780236234416.jpg	\N	t	ACTIVE	487	2026-05-31 14:03:54.723	2026-05-31 14:03:54.723	33.9904259531058	71.51534814137602	\N
284	STEEL Scrap - 57.82kg - Quality Fair	Sorted and cleaned for easy handling.	steel	4163	45	57.82	\N	bundle	Fair	/uploads/products/product_490_1780236234724.jpg	\N	t	ACTIVE	490	2026-05-31 14:03:55.028	2026-05-31 14:03:55.028	31.59202217962259	74.32940431687653	\N
285	COMPOSITE Scrap - 108.22kg - Quality Poor	Eco-friendly scrap collection.	composite	1092	35	108.22	\N	piece	Poor	/uploads/products/product_483_1780236235029.jpg	\N	t	ACTIVE	483	2026-05-31 14:03:55.337	2026-05-31 14:03:55.337	33.60617248681818	73.14429311997056	\N
286	COPPER Scrap - 31.65kg - Quality Fair	Recently collected, excellent condition.	copper	2116	46	31.65	\N	kg	Fair	/uploads/products/product_460_1780236235338.jpg	\N	t	ACTIVE	460	2026-05-31 14:03:55.582	2026-05-31 14:03:55.582	31.39681594215761	72.31014590879778	\N
287	COPPER Scrap - 71.98kg - Quality Good	Collected from industrial facilities. Ready for processing.	copper	2211	22	71.98	\N	ton	Good	/uploads/products/product_470_1780236235585.jpg	\N	t	ACTIVE	470	2026-05-31 14:03:55.852	2026-05-31 14:03:55.852	25.46294859489197	68.44562848213275	\N
288	METAL Scrap - 97.20kg - Quality Good	Eco-friendly scrap collection.	metal	3541	44	97.2	\N	kg	Good	/uploads/products/product_490_1780236235854.jpg	\N	t	ACTIVE	490	2026-05-31 14:03:56.158	2026-05-31 14:03:56.158	31.58829760939502	74.35111906339306	\N
289	RUBBER Scrap - 62.98kg - Quality Poor	Eco-friendly scrap collection.	rubber	4192	21	62.98	\N	ton	Poor	/uploads/products/product_468_1780236236163.jpg	\N	t	ACTIVE	468	2026-05-31 14:03:56.463	2026-05-31 14:03:56.463	33.65868474386957	73.06350153870405	\N
290	GLASS Scrap - 13.95kg - Quality Good	Recently collected, excellent condition.	glass	4870	23	13.95	\N	piece	Good	/uploads/products/product_467_1780236236465.jpg	\N	t	ACTIVE	467	2026-05-31 14:03:56.77	2026-05-31 14:03:56.77	24.88751446615789	67.00754649312223	\N
291	WOOD Scrap - 92.84kg - Quality Good	High quality scrap material, ideal for recycling.	wood	1238	16	92.84	\N	bundle	Good	/uploads/products/product_467_1780236236771.jpg	\N	t	ACTIVE	467	2026-05-31 14:03:57.077	2026-05-31 14:03:57.077	24.91733355177541	67.00310973796577	\N
292	METAL Scrap - 106.22kg - Quality Fair	Perfect for manufacturing and industrial use.	metal	1047	23	106.22	\N	bundle	Fair	/uploads/products/product_455_1780236237083.jpg	\N	t	ACTIVE	455	2026-05-31 14:03:57.385	2026-05-31 14:03:57.385	33.60665663868316	73.1742559123909	\N
293	METAL Scrap - 59.96kg - Quality Good	Eco-friendly scrap collection.	metal	2283	47	59.96	\N	ton	Good	/uploads/products/product_486_1780236237386.jpg	\N	t	ACTIVE	486	2026-05-31 14:03:57.627	2026-05-31 14:03:57.627	31.38278585573076	72.28836671692335	\N
294	GLASS Scrap - 81.37kg - Quality Good	Verified weight and quality.	glass	4158	6	81.37	\N	kg	Good	/uploads/products/product_455_1780236237628.jpg	\N	t	ACTIVE	455	2026-05-31 14:03:57.875	2026-05-31 14:03:57.875	33.6409243946256	73.17936653547119	\N
295	CARDBOARD Scrap - 36.95kg - Quality Good	High quality scrap material, ideal for recycling.	cardboard	3575	29	36.95	\N	piece	Good	/uploads/products/product_492_1780236237876.jpg	\N	t	ACTIVE	492	2026-05-31 14:03:58.203	2026-05-31 14:03:58.203	30.20375483476363	67.06325633770398	\N
296	WOOD Scrap - 30.32kg - Quality Fair	Sorted and cleaned for easy handling.	wood	2636	47	30.32	\N	bundle	Fair	/uploads/products/product_459_1780236238204.jpg	\N	t	ACTIVE	459	2026-05-31 14:03:58.51	2026-05-31 14:03:58.51	31.37234042908923	72.3430374958927	\N
297	LEATHER Scrap - 40.76kg - Quality Good	Perfect for manufacturing and industrial use.	leather	1329	49	40.76	\N	piece	Good	/uploads/products/product_489_1780236238511.jpg	\N	t	ACTIVE	489	2026-05-31 14:03:58.752	2026-05-31 14:03:58.752	24.87946509495069	66.95906258453988	\N
298	COPPER Scrap - 25.38kg - Quality Good	Bulk quantity available for bulk buyers.	copper	3996	34	25.38	\N	kg	Good	/uploads/products/product_470_1780236238753.jpg	\N	t	ACTIVE	470	2026-05-31 14:03:59.022	2026-05-31 14:03:59.022	25.46433929889579	68.46794382533554	\N
299	TEXTILE Scrap - 99.68kg - Quality Good	High quality scrap material, ideal for recycling.	textile	4670	6	99.68	\N	bag	Good	/uploads/products/product_471_1780236239023.jpg	\N	t	ACTIVE	471	2026-05-31 14:03:59.331	2026-05-31 14:03:59.331	31.45542183758841	72.35896704023129	\N
300	PLASTIC Scrap - 91.88kg - Quality Poor	Perfect for manufacturing and industrial use.	plastic	1114	30	91.88	\N	ton	Poor	/uploads/products/product_497_1780236239333.jpg	\N	t	ACTIVE	497	2026-05-31 14:03:59.636	2026-05-31 14:03:59.636	32.18298115371245	74.19881872587614	\N
301	RUBBER Scrap - 16.65kg - Quality Fair	Bulk quantity available for bulk buyers.	rubber	1573	53	16.65	\N	kg	Fair	/uploads/products/product_496_1780236239637.jpg	\N	t	ACTIVE	496	2026-05-31 14:03:59.944	2026-05-31 14:03:59.944	33.96846109914932	71.4949983604271	\N
302	PAPER Scrap - 32.16kg - Quality Poor	Collected from industrial facilities. Ready for processing.	paper	1005	54	32.16	\N	bag	Poor	/uploads/products/product_497_1780236239945.jpg	\N	t	ACTIVE	497	2026-05-31 14:04:00.25	2026-05-31 14:04:00.25	32.17026352230724	74.17601906982881	\N
303	CARDBOARD Scrap - 87.64kg - Quality Fair	Perfect for manufacturing and industrial use.	cardboard	4553	49	87.64	\N	bag	Fair	/uploads/products/product_489_1780236240251.jpg	\N	t	ACTIVE	489	2026-05-31 14:04:00.558	2026-05-31 14:04:00.558	24.85646503903751	67.00346677942362	\N
304	FOAM Scrap - 31.53kg - Quality Good	Verified weight and quality.	foam	2140	51	31.53	\N	piece	Good	/uploads/products/product_484_1780236240559.jpg	\N	t	ACTIVE	484	2026-05-31 14:04:00.866	2026-05-31 14:04:00.866	30.11642489806179	71.46244353279631	\N
305	WOOD Scrap - 40.14kg - Quality Good	Perfect for manufacturing and industrial use.	wood	3264	54	40.14	\N	bag	Good	/uploads/products/product_489_1780236240867.jpg	\N	t	ACTIVE	489	2026-05-31 14:04:01.108	2026-05-31 14:04:01.108	24.87714318390239	66.9628090508391	\N
306	COPPER Scrap - 56.37kg - Quality Fair	Verified weight and quality.	copper	3605	36	56.37	\N	kg	Fair	/uploads/products/product_489_1780236241108.jpg	\N	t	ACTIVE	489	2026-05-31 14:04:01.378	2026-05-31 14:04:01.378	24.8752253040125	66.98403714219663	\N
307	RUBBER Scrap - 67.26kg - Quality Good	High quality scrap material, ideal for recycling.	rubber	1171	36	67.26	\N	bundle	Good	/uploads/products/product_464_1780236241379.jpg	\N	t	ACTIVE	464	2026-05-31 14:04:01.62	2026-05-31 14:04:01.62	33.71877620955549	72.99806625347742	\N
308	ALUMINUM Scrap - 56.79kg - Quality Fair	High quality scrap material, ideal for recycling.	aluminum	1324	10	56.79	\N	ton	Fair	/uploads/products/product_487_1780236241621.jpg	\N	t	ACTIVE	487	2026-05-31 14:04:01.889	2026-05-31 14:04:01.889	33.96058164204246	71.50527108312737	\N
309	FOAM Scrap - 22.34kg - Quality Fair	Eco-friendly scrap collection.	foam	1374	38	22.34	\N	bag	Fair	/uploads/products/product_464_1780236241890.jpg	\N	t	ACTIVE	464	2026-05-31 14:04:02.196	2026-05-31 14:04:02.196	33.73424181557335	72.99676061297609	\N
310	CARDBOARD Scrap - 93.72kg - Quality Poor	Bulk quantity available for bulk buyers.	cardboard	3578	14	93.72	\N	piece	Poor	/uploads/products/product_458_1780236242197.jpg	\N	t	ACTIVE	458	2026-05-31 14:04:02.504	2026-05-31 14:04:02.504	32.11965726024672	74.1544227944348	\N
311	GLASS Scrap - 34.04kg - Quality Fair	Perfect for manufacturing and industrial use.	glass	3377	29	34.04	\N	ton	Fair	/uploads/products/product_470_1780236242504.jpg	\N	t	ACTIVE	470	2026-05-31 14:04:02.811	2026-05-31 14:04:02.811	25.42000472811565	68.4626850179085	\N
312	CARDBOARD Scrap - 101.84kg - Quality Poor	Eco-friendly scrap collection.	cardboard	4580	53	101.84	\N	bundle	Poor	/uploads/products/product_465_1780236242813.jpg	\N	t	ACTIVE	465	2026-05-31 14:04:03.054	2026-05-31 14:04:03.054	30.1018192991602	71.37458605911809	\N
313	PAPER Scrap - 74.45kg - Quality Poor	Collected from industrial facilities. Ready for processing.	paper	2948	38	74.45	\N	bag	Poor	/uploads/products/product_484_1780236243055.jpg	\N	t	ACTIVE	484	2026-05-31 14:04:03.296	2026-05-31 14:04:03.296	30.11210335280597	71.44112174220119	\N
314	CARDBOARD Scrap - 69.18kg - Quality Good	Eco-friendly scrap collection.	cardboard	1802	15	69.18	\N	bundle	Good	/uploads/products/product_465_1780236243298.jpg	\N	t	ACTIVE	465	2026-05-31 14:04:03.737	2026-05-31 14:04:03.737	30.13430419636714	71.38816225694192	\N
315	STEEL Scrap - 96.82kg - Quality Good	Collected from industrial facilities. Ready for processing.	steel	3335	34	96.82	\N	kg	Good	/uploads/products/product_457_1780236243738.jpg	\N	t	ACTIVE	457	2026-05-31 14:04:04.532	2026-05-31 14:04:04.532	24.87398354307557	66.9798497055511	\N
316	METAL Scrap - 73.89kg - Quality Good	Bulk quantity available for bulk buyers.	metal	3076	24	73.89	\N	bag	Good	/uploads/products/product_459_1780236244539.jpg	\N	t	ACTIVE	459	2026-05-31 14:04:04.78	2026-05-31 14:04:04.78	31.38880574375411	72.32664250621234	\N
317	COPPER Scrap - 103.38kg - Quality Good	Verified weight and quality.	copper	4939	5	103.38	\N	kg	Good	/uploads/products/product_459_1780236244781.jpg	\N	t	ACTIVE	459	2026-05-31 14:04:05.066	2026-05-31 14:04:05.066	31.37768621001114	72.32734178152597	\N
318	BRASS Scrap - 16.07kg - Quality Poor	Verified weight and quality.	brass	2955	38	16.07	\N	bundle	Poor	/uploads/products/product_455_1780236245067.jpg	\N	t	ACTIVE	455	2026-05-31 14:04:05.309	2026-05-31 14:04:05.309	33.63967321802264	73.16145271069958	\N
319	COMPOSITE Scrap - 18.90kg - Quality Good	High quality scrap material, ideal for recycling.	composite	2675	26	18.9	\N	bag	Good	/uploads/products/product_456_1780236245310.jpg	\N	t	ACTIVE	456	2026-05-31 14:04:05.554	2026-05-31 14:04:05.554	32.17695075449782	74.17147383229775	\N
320	PAPER Scrap - 44.29kg - Quality Good	Sorted and cleaned for easy handling.	paper	1567	31	44.29	\N	kg	Good	/uploads/products/product_497_1780236245555.jpg	\N	t	ACTIVE	497	2026-05-31 14:04:05.883	2026-05-31 14:04:05.883	32.20820207014382	74.16645186166318	\N
321	PLASTIC Scrap - 25.49kg - Quality Poor	Recently collected, excellent condition.	plastic	3201	9	25.49	\N	bundle	Poor	/uploads/products/product_457_1780236245884.jpg	\N	t	ACTIVE	457	2026-05-31 14:04:06.126	2026-05-31 14:04:06.126	24.85073644290322	66.99256171861266	\N
322	COPPER Scrap - 51.57kg - Quality Fair	High quality scrap material, ideal for recycling.	copper	114	21	51.57	\N	ton	Fair	/uploads/products/product_484_1780236246127.jpg	\N	t	ACTIVE	484	2026-05-31 14:04:06.395	2026-05-31 14:04:06.395	30.09524798567252	71.48513839665505	\N
323	WOOD Scrap - 12.65kg - Quality Good	Perfect for manufacturing and industrial use.	wood	4433	8	12.65	\N	bag	Good	/uploads/products/product_493_1780236246396.jpg	\N	t	ACTIVE	493	2026-05-31 14:04:06.637	2026-05-31 14:04:06.637	30.20579748381974	67.07935578338123	\N
324	RUBBER Scrap - 86.31kg - Quality Good	Recently collected, excellent condition.	rubber	768	25	86.31	\N	bundle	Good	/uploads/products/product_486_1780236246638.jpg	\N	t	ACTIVE	486	2026-05-31 14:04:06.879	2026-05-31 14:04:06.879	31.3690927774989	72.29602502436603	\N
325	COPPER Scrap - 10.97kg - Quality Fair	Sorted and cleaned for easy handling.	copper	699	31	10.97	\N	bundle	Fair	/uploads/products/product_487_1780236246880.jpg	\N	t	ACTIVE	487	2026-05-31 14:04:07.214	2026-05-31 14:04:07.214	33.94690170315562	71.47565990686938	\N
326	BRASS Scrap - 60.89kg - Quality Poor	Perfect for manufacturing and industrial use.	brass	3360	50	60.89	\N	bag	Poor	/uploads/products/product_453_1780236247215.jpg	\N	t	ACTIVE	453	2026-05-31 14:04:07.522	2026-05-31 14:04:07.522	24.88222493850385	67.0348661782443	\N
327	LEATHER Scrap - 24.41kg - Quality Fair	Sorted and cleaned for easy handling.	leather	2785	7	24.41	\N	bundle	Fair	/uploads/products/product_461_1780236247523.jpg	\N	t	ACTIVE	461	2026-05-31 14:04:07.812	2026-05-31 14:04:07.812	31.57701135801418	74.30574645655005	\N
328	ELECTRONICS Scrap - 35.43kg - Quality Good	Bulk quantity available for bulk buyers.	electronics	2658	11	35.43	\N	bag	Good	/uploads/products/product_455_1780236247813.jpg	\N	t	ACTIVE	455	2026-05-31 14:04:08.054	2026-05-31 14:04:08.054	33.62918670916077	73.16145866106197	\N
329	ALUMINUM Scrap - 87.57kg - Quality Fair	Sorted and cleaned for easy handling.	aluminum	3220	15	87.57	\N	kg	Fair	/uploads/products/product_494_1780236248055.jpg	\N	t	ACTIVE	494	2026-05-31 14:04:08.296	2026-05-31 14:04:08.296	25.40086635356904	68.50893627471739	\N
330	BRASS Scrap - 63.96kg - Quality Poor	Recently collected, excellent condition.	brass	4353	53	63.96	\N	piece	Poor	/uploads/products/product_455_1780236248297.jpg	\N	t	ACTIVE	455	2026-05-31 14:04:08.545	2026-05-31 14:04:08.545	33.59730694996043	73.13508500323182	\N
331	METAL Scrap - 76.72kg - Quality Good	Collected from industrial facilities. Ready for processing.	metal	3127	23	76.72	\N	bundle	Good	/uploads/products/product_495_1780236248546.jpg	\N	t	ACTIVE	495	2026-05-31 14:04:08.853	2026-05-31 14:04:08.853	25.42032102867971	68.45494107335375	\N
332	METAL Scrap - 85.98kg - Quality Good	Eco-friendly scrap collection.	metal	3679	40	85.98	\N	bundle	Good	/uploads/products/product_484_1780236248854.jpg	\N	t	ACTIVE	484	2026-05-31 14:04:09.16	2026-05-31 14:04:09.16	30.12150231204435	71.4510713093524	\N
333	ALUMINUM Scrap - 17.22kg - Quality Good	High quality scrap material, ideal for recycling.	aluminum	767	5	17.22	\N	bag	Good	/uploads/products/product_495_1780236249161.jpg	\N	t	ACTIVE	495	2026-05-31 14:04:09.467	2026-05-31 14:04:09.467	25.38737907698642	68.44270539743054	\N
334	FOAM Scrap - 34.28kg - Quality Good	Eco-friendly scrap collection.	foam	4010	53	34.28	\N	ton	Good	/uploads/products/product_455_1780236249468.jpg	\N	t	ACTIVE	455	2026-05-31 14:04:09.774	2026-05-31 14:04:09.774	33.635608784979	73.13914137672336	\N
335	FOAM Scrap - 60.44kg - Quality Good	Eco-friendly scrap collection.	foam	2487	37	60.44	\N	kg	Good	/uploads/products/product_469_1780236249775.jpg	\N	t	ACTIVE	469	2026-05-31 14:04:10.082	2026-05-31 14:04:10.082	32.18773405939119	74.16901084389474	\N
336	COMPOSITE Scrap - 30.98kg - Quality Good	Sorted and cleaned for easy handling.	composite	119	5	30.98	\N	piece	Good	/uploads/products/product_454_1780236250083.jpg	\N	t	ACTIVE	454	2026-05-31 14:04:10.389	2026-05-31 14:04:10.389	32.15393324795593	74.144544085465	\N
337	COMPOSITE Scrap - 83.85kg - Quality Good	Recently collected, excellent condition.	composite	3825	14	83.85	\N	bundle	Good	/uploads/products/product_459_1780236250390.jpg	\N	t	ACTIVE	459	2026-05-31 14:04:10.696	2026-05-31 14:04:10.696	31.38048799678867	72.33970766929515	\N
338	TEXTILE Scrap - 102.01kg - Quality Good	Recently collected, excellent condition.	textile	1713	23	102.01	\N	kg	Good	/uploads/products/product_491_1780236250697.jpg	\N	t	ACTIVE	491	2026-05-31 14:04:11.003	2026-05-31 14:04:11.003	25.36249518314595	68.42007193767515	\N
339	WOOD Scrap - 40.44kg - Quality Fair	Bulk quantity available for bulk buyers.	wood	2986	19	40.44	\N	bundle	Fair	/uploads/products/product_494_1780236251004.jpg	\N	t	ACTIVE	494	2026-05-31 14:04:11.311	2026-05-31 14:04:11.311	25.4336139924077	68.47517111304613	\N
340	COMPOSITE Scrap - 33.54kg - Quality Fair	Collected from industrial facilities. Ready for processing.	composite	1485	54	33.54	\N	ton	Fair	/uploads/products/product_455_1780236251313.jpg	\N	t	ACTIVE	455	2026-05-31 14:04:11.618	2026-05-31 14:04:11.618	33.62208052710945	73.13363061841476	\N
341	COMPOSITE Scrap - 19.83kg - Quality Fair	Verified weight and quality.	composite	3352	26	19.83	\N	piece	Fair	/uploads/products/product_464_1780236251619.jpg	\N	t	ACTIVE	464	2026-05-31 14:04:11.93	2026-05-31 14:04:11.93	33.72382088599989	73.02702596241107	\N
342	GLASS Scrap - 85.96kg - Quality Fair	Bulk quantity available for bulk buyers.	glass	1763	18	85.96	\N	bag	Fair	/uploads/products/product_462_1780236251931.jpg	\N	t	ACTIVE	462	2026-05-31 14:04:12.232	2026-05-31 14:04:12.232	24.86371253555456	67.0010409170936	\N
343	WOOD Scrap - 45.64kg - Quality Fair	Verified weight and quality.	wood	3049	13	45.64	\N	piece	Fair	/uploads/products/product_488_1780236252233.jpg	\N	t	ACTIVE	488	2026-05-31 14:04:12.539	2026-05-31 14:04:12.539	24.87705594229401	66.99611565743045	\N
344	METAL Scrap - 46.06kg - Quality Poor	Verified weight and quality.	metal	4237	41	46.06	\N	bundle	Poor	/uploads/products/product_491_1780236252540.jpg	\N	t	ACTIVE	491	2026-05-31 14:04:12.847	2026-05-31 14:04:12.847	25.33980326440413	68.42336036773067	\N
345	TEXTILE Scrap - 82.40kg - Quality Fair	Verified weight and quality.	textile	4582	28	82.4	\N	bag	Fair	/uploads/products/product_484_1780236252848.jpg	\N	t	ACTIVE	484	2026-05-31 14:04:13.154	2026-05-31 14:04:13.154	30.1054234786303	71.47920103393666	\N
346	COPPER Scrap - 65.25kg - Quality Poor	High quality scrap material, ideal for recycling.	copper	5075	16	65.25	\N	ton	Poor	/uploads/products/product_470_1780236253155.jpg	\N	t	ACTIVE	470	2026-05-31 14:04:13.461	2026-05-31 14:04:13.461	25.41839729191389	68.43327529129732	\N
347	BRASS Scrap - 42.64kg - Quality Fair	Collected from industrial facilities. Ready for processing.	brass	2640	50	42.64	\N	piece	Fair	/uploads/products/product_458_1780236253462.jpg	\N	t	ACTIVE	458	2026-05-31 14:04:13.703	2026-05-31 14:04:13.703	32.1144971747173	74.12121349290597	\N
348	CARDBOARD Scrap - 34.57kg - Quality Fair	Perfect for manufacturing and industrial use.	cardboard	1011	52	34.57	\N	piece	Fair	/uploads/products/product_461_1780236253704.jpg	\N	t	ACTIVE	461	2026-05-31 14:04:13.946	2026-05-31 14:04:13.946	31.57222398148946	74.31337686225169	\N
349	BRASS Scrap - 39.50kg - Quality Poor	Verified weight and quality.	brass	3793	20	39.5	\N	bundle	Poor	/uploads/products/product_483_1780236253946.jpg	\N	t	ACTIVE	483	2026-05-31 14:04:14.281	2026-05-31 14:04:14.281	33.61960176414931	73.15328965399756	\N
350	GLASS Scrap - 108.37kg - Quality Poor	Recently collected, excellent condition.	glass	798	52	108.37	\N	ton	Poor	/uploads/products/product_456_1780236254282.jpg	\N	t	ACTIVE	456	2026-05-31 14:04:14.523	2026-05-31 14:04:14.523	32.16962749707836	74.15910715535644	\N
351	LEATHER Scrap - 55.82kg - Quality Good	Recently collected, excellent condition.	leather	4305	28	55.82	\N	bag	Good	/uploads/products/product_472_1780236254524.jpg	\N	t	ACTIVE	472	2026-05-31 14:04:14.792	2026-05-31 14:04:14.792	25.38146227103644	68.42905783372443	\N
352	PAPER Scrap - 64.18kg - Quality Good	Bulk quantity available for bulk buyers.	paper	571	44	64.18	\N	bundle	Good	/uploads/products/product_462_1780236254793.jpg	\N	t	ACTIVE	462	2026-05-31 14:04:15.034	2026-05-31 14:04:15.034	24.88874107897232	67.00493179388282	\N
353	COMPOSITE Scrap - 86.49kg - Quality Fair	Verified weight and quality.	composite	3386	42	86.49	\N	piece	Fair	/uploads/products/product_454_1780236255035.jpg	\N	t	ACTIVE	454	2026-05-31 14:04:15.305	2026-05-31 14:04:15.305	32.11135388299296	74.14102266252509	\N
354	COMPOSITE Scrap - 13.80kg - Quality Poor	Sorted and cleaned for easy handling.	composite	1149	33	13.8	\N	ton	Poor	/uploads/products/product_472_1780236255306.jpg	\N	t	ACTIVE	472	2026-05-31 14:04:15.547	2026-05-31 14:04:15.547	25.38719383755595	68.42212032106549	\N
355	TEXTILE Scrap - 67.50kg - Quality Fair	Recently collected, excellent condition.	textile	1088	35	67.5	\N	bundle	Fair	/uploads/products/product_472_1780236255548.jpg	\N	t	ACTIVE	472	2026-05-31 14:04:15.816	2026-05-31 14:04:15.816	25.37912633687813	68.44629354438985	\N
356	CARDBOARD Scrap - 20.05kg - Quality Poor	Eco-friendly scrap collection.	cardboard	789	35	20.05	\N	bag	Poor	/uploads/products/product_486_1780236255817.jpg	\N	t	ACTIVE	486	2026-05-31 14:04:16.123	2026-05-31 14:04:16.123	31.40662966316635	72.32664626062409	\N
357	TEXTILE Scrap - 66.47kg - Quality Fair	Recently collected, excellent condition.	textile	4109	49	66.47	\N	ton	Fair	/uploads/products/product_484_1780236256124.jpg	\N	t	ACTIVE	484	2026-05-31 14:04:16.431	2026-05-31 14:04:16.431	30.12861696775254	71.46643668930267	\N
358	COMPOSITE Scrap - 99.20kg - Quality Poor	Verified weight and quality.	composite	3491	15	99.2	\N	bundle	Poor	/uploads/products/product_467_1780236256431.jpg	\N	t	ACTIVE	467	2026-05-31 14:04:16.673	2026-05-31 14:04:16.673	24.91908488001332	67.01884461250259	\N
359	FOAM Scrap - 42.68kg - Quality Good	Recently collected, excellent condition.	foam	4486	22	42.68	\N	bag	Good	/uploads/products/product_457_1780236256674.jpg	\N	t	ACTIVE	457	2026-05-31 14:04:16.943	2026-05-31 14:04:16.943	24.88344080483741	66.9547835193906	\N
360	RUBBER Scrap - 97.75kg - Quality Fair	Perfect for manufacturing and industrial use.	rubber	3742	25	97.75	\N	bundle	Fair	/uploads/products/product_496_1780236256944.jpg	\N	t	ACTIVE	496	2026-05-31 14:04:17.25	2026-05-31 14:04:17.25	33.99251713105922	71.49508008090102	\N
361	COPPER Scrap - 61.09kg - Quality Poor	Eco-friendly scrap collection.	copper	3272	11	61.09	\N	piece	Poor	/uploads/products/product_488_1780236257251.jpg	\N	t	ACTIVE	488	2026-05-31 14:04:17.559	2026-05-31 14:04:17.559	24.87367412988375	67.00985804573924	\N
362	STEEL Scrap - 60.09kg - Quality Good	Bulk quantity available for bulk buyers.	steel	5003	36	60.09	\N	kg	Good	/uploads/products/product_488_1780236257559.jpg	\N	t	ACTIVE	488	2026-05-31 14:04:17.864	2026-05-31 14:04:17.864	24.85989518251915	66.99986006265053	\N
363	BRASS Scrap - 38.44kg - Quality Fair	Recently collected, excellent condition.	brass	1157	7	38.44	\N	bundle	Fair	/uploads/products/product_469_1780236257865.jpg	\N	t	ACTIVE	469	2026-05-31 14:04:18.107	2026-05-31 14:04:18.107	32.19449627409109	74.15277376638126	\N
364	PLASTIC Scrap - 103.84kg - Quality Poor	Collected from industrial facilities. Ready for processing.	plastic	4181	5	103.84	\N	bag	Poor	/uploads/products/product_486_1780236258108.jpg	\N	t	ACTIVE	486	2026-05-31 14:04:18.377	2026-05-31 14:04:18.377	31.39887928499603	72.32703453225419	\N
365	LEATHER Scrap - 107.71kg - Quality Poor	Verified weight and quality.	leather	2088	26	107.71	\N	bag	Poor	/uploads/products/product_471_1780236258378.jpg	\N	t	ACTIVE	471	2026-05-31 14:04:18.683	2026-05-31 14:04:18.683	31.44385787108681	72.38415560084599	\N
366	COMPOSITE Scrap - 84.99kg - Quality Fair	Bulk quantity available for bulk buyers.	composite	744	11	84.99	\N	piece	Fair	/uploads/products/product_494_1780236258684.jpg	\N	t	ACTIVE	494	2026-05-31 14:04:18.99	2026-05-31 14:04:18.99	25.41551205466826	68.47851503737017	\N
367	METAL Scrap - 83.55kg - Quality Poor	High quality scrap material, ideal for recycling.	metal	4689	37	83.55	\N	bag	Poor	/uploads/products/product_483_1780236258992.jpg	\N	t	ACTIVE	483	2026-05-31 14:04:19.3	2026-05-31 14:04:19.3	33.60012243132032	73.18857366704536	\N
368	FOAM Scrap - 101.31kg - Quality Poor	Sorted and cleaned for easy handling.	foam	4833	28	101.31	\N	piece	Poor	/uploads/products/product_465_1780236259301.jpg	\N	t	ACTIVE	465	2026-05-31 14:04:19.606	2026-05-31 14:04:19.606	30.14373066051874	71.38513504972668	\N
369	METAL Scrap - 16.57kg - Quality Poor	Sorted and cleaned for easy handling.	metal	2702	19	16.57	\N	piece	Poor	/uploads/products/product_458_1780236259607.jpg	\N	t	ACTIVE	458	2026-05-31 14:04:19.891	2026-05-31 14:04:19.891	32.14705978709539	74.15179011808695	\N
370	COPPER Scrap - 33.89kg - Quality Good	Recently collected, excellent condition.	copper	4233	40	33.89	\N	piece	Good	/uploads/products/product_469_1780236259892.jpg	\N	t	ACTIVE	469	2026-05-31 14:04:20.219	2026-05-31 14:04:20.219	32.21984602996996	74.17286256214821	\N
371	GLASS Scrap - 10.75kg - Quality Good	High quality scrap material, ideal for recycling.	glass	2837	49	10.75	\N	bag	Good	/uploads/products/product_453_1780236260220.jpg	\N	t	ACTIVE	453	2026-05-31 14:04:20.526	2026-05-31 14:04:20.526	24.88379487051733	67.04809699722568	\N
372	GLASS Scrap - 44.87kg - Quality Good	Recently collected, excellent condition.	glass	2493	37	44.87	\N	ton	Good	/uploads/products/product_487_1780236260527.jpg	\N	t	ACTIVE	487	2026-05-31 14:04:20.768	2026-05-31 14:04:20.768	33.99107285692946	71.50953704847804	\N
373	STEEL Scrap - 62.99kg - Quality Fair	Bulk quantity available for bulk buyers.	steel	4012	44	62.99	\N	piece	Fair	/uploads/products/product_486_1780236260769.jpg	\N	t	ACTIVE	486	2026-05-31 14:04:21.038	2026-05-31 14:04:21.038	31.37407115348902	72.3254785156933	\N
374	COPPER Scrap - 65.44kg - Quality Good	Bulk quantity available for bulk buyers.	copper	3196	47	65.44	\N	bundle	Good	/uploads/products/product_459_1780236261039.jpg	\N	t	ACTIVE	459	2026-05-31 14:04:21.346	2026-05-31 14:04:21.346	31.37534462168455	72.34337578822226	\N
375	TEXTILE Scrap - 41.65kg - Quality Poor	Verified weight and quality.	textile	2162	30	41.65	\N	bag	Poor	/uploads/products/product_460_1780236261347.jpg	\N	t	ACTIVE	460	2026-05-31 14:04:21.653	2026-05-31 14:04:21.653	31.39005222016964	72.3479163323341	\N
376	ELECTRONICS Scrap - 57.48kg - Quality Poor	Collected from industrial facilities. Ready for processing.	electronics	747	18	57.48	\N	bag	Poor	/uploads/products/product_497_1780236261653.jpg	\N	t	ACTIVE	497	2026-05-31 14:04:21.94	2026-05-31 14:04:21.94	32.17494265649869	74.19826908065116	\N
377	CARDBOARD Scrap - 95.30kg - Quality Poor	Eco-friendly scrap collection.	cardboard	420	40	95.3	\N	piece	Poor	/uploads/products/product_459_1780236261941.jpg	\N	t	ACTIVE	459	2026-05-31 14:04:22.182	2026-05-31 14:04:22.182	31.40922341401331	72.33668822938262	\N
378	ALUMINUM Scrap - 41.49kg - Quality Good	Verified weight and quality.	aluminum	4175	35	41.49	\N	bag	Good	/uploads/products/product_456_1780236262183.jpg	\N	t	ACTIVE	456	2026-05-31 14:04:22.472	2026-05-31 14:04:22.472	32.17324900746188	74.16616255353547	\N
379	LEATHER Scrap - 16.51kg - Quality Good	Recently collected, excellent condition.	leather	2814	23	16.51	\N	bag	Good	/uploads/products/product_455_1780236262473.jpg	\N	t	ACTIVE	455	2026-05-31 14:04:22.779	2026-05-31 14:04:22.779	33.63907353372328	73.15801385223186	\N
380	COPPER Scrap - 85.13kg - Quality Fair	Collected from industrial facilities. Ready for processing.	copper	4387	33	85.13	\N	bag	Fair	/uploads/products/product_470_1780236262780.jpg	\N	t	ACTIVE	470	2026-05-31 14:04:23.087	2026-05-31 14:04:23.087	25.43941075852826	68.45258468683689	\N
381	FOAM Scrap - 94.66kg - Quality Poor	Verified weight and quality.	foam	4459	29	94.66	\N	bundle	Poor	/uploads/products/product_467_1780236263088.jpg	\N	t	ACTIVE	467	2026-05-31 14:04:23.42	2026-05-31 14:04:23.42	24.92773980140997	67.01604711271868	\N
382	ELECTRONICS Scrap - 85.64kg - Quality Poor	Verified weight and quality.	electronics	5094	36	85.64	\N	kg	Poor	/uploads/products/product_458_1780236263421.jpg	\N	t	ACTIVE	458	2026-05-31 14:04:23.664	2026-05-31 14:04:23.664	32.12190492042461	74.16714316289848	\N
383	COPPER Scrap - 98.83kg - Quality Fair	Verified weight and quality.	copper	1598	8	98.83	\N	bag	Fair	/uploads/products/product_497_1780236263665.jpg	\N	t	ACTIVE	497	2026-05-31 14:04:24.009	2026-05-31 14:04:24.009	32.16753459147585	74.18022606675142	\N
384	WOOD Scrap - 68.69kg - Quality Good	Sorted and cleaned for easy handling.	wood	1488	42	68.69	\N	kg	Good	/uploads/products/product_470_1780236264009.jpg	\N	t	ACTIVE	470	2026-05-31 14:04:24.25	2026-05-31 14:04:24.25	25.43558941993712	68.42934736430222	\N
385	COMPOSITE Scrap - 14.41kg - Quality Poor	Perfect for manufacturing and industrial use.	composite	4161	22	14.41	\N	bundle	Poor	/uploads/products/product_458_1780236264251.jpg	\N	t	ACTIVE	458	2026-05-31 14:04:24.493	2026-05-31 14:04:24.493	32.14943831536861	74.12821389820965	\N
386	STEEL Scrap - 43.31kg - Quality Poor	Collected from industrial facilities. Ready for processing.	steel	3514	9	43.31	\N	bag	Poor	/uploads/products/product_492_1780236264493.jpg	\N	t	ACTIVE	492	2026-05-31 14:04:24.735	2026-05-31 14:04:24.735	30.17974292884915	67.07322482009668	\N
387	ALUMINUM Scrap - 103.94kg - Quality Poor	High quality scrap material, ideal for recycling.	aluminum	302	14	103.94	\N	kg	Poor	/uploads/products/product_454_1780236264736.jpg	\N	t	ACTIVE	454	2026-05-31 14:04:24.978	2026-05-31 14:04:24.978	32.14071097078532	74.11933995311455	\N
388	COMPOSITE Scrap - 59.67kg - Quality Fair	Verified weight and quality.	composite	3756	49	59.67	\N	kg	Fair	/uploads/products/product_471_1780236264979.jpg	\N	t	ACTIVE	471	2026-05-31 14:04:25.22	2026-05-31 14:04:25.22	31.43972705293248	72.37899925157933	\N
389	CARDBOARD Scrap - 69.83kg - Quality Poor	Recently collected, excellent condition.	cardboard	4429	19	69.83	\N	bundle	Poor	/uploads/products/product_466_1780236265221.jpg	\N	t	ACTIVE	466	2026-05-31 14:04:25.462	2026-05-31 14:04:25.462	32.1881255245843	74.17136583444734	\N
390	ELECTRONICS Scrap - 95.79kg - Quality Fair	Perfect for manufacturing and industrial use.	electronics	1814	44	95.79	\N	kg	Fair	/uploads/products/product_486_1780236265463.jpg	\N	t	ACTIVE	486	2026-05-31 14:04:25.749	2026-05-31 14:04:25.749	31.38295957451686	72.3243804894714	\N
391	STEEL Scrap - 24.69kg - Quality Good	High quality scrap material, ideal for recycling.	steel	4497	37	24.69	\N	ton	Good	/uploads/products/product_455_1780236265750.jpg	\N	t	ACTIVE	455	2026-05-31 14:04:26.056	2026-05-31 14:04:26.056	33.60723752328979	73.15248644921928	\N
392	COPPER Scrap - 60.77kg - Quality Good	Eco-friendly scrap collection.	copper	4056	42	60.77	\N	bag	Good	/uploads/products/product_487_1780236266057.jpg	\N	t	ACTIVE	487	2026-05-31 14:04:26.364	2026-05-31 14:04:26.364	33.97515148710004	71.4971893564245	\N
393	FOAM Scrap - 52.43kg - Quality Poor	Recently collected, excellent condition.	foam	4031	40	52.43	\N	bag	Poor	/uploads/products/product_489_1780236266365.jpg	\N	t	ACTIVE	489	2026-05-31 14:04:26.606	2026-05-31 14:04:26.606	24.83548384573574	66.994536807662	\N
394	STEEL Scrap - 30.84kg - Quality Poor	Eco-friendly scrap collection.	steel	161	6	30.84	\N	kg	Poor	/uploads/products/product_486_1780236266607.jpg	\N	t	ACTIVE	486	2026-05-31 14:04:26.875	2026-05-31 14:04:26.875	31.37063017612918	72.30598935852952	\N
395	PLASTIC Scrap - 18.43kg - Quality Fair	Verified weight and quality.	plastic	3841	47	18.43	\N	piece	Fair	/uploads/products/product_461_1780236266876.jpg	\N	t	ACTIVE	461	2026-05-31 14:04:27.117	2026-05-31 14:04:27.117	31.59555746019307	74.3083066743491	\N
396	COPPER Scrap - 66.61kg - Quality Fair	High quality scrap material, ideal for recycling.	copper	2755	53	66.61	\N	kg	Fair	/uploads/products/product_461_1780236267118.jpg	\N	t	ACTIVE	461	2026-05-31 14:04:27.359	2026-05-31 14:04:27.359	31.57866014343679	74.3131466436891	\N
397	GLASS Scrap - 81.54kg - Quality Poor	Eco-friendly scrap collection.	glass	995	25	81.54	\N	bundle	Poor	/uploads/products/product_460_1780236267360.jpg	\N	t	ACTIVE	460	2026-05-31 14:04:27.601	2026-05-31 14:04:27.601	31.39789229290958	72.33587757934454	\N
398	COMPOSITE Scrap - 59.46kg - Quality Fair	Bulk quantity available for bulk buyers.	composite	1490	12	59.46	\N	bag	Fair	/uploads/products/product_487_1780236267602.jpg	\N	t	ACTIVE	487	2026-05-31 14:04:27.844	2026-05-31 14:04:27.844	33.94920905243363	71.47925385613837	\N
399	RUBBER Scrap - 90.92kg - Quality Poor	Eco-friendly scrap collection.	rubber	5004	38	90.92	\N	bag	Poor	/uploads/products/product_493_1780236267844.jpg	\N	t	ACTIVE	493	2026-05-31 14:04:28.105	2026-05-31 14:04:28.105	30.21353045326035	67.08684455511535	\N
400	GLASS Scrap - 79.38kg - Quality Fair	Verified weight and quality.	glass	4645	52	79.38	\N	ton	Fair	/uploads/products/product_453_1780236268106.jpg	\N	t	ACTIVE	453	2026-05-31 14:04:28.348	2026-05-31 14:04:28.348	24.87819745404594	67.02613031006153	\N
401	COPPER Scrap - 107.78kg - Quality Fair	Perfect for manufacturing and industrial use.	copper	4634	35	107.78	\N	bag	Fair	/uploads/products/product_499_1780236527350.jpg	\N	t	ACTIVE	499	2026-05-31 14:08:51.174	2026-05-31 14:08:51.174	31.54624336290872	74.32591188363222	\N
402	CARDBOARD Scrap - 75.10kg - Quality Good	Verified weight and quality.	cardboard	690	7	75.1	\N	bundle	Good	/uploads/products/product_504_1780236531176.jpg	\N	t	ACTIVE	504	2026-05-31 14:08:53.735	2026-05-31 14:08:53.735	34.02158724468984	71.52335291491505	\N
403	STEEL Scrap - 107.37kg - Quality Fair	Eco-friendly scrap collection.	steel	1802	24	107.37	\N	piece	Fair	/uploads/products/product_498_1780236533736.jpg	\N	t	ACTIVE	498	2026-05-31 14:08:56.851	2026-05-31 14:08:56.851	24.83636556905332	66.96851935134931	\N
404	FOAM Scrap - 87.14kg - Quality Fair	Bulk quantity available for bulk buyers.	foam	4110	35	87.14	\N	bundle	Fair	/uploads/products/product_539_1780236536852.jpg	\N	t	ACTIVE	539	2026-05-31 14:08:58.854	2026-05-31 14:08:58.854	25.34113427307377	68.47565315043126	\N
405	FOAM Scrap - 32.22kg - Quality Poor	Verified weight and quality.	foam	485	12	32.22	\N	ton	Poor	/uploads/products/product_507_1780236538855.jpg	\N	t	ACTIVE	507	2026-05-31 14:08:59.764	2026-05-31 14:08:59.764	33.65147933058372	73.05918546904057	\N
406	METAL Scrap - 94.44kg - Quality Good	Verified weight and quality.	metal	4545	16	94.44	\N	kg	Good	/uploads/products/product_533_1780236539764.jpg	\N	t	ACTIVE	533	2026-05-31 14:09:02.645	2026-05-31 14:09:02.645	24.90529795311426	66.95868351028314	\N
407	PLASTIC Scrap - 47.15kg - Quality Poor	Perfect for manufacturing and industrial use.	plastic	3647	32	47.15	\N	bundle	Poor	/uploads/products/product_500_1780236542646.jpg	\N	t	ACTIVE	500	2026-05-31 14:09:05.306	2026-05-31 14:09:05.306	33.5175811506987	73.1650892482106	\N
408	RUBBER Scrap - 35.46kg - Quality Good	Bulk quantity available for bulk buyers.	rubber	4147	51	35.46	\N	bundle	Good	/uploads/products/product_513_1780236545307.jpg	\N	t	ACTIVE	513	2026-05-31 14:09:08.276	2026-05-31 14:09:08.276	34.00594548562213	71.5299578525261	\N
409	TEXTILE Scrap - 20.90kg - Quality Good	Verified weight and quality.	textile	4051	23	20.9	\N	kg	Good	/uploads/products/product_505_1780236548278.jpg	\N	t	ACTIVE	505	2026-05-31 14:09:10.674	2026-05-31 14:09:10.674	31.52764940912235	74.3630217951351	\N
410	COMPOSITE Scrap - 77.03kg - Quality Good	High quality scrap material, ideal for recycling.	composite	645	26	77.03	\N	bundle	Good	/uploads/products/product_534_1780236550675.jpg	\N	t	ACTIVE	534	2026-05-31 14:09:12.372	2026-05-31 14:09:12.372	25.35107653608276	68.47603224166896	\N
411	BRASS Scrap - 102.00kg - Quality Poor	Eco-friendly scrap collection.	brass	1517	54	102	\N	ton	Poor	/uploads/products/product_512_1780236552373.jpg	\N	t	ACTIVE	512	2026-05-31 14:09:14.92	2026-05-31 14:09:14.92	25.42604963360749	68.47264632562275	\N
412	PAPER Scrap - 60.54kg - Quality Fair	Eco-friendly scrap collection.	paper	2624	47	60.54	\N	bag	Fair	/uploads/products/product_535_1780236554920.jpg	\N	t	ACTIVE	535	2026-05-31 14:09:17.696	2026-05-31 14:09:17.696	31.43022770004988	72.33393636076997	\N
413	STEEL Scrap - 58.64kg - Quality Good	Perfect for manufacturing and industrial use.	steel	3438	44	58.64	\N	ton	Good	/uploads/products/product_508_1780236557697.jpg	\N	t	ACTIVE	508	2026-05-31 14:09:18.72	2026-05-31 14:09:18.72	32.13005362845902	74.21111041632302	\N
414	STEEL Scrap - 63.63kg - Quality Fair	Bulk quantity available for bulk buyers.	steel	3726	32	63.63	\N	bag	Fair	/uploads/products/product_517_1780236558721.jpg	\N	t	ACTIVE	517	2026-05-31 14:09:19.745	2026-05-31 14:09:19.745	33.72921745070917	73.00873000741419	\N
415	WOOD Scrap - 105.71kg - Quality Good	Eco-friendly scrap collection.	wood	2418	12	105.71	\N	ton	Good	/uploads/products/product_531_1780236559745.jpg	\N	t	ACTIVE	531	2026-05-31 14:09:23.11	2026-05-31 14:09:23.11	31.41265018647523	72.32269434451503	\N
416	RUBBER Scrap - 57.75kg - Quality Good	Bulk quantity available for bulk buyers.	rubber	2941	36	57.75	\N	bundle	Good	/uploads/products/product_540_1780236563111.jpg	\N	t	ACTIVE	540	2026-05-31 14:09:24.019	2026-05-31 14:09:24.019	33.9609435450491	71.46231249126079	\N
417	GLASS Scrap - 37.54kg - Quality Fair	Eco-friendly scrap collection.	glass	1871	51	37.54	\N	piece	Fair	/uploads/products/product_541_1780236564020.jpg	\N	t	ACTIVE	541	2026-05-31 14:09:26.642	2026-05-31 14:09:26.642	33.63135191757325	73.21951445264966	\N
418	RUBBER Scrap - 109.46kg - Quality Poor	Sorted and cleaned for easy handling.	rubber	4358	44	109.46	\N	ton	Poor	/uploads/products/product_542_1780236566643.jpg	\N	t	ACTIVE	542	2026-05-31 14:09:27.645	2026-05-31 14:09:27.645	34.0278490659616	71.4579669437599	\N
419	TEXTILE Scrap - 69.70kg - Quality Fair	Sorted and cleaned for easy handling.	textile	3838	40	69.7	\N	bag	Fair	/uploads/products/product_501_1780236567646.jpg	\N	t	ACTIVE	501	2026-05-31 14:09:28.545	2026-05-31 14:09:28.545	33.59274552078259	73.18942616661329	\N
420	ALUMINUM Scrap - 39.32kg - Quality Good	Verified weight and quality.	aluminum	1022	48	39.32	\N	kg	Good	/uploads/products/product_513_1780236568546.jpg	\N	t	ACTIVE	513	2026-05-31 14:09:30.906	2026-05-31 14:09:30.906	34.04356505120458	71.49465205189352	\N
421	PAPER Scrap - 15.87kg - Quality Fair	High quality scrap material, ideal for recycling.	paper	3651	52	15.87	\N	piece	Fair	/uploads/products/product_531_1780236570907.jpg	\N	t	ACTIVE	531	2026-05-31 14:09:31.798	2026-05-31 14:09:31.798	31.40856483610759	72.31374731105167	\N
422	BRASS Scrap - 95.86kg - Quality Good	Perfect for manufacturing and industrial use.	brass	278	16	95.86	\N	ton	Good	/uploads/products/product_509_1780236571799.jpg	\N	t	ACTIVE	509	2026-05-31 14:09:32.656	2026-05-31 14:09:32.656	31.56021076006329	74.35010749801177	\N
423	LEATHER Scrap - 96.73kg - Quality Fair	Eco-friendly scrap collection.	leather	2338	43	96.73	\N	bundle	Fair	/uploads/products/product_503_1780236572657.jpg	\N	t	ACTIVE	503	2026-05-31 14:09:35.207	2026-05-31 14:09:35.207	33.65486588093758	73.06903426398843	\N
424	PAPER Scrap - 27.85kg - Quality Good	Sorted and cleaned for easy handling.	paper	1968	16	27.85	\N	piece	Good	/uploads/products/product_537_1780236575208.jpg	\N	t	ACTIVE	537	2026-05-31 14:09:36.212	2026-05-31 14:09:36.212	32.16741209263979	74.2399226821892	\N
425	WOOD Scrap - 97.88kg - Quality Good	Sorted and cleaned for easy handling.	wood	2306	9	97.88	\N	kg	Good	/uploads/products/product_535_1780236576214.jpg	\N	t	ACTIVE	535	2026-05-31 14:09:37.152	2026-05-31 14:09:37.152	31.42803208198561	72.32340329275058	\N
426	LEATHER Scrap - 106.68kg - Quality Good	Verified weight and quality.	leather	4066	39	106.68	\N	ton	Good	/uploads/products/product_541_1780236577153.jpg	\N	t	ACTIVE	541	2026-05-31 14:09:38.12	2026-05-31 14:09:38.12	33.59843736200531	73.24063087163759	\N
427	PAPER Scrap - 53.06kg - Quality Fair	Perfect for manufacturing and industrial use.	paper	464	13	53.06	\N	piece	Fair	/uploads/products/product_505_1780236578120.jpg	\N	t	ACTIVE	505	2026-05-31 14:09:38.837	2026-05-31 14:09:38.837	31.53015571553623	74.3799383452305	\N
428	RUBBER Scrap - 73.74kg - Quality Good	Perfect for manufacturing and industrial use.	rubber	3411	23	73.74	\N	kg	Good	/uploads/products/product_514_1780236578838.jpg	\N	t	ACTIVE	514	2026-05-31 14:09:39.815	2026-05-31 14:09:39.815	31.4668216371952	72.39401276537089	\N
429	ALUMINUM Scrap - 14.90kg - Quality Poor	Verified weight and quality.	aluminum	3953	16	14.9	\N	bag	Poor	/uploads/products/product_515_1780236579817.jpg	\N	t	ACTIVE	515	2026-05-31 14:09:40.839	2026-05-31 14:09:40.839	33.66673092159125	73.00606228849259	\N
430	TEXTILE Scrap - 53.54kg - Quality Fair	High quality scrap material, ideal for recycling.	textile	4672	25	53.54	\N	ton	Fair	/uploads/products/product_498_1780236580840.jpg	\N	t	ACTIVE	498	2026-05-31 14:09:41.761	2026-05-31 14:09:41.761	24.83587648542407	66.93749978186267	\N
431	ELECTRONICS Scrap - 58.19kg - Quality Good	Recently collected, excellent condition.	electronics	2227	14	58.19	\N	bag	Good	/uploads/products/product_514_1780236581762.jpg	\N	t	ACTIVE	514	2026-05-31 14:09:44.368	2026-05-31 14:09:44.368	31.44789324917843	72.39452635626121	\N
432	ELECTRONICS Scrap - 106.18kg - Quality Fair	Verified weight and quality.	electronics	3549	44	106.18	\N	bag	Fair	/uploads/products/product_503_1780236584368.jpg	\N	t	ACTIVE	503	2026-05-31 14:09:45.244	2026-05-31 14:09:45.244	33.6234385059664	73.06828527381866	\N
433	METAL Scrap - 13.97kg - Quality Poor	Recently collected, excellent condition.	metal	4543	7	13.97	\N	kg	Poor	/uploads/products/product_511_1780236585244.jpg	\N	t	ACTIVE	511	2026-05-31 14:09:46.155	2026-05-31 14:09:46.155	30.16219350373766	71.38437086945652	\N
434	ALUMINUM Scrap - 66.68kg - Quality Good	Collected from industrial facilities. Ready for processing.	aluminum	1691	54	66.68	\N	bag	Good	/uploads/products/product_506_1780236586156.jpg	\N	t	ACTIVE	506	2026-05-31 14:09:46.576	2026-05-31 14:09:46.576	33.6699315758592	73.05820831495515	\N
435	GLASS Scrap - 47.91kg - Quality Fair	Sorted and cleaned for easy handling.	glass	1032	22	47.91	\N	piece	Fair	/uploads/products/product_514_1780236586577.jpg	\N	t	ACTIVE	514	2026-05-31 14:09:47.598	2026-05-31 14:09:47.598	31.47443096776355	72.35361456465134	\N
436	COMPOSITE Scrap - 78.02kg - Quality Good	Eco-friendly scrap collection.	composite	2348	48	78.02	\N	ton	Good	/uploads/products/product_516_1780236587599.jpg	\N	t	ACTIVE	516	2026-05-31 14:09:48.621	2026-05-31 14:09:48.621	34.08041245841102	71.46656997063837	\N
437	BRASS Scrap - 53.27kg - Quality Poor	Perfect for manufacturing and industrial use.	brass	849	53	53.27	\N	piece	Poor	/uploads/products/product_499_1780236588622.jpg	\N	t	ACTIVE	499	2026-05-31 14:09:49.448	2026-05-31 14:09:49.448	31.58427488522987	74.3188170826446	\N
438	COPPER Scrap - 82.24kg - Quality Fair	High quality scrap material, ideal for recycling.	copper	2833	16	82.24	\N	ton	Fair	/uploads/products/product_529_1780236589449.jpg	\N	t	ACTIVE	529	2026-05-31 14:09:50.363	2026-05-31 14:09:50.363	30.10657451758528	71.3890836130691	\N
439	COMPOSITE Scrap - 38.91kg - Quality Poor	Perfect for manufacturing and industrial use.	composite	4388	19	38.91	\N	bundle	Poor	/uploads/products/product_508_1780236590364.jpg	\N	t	ACTIVE	508	2026-05-31 14:09:51.387	2026-05-31 14:09:51.387	32.12201466147138	74.19212577710272	\N
440	ALUMINUM Scrap - 34.72kg - Quality Fair	High quality scrap material, ideal for recycling.	aluminum	3691	47	34.72	\N	piece	Fair	/uploads/products/product_513_1780236591388.jpg	\N	t	ACTIVE	513	2026-05-31 14:09:52.314	2026-05-31 14:09:52.314	34.04026156306782	71.49951089675635	\N
441	WOOD Scrap - 41.12kg - Quality Poor	Perfect for manufacturing and industrial use.	wood	2205	26	41.12	\N	bag	Poor	/uploads/products/product_531_1780236592315.jpg	\N	t	ACTIVE	531	2026-05-31 14:09:53.173	2026-05-31 14:09:53.173	31.41747762698627	72.31641847759624	\N
442	PLASTIC Scrap - 35.13kg - Quality Fair	Verified weight and quality.	plastic	3109	17	35.13	\N	bundle	Fair	/uploads/products/product_501_1780236593173.jpg	\N	t	ACTIVE	501	2026-05-31 14:09:53.585	2026-05-31 14:09:53.585	33.58548417865591	73.1981416012291	\N
443	RUBBER Scrap - 60.22kg - Quality Fair	Recently collected, excellent condition.	rubber	760	8	60.22	\N	bag	Fair	/uploads/products/product_538_1780236593585.jpg	\N	t	ACTIVE	538	2026-05-31 14:09:54.56	2026-05-31 14:09:54.56	30.18143847222299	71.44684044002454	\N
444	COPPER Scrap - 79.75kg - Quality Fair	Perfect for manufacturing and industrial use.	copper	1724	52	79.75	\N	piece	Fair	/uploads/products/product_509_1780236594566.jpg	\N	t	ACTIVE	509	2026-05-31 14:09:55.382	2026-05-31 14:09:55.382	31.56258701145101	74.38914648154017	\N
445	TEXTILE Scrap - 66.28kg - Quality Fair	Collected from industrial facilities. Ready for processing.	textile	2277	19	66.28	\N	ton	Fair	/uploads/products/product_500_1780236595382.jpg	\N	t	ACTIVE	500	2026-05-31 14:09:56.404	2026-05-31 14:09:56.404	33.53130448682221	73.15323418815258	\N
446	PLASTIC Scrap - 89.02kg - Quality Poor	Eco-friendly scrap collection.	plastic	768	5	89.02	\N	piece	Poor	/uploads/products/product_514_1780236596405.jpg	\N	t	ACTIVE	514	2026-05-31 14:09:57.429	2026-05-31 14:09:57.429	31.48034670889101	72.36176231507612	\N
447	PAPER Scrap - 42.55kg - Quality Fair	Bulk quantity available for bulk buyers.	paper	3400	20	42.55	\N	piece	Fair	/uploads/products/product_502_1780236597430.jpg	\N	t	ACTIVE	502	2026-05-31 14:09:58.145	2026-05-31 14:09:58.145	25.36282682382627	68.52586698149152	\N
448	COPPER Scrap - 51.74kg - Quality Poor	Collected from industrial facilities. Ready for processing.	copper	2361	27	51.74	\N	piece	Poor	/uploads/products/product_541_1780236598146.jpg	\N	t	ACTIVE	541	2026-05-31 14:09:58.908	2026-05-31 14:09:58.908	33.61664296903874	73.24762452297901	\N
449	FOAM Scrap - 93.50kg - Quality Poor	Verified weight and quality.	foam	1660	27	93.5	\N	ton	Poor	/uploads/products/product_508_1780236598909.jpg	\N	t	ACTIVE	508	2026-05-31 14:09:59.579	2026-05-31 14:09:59.579	32.13433361609546	74.19596236185882	\N
450	CARDBOARD Scrap - 83.01kg - Quality Poor	High quality scrap material, ideal for recycling.	cardboard	2616	12	83.01	\N	piece	Poor	/uploads/products/product_510_1780236599580.jpg	\N	t	ACTIVE	510	2026-05-31 14:10:00.442	2026-05-31 14:10:00.442	33.5806813460073	73.22070190996143	\N
451	RUBBER Scrap - 61.14kg - Quality Poor	Verified weight and quality.	rubber	2264	32	61.14	\N	bundle	Poor	/uploads/products/product_507_1780236600443.jpg	\N	t	ACTIVE	507	2026-05-31 14:10:01.415	2026-05-31 14:10:01.415	33.66281841576406	73.05255226710419	\N
452	LEATHER Scrap - 71.93kg - Quality Fair	Bulk quantity available for bulk buyers.	leather	3250	44	71.93	\N	kg	Fair	/uploads/products/product_534_1780236601416.jpg	\N	t	ACTIVE	534	2026-05-31 14:10:02.241	2026-05-31 14:10:02.241	25.3502425975265	68.4689187183237	\N
453	COMPOSITE Scrap - 49.95kg - Quality Poor	Perfect for manufacturing and industrial use.	composite	499	21	49.95	\N	bundle	Poor	/uploads/products/product_512_1780236602242.jpg	\N	t	ACTIVE	512	2026-05-31 14:10:02.855	2026-05-31 14:10:02.855	25.41804650977419	68.45814287592783	\N
454	COMPOSITE Scrap - 44.46kg - Quality Poor	Recently collected, excellent condition.	composite	3586	50	44.46	\N	piece	Poor	/uploads/products/product_528_1780236602855.jpg	\N	t	ACTIVE	528	2026-05-31 14:10:03.16	2026-05-31 14:10:03.16	33.62086417078175	73.19514763603513	\N
455	PAPER Scrap - 25.71kg - Quality Good	Sorted and cleaned for easy handling.	paper	2644	35	25.71	\N	ton	Good	/uploads/products/product_536_1780236603160.jpg	\N	t	ACTIVE	536	2026-05-31 14:10:03.982	2026-05-31 14:10:03.982	30.14424994221833	71.35958154779404	\N
456	ALUMINUM Scrap - 44.11kg - Quality Fair	Recently collected, excellent condition.	aluminum	2347	16	44.11	\N	bundle	Fair	/uploads/products/product_500_1780236603983.jpg	\N	t	ACTIVE	500	2026-05-31 14:10:04.699	2026-05-31 14:10:04.699	33.50947435116998	73.14600390701528	\N
457	LEATHER Scrap - 96.90kg - Quality Good	Sorted and cleaned for easy handling.	leather	3747	32	96.9	\N	bag	Good	/uploads/products/product_539_1780236604701.jpg	\N	t	ACTIVE	539	2026-05-31 14:10:05.62	2026-05-31 14:10:05.62	25.34113914203326	68.45322166877386	\N
458	FOAM Scrap - 104.54kg - Quality Good	Collected from industrial facilities. Ready for processing.	foam	1767	36	104.54	\N	piece	Good	/uploads/products/product_528_1780236605621.jpg	\N	t	ACTIVE	528	2026-05-31 14:10:06.44	2026-05-31 14:10:06.44	33.61138639633654	73.19260731718488	\N
459	ELECTRONICS Scrap - 65.92kg - Quality Fair	Verified weight and quality.	electronics	3230	20	65.92	\N	bundle	Fair	/uploads/products/product_501_1780236606441.jpg	\N	t	ACTIVE	501	2026-05-31 14:10:07.1	2026-05-31 14:10:07.1	33.57215705138991	73.19100887842183	\N
460	PAPER Scrap - 99.05kg - Quality Good	Verified weight and quality.	paper	492	45	99.05	\N	piece	Good	/uploads/products/product_534_1780236607101.jpg	\N	t	ACTIVE	534	2026-05-31 14:10:08.182	2026-05-31 14:10:08.182	25.33890370698308	68.47727954237652	\N
461	BRASS Scrap - 45.08kg - Quality Poor	Eco-friendly scrap collection.	brass	1954	26	45.08	\N	piece	Poor	/uploads/products/product_516_1780236608185.jpg	\N	t	ACTIVE	516	2026-05-31 14:10:09.204	2026-05-31 14:10:09.204	34.05226985956565	71.49908730346723	\N
462	BRASS Scrap - 99.92kg - Quality Poor	High quality scrap material, ideal for recycling.	brass	2441	10	99.92	\N	ton	Poor	/uploads/products/product_517_1780236609215.jpg	\N	t	ACTIVE	517	2026-05-31 14:10:10.177	2026-05-31 14:10:10.177	33.73633723975153	73.02330325767149	\N
463	BRASS Scrap - 61.93kg - Quality Fair	High quality scrap material, ideal for recycling.	brass	348	14	61.93	\N	bundle	Fair	/uploads/products/product_504_1780236610180.jpg	\N	t	ACTIVE	504	2026-05-31 14:10:10.646	2026-05-31 14:10:10.646	34.01321238805417	71.50456792929148	\N
464	PLASTIC Scrap - 15.96kg - Quality Fair	Sorted and cleaned for easy handling.	plastic	4088	36	15.96	\N	piece	Fair	/uploads/products/product_530_1780236610659.jpg	\N	t	ACTIVE	530	2026-05-31 14:10:11.65	2026-05-31 14:10:11.65	25.44301012884794	68.42725017401662	\N
465	CARDBOARD Scrap - 109.00kg - Quality Fair	Collected from industrial facilities. Ready for processing.	cardboard	1237	43	109	\N	bundle	Fair	/uploads/products/product_529_1780236611655.jpg	\N	t	ACTIVE	529	2026-05-31 14:10:12.38	2026-05-31 14:10:12.38	30.10772368531284	71.3780330837137	\N
466	TEXTILE Scrap - 41.46kg - Quality Fair	Verified weight and quality.	textile	2058	11	41.46	\N	ton	Fair	/uploads/products/product_499_1780236612383.jpg	\N	t	ACTIVE	499	2026-05-31 14:10:13.438	2026-05-31 14:10:13.438	31.56638034204918	74.3208318902576	\N
467	RUBBER Scrap - 50.83kg - Quality Fair	Collected from industrial facilities. Ready for processing.	rubber	3935	38	50.83	\N	bag	Fair	/uploads/products/product_509_1780236613456.jpg	\N	t	ACTIVE	509	2026-05-31 14:10:14.387	2026-05-31 14:10:14.387	31.55874482145396	74.36440155734643	\N
468	TEXTILE Scrap - 84.58kg - Quality Poor	Recently collected, excellent condition.	textile	2664	5	84.58	\N	ton	Poor	/uploads/products/product_533_1780236614395.jpg	\N	t	ACTIVE	533	2026-05-31 14:10:15.365	2026-05-31 14:10:15.365	24.88056405829652	66.94959780265182	\N
469	METAL Scrap - 15.63kg - Quality Fair	Bulk quantity available for bulk buyers.	metal	4023	43	15.63	\N	ton	Fair	/uploads/products/product_513_1780236615403.jpg	\N	t	ACTIVE	513	2026-05-31 14:10:15.812	2026-05-31 14:10:15.812	34.02002307760682	71.4840954393373	\N
470	PAPER Scrap - 73.68kg - Quality Poor	Perfect for manufacturing and industrial use.	paper	562	50	73.68	\N	bag	Poor	/uploads/products/product_499_1780236615816.jpg	\N	t	ACTIVE	499	2026-05-31 14:10:16.591	2026-05-31 14:10:16.591	31.57484231791599	74.33013483329763	\N
471	PAPER Scrap - 55.59kg - Quality Poor	Bulk quantity available for bulk buyers.	paper	4254	19	55.59	\N	kg	Poor	/uploads/products/product_505_1780236616592.jpg	\N	t	ACTIVE	505	2026-05-31 14:10:17.706	2026-05-31 14:10:17.706	31.5350538446504	74.3616869096448	\N
472	CARDBOARD Scrap - 102.89kg - Quality Fair	High quality scrap material, ideal for recycling.	cardboard	209	8	102.89	\N	piece	Fair	/uploads/products/product_533_1780236617707.jpg	\N	t	ACTIVE	533	2026-05-31 14:10:18.466	2026-05-31 14:10:18.466	24.85795583064817	66.97278400154246	\N
473	PAPER Scrap - 86.38kg - Quality Fair	Recently collected, excellent condition.	paper	1109	32	86.38	\N	bag	Fair	/uploads/products/product_510_1780236618467.jpg	\N	t	ACTIVE	510	2026-05-31 14:10:19.343	2026-05-31 14:10:19.343	33.56293720253262	73.20265496752317	\N
474	WOOD Scrap - 30.89kg - Quality Good	Perfect for manufacturing and industrial use.	wood	4645	37	30.89	\N	kg	Good	/uploads/products/product_498_1780236619344.jpg	\N	t	ACTIVE	498	2026-05-31 14:10:20.365	2026-05-31 14:10:20.365	24.80867825187397	66.98046204873843	\N
475	PLASTIC Scrap - 24.67kg - Quality Good	High quality scrap material, ideal for recycling.	plastic	2205	22	24.67	\N	kg	Good	/uploads/products/product_528_1780236620366.jpg	\N	t	ACTIVE	528	2026-05-31 14:10:21.063	2026-05-31 14:10:21.063	33.58870153069559	73.19292336875033	\N
476	BRASS Scrap - 11.21kg - Quality Fair	Perfect for manufacturing and industrial use.	brass	292	6	11.21	\N	bag	Fair	/uploads/products/product_509_1780236621064.jpg	\N	t	ACTIVE	509	2026-05-31 14:10:22.024	2026-05-31 14:10:22.024	31.55230518521151	74.37147836444869	\N
477	CARDBOARD Scrap - 53.05kg - Quality Poor	Eco-friendly scrap collection.	cardboard	341	24	53.05	\N	kg	Poor	/uploads/products/product_504_1780236622025.jpg	\N	t	ACTIVE	504	2026-05-31 14:10:22.722	2026-05-31 14:10:22.722	33.98457689666689	71.533203563504	\N
478	ELECTRONICS Scrap - 37.32kg - Quality Good	High quality scrap material, ideal for recycling.	electronics	2571	53	37.32	\N	ton	Good	/uploads/products/product_504_1780236622722.jpg	\N	t	ACTIVE	504	2026-05-31 14:10:23.642	2026-05-31 14:10:23.642	34.02257381204884	71.49895071619778	\N
479	STEEL Scrap - 92.49kg - Quality Good	Sorted and cleaned for easy handling.	steel	1289	32	92.49	\N	kg	Good	/uploads/products/product_504_1780236623643.jpg	\N	t	ACTIVE	504	2026-05-31 14:10:24.36	2026-05-31 14:10:24.36	34.0011178046727	71.5056865969598	\N
480	PAPER Scrap - 103.50kg - Quality Fair	Recently collected, excellent condition.	paper	4684	43	103.5	\N	piece	Fair	/uploads/products/product_514_1780236624361.jpg	\N	t	ACTIVE	514	2026-05-31 14:10:25.077	2026-05-31 14:10:25.077	31.46571390604933	72.37446489477037	\N
481	ELECTRONICS Scrap - 43.02kg - Quality Fair	Verified weight and quality.	electronics	3389	33	43.02	\N	piece	Fair	/uploads/products/product_507_1780236625078.jpg	\N	t	ACTIVE	507	2026-05-31 14:10:26.204	2026-05-31 14:10:26.204	33.6843862597354	73.06870096264069	\N
482	LEATHER Scrap - 17.58kg - Quality Poor	Verified weight and quality.	leather	1727	15	17.58	\N	piece	Poor	/uploads/products/product_511_1780236626207.jpg	\N	t	ACTIVE	511	2026-05-31 14:10:40.335	2026-05-31 14:10:40.335	30.17060893204929	71.41791960681508	\N
483	LEATHER Scrap - 48.15kg - Quality Good	Bulk quantity available for bulk buyers.	leather	1160	42	48.15	\N	piece	Good	/uploads/products/product_498_1780236640336.jpg	\N	t	ACTIVE	498	2026-05-31 14:10:41.46	2026-05-31 14:10:41.46	24.80816661048286	66.98085559014194	\N
484	FOAM Scrap - 16.68kg - Quality Fair	Perfect for manufacturing and industrial use.	foam	3222	17	16.68	\N	bag	Fair	/uploads/products/product_537_1780236641461.jpg	\N	t	ACTIVE	537	2026-05-31 14:10:42.076	2026-05-31 14:10:42.076	32.18596638111478	74.23533885212882	\N
485	LEATHER Scrap - 75.53kg - Quality Fair	Sorted and cleaned for easy handling.	leather	1369	17	75.53	\N	bag	Fair	/uploads/products/product_542_1780236642077.jpg	\N	t	ACTIVE	542	2026-05-31 14:10:42.69	2026-05-31 14:10:42.69	33.99670162898664	71.46173237001636	\N
486	PLASTIC Scrap - 96.48kg - Quality Fair	Verified weight and quality.	plastic	1955	38	96.48	\N	piece	Fair	/uploads/products/product_502_1780236642690.jpg	\N	t	ACTIVE	502	2026-05-31 14:10:43.918	2026-05-31 14:10:43.918	25.36298285696514	68.47906715367282	\N
487	TEXTILE Scrap - 92.67kg - Quality Fair	Collected from industrial facilities. Ready for processing.	textile	4629	36	92.67	\N	piece	Fair	/uploads/products/product_536_1780236643919.jpg	\N	t	ACTIVE	536	2026-05-31 14:10:44.989	2026-05-31 14:10:44.989	30.14557529064698	71.37062669431758	\N
488	ALUMINUM Scrap - 30.02kg - Quality Fair	Verified weight and quality.	aluminum	3853	32	30.02	\N	piece	Fair	/uploads/products/product_508_1780236644990.jpg	\N	t	ACTIVE	508	2026-05-31 14:10:45.954	2026-05-31 14:10:45.954	32.11655288297614	74.17589014836646	\N
489	ALUMINUM Scrap - 76.16kg - Quality Fair	Eco-friendly scrap collection.	aluminum	4434	51	76.16	\N	bag	Fair	/uploads/products/product_505_1780236645956.jpg	\N	t	ACTIVE	505	2026-05-31 14:10:46.992	2026-05-31 14:10:46.992	31.52933891724247	74.37511722878722	\N
490	PLASTIC Scrap - 95.86kg - Quality Fair	Collected from industrial facilities. Ready for processing.	plastic	265	15	95.86	\N	bundle	Fair	/uploads/products/product_505_1780236646992.jpg	\N	t	ACTIVE	505	2026-05-31 14:10:47.825	2026-05-31 14:10:47.825	31.53207558293816	74.36315071330753	\N
491	METAL Scrap - 99.91kg - Quality Fair	Eco-friendly scrap collection.	metal	3265	43	99.91	\N	bag	Fair	/uploads/products/product_528_1780236647827.jpg	\N	t	ACTIVE	528	2026-05-31 14:10:48.833	2026-05-31 14:10:48.833	33.61281365370413	73.19522419754486	\N
492	BRASS Scrap - 63.63kg - Quality Good	Perfect for manufacturing and industrial use.	brass	2380	11	63.63	\N	bundle	Good	/uploads/products/product_514_1780236648834.jpg	\N	t	ACTIVE	514	2026-05-31 14:10:49.224	2026-05-31 14:10:49.224	31.44591181	72.36562090275247	\N
493	PLASTIC Scrap - 98.47kg - Quality Poor	Sorted and cleaned for easy handling.	plastic	1180	43	98.47	\N	kg	Poor	/uploads/products/product_517_1780236649225.jpg	\N	t	ACTIVE	517	2026-05-31 14:10:49.653	2026-05-31 14:10:49.653	33.71949732454996	73.03290884049787	\N
494	ALUMINUM Scrap - 100.27kg - Quality Poor	Bulk quantity available for bulk buyers.	aluminum	3685	14	100.27	\N	kg	Poor	/uploads/products/product_500_1780236649654.jpg	\N	t	ACTIVE	500	2026-05-31 14:10:50.521	2026-05-31 14:10:50.521	33.52044562269161	73.17911035832823	\N
495	WOOD Scrap - 71.79kg - Quality Poor	High quality scrap material, ideal for recycling.	wood	4629	45	71.79	\N	bag	Poor	/uploads/products/product_533_1780236650524.jpg	\N	t	ACTIVE	533	2026-05-31 14:10:51.397	2026-05-31 14:10:51.397	24.86187558989899	66.94482315773652	\N
496	BRASS Scrap - 10.50kg - Quality Poor	Sorted and cleaned for easy handling.	brass	4326	29	10.5	\N	ton	Poor	/uploads/products/product_517_1780236651398.jpg	\N	t	ACTIVE	517	2026-05-31 14:10:52.359	2026-05-31 14:10:52.359	33.71583361381409	73.02960494898264	\N
497	FOAM Scrap - 40.56kg - Quality Fair	Collected from industrial facilities. Ready for processing.	foam	2298	7	40.56	\N	bundle	Fair	/uploads/products/product_517_1780236652359.jpg	\N	t	ACTIVE	517	2026-05-31 14:10:53.032	2026-05-31 14:10:53.032	33.71319020448563	73.0259410690079	\N
498	ELECTRONICS Scrap - 96.01kg - Quality Good	Bulk quantity available for bulk buyers.	electronics	3062	41	96.01	\N	piece	Good	/uploads/products/product_535_1780236653033.jpg	\N	t	ACTIVE	535	2026-05-31 14:10:53.953	2026-05-31 14:10:53.953	31.41240034778554	72.32444608253581	\N
499	ELECTRONICS Scrap - 76.08kg - Quality Fair	High quality scrap material, ideal for recycling.	electronics	1820	38	76.08	\N	bundle	Fair	/uploads/products/product_504_1780236653954.jpg	\N	t	ACTIVE	504	2026-05-31 14:10:54.885	2026-05-31 14:10:54.885	34.00731553778225	71.53412003833945	\N
500	LEATHER Scrap - 53.29kg - Quality Fair	Sorted and cleaned for easy handling.	leather	3845	16	53.29	\N	ton	Fair	/uploads/products/product_530_1780236654886.jpg	\N	t	ACTIVE	530	2026-05-31 14:10:56.005	2026-05-31 14:10:56.005	25.45891025728091	68.43498892002663	\N
501	PAPER Scrap - 77.13kg - Quality Good	Sorted and cleaned for easy handling.	paper	4520	41	77.13	\N	ton	Good	/uploads/products/product_512_1780236656006.jpg	\N	t	ACTIVE	512	2026-05-31 14:10:57.026	2026-05-31 14:10:57.026	25.42287333220667	68.43963401349262	\N
502	PAPER Scrap - 75.63kg - Quality Good	Sorted and cleaned for easy handling.	paper	4435	33	75.63	\N	bundle	Good	/uploads/products/product_514_1780236657026.jpg	\N	t	ACTIVE	514	2026-05-31 14:10:58.05	2026-05-31 14:10:58.05	31.44335090333248	72.37125428445825	\N
503	BRASS Scrap - 25.58kg - Quality Poor	Sorted and cleaned for easy handling.	brass	2946	48	25.58	\N	kg	Poor	/uploads/products/product_514_1780236658051.jpg	\N	t	ACTIVE	514	2026-05-31 14:10:58.812	2026-05-31 14:10:58.812	31.47251044455316	72.37645804018848	\N
504	WOOD Scrap - 87.70kg - Quality Good	High quality scrap material, ideal for recycling.	wood	1115	18	87.7	\N	ton	Good	/uploads/products/product_511_1780236658813.jpg	\N	t	ACTIVE	511	2026-05-31 14:10:59.996	2026-05-31 14:10:59.996	30.18115489561536	71.39520533285851	\N
505	ELECTRONICS Scrap - 77.16kg - Quality Poor	Eco-friendly scrap collection.	electronics	1039	22	77.16	\N	piece	Poor	/uploads/products/product_498_1780236659997.jpg	\N	t	ACTIVE	498	2026-05-31 14:11:00.962	2026-05-31 14:11:00.962	24.79848303560159	66.98471579477103	\N
506	PAPER Scrap - 78.10kg - Quality Fair	Eco-friendly scrap collection.	paper	5033	32	78.1	\N	ton	Fair	/uploads/products/product_529_1780236660962.jpg	\N	t	ACTIVE	529	2026-05-31 14:11:01.813	2026-05-31 14:11:01.813	30.12842126933335	71.40040614195088	\N
507	STEEL Scrap - 19.06kg - Quality Good	High quality scrap material, ideal for recycling.	steel	1467	7	19.06	\N	ton	Good	/uploads/products/product_510_1780236661814.jpg	\N	t	ACTIVE	510	2026-05-31 14:11:02.556	2026-05-31 14:11:02.556	33.55990023431726	73.20725430776375	\N
508	ALUMINUM Scrap - 91.18kg - Quality Good	High quality scrap material, ideal for recycling.	aluminum	975	52	91.18	\N	bag	Good	/uploads/products/product_516_1780236662557.jpg	\N	t	ACTIVE	516	2026-05-31 14:11:03.055	2026-05-31 14:11:03.055	34.0528399892527	71.46565730617556	\N
509	PAPER Scrap - 104.30kg - Quality Poor	Perfect for manufacturing and industrial use.	paper	2239	52	104.3	\N	piece	Poor	/uploads/products/product_515_1780236663056.jpg	\N	t	ACTIVE	515	2026-05-31 14:11:04.077	2026-05-31 14:11:04.077	33.67362641219358	73.01393502768866	\N
510	FOAM Scrap - 94.24kg - Quality Good	Verified weight and quality.	foam	3640	39	94.24	\N	piece	Good	/uploads/products/product_541_1780236664077.jpg	\N	t	ACTIVE	541	2026-05-31 14:11:04.444	2026-05-31 14:11:04.444	33.61686054394538	73.20998609743464	\N
511	PAPER Scrap - 43.15kg - Quality Poor	Eco-friendly scrap collection.	paper	2044	37	43.15	\N	piece	Poor	/uploads/products/product_511_1780236664445.jpg	\N	t	ACTIVE	511	2026-05-31 14:11:05.32	2026-05-31 14:11:05.32	30.17023375757397	71.39237184647159	\N
512	FOAM Scrap - 61.28kg - Quality Poor	High quality scrap material, ideal for recycling.	foam	954	6	61.28	\N	bag	Poor	/uploads/products/product_537_1780236665322.jpg	\N	t	ACTIVE	537	2026-05-31 14:11:05.969	2026-05-31 14:11:05.969	32.18209946932497	74.23436694671398	\N
513	METAL Scrap - 78.39kg - Quality Fair	Collected from industrial facilities. Ready for processing.	metal	1629	44	78.39	\N	ton	Fair	/uploads/products/product_510_1780236665970.jpg	\N	t	ACTIVE	510	2026-05-31 14:11:07.063	2026-05-31 14:11:07.063	33.55536455263317	73.23692871983113	\N
514	BRASS Scrap - 79.41kg - Quality Fair	Sorted and cleaned for easy handling.	brass	1089	35	79.41	\N	ton	Fair	/uploads/products/product_515_1780236667064.jpg	\N	t	ACTIVE	515	2026-05-31 14:11:07.778	2026-05-31 14:11:07.778	33.68082861097352	73.02085060094505	\N
515	STEEL Scrap - 30.69kg - Quality Poor	High quality scrap material, ideal for recycling.	steel	4185	21	30.69	\N	bag	Poor	/uploads/products/product_509_1780236667779.jpg	\N	t	ACTIVE	509	2026-05-31 14:11:08.904	2026-05-31 14:11:08.904	31.54388938521191	74.37178261269746	\N
516	TEXTILE Scrap - 78.49kg - Quality Poor	Recently collected, excellent condition.	textile	3957	39	78.49	\N	ton	Poor	/uploads/products/product_511_1780236668905.jpg	\N	t	ACTIVE	511	2026-05-31 14:11:09.335	2026-05-31 14:11:09.335	30.16064357196665	71.39977347361123	\N
517	WOOD Scrap - 13.25kg - Quality Good	High quality scrap material, ideal for recycling.	wood	1958	51	13.25	\N	ton	Good	/uploads/products/product_514_1780236669336.jpg	\N	t	ACTIVE	514	2026-05-31 14:11:10.177	2026-05-31 14:11:10.177	31.44253739242346	72.36281977582345	\N
518	PLASTIC Scrap - 52.04kg - Quality Fair	Bulk quantity available for bulk buyers.	plastic	4043	6	52.04	\N	bundle	Fair	/uploads/products/product_532_1780236670178.jpg	\N	t	ACTIVE	532	2026-05-31 14:11:10.544	2026-05-31 14:11:10.544	25.38868795493479	68.44743146928909	\N
519	CARDBOARD Scrap - 79.22kg - Quality Fair	Eco-friendly scrap collection.	cardboard	440	15	79.22	\N	kg	Fair	/uploads/products/product_529_1780236670544.jpg	\N	t	ACTIVE	529	2026-05-31 14:11:11.567	2026-05-31 14:11:11.567	30.13701103532684	71.39272306880197	\N
520	LEATHER Scrap - 62.84kg - Quality Fair	Sorted and cleaned for easy handling.	leather	2719	7	62.84	\N	piece	Fair	/uploads/products/product_538_1780236671568.jpg	\N	t	ACTIVE	538	2026-05-31 14:11:12.3	2026-05-31 14:11:12.3	30.20084921905108	71.43963454165663	\N
521	TEXTILE Scrap - 70.00kg - Quality Fair	Collected from industrial facilities. Ready for processing.	textile	5077	40	70	\N	ton	Fair	/uploads/products/product_528_1780236672301.jpg	\N	t	ACTIVE	528	2026-05-31 14:11:13.163	2026-05-31 14:11:13.163	33.60714837571447	73.16210358819465	\N
522	RUBBER Scrap - 37.63kg - Quality Poor	Sorted and cleaned for easy handling.	rubber	3347	16	37.63	\N	piece	Poor	/uploads/products/product_517_1780236673163.jpg	\N	t	ACTIVE	517	2026-05-31 14:11:14.068	2026-05-31 14:11:14.068	33.72799307707655	73.01375558857373	\N
523	CARDBOARD Scrap - 55.90kg - Quality Good	Eco-friendly scrap collection.	cardboard	3972	7	55.9	\N	bundle	Good	/uploads/products/product_515_1780236674069.jpg	\N	t	ACTIVE	515	2026-05-31 14:11:14.796	2026-05-31 14:11:14.796	33.64184564210038	73.02449759232344	\N
524	METAL Scrap - 39.26kg - Quality Good	Perfect for manufacturing and industrial use.	metal	2308	36	39.26	\N	kg	Good	/uploads/products/product_508_1780236674797.jpg	\N	t	ACTIVE	508	2026-05-31 14:11:15.868	2026-05-31 14:11:15.868	32.12346157242794	74.19171977159326	\N
525	PLASTIC Scrap - 89.06kg - Quality Poor	Verified weight and quality.	plastic	783	41	89.06	\N	kg	Poor	/uploads/products/product_512_1780236675869.jpg	\N	t	ACTIVE	512	2026-05-31 14:11:16.891	2026-05-31 14:11:16.891	25.41824118074842	68.48136582161008	\N
526	WOOD Scrap - 41.23kg - Quality Good	Perfect for manufacturing and industrial use.	wood	2881	7	41.23	\N	bag	Good	/uploads/products/product_504_1780236676892.jpg	\N	t	ACTIVE	504	2026-05-31 14:11:17.758	2026-05-31 14:11:17.758	34.0179945659239	71.51068470513995	\N
527	CARDBOARD Scrap - 89.39kg - Quality Fair	High quality scrap material, ideal for recycling.	cardboard	2184	17	89.39	\N	piece	Fair	/uploads/products/product_536_1780236677759.jpg	\N	t	ACTIVE	536	2026-05-31 14:11:18.632	2026-05-31 14:11:18.632	30.14989915900138	71.35550188099248	\N
528	STEEL Scrap - 87.23kg - Quality Fair	Verified weight and quality.	steel	331	33	87.23	\N	kg	Fair	/uploads/products/product_540_1780236678632.jpg	\N	t	ACTIVE	540	2026-05-31 14:11:19.597	2026-05-31 14:11:19.597	33.94754856387109	71.48141680718523	\N
529	ALUMINUM Scrap - 100.59kg - Quality Poor	High quality scrap material, ideal for recycling.	aluminum	3549	43	100.59	\N	kg	Poor	/uploads/products/product_515_1780236679597.jpg	\N	t	ACTIVE	515	2026-05-31 14:11:20.019	2026-05-31 14:11:20.019	33.65747725363016	73.00489889464144	\N
530	ALUMINUM Scrap - 64.61kg - Quality Poor	Recently collected, excellent condition.	aluminum	2256	19	64.61	\N	bag	Poor	/uploads/products/product_537_1780236680020.jpg	\N	t	ACTIVE	537	2026-05-31 14:11:20.99	2026-05-31 14:11:20.99	32.14315029768953	74.22721483111425	\N
531	RUBBER Scrap - 57.51kg - Quality Fair	Sorted and cleaned for easy handling.	rubber	3132	11	57.51	\N	kg	Fair	/uploads/products/product_498_1780236680991.jpg	\N	t	ACTIVE	498	2026-05-31 14:11:22.012	2026-05-31 14:11:22.012	24.8348573000635	66.9643878570443	\N
532	ELECTRONICS Scrap - 78.62kg - Quality Good	Perfect for manufacturing and industrial use.	electronics	1162	41	78.62	\N	kg	Good	/uploads/products/product_508_1780236682013.jpg	\N	t	ACTIVE	508	2026-05-31 14:11:22.933	2026-05-31 14:11:22.933	32.14617489171159	74.20243211265563	\N
533	RUBBER Scrap - 82.03kg - Quality Fair	Recently collected, excellent condition.	rubber	2840	36	82.03	\N	piece	Fair	/uploads/products/product_516_1780236682934.jpg	\N	t	ACTIVE	516	2026-05-31 14:11:23.959	2026-05-31 14:11:23.959	34.04004609816703	71.47973008018116	\N
534	ALUMINUM Scrap - 23.89kg - Quality Fair	Eco-friendly scrap collection.	aluminum	2475	25	23.89	\N	bundle	Fair	/uploads/products/product_511_1780236683960.jpg	\N	t	ACTIVE	511	2026-05-31 14:11:31.433	2026-05-31 14:11:31.433	30.20327359963083	71.38363546367984	\N
535	ELECTRONICS Scrap - 86.94kg - Quality Good	Recently collected, excellent condition.	electronics	2512	17	86.94	\N	bundle	Good	/uploads/products/product_528_1780236691434.jpg	\N	t	ACTIVE	528	2026-05-31 14:11:32.534	2026-05-31 14:11:32.534	33.58554409491094	73.16936922848869	\N
536	BRASS Scrap - 73.57kg - Quality Good	Collected from industrial facilities. Ready for processing.	brass	807	17	73.57	\N	piece	Good	/uploads/products/product_500_1780236692535.jpg	\N	t	ACTIVE	500	2026-05-31 14:11:32.985	2026-05-31 14:11:32.985	33.52949640293743	73.1578433843388	\N
537	COMPOSITE Scrap - 18.96kg - Quality Good	Recently collected, excellent condition.	composite	1978	35	18.96	\N	bag	Good	/uploads/products/product_536_1780236692986.jpg	\N	t	ACTIVE	536	2026-05-31 14:11:34.011	2026-05-31 14:11:34.011	30.14691065937671	71.37516361017778	\N
538	COPPER Scrap - 99.29kg - Quality Fair	Eco-friendly scrap collection.	copper	4817	6	99.29	\N	bundle	Fair	/uploads/products/product_513_1780236694011.jpg	\N	t	ACTIVE	513	2026-05-31 14:11:34.863	2026-05-31 14:11:34.863	33.99648123667706	71.5266883712795	\N
539	METAL Scrap - 50.82kg - Quality Fair	Perfect for manufacturing and industrial use.	metal	1184	30	50.82	\N	piece	Fair	/uploads/products/product_510_1780236694864.jpg	\N	t	ACTIVE	510	2026-05-31 14:11:35.878	2026-05-31 14:11:35.878	33.56303529648753	73.21588636744832	\N
540	RUBBER Scrap - 23.19kg - Quality Good	Sorted and cleaned for easy handling.	rubber	233	37	23.19	\N	bag	Good	/uploads/products/product_530_1780236695879.jpg	\N	t	ACTIVE	530	2026-05-31 14:11:36.862	2026-05-31 14:11:36.862	25.45740390935393	68.46391094969445	\N
541	COMPOSITE Scrap - 82.52kg - Quality Good	Eco-friendly scrap collection.	composite	4306	28	82.52	\N	ton	Good	/uploads/products/product_514_1780236696863.jpg	\N	t	ACTIVE	514	2026-05-31 14:11:37.295	2026-05-31 14:11:37.295	31.46194266832721	72.37784050762751	\N
542	RUBBER Scrap - 27.74kg - Quality Good	Recently collected, excellent condition.	rubber	2861	11	27.74	\N	bundle	Good	/uploads/products/product_536_1780236697296.jpg	\N	t	ACTIVE	536	2026-05-31 14:11:38.171	2026-05-31 14:11:38.171	30.12772628200519	71.37985381277836	\N
543	COPPER Scrap - 62.69kg - Quality Good	Recently collected, excellent condition.	copper	2145	32	62.69	\N	bundle	Good	/uploads/products/product_535_1780236698171.jpg	\N	t	ACTIVE	535	2026-05-31 14:11:39.083	2026-05-31 14:11:39.083	31.41803984248821	72.30056545130954	\N
544	ALUMINUM Scrap - 21.16kg - Quality Fair	Recently collected, excellent condition.	aluminum	3211	49	21.16	\N	ton	Fair	/uploads/products/product_530_1780236699083.jpg	\N	t	ACTIVE	530	2026-05-31 14:11:39.83	2026-05-31 14:11:39.83	25.4386495820488	68.45580491362387	\N
545	PLASTIC Scrap - 90.25kg - Quality Poor	Verified weight and quality.	plastic	333	47	90.25	\N	bundle	Poor	/uploads/products/product_504_1780236699831.jpg	\N	t	ACTIVE	504	2026-05-31 14:11:40.752	2026-05-31 14:11:40.752	34.00701725424631	71.50193438021498	\N
546	PLASTIC Scrap - 79.11kg - Quality Good	Perfect for manufacturing and industrial use.	plastic	1400	24	79.11	\N	bundle	Good	/uploads/products/product_530_1780236700753.jpg	\N	t	ACTIVE	530	2026-05-31 14:11:41.162	2026-05-31 14:11:41.162	25.42338553496264	68.43188536160014	\N
547	PLASTIC Scrap - 109.41kg - Quality Fair	Recently collected, excellent condition.	plastic	5087	7	109.41	\N	kg	Fair	/uploads/products/product_503_1780236701163.jpg	\N	t	ACTIVE	503	2026-05-31 14:11:42.185	2026-05-31 14:11:42.185	33.66048987328301	73.09667398761171	\N
548	BRASS Scrap - 73.54kg - Quality Fair	Eco-friendly scrap collection.	brass	4070	15	73.54	\N	ton	Fair	/uploads/products/product_510_1780236702186.jpg	\N	t	ACTIVE	510	2026-05-31 14:11:42.801	2026-05-31 14:11:42.801	33.58661501136686	73.22477436606762	\N
549	BRASS Scrap - 88.51kg - Quality Fair	Eco-friendly scrap collection.	brass	2275	22	88.51	\N	bundle	Fair	/uploads/products/product_503_1780236702802.jpg	\N	t	ACTIVE	503	2026-05-31 14:11:43.454	2026-05-31 14:11:43.454	33.63038806384111	73.06752249689643	\N
550	PAPER Scrap - 13.96kg - Quality Fair	Collected from industrial facilities. Ready for processing.	paper	1720	23	13.96	\N	bag	Fair	/uploads/products/product_498_1780236703455.jpg	\N	t	ACTIVE	498	2026-05-31 14:11:44.437	2026-05-31 14:11:44.437	24.82177323371593	66.97231984984239	\N
551	CARDBOARD Scrap - 67.72kg - Quality Fair	Collected from industrial facilities. Ready for processing.	cardboard	2522	10	67.72	\N	ton	Fair	/uploads/products/product_507_1780236704438.jpg	\N	t	ACTIVE	507	2026-05-31 14:11:45.402	2026-05-31 14:11:45.402	33.6654308732865	73.0596640114249	\N
552	ELECTRONICS Scrap - 74.83kg - Quality Fair	Perfect for manufacturing and industrial use.	electronics	1627	38	74.83	\N	bag	Fair	/uploads/products/product_512_1780236705403.jpg	\N	t	ACTIVE	512	2026-05-31 14:11:46.282	2026-05-31 14:11:46.282	25.45686400530803	68.47409855355882	\N
553	METAL Scrap - 55.36kg - Quality Fair	Eco-friendly scrap collection.	metal	1719	36	55.36	\N	piece	Fair	/uploads/products/product_530_1780236706284.jpg	\N	t	ACTIVE	530	2026-05-31 14:11:47.306	2026-05-31 14:11:47.306	25.44837336606098	68.43562165514989	\N
554	STEEL Scrap - 23.33kg - Quality Good	High quality scrap material, ideal for recycling.	steel	2154	35	23.33	\N	ton	Good	/uploads/products/product_500_1780236707307.jpg	\N	t	ACTIVE	500	2026-05-31 14:11:48.265	2026-05-31 14:11:48.265	33.55095902075514	73.1554654069643	\N
555	METAL Scrap - 20.88kg - Quality Fair	Sorted and cleaned for easy handling.	metal	5037	19	20.88	\N	kg	Fair	/uploads/products/product_500_1780236708266.jpg	\N	t	ACTIVE	500	2026-05-31 14:11:49.251	2026-05-31 14:11:49.251	33.50231247034598	73.14334666251216	\N
556	ELECTRONICS Scrap - 38.46kg - Quality Good	Recently collected, excellent condition.	electronics	1402	48	38.46	\N	bundle	Good	/uploads/products/product_505_1780236709251.jpg	\N	t	ACTIVE	505	2026-05-31 14:11:50.275	2026-05-31 14:11:50.275	31.52486976792012	74.38290170299163	\N
557	CARDBOARD Scrap - 45.34kg - Quality Fair	Verified weight and quality.	cardboard	3709	14	45.34	\N	kg	Fair	/uploads/products/product_542_1780236710276.jpg	\N	t	ACTIVE	542	2026-05-31 14:11:51.094	2026-05-31 14:11:51.094	33.99035823582026	71.46747286092454	\N
558	PLASTIC Scrap - 33.44kg - Quality Good	Recently collected, excellent condition.	plastic	2502	6	33.44	\N	bag	Good	/uploads/products/product_512_1780236711094.jpg	\N	t	ACTIVE	512	2026-05-31 14:11:51.607	2026-05-31 14:11:51.607	25.42601268817453	68.48031634700048	\N
559	GLASS Scrap - 67.00kg - Quality Poor	Verified weight and quality.	glass	3750	31	67	\N	piece	Poor	/uploads/products/product_512_1780236711608.jpg	\N	t	ACTIVE	512	2026-05-31 14:11:52.528	2026-05-31 14:11:52.528	25.40768456086699	68.44560644458086	\N
560	GLASS Scrap - 14.42kg - Quality Fair	Recently collected, excellent condition.	glass	4274	28	14.42	\N	bag	Fair	/uploads/products/product_511_1780236712529.jpg	\N	t	ACTIVE	511	2026-05-31 14:11:53.079	2026-05-31 14:11:53.079	30.17948401540667	71.3739354750762	\N
561	METAL Scrap - 44.03kg - Quality Fair	Perfect for manufacturing and industrial use.	metal	817	20	44.03	\N	ton	Fair	/uploads/products/product_505_1780236713080.jpg	\N	t	ACTIVE	505	2026-05-31 14:11:54.04	2026-05-31 14:11:54.04	31.53336932141514	74.36021230319574	\N
562	STEEL Scrap - 39.81kg - Quality Good	Perfect for manufacturing and industrial use.	steel	797	51	39.81	\N	ton	Good	/uploads/products/product_517_1780236714041.jpg	\N	t	ACTIVE	517	2026-05-31 14:11:54.932	2026-05-31 14:11:54.932	33.70135902618544	73.00039915742686	\N
563	PAPER Scrap - 95.06kg - Quality Poor	Recently collected, excellent condition.	paper	2505	48	95.06	\N	bag	Poor	/uploads/products/product_536_1780236714932.jpg	\N	t	ACTIVE	536	2026-05-31 14:11:55.947	2026-05-31 14:11:55.947	30.1370874331314	71.39524587705905	\N
564	BRASS Scrap - 37.47kg - Quality Fair	High quality scrap material, ideal for recycling.	brass	247	50	37.47	\N	ton	Fair	/uploads/products/product_508_1780236715948.jpg	\N	t	ACTIVE	508	2026-05-31 14:11:56.868	2026-05-31 14:11:56.868	32.11528200131708	74.18982980478079	\N
565	RUBBER Scrap - 20.46kg - Quality Good	Eco-friendly scrap collection.	rubber	4439	36	20.46	\N	piece	Good	/uploads/products/product_498_1780236716869.jpg	\N	t	ACTIVE	498	2026-05-31 14:11:57.75	2026-05-31 14:11:57.75	24.83190538134188	66.93797637250726	\N
566	FOAM Scrap - 106.88kg - Quality Fair	Bulk quantity available for bulk buyers.	foam	2286	39	106.88	\N	bag	Fair	/uploads/products/product_513_1780236717751.jpg	\N	t	ACTIVE	513	2026-05-31 14:11:58.774	2026-05-31 14:11:58.774	34.03044360662041	71.48759884297068	\N
567	COMPOSITE Scrap - 36.57kg - Quality Fair	Collected from industrial facilities. Ready for processing.	composite	1121	43	36.57	\N	bag	Fair	/uploads/products/product_517_1780236718775.jpg	\N	t	ACTIVE	517	2026-05-31 14:11:59.797	2026-05-31 14:11:59.797	33.71179342172693	73.03575121252109	\N
568	TEXTILE Scrap - 14.25kg - Quality Good	Verified weight and quality.	textile	3041	29	14.25	\N	ton	Good	/uploads/products/product_533_1780236719797.jpg	\N	t	ACTIVE	533	2026-05-31 14:12:00.799	2026-05-31 14:12:00.799	24.8601102304827	66.94659317694993	\N
569	COMPOSITE Scrap - 71.88kg - Quality Good	Perfect for manufacturing and industrial use.	composite	473	53	71.88	\N	piece	Good	/uploads/products/product_513_1780236720800.jpg	\N	t	ACTIVE	513	2026-05-31 14:12:01.312	2026-05-31 14:12:01.312	34.02435500021878	71.51706115166823	\N
570	ELECTRONICS Scrap - 15.55kg - Quality Fair	Sorted and cleaned for easy handling.	electronics	3169	22	15.55	\N	piece	Fair	/uploads/products/product_498_1780236721312.jpg	\N	t	ACTIVE	498	2026-05-31 14:12:02.232	2026-05-31 14:12:02.232	24.81633883189482	66.94560200592214	\N
571	WOOD Scrap - 49.78kg - Quality Poor	Eco-friendly scrap collection.	wood	4459	10	49.78	\N	bag	Poor	/uploads/products/product_538_1780236722233.jpg	\N	t	ACTIVE	538	2026-05-31 14:12:02.666	2026-05-31 14:12:02.666	30.16642674944075	71.45440846229269	\N
572	WOOD Scrap - 104.26kg - Quality Fair	High quality scrap material, ideal for recycling.	wood	3139	30	104.26	\N	bundle	Fair	/uploads/products/product_507_1780236722667.jpg	\N	t	ACTIVE	507	2026-05-31 14:12:03.537	2026-05-31 14:12:03.537	33.67448177935007	73.08204703433023	\N
573	ALUMINUM Scrap - 104.45kg - Quality Poor	Recently collected, excellent condition.	aluminum	4580	35	104.45	\N	bag	Poor	/uploads/products/product_507_1780236723538.jpg	\N	t	ACTIVE	507	2026-05-31 14:12:04.487	2026-05-31 14:12:04.487	33.64534890568969	73.07550102545443	\N
574	RUBBER Scrap - 83.95kg - Quality Fair	Sorted and cleaned for easy handling.	rubber	4158	6	83.95	\N	bundle	Fair	/uploads/products/product_534_1780236724488.jpg	\N	t	ACTIVE	534	2026-05-31 14:12:05.752	2026-05-31 14:12:05.752	25.35270255838284	68.4415844546369	\N
575	COPPER Scrap - 92.86kg - Quality Fair	Eco-friendly scrap collection.	copper	3304	42	92.86	\N	kg	Fair	/uploads/products/product_537_1780236725753.jpg	\N	t	ACTIVE	537	2026-05-31 14:12:06.98	2026-05-31 14:12:06.98	32.18547194647677	74.21144710873592	\N
576	PLASTIC Scrap - 99.62kg - Quality Fair	High quality scrap material, ideal for recycling.	plastic	5089	39	99.62	\N	bag	Fair	/uploads/products/product_515_1780236726981.jpg	\N	t	ACTIVE	515	2026-05-31 14:12:07.402	2026-05-31 14:12:07.402	33.68124521684851	72.9866185480835	\N
577	RUBBER Scrap - 97.47kg - Quality Good	Sorted and cleaned for easy handling.	rubber	3375	38	97.47	\N	ton	Good	/uploads/products/product_541_1780236727403.jpg	\N	t	ACTIVE	541	2026-05-31 14:12:08.415	2026-05-31 14:12:08.415	33.58619488542933	73.24431060570755	\N
578	FOAM Scrap - 83.93kg - Quality Fair	High quality scrap material, ideal for recycling.	foam	4659	24	83.93	\N	ton	Fair	/uploads/products/product_529_1780236728416.jpg	\N	t	ACTIVE	529	2026-05-31 14:12:09.438	2026-05-31 14:12:09.438	30.14778760195613	71.39512312052001	\N
579	ALUMINUM Scrap - 91.52kg - Quality Poor	Recently collected, excellent condition.	aluminum	726	29	91.52	\N	ton	Poor	/uploads/products/product_501_1780236729439.jpg	\N	t	ACTIVE	501	2026-05-31 14:12:09.849	2026-05-31 14:12:09.849	33.58734560802784	73.21381795537386	\N
580	TEXTILE Scrap - 104.57kg - Quality Poor	Perfect for manufacturing and industrial use.	textile	3942	23	104.57	\N	piece	Poor	/uploads/products/product_510_1780236729850.jpg	\N	t	ACTIVE	510	2026-05-31 14:12:10.858	2026-05-31 14:12:10.858	33.55786424753704	73.20554920967675	\N
581	COPPER Scrap - 49.73kg - Quality Fair	Sorted and cleaned for easy handling.	copper	1832	9	49.73	\N	bundle	Fair	/uploads/products/product_535_1780236730859.jpg	\N	t	ACTIVE	535	2026-05-31 14:12:11.677	2026-05-31 14:12:11.677	31.43646400385418	72.30928354954891	\N
582	PAPER Scrap - 16.13kg - Quality Good	High quality scrap material, ideal for recycling.	paper	4925	23	16.13	\N	ton	Good	/uploads/products/product_529_1780236731678.jpg	\N	t	ACTIVE	529	2026-05-31 14:12:12.087	2026-05-31 14:12:12.087	30.1413614227365	71.37403389701211	\N
583	ALUMINUM Scrap - 66.74kg - Quality Fair	Sorted and cleaned for easy handling.	aluminum	163	28	66.74	\N	bundle	Fair	/uploads/products/product_499_1780236732087.jpg	\N	t	ACTIVE	499	2026-05-31 14:12:12.533	2026-05-31 14:12:12.533	31.54316329221717	74.32125843150732	\N
584	RUBBER Scrap - 92.62kg - Quality Fair	Perfect for manufacturing and industrial use.	rubber	4992	35	92.62	\N	piece	Fair	/uploads/products/product_504_1780236732534.jpg	\N	t	ACTIVE	504	2026-05-31 14:12:12.981	2026-05-31 14:12:12.981	33.99101120393392	71.49429987908916	\N
585	COPPER Scrap - 30.59kg - Quality Poor	Sorted and cleaned for easy handling.	copper	622	14	30.59	\N	bundle	Poor	/uploads/products/product_507_1780236732982.jpg	\N	t	ACTIVE	507	2026-05-31 14:12:13.827	2026-05-31 14:12:13.827	33.66096618043068	73.0970421358875	\N
586	METAL Scrap - 18.78kg - Quality Poor	Verified weight and quality.	metal	3142	23	18.78	\N	bag	Poor	/uploads/products/product_514_1780236733828.jpg	\N	t	ACTIVE	514	2026-05-31 14:12:14.726	2026-05-31 14:12:14.726	31.46251005622096	72.36327095645336	\N
587	COPPER Scrap - 70.85kg - Quality Poor	Recently collected, excellent condition.	copper	811	7	70.85	\N	piece	Poor	/uploads/products/product_509_1780236734727.jpg	\N	t	ACTIVE	509	2026-05-31 14:12:15.26	2026-05-31 14:12:15.26	31.56239494508769	74.34899672449359	\N
588	COPPER Scrap - 53.27kg - Quality Good	Perfect for manufacturing and industrial use.	copper	3266	30	53.27	\N	bundle	Good	/uploads/products/product_500_1780236735261.jpg	\N	t	ACTIVE	500	2026-05-31 14:12:15.67	2026-05-31 14:12:15.67	33.50347013646446	73.14999070636539	\N
589	STEEL Scrap - 97.88kg - Quality Good	Verified weight and quality.	steel	1488	45	97.88	\N	ton	Good	/uploads/products/product_513_1780236735671.jpg	\N	t	ACTIVE	513	2026-05-31 14:12:16.309	2026-05-31 14:12:16.309	34.02215925673885	71.48324741783776	\N
590	ELECTRONICS Scrap - 72.98kg - Quality Fair	Verified weight and quality.	electronics	1288	9	72.98	\N	ton	Fair	/uploads/products/product_506_1780236736310.jpg	\N	t	ACTIVE	506	2026-05-31 14:12:16.633	2026-05-31 14:12:16.633	33.70022306368284	73.01562319129354	\N
591	METAL Scrap - 104.99kg - Quality Good	Collected from industrial facilities. Ready for processing.	metal	1804	11	104.99	\N	kg	Good	/uploads/products/product_529_1780236736634.jpg	\N	t	ACTIVE	529	2026-05-31 14:12:17.518	2026-05-31 14:12:17.518	30.13878880036109	71.38911233236665	\N
592	TEXTILE Scrap - 93.37kg - Quality Poor	Eco-friendly scrap collection.	textile	4069	43	93.37	\N	bag	Poor	/uploads/products/product_513_1780236737519.jpg	\N	t	ACTIVE	513	2026-05-31 14:12:17.917	2026-05-31 14:12:17.917	34.02992576732849	71.48454683295729	\N
593	FOAM Scrap - 87.07kg - Quality Good	High quality scrap material, ideal for recycling.	foam	2275	14	87.07	\N	bag	Good	/uploads/products/product_534_1780236737917.jpg	\N	t	ACTIVE	534	2026-05-31 14:12:18.844	2026-05-31 14:12:18.844	25.33446627213034	68.44399527020788	\N
594	GLASS Scrap - 64.03kg - Quality Fair	Verified weight and quality.	glass	3516	46	64.03	\N	ton	Fair	/uploads/products/product_536_1780236738845.jpg	\N	t	ACTIVE	536	2026-05-31 14:12:19.641	2026-05-31 14:12:19.641	30.12009958132098	71.39901364337264	\N
595	COMPOSITE Scrap - 44.68kg - Quality Fair	Verified weight and quality.	composite	4525	29	44.68	\N	kg	Fair	/uploads/products/product_509_1780236739641.jpg	\N	t	ACTIVE	509	2026-05-31 14:12:20.012	2026-05-31 14:12:20.012	31.5491163600128	74.36022188488377	\N
596	RUBBER Scrap - 57.75kg - Quality Fair	Verified weight and quality.	rubber	1941	52	57.75	\N	piece	Fair	/uploads/products/product_535_1780236740013.jpg	\N	t	ACTIVE	535	2026-05-31 14:12:20.897	2026-05-31 14:12:20.897	31.43456228080922	72.28617180024972	\N
597	WOOD Scrap - 96.20kg - Quality Good	High quality scrap material, ideal for recycling.	wood	3186	39	96.2	\N	piece	Good	/uploads/products/product_515_1780236740897.jpg	\N	t	ACTIVE	515	2026-05-31 14:12:22.006	2026-05-31 14:12:22.006	33.66507407699219	73.00896068858718	\N
598	BRASS Scrap - 53.91kg - Quality Good	Eco-friendly scrap collection.	brass	4947	26	53.91	\N	kg	Good	/uploads/products/product_500_1780236742007.jpg	\N	t	ACTIVE	500	2026-05-31 14:12:22.429	2026-05-31 14:12:22.429	33.54262787545508	73.13491548954366	\N
599	TEXTILE Scrap - 11.50kg - Quality Poor	Eco-friendly scrap collection.	textile	858	15	11.5	\N	bag	Poor	/uploads/products/product_514_1780236742430.jpg	\N	t	ACTIVE	514	2026-05-31 14:12:22.778	2026-05-31 14:12:22.778	31.48692811494516	72.35660051619455	\N
600	TEXTILE Scrap - 52.96kg - Quality Fair	Recently collected, excellent condition.	textile	2469	32	52.96	\N	ton	Fair	/uploads/products/product_503_1780236742779.jpg	\N	t	ACTIVE	503	2026-05-31 14:12:23.657	2026-05-31 14:12:23.657	33.64235425940358	73.087754734672	\N
\.


--
-- Data for Name: Offer; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."Offer" (id, "listingId", "buyerId", price, weight, status, "parentOfferId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: PriceHistory; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."PriceHistory" (id, material, city, condition, "minPrice", "maxPrice", price, unit, source, "recordedAt") FROM stdin;
\.


--
-- Data for Name: Review; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."Review" (id, "reviewerId", "dealerId", rating, comment, "createdAt", "updatedAt") FROM stdin;
1	476	496	3	Reliable seller, good communication.	2026-05-02 14:04:28.349	2026-05-31 14:04:28.35
2	477	456	5	Premium quality scrap.	2026-05-27 14:04:28.352	2026-05-31 14:04:28.352
3	477	456	4	Very satisfied with the purchase.	2026-05-14 14:04:28.353	2026-05-31 14:04:28.353
4	476	456	4	Worth the price.	2026-05-19 14:04:28.354	2026-05-31 14:04:28.354
5	481	463	3	Excellent quality! Highly recommended.	2026-05-27 14:04:28.355	2026-05-31 14:04:28.355
6	476	463	4	Premium quality scrap.	2026-05-04 14:04:28.356	2026-05-31 14:04:28.356
7	480	490	5	Good material, fair price.	2026-05-23 14:04:28.357	2026-05-31 14:04:28.358
8	479	490	5	Good material, fair price.	2026-05-08 14:04:28.358	2026-05-31 14:04:28.359
9	479	456	4	Will buy again!	2026-05-03 14:04:28.36	2026-05-31 14:04:28.36
10	475	457	3	Premium quality scrap.	2026-05-07 14:04:28.361	2026-05-31 14:04:28.361
11	478	487	4	Premium quality scrap.	2026-05-22 14:04:28.362	2026-05-31 14:04:28.363
12	479	487	5	Highly professional service.	2026-05-10 14:04:28.363	2026-05-31 14:04:28.364
13	480	456	3	Great seller, fast delivery.	2026-05-03 14:04:28.364	2026-05-31 14:04:28.365
14	477	456	5	Highly professional service.	2026-05-11 14:04:28.366	2026-05-31 14:04:28.366
15	478	456	4	Reliable seller, good communication.	2026-05-08 14:04:28.367	2026-05-31 14:04:28.368
16	482	492	4	Premium quality scrap.	2026-05-09 14:04:28.368	2026-05-31 14:04:28.368
17	473	471	3	Will buy again!	2026-05-28 14:04:28.368	2026-05-31 14:04:28.369
18	475	471	3	Very satisfied with the purchase.	2026-05-30 14:04:28.369	2026-05-31 14:04:28.37
19	473	468	5	Best quality in the market.	2026-05-17 14:04:28.37	2026-05-31 14:04:28.371
20	475	468	3	Very satisfied with the purchase.	2026-05-17 14:04:28.371	2026-05-31 14:04:28.371
21	478	459	5	Very satisfied with the purchase.	2026-05-08 14:04:28.371	2026-05-31 14:04:28.372
22	474	491	4	Great seller, fast delivery.	2026-05-15 14:04:28.372	2026-05-31 14:04:28.373
23	474	486	4	Great seller, fast delivery.	2026-05-28 14:04:28.373	2026-05-31 14:04:28.374
24	476	492	3	Excellent quality! Highly recommended.	2026-05-16 14:04:28.374	2026-05-31 14:04:28.374
25	479	492	3	Premium quality scrap.	2026-05-20 14:04:28.374	2026-05-31 14:04:28.375
26	479	492	5	Highly professional service.	2026-05-15 14:04:28.375	2026-05-31 14:04:28.376
27	474	489	4	Great seller, fast delivery.	2026-05-09 14:04:28.376	2026-05-31 14:04:28.376
28	477	458	3	Highly professional service.	2026-05-18 14:04:28.377	2026-05-31 14:04:28.377
29	475	463	5	Worth the price.	2026-05-18 14:04:28.378	2026-05-31 14:04:28.378
30	480	495	3	Will buy again!	2026-05-17 14:04:28.379	2026-05-31 14:04:28.379
31	477	495	4	Excellent quality! Highly recommended.	2026-05-22 14:04:28.38	2026-05-31 14:04:28.38
32	476	497	5	Best quality in the market.	2026-05-31 14:04:28.381	2026-05-31 14:04:28.382
33	478	470	3	Best quality in the market.	2026-05-04 14:04:28.382	2026-05-31 14:04:28.382
34	476	470	5	Best quality in the market.	2026-05-25 14:04:28.383	2026-05-31 14:04:28.383
35	482	483	3	Worth the price.	2026-05-24 14:04:28.383	2026-05-31 14:04:28.384
36	482	483	4	Reliable seller, good communication.	2026-05-06 14:04:28.384	2026-05-31 14:04:28.385
37	476	455	5	Highly professional service.	2026-05-18 14:04:28.385	2026-05-31 14:04:28.386
38	474	496	5	Premium quality scrap.	2026-05-07 14:04:28.386	2026-05-31 14:04:28.387
39	480	495	5	Good material, fair price.	2026-05-20 14:04:28.387	2026-05-31 14:04:28.388
40	478	495	4	Good material, fair price.	2026-05-18 14:04:28.388	2026-05-31 14:04:28.389
41	476	495	5	Best quality in the market.	2026-05-29 14:04:28.389	2026-05-31 14:04:28.39
42	479	458	5	Reliable seller, good communication.	2026-05-26 14:04:28.39	2026-05-31 14:04:28.391
43	481	471	3	Good material, fair price.	2026-05-20 14:04:28.391	2026-05-31 14:04:28.391
44	475	471	3	Very satisfied with the purchase.	2026-05-04 14:04:28.392	2026-05-31 14:04:28.392
45	478	471	5	Premium quality scrap.	2026-05-22 14:04:28.392	2026-05-31 14:04:28.393
46	482	468	3	Best quality in the market.	2026-05-06 14:04:28.393	2026-05-31 14:04:28.394
47	481	468	4	Worth the price.	2026-05-02 14:04:28.394	2026-05-31 14:04:28.394
48	474	468	4	Reliable seller, good communication.	2026-05-09 14:04:28.395	2026-05-31 14:04:28.395
49	478	468	3	Worth the price.	2026-05-07 14:04:28.395	2026-05-31 14:04:28.396
50	476	469	3	Will buy again!	2026-05-03 14:04:28.396	2026-05-31 14:04:28.397
51	478	458	4	Excellent quality! Highly recommended.	2026-05-20 14:04:28.397	2026-05-31 14:04:28.397
52	479	468	3	Highly professional service.	2026-05-10 14:04:28.398	2026-05-31 14:04:28.398
53	479	468	4	Best quality in the market.	2026-05-16 14:04:28.398	2026-05-31 14:04:28.399
54	478	468	4	Great seller, fast delivery.	2026-05-16 14:04:28.399	2026-05-31 14:04:28.4
55	476	454	3	Excellent quality! Highly recommended.	2026-05-26 14:04:28.4	2026-05-31 14:04:28.4
56	482	454	3	Worth the price.	2026-05-08 14:04:28.401	2026-05-31 14:04:28.401
57	480	485	5	Very satisfied with the purchase.	2026-05-19 14:04:28.401	2026-05-31 14:04:28.402
58	479	485	3	Premium quality scrap.	2026-05-21 14:04:28.402	2026-05-31 14:04:28.403
59	481	471	5	Highly professional service.	2026-05-20 14:04:28.403	2026-05-31 14:04:28.403
60	482	471	4	Reliable seller, good communication.	2026-05-06 14:04:28.403	2026-05-31 14:04:28.404
61	474	471	3	Good material, fair price.	2026-05-17 14:04:28.404	2026-05-31 14:04:28.405
62	478	491	3	Best quality in the market.	2026-05-08 14:04:28.405	2026-05-31 14:04:28.405
63	481	491	4	Highly professional service.	2026-05-27 14:04:28.405	2026-05-31 14:04:28.406
64	475	459	3	Very satisfied with the purchase.	2026-05-05 14:04:28.406	2026-05-31 14:04:28.407
65	474	459	4	Good material, fair price.	2026-05-06 14:04:28.407	2026-05-31 14:04:28.407
66	480	488	3	Will buy again!	2026-05-23 14:04:28.407	2026-05-31 14:04:28.408
67	479	488	5	Reliable seller, good communication.	2026-05-30 14:04:28.408	2026-05-31 14:04:28.409
68	479	492	3	Worth the price.	2026-05-11 14:04:28.409	2026-05-31 14:04:28.41
69	474	492	5	Good material, fair price.	2026-05-06 14:04:28.41	2026-05-31 14:04:28.411
70	482	486	3	Highly professional service.	2026-05-03 14:04:28.411	2026-05-31 14:04:28.411
71	482	486	3	Reliable seller, good communication.	2026-05-14 14:04:28.412	2026-05-31 14:04:28.412
72	481	459	3	Excellent quality! Highly recommended.	2026-05-19 14:04:28.412	2026-05-31 14:04:28.413
73	480	459	3	Worth the price.	2026-05-08 14:04:28.413	2026-05-31 14:04:28.414
74	475	459	5	Worth the price.	2026-05-19 14:04:28.414	2026-05-31 14:04:28.414
75	476	454	3	Worth the price.	2026-05-28 14:04:28.414	2026-05-31 14:04:28.415
76	481	454	3	Will buy again!	2026-05-06 14:04:28.415	2026-05-31 14:04:28.416
77	473	465	3	Excellent quality! Highly recommended.	2026-05-30 14:04:28.416	2026-05-31 14:04:28.416
78	474	465	4	Reliable seller, good communication.	2026-05-17 14:04:28.416	2026-05-31 14:04:28.417
79	478	471	5	Excellent quality! Highly recommended.	2026-05-17 14:04:28.417	2026-05-31 14:04:28.417
80	478	471	4	Good material, fair price.	2026-05-31 14:04:28.418	2026-05-31 14:04:28.418
81	475	471	3	Very satisfied with the purchase.	2026-05-05 14:04:28.418	2026-05-31 14:04:28.419
82	482	487	4	Great seller, fast delivery.	2026-05-28 14:04:28.419	2026-05-31 14:04:28.42
83	475	487	4	Reliable seller, good communication.	2026-05-31 14:04:28.42	2026-05-31 14:04:28.421
84	473	472	5	Good material, fair price.	2026-05-21 14:04:28.421	2026-05-31 14:04:28.421
85	476	472	5	Reliable seller, good communication.	2026-05-31 14:04:28.421	2026-05-31 14:04:28.422
86	473	471	3	Will buy again!	2026-05-29 14:04:28.422	2026-05-31 14:04:28.423
87	482	471	3	Premium quality scrap.	2026-05-22 14:04:28.423	2026-05-31 14:04:28.423
88	482	471	5	Premium quality scrap.	2026-05-27 14:04:28.424	2026-05-31 14:04:28.424
89	477	454	4	Will buy again!	2026-05-08 14:04:28.424	2026-05-31 14:04:28.425
90	477	454	5	Great seller, fast delivery.	2026-05-12 14:04:28.425	2026-05-31 14:04:28.426
91	478	454	5	Highly professional service.	2026-05-13 14:04:28.426	2026-05-31 14:04:28.427
92	479	486	4	Great seller, fast delivery.	2026-05-24 14:04:28.427	2026-05-31 14:04:28.428
93	475	486	5	Reliable seller, good communication.	2026-05-25 14:04:28.428	2026-05-31 14:04:28.429
94	478	458	4	Will buy again!	2026-05-11 14:04:28.429	2026-05-31 14:04:28.429
95	479	453	4	Highly professional service.	2026-05-10 14:04:28.43	2026-05-31 14:04:28.43
96	474	490	3	Great seller, fast delivery.	2026-05-27 14:04:28.431	2026-05-31 14:04:28.431
97	482	490	4	Premium quality scrap.	2026-05-09 14:04:28.432	2026-05-31 14:04:28.432
98	478	490	3	Good material, fair price.	2026-05-15 14:04:28.432	2026-05-31 14:04:28.433
99	481	483	5	Great seller, fast delivery.	2026-05-17 14:04:28.433	2026-05-31 14:04:28.434
100	482	483	5	Premium quality scrap.	2026-05-30 14:04:28.434	2026-05-31 14:04:28.435
101	481	485	5	Highly professional service.	2026-05-18 14:04:28.435	2026-05-31 14:04:28.436
102	481	492	5	Best quality in the market.	2026-05-24 14:04:28.436	2026-05-31 14:04:28.436
103	474	492	5	Best quality in the market.	2026-05-30 14:04:28.437	2026-05-31 14:04:28.437
104	474	496	4	Reliable seller, good communication.	2026-05-09 14:04:28.437	2026-05-31 14:04:28.438
105	479	496	4	Great seller, fast delivery.	2026-05-25 14:04:28.438	2026-05-31 14:04:28.439
106	474	496	3	Best quality in the market.	2026-05-22 14:04:28.439	2026-05-31 14:04:28.439
107	476	492	5	Worth the price.	2026-05-14 14:04:28.439	2026-05-31 14:04:28.44
108	474	496	5	Will buy again!	2026-05-14 14:04:28.44	2026-05-31 14:04:28.441
109	473	496	5	Highly professional service.	2026-05-30 14:04:28.441	2026-05-31 14:04:28.441
110	482	496	5	Very satisfied with the purchase.	2026-05-08 14:04:28.441	2026-05-31 14:04:28.442
111	477	472	4	Will buy again!	2026-05-03 14:04:28.442	2026-05-31 14:04:28.443
112	473	472	4	Very satisfied with the purchase.	2026-05-19 14:04:28.443	2026-05-31 14:04:28.443
113	473	458	4	Very satisfied with the purchase.	2026-05-28 14:04:28.443	2026-05-31 14:04:28.444
114	480	458	3	Highly professional service.	2026-05-30 14:04:28.444	2026-05-31 14:04:28.445
115	479	467	5	Premium quality scrap.	2026-05-14 14:04:28.445	2026-05-31 14:04:28.445
116	476	467	5	Best quality in the market.	2026-05-10 14:04:28.445	2026-05-31 14:04:28.446
117	478	467	4	Excellent quality! Highly recommended.	2026-05-30 14:04:28.446	2026-05-31 14:04:28.446
118	479	457	5	Best quality in the market.	2026-05-05 14:04:28.447	2026-05-31 14:04:28.447
119	478	457	5	Very satisfied with the purchase.	2026-05-22 14:04:28.447	2026-05-31 14:04:28.448
120	482	461	4	Worth the price.	2026-05-09 14:04:28.448	2026-05-31 14:04:28.448
121	473	489	4	Will buy again!	2026-05-17 14:04:28.449	2026-05-31 14:04:28.449
122	482	489	5	Premium quality scrap.	2026-05-29 14:04:28.449	2026-05-31 14:04:28.45
123	479	489	4	Premium quality scrap.	2026-05-15 14:04:28.45	2026-05-31 14:04:28.45
124	479	466	3	Excellent quality! Highly recommended.	2026-05-29 14:04:28.45	2026-05-31 14:04:28.451
125	477	466	3	Good material, fair price.	2026-05-26 14:04:28.451	2026-05-31 14:04:28.452
126	480	461	5	Premium quality scrap.	2026-05-07 14:04:28.452	2026-05-31 14:04:28.452
127	482	461	5	Premium quality scrap.	2026-05-28 14:04:28.453	2026-05-31 14:04:28.453
128	473	461	4	Good material, fair price.	2026-05-30 14:04:28.453	2026-05-31 14:04:28.454
129	478	458	4	Will buy again!	2026-05-28 14:04:28.454	2026-05-31 14:04:28.455
130	475	458	5	Worth the price.	2026-05-11 14:04:28.455	2026-05-31 14:04:28.455
131	476	464	3	Highly professional service.	2026-05-22 14:04:28.455	2026-05-31 14:04:28.456
132	473	464	4	Excellent quality! Highly recommended.	2026-05-10 14:04:28.456	2026-05-31 14:04:28.457
133	474	464	3	Great seller, fast delivery.	2026-05-06 14:04:28.457	2026-05-31 14:04:28.457
134	475	492	5	Good material, fair price.	2026-05-10 14:04:28.457	2026-05-31 14:04:28.458
135	479	492	4	Premium quality scrap.	2026-05-07 14:04:28.458	2026-05-31 14:04:28.459
136	476	483	4	Premium quality scrap.	2026-05-24 14:04:28.459	2026-05-31 14:04:28.46
137	482	483	3	Good material, fair price.	2026-05-03 14:04:28.46	2026-05-31 14:04:28.461
138	480	483	4	Worth the price.	2026-05-05 14:04:28.461	2026-05-31 14:04:28.462
139	479	489	3	Reliable seller, good communication.	2026-05-14 14:04:28.462	2026-05-31 14:04:28.463
140	474	489	5	Very satisfied with the purchase.	2026-05-22 14:04:28.463	2026-05-31 14:04:28.464
141	478	491	4	Highly professional service.	2026-05-23 14:04:28.464	2026-05-31 14:04:28.465
142	477	491	3	Excellent quality! Highly recommended.	2026-05-25 14:04:28.465	2026-05-31 14:04:28.466
143	473	491	4	Highly professional service.	2026-05-07 14:04:28.466	2026-05-31 14:04:28.467
144	482	488	4	Highly professional service.	2026-05-24 14:04:28.467	2026-05-31 14:04:28.468
145	479	488	5	Premium quality scrap.	2026-05-26 14:04:28.468	2026-05-31 14:04:28.468
146	477	471	5	Highly professional service.	2026-05-29 14:04:28.469	2026-05-31 14:04:28.469
147	477	471	3	Excellent quality! Highly recommended.	2026-05-08 14:04:28.469	2026-05-31 14:04:28.47
148	481	471	4	Best quality in the market.	2026-05-03 14:04:28.47	2026-05-31 14:04:28.47
149	475	468	4	Excellent quality! Highly recommended.	2026-05-26 14:04:28.471	2026-05-31 14:04:28.471
150	482	468	5	Good material, fair price.	2026-05-08 14:04:28.471	2026-05-31 14:04:28.472
151	480	485	4	Reliable seller, good communication.	2026-05-12 14:04:28.472	2026-05-31 14:04:28.472
152	473	485	3	Excellent quality! Highly recommended.	2026-05-25 14:04:28.472	2026-05-31 14:04:28.473
153	481	485	4	Best quality in the market.	2026-05-14 14:04:28.473	2026-05-31 14:04:28.474
154	482	472	3	Great seller, fast delivery.	2026-05-24 14:04:28.474	2026-05-31 14:04:28.474
155	473	493	5	Reliable seller, good communication.	2026-05-25 14:04:28.474	2026-05-31 14:04:28.475
156	480	493	4	Great seller, fast delivery.	2026-05-28 14:04:28.475	2026-05-31 14:04:28.476
157	479	462	5	Excellent quality! Highly recommended.	2026-05-02 14:04:28.476	2026-05-31 14:04:28.477
158	479	462	3	Great seller, fast delivery.	2026-05-06 14:04:28.477	2026-05-31 14:04:28.477
159	478	462	4	Good material, fair price.	2026-05-24 14:04:28.477	2026-05-31 14:04:28.478
160	474	454	5	Good material, fair price.	2026-05-24 14:04:28.478	2026-05-31 14:04:28.479
161	473	454	3	Best quality in the market.	2026-05-21 14:04:28.479	2026-05-31 14:04:28.479
162	481	454	4	Very satisfied with the purchase.	2026-05-22 14:04:28.479	2026-05-31 14:04:28.48
163	473	467	4	Will buy again!	2026-05-06 14:04:28.48	2026-05-31 14:04:28.481
164	481	455	5	Will buy again!	2026-05-25 14:04:28.481	2026-05-31 14:04:28.481
165	473	455	3	Good material, fair price.	2026-05-06 14:04:28.482	2026-05-31 14:04:28.482
166	479	487	5	Premium quality scrap.	2026-05-23 14:04:28.482	2026-05-31 14:04:28.483
167	473	487	4	Will buy again!	2026-05-09 14:04:28.483	2026-05-31 14:04:28.484
168	474	490	3	Worth the price.	2026-05-06 14:04:28.484	2026-05-31 14:04:28.484
169	473	483	5	Worth the price.	2026-05-26 14:04:28.484	2026-05-31 14:04:28.485
170	478	483	5	Highly professional service.	2026-05-08 14:04:28.485	2026-05-31 14:04:28.486
171	474	460	5	Excellent quality! Highly recommended.	2026-05-29 14:04:28.486	2026-05-31 14:04:28.486
172	473	460	5	Best quality in the market.	2026-05-06 14:04:28.486	2026-05-31 14:04:28.487
173	474	460	4	Excellent quality! Highly recommended.	2026-05-06 14:04:28.487	2026-05-31 14:04:28.488
174	476	470	3	Best quality in the market.	2026-05-05 14:04:28.488	2026-05-31 14:04:28.488
175	477	470	4	Will buy again!	2026-05-12 14:04:28.489	2026-05-31 14:04:28.49
176	476	470	3	Great seller, fast delivery.	2026-05-05 14:04:28.49	2026-05-31 14:04:28.49
177	481	490	4	Good material, fair price.	2026-05-18 14:04:28.491	2026-05-31 14:04:28.491
178	477	490	5	Best quality in the market.	2026-05-22 14:04:28.491	2026-05-31 14:04:28.492
179	478	490	5	Best quality in the market.	2026-05-27 14:04:28.492	2026-05-31 14:04:28.493
180	478	468	4	Reliable seller, good communication.	2026-05-24 14:04:28.493	2026-05-31 14:04:28.493
181	477	468	4	Worth the price.	2026-05-13 14:04:28.493	2026-05-31 14:04:28.494
182	473	467	5	Very satisfied with the purchase.	2026-05-31 14:04:28.494	2026-05-31 14:04:28.495
183	477	467	5	Excellent quality! Highly recommended.	2026-05-22 14:04:28.495	2026-05-31 14:04:28.495
184	475	467	3	Good material, fair price.	2026-05-13 14:04:28.496	2026-05-31 14:04:28.496
185	476	467	4	Great seller, fast delivery.	2026-05-05 14:04:28.496	2026-05-31 14:04:28.497
186	478	455	4	Worth the price.	2026-05-12 14:04:28.497	2026-05-31 14:04:28.498
187	477	455	4	Highly professional service.	2026-05-15 14:04:28.498	2026-05-31 14:04:28.498
188	475	455	4	Premium quality scrap.	2026-05-27 14:04:28.498	2026-05-31 14:04:28.499
189	481	486	4	Worth the price.	2026-05-08 14:04:28.499	2026-05-31 14:04:28.5
190	477	486	4	Reliable seller, good communication.	2026-05-13 14:04:28.501	2026-05-31 14:04:28.501
191	475	486	3	Very satisfied with the purchase.	2026-05-15 14:04:28.501	2026-05-31 14:04:28.502
192	474	455	5	Excellent quality! Highly recommended.	2026-05-14 14:04:28.502	2026-05-31 14:04:28.503
193	481	492	5	Good material, fair price.	2026-05-18 14:04:28.503	2026-05-31 14:04:28.503
194	480	492	4	Reliable seller, good communication.	2026-05-16 14:04:28.504	2026-05-31 14:04:28.504
195	479	459	4	Reliable seller, good communication.	2026-05-29 14:04:28.504	2026-05-31 14:04:28.505
196	474	459	5	Best quality in the market.	2026-05-05 14:04:28.505	2026-05-31 14:04:28.506
197	478	459	4	Highly professional service.	2026-05-05 14:04:28.506	2026-05-31 14:04:28.506
198	482	489	3	Will buy again!	2026-05-24 14:04:28.506	2026-05-31 14:04:28.507
199	478	470	5	Great seller, fast delivery.	2026-05-03 14:04:28.507	2026-05-31 14:04:28.508
200	477	470	4	Best quality in the market.	2026-05-27 14:04:28.508	2026-05-31 14:04:28.509
201	474	470	5	Worth the price.	2026-05-23 14:04:28.509	2026-05-31 14:04:28.509
202	481	471	3	Will buy again!	2026-05-25 14:04:28.509	2026-05-31 14:04:28.51
203	473	471	4	Excellent quality! Highly recommended.	2026-05-07 14:04:28.51	2026-05-31 14:04:28.511
204	476	497	4	Good material, fair price.	2026-05-03 14:04:28.511	2026-05-31 14:04:28.511
205	475	497	4	Excellent quality! Highly recommended.	2026-05-06 14:04:28.512	2026-05-31 14:04:28.512
206	478	497	3	Best quality in the market.	2026-05-23 14:04:28.512	2026-05-31 14:04:28.513
207	481	496	3	Good material, fair price.	2026-05-21 14:04:28.513	2026-05-31 14:04:28.514
208	475	496	3	Very satisfied with the purchase.	2026-05-09 14:04:28.514	2026-05-31 14:04:28.514
209	480	496	4	Excellent quality! Highly recommended.	2026-05-03 14:04:28.514	2026-05-31 14:04:28.515
210	479	497	3	Great seller, fast delivery.	2026-05-08 14:04:28.515	2026-05-31 14:04:28.516
211	475	497	3	Excellent quality! Highly recommended.	2026-05-08 14:04:28.516	2026-05-31 14:04:28.516
212	478	497	3	Good material, fair price.	2026-05-26 14:04:28.517	2026-05-31 14:04:28.517
213	481	489	3	Highly professional service.	2026-05-20 14:04:28.517	2026-05-31 14:04:28.518
214	474	489	5	Excellent quality! Highly recommended.	2026-05-08 14:04:28.518	2026-05-31 14:04:28.519
215	477	484	5	Reliable seller, good communication.	2026-05-19 14:04:28.519	2026-05-31 14:04:28.519
216	475	489	3	Worth the price.	2026-05-25 14:04:28.519	2026-05-31 14:04:28.52
217	474	489	5	Worth the price.	2026-05-26 14:04:28.52	2026-05-31 14:04:28.521
218	482	489	4	Very satisfied with the purchase.	2026-05-22 14:04:28.521	2026-05-31 14:04:28.522
219	475	489	5	Good material, fair price.	2026-05-17 14:04:28.522	2026-05-31 14:04:28.523
220	481	464	3	Good material, fair price.	2026-05-23 14:04:28.523	2026-05-31 14:04:28.523
221	473	464	5	Great seller, fast delivery.	2026-05-09 14:04:28.523	2026-05-31 14:04:28.524
222	478	487	3	Worth the price.	2026-05-02 14:04:28.524	2026-05-31 14:04:28.525
223	481	487	5	Highly professional service.	2026-05-11 14:04:28.525	2026-05-31 14:04:28.526
224	479	464	4	Good material, fair price.	2026-05-29 14:04:28.526	2026-05-31 14:04:28.527
225	477	464	3	Highly professional service.	2026-05-02 14:04:28.527	2026-05-31 14:04:28.527
226	477	458	4	Excellent quality! Highly recommended.	2026-05-21 14:04:28.527	2026-05-31 14:04:28.528
227	480	470	4	Best quality in the market.	2026-05-10 14:04:28.528	2026-05-31 14:04:28.529
228	479	470	3	Highly professional service.	2026-05-02 14:04:28.529	2026-05-31 14:04:28.529
229	473	465	3	Premium quality scrap.	2026-05-12 14:04:28.53	2026-05-31 14:04:28.53
230	477	465	5	Highly professional service.	2026-05-25 14:04:28.53	2026-05-31 14:04:28.531
231	473	484	4	Will buy again!	2026-05-28 14:04:28.531	2026-05-31 14:04:28.532
232	475	484	5	Highly professional service.	2026-05-20 14:04:28.532	2026-05-31 14:04:28.532
233	481	484	4	Will buy again!	2026-05-30 14:04:28.532	2026-05-31 14:04:28.533
234	478	465	3	Will buy again!	2026-05-04 14:04:28.533	2026-05-31 14:04:28.534
235	479	457	3	Best quality in the market.	2026-05-09 14:04:28.534	2026-05-31 14:04:28.534
236	474	457	4	Best quality in the market.	2026-05-09 14:04:28.535	2026-05-31 14:04:28.535
237	480	459	5	Worth the price.	2026-05-03 14:04:28.535	2026-05-31 14:04:28.536
238	479	459	4	Will buy again!	2026-05-04 14:04:28.536	2026-05-31 14:04:28.537
239	474	455	5	Very satisfied with the purchase.	2026-05-04 14:04:28.537	2026-05-31 14:04:28.537
240	481	455	3	Very satisfied with the purchase.	2026-05-04 14:04:28.537	2026-05-31 14:04:28.538
241	473	455	5	Will buy again!	2026-05-04 14:04:28.538	2026-05-31 14:04:28.539
242	476	456	5	Reliable seller, good communication.	2026-05-05 14:04:28.539	2026-05-31 14:04:28.539
243	473	456	3	Premium quality scrap.	2026-05-31 14:04:28.54	2026-05-31 14:04:28.54
244	482	456	3	Highly professional service.	2026-05-10 14:04:28.54	2026-05-31 14:04:28.541
245	474	497	4	Great seller, fast delivery.	2026-05-10 14:04:28.541	2026-05-31 14:04:28.542
246	475	497	5	Best quality in the market.	2026-05-20 14:04:28.542	2026-05-31 14:04:28.542
247	480	457	3	Excellent quality! Highly recommended.	2026-05-17 14:04:28.542	2026-05-31 14:04:28.543
248	481	457	4	Very satisfied with the purchase.	2026-05-10 14:04:28.543	2026-05-31 14:04:28.544
249	478	484	4	Excellent quality! Highly recommended.	2026-05-23 14:04:28.544	2026-05-31 14:04:28.544
250	474	484	4	Will buy again!	2026-05-18 14:04:28.544	2026-05-31 14:04:28.545
251	473	493	4	Excellent quality! Highly recommended.	2026-05-03 14:04:28.545	2026-05-31 14:04:28.546
252	480	493	5	Good material, fair price.	2026-05-31 14:04:28.546	2026-05-31 14:04:28.546
253	481	486	5	Reliable seller, good communication.	2026-05-24 14:04:28.547	2026-05-31 14:04:28.547
254	476	486	3	Good material, fair price.	2026-05-19 14:04:28.547	2026-05-31 14:04:28.548
255	473	486	4	Will buy again!	2026-05-13 14:04:28.548	2026-05-31 14:04:28.549
256	474	487	4	Will buy again!	2026-05-08 14:04:28.549	2026-05-31 14:04:28.549
257	477	487	4	Best quality in the market.	2026-05-19 14:04:28.549	2026-05-31 14:04:28.55
258	479	487	3	Best quality in the market.	2026-05-28 14:04:28.55	2026-05-31 14:04:28.551
259	479	453	3	Best quality in the market.	2026-05-16 14:04:28.551	2026-05-31 14:04:28.551
260	473	453	5	Good material, fair price.	2026-05-26 14:04:28.551	2026-05-31 14:04:28.552
261	479	453	3	Excellent quality! Highly recommended.	2026-05-13 14:04:28.552	2026-05-31 14:04:28.553
262	481	461	4	Great seller, fast delivery.	2026-05-15 14:04:28.553	2026-05-31 14:04:28.554
263	473	461	4	Will buy again!	2026-05-21 14:04:28.554	2026-05-31 14:04:28.555
264	479	461	3	Good material, fair price.	2026-05-08 14:04:28.555	2026-05-31 14:04:28.556
265	473	455	3	Great seller, fast delivery.	2026-05-27 14:04:28.557	2026-05-31 14:04:28.557
266	476	494	4	Reliable seller, good communication.	2026-05-27 14:04:28.558	2026-05-31 14:04:28.559
267	481	494	4	Reliable seller, good communication.	2026-05-14 14:04:28.559	2026-05-31 14:04:28.56
268	479	455	3	Will buy again!	2026-05-17 14:04:28.561	2026-05-31 14:04:28.561
269	474	455	3	Best quality in the market.	2026-05-14 14:04:28.562	2026-05-31 14:04:28.563
270	478	495	5	Very satisfied with the purchase.	2026-05-11 14:04:28.563	2026-05-31 14:04:28.564
271	474	495	5	Reliable seller, good communication.	2026-05-23 14:04:28.564	2026-05-31 14:04:28.565
272	475	484	3	Great seller, fast delivery.	2026-05-27 14:04:28.565	2026-05-31 14:04:28.566
273	477	484	3	Excellent quality! Highly recommended.	2026-05-20 14:04:28.566	2026-05-31 14:04:28.566
274	474	495	4	Will buy again!	2026-05-14 14:04:28.567	2026-05-31 14:04:28.567
275	477	495	5	Good material, fair price.	2026-05-05 14:04:28.568	2026-05-31 14:04:28.568
276	475	495	5	Premium quality scrap.	2026-05-31 14:04:28.568	2026-05-31 14:04:28.569
277	479	455	3	Very satisfied with the purchase.	2026-05-30 14:04:28.569	2026-05-31 14:04:28.57
278	473	455	5	Will buy again!	2026-05-21 14:04:28.57	2026-05-31 14:04:28.571
279	480	469	5	Great seller, fast delivery.	2026-05-06 14:04:28.571	2026-05-31 14:04:28.572
280	475	469	5	Excellent quality! Highly recommended.	2026-05-21 14:04:28.572	2026-05-31 14:04:28.573
281	478	454	4	Great seller, fast delivery.	2026-05-30 14:04:28.573	2026-05-31 14:04:28.574
282	476	454	5	Worth the price.	2026-05-16 14:04:28.574	2026-05-31 14:04:28.575
283	482	454	5	Great seller, fast delivery.	2026-05-07 14:04:28.575	2026-05-31 14:04:28.576
284	476	459	5	Reliable seller, good communication.	2026-05-06 14:04:28.576	2026-05-31 14:04:28.577
285	482	459	3	Will buy again!	2026-05-12 14:04:28.577	2026-05-31 14:04:28.577
286	479	491	3	Best quality in the market.	2026-05-11 14:04:28.578	2026-05-31 14:04:28.578
287	478	491	4	Very satisfied with the purchase.	2026-05-18 14:04:28.578	2026-05-31 14:04:28.579
288	480	494	3	Worth the price.	2026-05-06 14:04:28.579	2026-05-31 14:04:28.58
289	474	494	3	Excellent quality! Highly recommended.	2026-05-26 14:04:28.58	2026-05-31 14:04:28.58
290	473	494	3	Great seller, fast delivery.	2026-05-30 14:04:28.58	2026-05-31 14:04:28.581
291	482	455	5	Great seller, fast delivery.	2026-05-23 14:04:28.581	2026-05-31 14:04:28.582
292	476	455	4	Good material, fair price.	2026-05-19 14:04:28.582	2026-05-31 14:04:28.583
293	473	464	3	Reliable seller, good communication.	2026-05-05 14:04:28.583	2026-05-31 14:04:28.583
294	479	462	3	Excellent quality! Highly recommended.	2026-05-03 14:04:28.584	2026-05-31 14:04:28.584
295	481	488	5	Good material, fair price.	2026-05-02 14:04:28.584	2026-05-31 14:04:28.585
296	482	488	4	Best quality in the market.	2026-05-06 14:04:28.585	2026-05-31 14:04:28.586
297	473	488	3	Good material, fair price.	2026-05-24 14:04:28.586	2026-05-31 14:04:28.586
298	473	491	5	Will buy again!	2026-05-15 14:04:28.587	2026-05-31 14:04:28.587
299	473	491	5	Premium quality scrap.	2026-05-23 14:04:28.588	2026-05-31 14:04:28.588
300	479	484	5	Will buy again!	2026-05-15 14:04:28.588	2026-05-31 14:04:28.589
301	474	470	4	Will buy again!	2026-05-05 14:04:28.589	2026-05-31 14:04:28.59
302	482	470	5	Very satisfied with the purchase.	2026-05-16 14:04:28.59	2026-05-31 14:04:28.591
303	479	458	5	Great seller, fast delivery.	2026-05-02 14:04:28.591	2026-05-31 14:04:28.592
304	480	458	3	Best quality in the market.	2026-05-21 14:04:28.592	2026-05-31 14:04:28.592
305	477	458	4	Best quality in the market.	2026-05-28 14:04:28.593	2026-05-31 14:04:28.593
306	476	461	4	Premium quality scrap.	2026-05-08 14:04:28.593	2026-05-31 14:04:28.594
307	481	483	4	Will buy again!	2026-05-18 14:04:28.594	2026-05-31 14:04:28.595
308	482	483	4	Premium quality scrap.	2026-05-10 14:04:28.595	2026-05-31 14:04:28.595
309	480	456	3	Reliable seller, good communication.	2026-05-07 14:04:28.596	2026-05-31 14:04:28.596
310	480	456	3	Worth the price.	2026-05-18 14:04:28.596	2026-05-31 14:04:28.597
311	482	456	5	Best quality in the market.	2026-05-26 14:04:28.597	2026-05-31 14:04:28.598
312	524	499	4	Very satisfied with the purchase.	2026-05-20 14:12:23.659	2026-05-31 14:12:23.663
313	526	499	4	Highly professional service.	2026-05-04 14:12:23.665	2026-05-31 14:12:23.665
314	524	499	4	Reliable seller, good communication.	2026-05-20 14:12:23.666	2026-05-31 14:12:23.666
315	526	504	3	Premium quality scrap.	2026-05-24 14:12:23.667	2026-05-31 14:12:23.667
316	520	504	4	Excellent quality! Highly recommended.	2026-05-14 14:12:23.668	2026-05-31 14:12:23.668
317	520	504	4	Reliable seller, good communication.	2026-05-19 14:12:23.668	2026-05-31 14:12:23.669
318	526	498	4	Great seller, fast delivery.	2026-05-29 14:12:23.67	2026-05-31 14:12:23.67
319	523	539	4	Premium quality scrap.	2026-05-09 14:12:23.671	2026-05-31 14:12:23.671
320	520	539	3	Great seller, fast delivery.	2026-05-11 14:12:23.672	2026-05-31 14:12:23.672
321	520	539	4	Very satisfied with the purchase.	2026-05-31 14:12:23.673	2026-05-31 14:12:23.673
322	521	507	5	Worth the price.	2026-05-29 14:12:23.673	2026-05-31 14:12:23.674
323	525	507	4	Very satisfied with the purchase.	2026-05-25 14:12:23.675	2026-05-31 14:12:23.675
324	526	507	5	Premium quality scrap.	2026-05-13 14:12:23.675	2026-05-31 14:12:23.676
325	520	533	3	Great seller, fast delivery.	2026-05-14 14:12:23.677	2026-05-31 14:12:23.677
326	523	533	4	Highly professional service.	2026-05-26 14:12:23.678	2026-05-31 14:12:23.679
327	520	500	4	Very satisfied with the purchase.	2026-05-20 14:12:23.679	2026-05-31 14:12:23.68
328	526	500	3	Best quality in the market.	2026-05-23 14:12:23.681	2026-05-31 14:12:23.681
329	527	513	4	Worth the price.	2026-05-27 14:12:23.682	2026-05-31 14:12:23.682
330	518	505	3	Worth the price.	2026-05-04 14:12:23.683	2026-05-31 14:12:23.684
331	522	534	5	Reliable seller, good communication.	2026-05-14 14:12:23.684	2026-05-31 14:12:23.685
332	523	534	5	Will buy again!	2026-05-17 14:12:23.685	2026-05-31 14:12:23.686
333	523	512	5	Worth the price.	2026-05-03 14:12:23.686	2026-05-31 14:12:23.687
334	523	512	4	Very satisfied with the purchase.	2026-05-07 14:12:23.688	2026-05-31 14:12:23.688
335	525	535	4	Best quality in the market.	2026-05-24 14:12:23.688	2026-05-31 14:12:23.689
336	522	508	4	Premium quality scrap.	2026-05-19 14:12:23.689	2026-05-31 14:12:23.69
337	521	508	3	Very satisfied with the purchase.	2026-05-08 14:12:23.69	2026-05-31 14:12:23.69
338	523	508	3	Very satisfied with the purchase.	2026-05-18 14:12:23.691	2026-05-31 14:12:23.691
339	525	517	5	Great seller, fast delivery.	2026-05-10 14:12:23.691	2026-05-31 14:12:23.692
340	527	517	4	Great seller, fast delivery.	2026-05-07 14:12:23.692	2026-05-31 14:12:23.693
341	523	531	5	Great seller, fast delivery.	2026-05-07 14:12:23.693	2026-05-31 14:12:23.693
342	527	531	5	Will buy again!	2026-05-22 14:12:23.693	2026-05-31 14:12:23.694
343	520	540	4	Worth the price.	2026-05-16 14:12:23.694	2026-05-31 14:12:23.695
344	525	540	5	Best quality in the market.	2026-05-23 14:12:23.695	2026-05-31 14:12:23.695
345	522	540	5	Worth the price.	2026-05-27 14:12:23.695	2026-05-31 14:12:23.696
346	521	541	4	Worth the price.	2026-05-30 14:12:23.696	2026-05-31 14:12:23.697
347	526	541	4	Best quality in the market.	2026-05-13 14:12:23.697	2026-05-31 14:12:23.698
348	522	542	3	Highly professional service.	2026-05-30 14:12:23.698	2026-05-31 14:12:23.698
349	523	542	5	Best quality in the market.	2026-05-06 14:12:23.698	2026-05-31 14:12:23.699
350	522	501	3	Great seller, fast delivery.	2026-05-29 14:12:23.699	2026-05-31 14:12:23.7
351	527	501	5	Worth the price.	2026-05-17 14:12:23.7	2026-05-31 14:12:23.701
352	519	513	5	Worth the price.	2026-05-30 14:12:23.701	2026-05-31 14:12:23.701
353	525	531	3	Worth the price.	2026-05-04 14:12:23.701	2026-05-31 14:12:23.702
354	518	531	5	Will buy again!	2026-05-09 14:12:23.702	2026-05-31 14:12:23.703
355	519	509	4	Great seller, fast delivery.	2026-05-14 14:12:23.703	2026-05-31 14:12:23.704
356	521	509	3	Great seller, fast delivery.	2026-05-09 14:12:23.704	2026-05-31 14:12:23.704
357	523	509	5	Excellent quality! Highly recommended.	2026-05-28 14:12:23.705	2026-05-31 14:12:23.705
358	522	503	5	Great seller, fast delivery.	2026-05-15 14:12:23.705	2026-05-31 14:12:23.706
359	523	503	5	Best quality in the market.	2026-05-06 14:12:23.706	2026-05-31 14:12:23.707
360	519	537	4	Worth the price.	2026-05-10 14:12:23.707	2026-05-31 14:12:23.708
361	526	537	3	Worth the price.	2026-05-19 14:12:23.708	2026-05-31 14:12:23.709
362	527	537	5	Very satisfied with the purchase.	2026-05-08 14:12:23.709	2026-05-31 14:12:23.71
363	521	535	4	Worth the price.	2026-05-28 14:12:23.71	2026-05-31 14:12:23.711
364	526	541	3	Worth the price.	2026-05-22 14:12:23.711	2026-05-31 14:12:23.711
365	523	541	5	Will buy again!	2026-05-26 14:12:23.712	2026-05-31 14:12:23.712
366	521	541	5	Very satisfied with the purchase.	2026-05-11 14:12:23.712	2026-05-31 14:12:23.713
367	526	505	5	Best quality in the market.	2026-05-13 14:12:23.713	2026-05-31 14:12:23.714
368	526	514	5	Will buy again!	2026-05-22 14:12:23.714	2026-05-31 14:12:23.715
369	518	514	3	Great seller, fast delivery.	2026-05-25 14:12:23.715	2026-05-31 14:12:23.715
370	524	514	3	Very satisfied with the purchase.	2026-05-21 14:12:23.715	2026-05-31 14:12:23.716
371	523	515	5	Reliable seller, good communication.	2026-05-26 14:12:23.716	2026-05-31 14:12:23.717
372	519	498	3	Premium quality scrap.	2026-05-22 14:12:23.717	2026-05-31 14:12:23.718
373	523	498	3	Will buy again!	2026-05-09 14:12:23.718	2026-05-31 14:12:23.718
374	525	514	3	Worth the price.	2026-05-30 14:12:23.718	2026-05-31 14:12:23.719
375	518	503	5	Worth the price.	2026-05-26 14:12:23.719	2026-05-31 14:12:23.72
376	523	503	4	Reliable seller, good communication.	2026-05-07 14:12:23.72	2026-05-31 14:12:23.72
377	526	503	5	Great seller, fast delivery.	2026-05-10 14:12:23.721	2026-05-31 14:12:23.721
378	524	511	3	Reliable seller, good communication.	2026-05-11 14:12:23.721	2026-05-31 14:12:23.722
379	519	511	5	Highly professional service.	2026-05-02 14:12:23.722	2026-05-31 14:12:23.723
380	526	506	3	Very satisfied with the purchase.	2026-05-08 14:12:23.723	2026-05-31 14:12:23.723
381	527	506	5	Good material, fair price.	2026-05-15 14:12:23.723	2026-05-31 14:12:23.724
382	526	506	4	Great seller, fast delivery.	2026-05-23 14:12:23.724	2026-05-31 14:12:23.725
383	524	514	4	Premium quality scrap.	2026-05-24 14:12:23.725	2026-05-31 14:12:23.726
384	520	514	3	Reliable seller, good communication.	2026-05-25 14:12:23.726	2026-05-31 14:12:23.727
385	519	516	5	Will buy again!	2026-05-18 14:12:23.727	2026-05-31 14:12:23.728
386	525	516	3	Premium quality scrap.	2026-05-09 14:12:23.728	2026-05-31 14:12:23.729
387	518	516	3	Worth the price.	2026-05-21 14:12:23.729	2026-05-31 14:12:23.729
388	520	499	3	Reliable seller, good communication.	2026-05-20 14:12:23.73	2026-05-31 14:12:23.73
389	527	529	4	Good material, fair price.	2026-05-22 14:12:23.731	2026-05-31 14:12:23.731
390	520	529	5	Worth the price.	2026-05-26 14:12:23.731	2026-05-31 14:12:23.732
391	519	508	3	Will buy again!	2026-05-25 14:12:23.732	2026-05-31 14:12:23.733
392	522	508	4	Highly professional service.	2026-05-12 14:12:23.733	2026-05-31 14:12:23.734
393	527	508	5	Highly professional service.	2026-05-07 14:12:23.734	2026-05-31 14:12:23.735
394	523	513	5	Best quality in the market.	2026-05-27 14:12:23.735	2026-05-31 14:12:23.735
395	520	531	3	Highly professional service.	2026-05-30 14:12:23.736	2026-05-31 14:12:23.736
396	526	501	5	Premium quality scrap.	2026-05-22 14:12:23.736	2026-05-31 14:12:23.737
397	527	501	5	Excellent quality! Highly recommended.	2026-05-12 14:12:23.737	2026-05-31 14:12:23.738
398	522	538	5	Great seller, fast delivery.	2026-05-22 14:12:23.738	2026-05-31 14:12:23.739
399	518	538	4	Excellent quality! Highly recommended.	2026-05-13 14:12:23.739	2026-05-31 14:12:23.739
400	519	538	3	Reliable seller, good communication.	2026-05-04 14:12:23.74	2026-05-31 14:12:23.74
401	520	509	5	Worth the price.	2026-05-20 14:12:23.74	2026-05-31 14:12:23.741
402	523	500	4	Very satisfied with the purchase.	2026-05-09 14:12:23.741	2026-05-31 14:12:23.742
403	520	500	5	Worth the price.	2026-05-25 14:12:23.742	2026-05-31 14:12:23.743
404	523	514	3	Will buy again!	2026-05-06 14:12:23.743	2026-05-31 14:12:23.743
405	519	514	5	Premium quality scrap.	2026-05-03 14:12:23.743	2026-05-31 14:12:23.744
406	524	514	4	Excellent quality! Highly recommended.	2026-05-19 14:12:23.745	2026-05-31 14:12:23.745
407	522	502	4	Good material, fair price.	2026-05-10 14:12:23.745	2026-05-31 14:12:23.746
408	525	541	4	Best quality in the market.	2026-05-27 14:12:23.746	2026-05-31 14:12:23.747
409	524	541	3	Reliable seller, good communication.	2026-05-24 14:12:23.747	2026-05-31 14:12:23.748
410	525	508	4	Excellent quality! Highly recommended.	2026-05-06 14:12:23.748	2026-05-31 14:12:23.748
411	522	508	5	Good material, fair price.	2026-05-06 14:12:23.748	2026-05-31 14:12:23.749
412	526	508	5	Very satisfied with the purchase.	2026-05-23 14:12:23.749	2026-05-31 14:12:23.75
413	527	510	4	Good material, fair price.	2026-05-05 14:12:23.75	2026-05-31 14:12:23.75
414	521	510	5	Worth the price.	2026-05-15 14:12:23.75	2026-05-31 14:12:23.751
415	524	507	4	Worth the price.	2026-05-09 14:12:23.751	2026-05-31 14:12:23.752
416	521	534	4	Will buy again!	2026-05-17 14:12:23.752	2026-05-31 14:12:23.752
417	518	534	3	Worth the price.	2026-05-21 14:12:23.752	2026-05-31 14:12:23.753
418	524	534	4	Highly professional service.	2026-05-15 14:12:23.753	2026-05-31 14:12:23.754
419	520	512	3	Will buy again!	2026-05-10 14:12:23.754	2026-05-31 14:12:23.755
420	520	512	5	Excellent quality! Highly recommended.	2026-05-21 14:12:23.755	2026-05-31 14:12:23.756
421	522	528	3	Will buy again!	2026-05-30 14:12:23.756	2026-05-31 14:12:23.757
422	524	528	4	Highly professional service.	2026-05-20 14:12:23.757	2026-05-31 14:12:23.757
423	526	536	3	Reliable seller, good communication.	2026-05-07 14:12:23.758	2026-05-31 14:12:23.758
424	525	536	3	Reliable seller, good communication.	2026-05-13 14:12:23.759	2026-05-31 14:12:23.759
425	526	500	3	Excellent quality! Highly recommended.	2026-05-10 14:12:23.759	2026-05-31 14:12:23.76
426	524	500	3	Worth the price.	2026-05-05 14:12:23.76	2026-05-31 14:12:23.761
427	521	500	3	Worth the price.	2026-05-18 14:12:23.761	2026-05-31 14:12:23.762
428	519	539	4	Will buy again!	2026-05-30 14:12:23.762	2026-05-31 14:12:23.762
429	527	528	3	Best quality in the market.	2026-05-23 14:12:23.763	2026-05-31 14:12:23.763
430	518	528	3	Great seller, fast delivery.	2026-05-02 14:12:23.765	2026-05-31 14:12:23.765
431	518	501	5	Premium quality scrap.	2026-05-07 14:12:23.765	2026-05-31 14:12:23.766
432	524	534	3	Very satisfied with the purchase.	2026-05-14 14:12:23.766	2026-05-31 14:12:23.767
433	527	534	4	Highly professional service.	2026-05-02 14:12:23.767	2026-05-31 14:12:23.768
434	523	534	3	Highly professional service.	2026-05-16 14:12:23.768	2026-05-31 14:12:23.768
435	519	516	3	Premium quality scrap.	2026-05-03 14:12:23.768	2026-05-31 14:12:23.769
436	520	517	5	Worth the price.	2026-05-13 14:12:23.769	2026-05-31 14:12:23.77
437	519	504	5	Highly professional service.	2026-05-19 14:12:23.77	2026-05-31 14:12:23.771
438	527	530	4	Premium quality scrap.	2026-05-05 14:12:23.771	2026-05-31 14:12:23.771
439	520	530	4	Worth the price.	2026-05-30 14:12:23.771	2026-05-31 14:12:23.772
440	526	529	3	Worth the price.	2026-05-02 14:12:23.772	2026-05-31 14:12:23.773
441	527	529	4	Best quality in the market.	2026-05-21 14:12:23.773	2026-05-31 14:12:23.773
442	526	529	3	Reliable seller, good communication.	2026-05-14 14:12:23.773	2026-05-31 14:12:23.774
443	521	499	4	Great seller, fast delivery.	2026-05-25 14:12:23.774	2026-05-31 14:12:23.774
444	526	509	4	Will buy again!	2026-05-21 14:12:23.774	2026-05-31 14:12:23.775
445	526	509	4	Highly professional service.	2026-05-18 14:12:23.775	2026-05-31 14:12:23.776
446	520	509	5	Will buy again!	2026-05-13 14:12:23.776	2026-05-31 14:12:23.776
447	521	533	3	Highly professional service.	2026-05-07 14:12:23.776	2026-05-31 14:12:23.777
448	523	533	3	Good material, fair price.	2026-05-14 14:12:23.777	2026-05-31 14:12:23.778
449	521	533	4	Excellent quality! Highly recommended.	2026-05-23 14:12:23.778	2026-05-31 14:12:23.778
450	521	513	5	Reliable seller, good communication.	2026-05-02 14:12:23.778	2026-05-31 14:12:23.779
451	524	499	4	Will buy again!	2026-05-15 14:12:23.779	2026-05-31 14:12:23.78
452	521	505	4	Highly professional service.	2026-05-20 14:12:23.78	2026-05-31 14:12:23.78
453	523	505	5	Highly professional service.	2026-05-17 14:12:23.78	2026-05-31 14:12:23.781
454	524	533	5	Good material, fair price.	2026-05-28 14:12:23.782	2026-05-31 14:12:23.782
455	527	510	5	Premium quality scrap.	2026-05-05 14:12:23.782	2026-05-31 14:12:23.783
456	525	498	3	Great seller, fast delivery.	2026-05-04 14:12:23.783	2026-05-31 14:12:23.783
457	525	498	3	Very satisfied with the purchase.	2026-05-26 14:12:23.783	2026-05-31 14:12:23.784
458	522	498	3	Worth the price.	2026-05-16 14:12:23.784	2026-05-31 14:12:23.785
459	518	528	5	Highly professional service.	2026-05-06 14:12:23.785	2026-05-31 14:12:23.786
460	527	528	4	Will buy again!	2026-05-10 14:12:23.786	2026-05-31 14:12:23.787
461	518	528	4	Great seller, fast delivery.	2026-05-21 14:12:23.787	2026-05-31 14:12:23.788
462	521	509	5	Highly professional service.	2026-05-29 14:12:23.789	2026-05-31 14:12:23.789
463	519	509	5	Premium quality scrap.	2026-05-18 14:12:23.789	2026-05-31 14:12:23.79
464	524	504	4	Worth the price.	2026-05-08 14:12:23.79	2026-05-31 14:12:23.791
465	521	504	4	Excellent quality! Highly recommended.	2026-05-04 14:12:23.791	2026-05-31 14:12:23.792
466	522	504	4	Good material, fair price.	2026-05-05 14:12:23.792	2026-05-31 14:12:23.792
467	518	504	5	Great seller, fast delivery.	2026-05-16 14:12:23.793	2026-05-31 14:12:23.793
468	525	504	3	Very satisfied with the purchase.	2026-05-31 14:12:23.793	2026-05-31 14:12:23.794
469	523	504	5	Highly professional service.	2026-05-18 14:12:23.794	2026-05-31 14:12:23.795
470	521	504	5	Will buy again!	2026-05-26 14:12:23.795	2026-05-31 14:12:23.796
471	524	504	4	Highly professional service.	2026-05-29 14:12:23.796	2026-05-31 14:12:23.796
472	519	504	3	Reliable seller, good communication.	2026-05-06 14:12:23.796	2026-05-31 14:12:23.797
473	525	514	4	Very satisfied with the purchase.	2026-05-11 14:12:23.797	2026-05-31 14:12:23.798
474	523	514	3	Good material, fair price.	2026-05-21 14:12:23.798	2026-05-31 14:12:23.799
475	526	507	3	Worth the price.	2026-05-21 14:12:23.799	2026-05-31 14:12:23.8
476	518	507	5	Will buy again!	2026-05-20 14:12:23.8	2026-05-31 14:12:23.801
477	523	507	3	Reliable seller, good communication.	2026-05-24 14:12:23.801	2026-05-31 14:12:23.802
478	522	511	5	Best quality in the market.	2026-05-05 14:12:23.802	2026-05-31 14:12:23.803
479	519	498	5	Highly professional service.	2026-05-09 14:12:23.803	2026-05-31 14:12:23.804
480	527	498	5	Great seller, fast delivery.	2026-05-02 14:12:23.804	2026-05-31 14:12:23.804
481	524	498	3	Reliable seller, good communication.	2026-05-14 14:12:23.804	2026-05-31 14:12:23.805
482	519	537	3	Will buy again!	2026-05-07 14:12:23.805	2026-05-31 14:12:23.806
483	522	542	4	Worth the price.	2026-05-04 14:12:23.806	2026-05-31 14:12:23.807
484	524	542	4	Very satisfied with the purchase.	2026-05-09 14:12:23.807	2026-05-31 14:12:23.807
485	527	542	5	Highly professional service.	2026-05-05 14:12:23.807	2026-05-31 14:12:23.808
486	524	502	5	Highly professional service.	2026-05-14 14:12:23.808	2026-05-31 14:12:23.809
487	522	502	5	Reliable seller, good communication.	2026-05-12 14:12:23.809	2026-05-31 14:12:23.81
488	527	536	4	Will buy again!	2026-05-25 14:12:23.81	2026-05-31 14:12:23.81
489	525	508	4	Will buy again!	2026-05-31 14:12:23.81	2026-05-31 14:12:23.811
490	522	508	3	Will buy again!	2026-05-17 14:12:23.811	2026-05-31 14:12:23.812
491	522	508	4	Will buy again!	2026-05-09 14:12:23.812	2026-05-31 14:12:23.812
492	526	505	4	Very satisfied with the purchase.	2026-05-12 14:12:23.812	2026-05-31 14:12:23.813
493	519	505	3	Great seller, fast delivery.	2026-05-06 14:12:23.813	2026-05-31 14:12:23.814
494	522	505	5	Reliable seller, good communication.	2026-05-12 14:12:23.814	2026-05-31 14:12:23.815
495	523	505	3	Great seller, fast delivery.	2026-05-14 14:12:23.815	2026-05-31 14:12:23.816
496	522	505	3	Good material, fair price.	2026-05-05 14:12:23.816	2026-05-31 14:12:23.816
497	519	528	3	Excellent quality! Highly recommended.	2026-05-19 14:12:23.816	2026-05-31 14:12:23.817
498	518	528	5	Good material, fair price.	2026-05-11 14:12:23.817	2026-05-31 14:12:23.817
499	519	528	4	Very satisfied with the purchase.	2026-05-18 14:12:23.818	2026-05-31 14:12:23.818
500	518	514	5	Reliable seller, good communication.	2026-05-08 14:12:23.818	2026-05-31 14:12:23.819
501	521	514	5	Good material, fair price.	2026-05-26 14:12:23.819	2026-05-31 14:12:23.819
502	521	514	5	Worth the price.	2026-05-11 14:12:23.819	2026-05-31 14:12:23.82
503	521	517	5	Great seller, fast delivery.	2026-05-17 14:12:23.82	2026-05-31 14:12:23.821
504	525	517	4	Reliable seller, good communication.	2026-05-13 14:12:23.821	2026-05-31 14:12:23.821
505	526	500	5	Best quality in the market.	2026-05-06 14:12:23.821	2026-05-31 14:12:23.822
506	522	500	4	Premium quality scrap.	2026-05-14 14:12:23.822	2026-05-31 14:12:23.822
507	519	533	5	Best quality in the market.	2026-05-16 14:12:23.822	2026-05-31 14:12:23.823
508	522	517	4	Best quality in the market.	2026-05-23 14:12:23.823	2026-05-31 14:12:23.824
509	527	517	4	Highly professional service.	2026-05-10 14:12:23.824	2026-05-31 14:12:23.824
510	518	517	4	Will buy again!	2026-05-23 14:12:23.824	2026-05-31 14:12:23.825
511	522	517	5	Highly professional service.	2026-05-20 14:12:23.825	2026-05-31 14:12:23.825
512	525	517	4	Good material, fair price.	2026-05-20 14:12:23.825	2026-05-31 14:12:23.826
513	526	535	4	Reliable seller, good communication.	2026-05-13 14:12:23.826	2026-05-31 14:12:23.827
514	524	535	3	Worth the price.	2026-05-12 14:12:23.827	2026-05-31 14:12:23.827
515	523	504	3	Reliable seller, good communication.	2026-05-14 14:12:23.827	2026-05-31 14:12:23.828
516	526	504	3	Worth the price.	2026-05-23 14:12:23.828	2026-05-31 14:12:23.829
517	524	530	3	Premium quality scrap.	2026-05-08 14:12:23.829	2026-05-31 14:12:23.829
518	522	530	3	Excellent quality! Highly recommended.	2026-05-08 14:12:23.83	2026-05-31 14:12:23.83
519	522	512	3	Premium quality scrap.	2026-05-07 14:12:23.83	2026-05-31 14:12:23.831
520	527	514	3	Worth the price.	2026-05-08 14:12:23.831	2026-05-31 14:12:23.832
521	520	514	5	Reliable seller, good communication.	2026-05-16 14:12:23.832	2026-05-31 14:12:23.832
522	519	514	3	Best quality in the market.	2026-05-31 14:12:23.832	2026-05-31 14:12:23.833
523	526	514	4	Good material, fair price.	2026-05-21 14:12:23.833	2026-05-31 14:12:23.833
524	518	514	5	Reliable seller, good communication.	2026-05-07 14:12:23.833	2026-05-31 14:12:23.834
525	526	511	3	Premium quality scrap.	2026-05-03 14:12:23.834	2026-05-31 14:12:23.835
526	522	498	5	Worth the price.	2026-05-15 14:12:23.835	2026-05-31 14:12:23.835
527	519	498	3	Highly professional service.	2026-05-26 14:12:23.835	2026-05-31 14:12:23.836
528	522	498	4	Reliable seller, good communication.	2026-05-22 14:12:23.836	2026-05-31 14:12:23.836
529	525	529	3	Good material, fair price.	2026-05-09 14:12:23.837	2026-05-31 14:12:23.837
530	524	529	3	Premium quality scrap.	2026-05-29 14:12:23.837	2026-05-31 14:12:23.838
531	519	529	3	Excellent quality! Highly recommended.	2026-05-25 14:12:23.838	2026-05-31 14:12:23.838
532	523	510	5	Very satisfied with the purchase.	2026-05-04 14:12:23.838	2026-05-31 14:12:23.839
533	520	510	4	Great seller, fast delivery.	2026-05-29 14:12:23.839	2026-05-31 14:12:23.84
534	520	516	4	Excellent quality! Highly recommended.	2026-05-19 14:12:23.84	2026-05-31 14:12:23.84
535	523	516	3	Premium quality scrap.	2026-05-13 14:12:23.84	2026-05-31 14:12:23.841
536	522	515	5	Best quality in the market.	2026-05-17 14:12:23.841	2026-05-31 14:12:23.841
537	526	515	3	Highly professional service.	2026-05-30 14:12:23.841	2026-05-31 14:12:23.842
538	526	541	5	Will buy again!	2026-05-29 14:12:23.842	2026-05-31 14:12:23.843
539	526	511	3	Excellent quality! Highly recommended.	2026-05-31 14:12:23.843	2026-05-31 14:12:23.843
540	524	511	3	Best quality in the market.	2026-05-25 14:12:23.843	2026-05-31 14:12:23.844
541	525	537	3	Reliable seller, good communication.	2026-05-10 14:12:23.844	2026-05-31 14:12:23.844
542	522	537	4	Will buy again!	2026-05-29 14:12:23.845	2026-05-31 14:12:23.845
543	524	510	5	Reliable seller, good communication.	2026-05-12 14:12:23.845	2026-05-31 14:12:23.846
544	519	510	5	Very satisfied with the purchase.	2026-05-02 14:12:23.846	2026-05-31 14:12:23.846
545	518	510	5	Will buy again!	2026-05-23 14:12:23.846	2026-05-31 14:12:23.847
546	522	515	3	Best quality in the market.	2026-05-23 14:12:23.847	2026-05-31 14:12:23.847
547	525	509	4	Highly professional service.	2026-05-19 14:12:23.847	2026-05-31 14:12:23.848
548	522	511	4	Excellent quality! Highly recommended.	2026-05-10 14:12:23.848	2026-05-31 14:12:23.849
549	525	514	4	Will buy again!	2026-05-06 14:12:23.849	2026-05-31 14:12:23.849
550	523	532	5	Worth the price.	2026-05-26 14:12:23.849	2026-05-31 14:12:23.85
551	523	529	5	Highly professional service.	2026-05-22 14:12:23.85	2026-05-31 14:12:23.85
552	523	529	4	Worth the price.	2026-05-11 14:12:23.85	2026-05-31 14:12:23.851
553	520	529	3	Reliable seller, good communication.	2026-05-22 14:12:23.851	2026-05-31 14:12:23.852
554	526	538	4	Premium quality scrap.	2026-05-05 14:12:23.852	2026-05-31 14:12:23.852
555	522	528	4	Premium quality scrap.	2026-05-31 14:12:23.852	2026-05-31 14:12:23.853
556	518	517	3	Will buy again!	2026-05-06 14:12:23.853	2026-05-31 14:12:23.853
557	519	515	4	Very satisfied with the purchase.	2026-05-02 14:12:23.853	2026-05-31 14:12:23.854
558	518	508	4	Best quality in the market.	2026-05-14 14:12:23.854	2026-05-31 14:12:23.854
559	522	508	5	Great seller, fast delivery.	2026-05-02 14:12:23.854	2026-05-31 14:12:23.855
560	526	508	5	Excellent quality! Highly recommended.	2026-05-09 14:12:23.855	2026-05-31 14:12:23.856
561	527	512	4	Will buy again!	2026-05-31 14:12:23.856	2026-05-31 14:12:23.856
562	518	512	4	Best quality in the market.	2026-05-17 14:12:23.856	2026-05-31 14:12:23.857
563	525	512	3	Very satisfied with the purchase.	2026-05-18 14:12:23.857	2026-05-31 14:12:23.857
564	520	504	3	Very satisfied with the purchase.	2026-05-12 14:12:23.857	2026-05-31 14:12:23.858
565	520	504	3	Excellent quality! Highly recommended.	2026-05-02 14:12:23.858	2026-05-31 14:12:23.858
566	527	504	3	Highly professional service.	2026-05-23 14:12:23.859	2026-05-31 14:12:23.859
567	523	536	3	Will buy again!	2026-05-11 14:12:23.859	2026-05-31 14:12:23.86
568	526	540	4	Good material, fair price.	2026-05-25 14:12:23.86	2026-05-31 14:12:23.86
569	518	515	5	Best quality in the market.	2026-05-10 14:12:23.86	2026-05-31 14:12:23.861
570	520	537	4	Best quality in the market.	2026-05-22 14:12:23.861	2026-05-31 14:12:23.861
571	523	537	4	Worth the price.	2026-05-21 14:12:23.861	2026-05-31 14:12:23.862
572	518	537	4	Good material, fair price.	2026-05-15 14:12:23.862	2026-05-31 14:12:23.863
573	518	498	3	Worth the price.	2026-05-25 14:12:23.863	2026-05-31 14:12:23.863
574	518	498	4	Excellent quality! Highly recommended.	2026-05-30 14:12:23.863	2026-05-31 14:12:23.864
575	527	508	5	Very satisfied with the purchase.	2026-05-19 14:12:23.864	2026-05-31 14:12:23.865
576	519	508	5	Reliable seller, good communication.	2026-05-08 14:12:23.865	2026-05-31 14:12:23.866
577	524	508	3	Worth the price.	2026-05-15 14:12:23.867	2026-05-31 14:12:23.867
578	527	516	3	Worth the price.	2026-05-04 14:12:23.868	2026-05-31 14:12:23.868
579	524	511	5	Highly professional service.	2026-05-28 14:12:23.869	2026-05-31 14:12:23.869
580	521	511	3	Reliable seller, good communication.	2026-05-14 14:12:23.87	2026-05-31 14:12:23.87
581	523	511	3	Excellent quality! Highly recommended.	2026-05-14 14:12:23.871	2026-05-31 14:12:23.871
582	521	528	5	Premium quality scrap.	2026-05-17 14:12:23.872	2026-05-31 14:12:23.872
583	518	500	4	Good material, fair price.	2026-05-23 14:12:23.872	2026-05-31 14:12:23.873
584	523	536	3	Highly professional service.	2026-05-25 14:12:23.873	2026-05-31 14:12:23.874
585	518	536	4	Premium quality scrap.	2026-05-09 14:12:23.874	2026-05-31 14:12:23.874
586	525	536	4	Very satisfied with the purchase.	2026-05-15 14:12:23.874	2026-05-31 14:12:23.875
587	524	513	5	Reliable seller, good communication.	2026-05-05 14:12:23.875	2026-05-31 14:12:23.875
588	522	513	5	Very satisfied with the purchase.	2026-05-24 14:12:23.875	2026-05-31 14:12:23.876
589	523	510	3	Will buy again!	2026-05-17 14:12:23.876	2026-05-31 14:12:23.877
590	522	510	5	Premium quality scrap.	2026-05-08 14:12:23.877	2026-05-31 14:12:23.877
591	527	510	3	Great seller, fast delivery.	2026-05-31 14:12:23.877	2026-05-31 14:12:23.878
592	526	530	5	Excellent quality! Highly recommended.	2026-05-15 14:12:23.878	2026-05-31 14:12:23.879
593	520	530	4	Very satisfied with the purchase.	2026-05-16 14:12:23.879	2026-05-31 14:12:23.879
594	522	514	5	Good material, fair price.	2026-05-15 14:12:23.879	2026-05-31 14:12:23.88
595	519	514	3	Highly professional service.	2026-05-12 14:12:23.88	2026-05-31 14:12:23.88
596	519	536	4	Very satisfied with the purchase.	2026-05-02 14:12:23.881	2026-05-31 14:12:23.881
597	526	535	3	Excellent quality! Highly recommended.	2026-05-17 14:12:23.881	2026-05-31 14:12:23.882
598	518	535	4	Highly professional service.	2026-05-09 14:12:23.882	2026-05-31 14:12:23.882
599	527	530	3	Excellent quality! Highly recommended.	2026-05-06 14:12:23.882	2026-05-31 14:12:23.883
600	520	504	3	Very satisfied with the purchase.	2026-05-07 14:12:23.883	2026-05-31 14:12:23.884
601	520	504	5	Best quality in the market.	2026-05-05 14:12:23.884	2026-05-31 14:12:23.884
602	522	504	4	Worth the price.	2026-05-23 14:12:23.884	2026-05-31 14:12:23.885
603	523	530	5	Good material, fair price.	2026-05-19 14:12:23.885	2026-05-31 14:12:23.886
604	525	530	5	Highly professional service.	2026-05-26 14:12:23.886	2026-05-31 14:12:23.886
605	518	530	4	Great seller, fast delivery.	2026-05-26 14:12:23.886	2026-05-31 14:12:23.887
606	522	503	4	Reliable seller, good communication.	2026-05-24 14:12:23.887	2026-05-31 14:12:23.888
607	526	503	3	Excellent quality! Highly recommended.	2026-05-21 14:12:23.888	2026-05-31 14:12:23.888
608	526	510	3	Worth the price.	2026-05-04 14:12:23.889	2026-05-31 14:12:23.889
609	524	503	3	Great seller, fast delivery.	2026-05-24 14:12:23.889	2026-05-31 14:12:23.89
610	523	498	5	Worth the price.	2026-05-11 14:12:23.89	2026-05-31 14:12:23.891
611	524	498	4	Worth the price.	2026-05-29 14:12:23.891	2026-05-31 14:12:23.891
612	527	498	4	Worth the price.	2026-05-25 14:12:23.891	2026-05-31 14:12:23.892
\.


--
-- Data for Name: SavedLocation; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."SavedLocation" (id, "userId", label, latitude, longitude, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Scan; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."Scan" (id, "primaryMaterial", "allMaterials", "anglesCount", "imageUrls", "estimatedMinPrice", "estimatedMaxPrice", "estimatedPrice", "estimationUnit", "conditionLevel", "userId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: scrap_user
--

COPY public."User" (name, email, "passwordHash", "isVerified", "createdAt", "googleId", "isActive", "isPrivateProfile", "lastLoginAt", "lastLoginIp", location, "newsletterOptIn", "passwordChangedAt", phone, "phoneVerified", "photoUrl", role, "showEmail", "showPhone", "updatedAt", id, "averageRating", latitude, longitude, "reviewCount") FROM stdin;
Omar Omar (Seller)	seller77_1780235966432@scrapexchange.com	$2b$12$/3wG.tx/RP3fchgc/v1vY.NdSK056T.lOChlqS.fLD.bf9w8yTfMa	t	2026-05-31 13:59:26.633	\N	t	f	\N	\N	Islamabad	f	\N	+925908028591	t	/uploads/products/profile_585_1780235966622.jpg	seller	t	f	2026-07-02 17:53:11.311	399	0	33.6852213633422	73.08027829639087	0
Sarah Ali (Seller)	seller88_1780235966634@scrapexchange.com	$2b$12$XHzW0OebyGOTFyyOvrEDhu1gVEt8f/7jgcAzF9Ly8Q3nPhe/jSG6e	t	2026-05-31 13:59:26.831	\N	t	f	\N	\N	Gujranwala	f	\N	+925608617998	t	/uploads/products/profile_123_1780235966822.jpg	seller	t	f	2026-07-02 17:53:11.314	400	0	32.20274389779217	74.19308238146522	0
Dina Malik (Seller)	seller99_1780235966833@scrapexchange.com	$2b$12$NY54WeYB9vJqzFp78nPyX.suZBsx21sQ0AIoDs7.eQqvbDqhn9a26	t	2026-05-31 13:59:27.03	\N	t	f	\N	\N	Quetta	f	\N	+929348744451	t	/uploads/products/profile_572_1780235967019.jpg	seller	t	f	2026-07-02 17:53:11.319	401	0	30.18021448001277	66.96791822273718	0
Zara Hussain (Seller)	seller1010_1780235967031@scrapexchange.com	$2b$12$6pI79VivGCU41LtLjrsPG.cwSpOfHGOZKmLV4Pjpt0MFKo1DDwio2	t	2026-05-31 13:59:27.229	\N	t	f	\N	\N	Islamabad	f	\N	+923158375490	t	/uploads/products/profile_101_1780235967219.jpg	seller	t	f	2026-07-02 17:53:11.322	402	0	33.69977978415233	73.00404230132838	0
Zara Jamal (Seller)	seller1111_1780235967230@scrapexchange.com	$2b$12$6rLPw9IcAY28UxMxp0.C2udCelwLUUqZn6fNliAydk7jSlHbZ6Vvu	t	2026-05-31 13:59:27.433	\N	t	f	\N	\N	Multan	f	\N	+929958732553	t	/uploads/products/profile_420_1780235967422.jpg	seller	t	f	2026-07-02 17:53:11.326	403	0	30.14155697122093	71.45749986404914	0
Bilal Ahmed (Seller)	seller1212_1780235967435@scrapexchange.com	$2b$12$olhsn6F8NrUo0fDCA/MdUuhrOBST.Z1sMTu8h/o5eYd/ND5MXkOe2	t	2026-05-31 13:59:27.631	\N	t	f	\N	\N	Multan	f	\N	+9210312777259	t	/uploads/products/profile_450_1780235967621.jpg	seller	t	f	2026-07-02 17:53:11.329	404	0	30.16925039992609	71.4196913701256	0
Zara Samir (Seller)	seller1313_1780235967632@scrapexchange.com	$2b$12$oDnFlUnrGShbtMgETc49de2EqHzgjFHziVLUKoTvDnKSPLdqWLC2C	t	2026-05-31 13:59:27.827	\N	t	f	\N	\N	Hyderabad	f	\N	+926915594975	t	/uploads/products/profile_393_1780235967818.jpg	seller	t	f	2026-07-02 17:53:11.332	405	0	25.42065787178375	68.50976794199788	0
Hana Samir (Seller)	seller1414_1780235967828@scrapexchange.com	$2b$12$3qJ6S2sALP1Zy5s3n8VUNOG6mWbXoPCfAqQDEka3TO4Ft99zesBBq	t	2026-05-31 13:59:28.03	\N	t	f	\N	\N	Rawalpindi	f	\N	+923545559925	t	/uploads/products/profile_624_1780235968021.jpg	seller	t	f	2026-07-02 17:53:11.335	406	0	33.58763553020121	73.23554044392128	0
Sarah Karim (Seller)	seller1515_1780235968031@scrapexchange.com	$2b$12$81BdtekQ6NDNKO0V1Z.uZeafKV8odqayPdhMx8WeoYAQvP/Deao0O	t	2026-05-31 13:59:28.226	\N	t	f	\N	\N	Multan	f	\N	+926441259463	t	/uploads/products/profile_507_1780235968217.jpg	seller	t	f	2026-07-02 17:53:11.34	407	0	30.12360482984016	71.4561841943345	0
Zara Malik (Dealer)	dealer22_1780235958294@scrapexchange.com	$2b$12$1SjYMl09duRfzuOv4K/wvuiUt8vsPRWHSeWHGtQaowMCpk4iIljSK	t	2026-05-31 13:59:18.813	\N	t	f	\N	\N	Hyderabad	f	\N	+925140760063	t	/uploads/products/profile_335_1780235958479.jpg	both	t	f	2026-07-02 17:53:11.346	364	0	25.41958269546394	68.42401893378604	0
Amina Omar (Dealer)	dealer33_1780235958814@scrapexchange.com	$2b$12$prenj0x3pXeeJILZzjRPouAaGm3GOHuXXRqknU1L7m/RugiYII2Le	t	2026-05-31 13:59:19.009	\N	t	f	\N	\N	Faisalabad	f	\N	+924637412045	t	/uploads/products/profile_709_1780235958997.jpg	both	t	f	2026-07-02 17:53:11.348	365	0	31.42786698974101	72.3803072605367	0
Leila Abdullah (Dealer)	dealer44_1780235959010@scrapexchange.com	$2b$12$PFgZc110BGTNhHWaNKnkSufNlj6IOmwTBRbraJmDoQ4D30X4Xp7Y6	t	2026-05-31 13:59:19.209	\N	t	f	\N	\N	Karachi	f	\N	+927662003426	t	/uploads/products/profile_390_1780235959197.jpg	both	t	f	2026-07-02 17:53:11.351	366	0	24.82480491642232	66.9823393516786	0
Rania Omar (Dealer)	dealer55_1780235959210@scrapexchange.com	$2b$12$aMn5.wplQKAoVX.iZ1JAzed0EhkCh2upLGIhcRXxnRWhn4qo5Ffiy	t	2026-05-31 13:59:19.406	\N	t	f	\N	\N	Lahore	f	\N	+9211692509574	t	/uploads/products/profile_269_1780235959396.jpg	both	t	f	2026-07-02 17:53:11.353	367	0	31.58419774826831	74.30445785073911	0
Nadia Rashid (Dealer)	dealer66_1780235959407@scrapexchange.com	$2b$12$7T5/X/RDZsLvGQjlQg5Ku.usjlk23ytvn7.mbG9/c6pIr8UdeLzVO	t	2026-05-31 13:59:19.605	\N	t	f	\N	\N	Peshawar	f	\N	+9211993265129	t	/uploads/products/profile_688_1780235959592.jpg	both	t	f	2026-07-02 17:53:11.355	368	0	34.01459182094397	71.49890832766727	0
Hassan Abdullah (Dealer)	dealer77_1780235959606@scrapexchange.com	$2b$12$XkghlgQN3ZLcJKT6XOS6xeCkFXPGb0ZW0iR9I2tXAdrxdj0ayAJa.	t	2026-05-31 13:59:19.809	\N	t	f	\N	\N	Karachi	f	\N	+923442751363	t	/uploads/products/profile_855_1780235959796.jpg	both	t	f	2026-07-02 17:53:11.356	369	0	24.87879299587231	66.98132322268232	0
Ayesha Mohamed (Seller)	seller66@scrapexchange.com	$2b$12$ik3PNipRuQwHDlaQrMiVrOFuA9WbeiGiFY1ThAijkUGWWVofCqJkW	t	2026-05-31 13:54:21.963	\N	t	f	\N	\N	Rawalpindi	f	\N	+925567647896	t	/uploads/products/profile_656_1780235661951.jpg	seller	t	f	2026-07-02 17:53:11.358	308	0	33.5476929998269	73.15472539169005	0
Leila Ahmed (Seller)	seller77@scrapexchange.com	$2b$12$SG1mpzQJA90LIAi1p1/tgudb/3dcktzVhcUD8Ehy6n7gmFJ1UJZzm	t	2026-05-31 13:54:22.167	\N	t	f	\N	\N	Gujranwala	f	\N	+926472562761	t	/uploads/products/profile_317_1780235662154.jpg	seller	t	f	2026-07-02 17:53:11.361	309	0	32.16718450705573	74.20122874068464	0
Layla Samir (Seller)	seller88@scrapexchange.com	$2b$12$.UmTQGYNJ23uQ0Qk03v/Y.lG0/kdeEs5EPhI2KDTQOE9NR.Eh1zRm	t	2026-05-31 13:54:22.37	\N	t	f	\N	\N	Faisalabad	f	\N	+924335856401	t	/uploads/products/profile_0_1780235662355.jpg	seller	t	f	2026-07-02 17:53:11.363	310	0	31.41450318800386	72.36328507260896	0
Tariq Hussain (Seller)	seller99@scrapexchange.com	$2b$12$jQpT4kN5lU2sC.IW2Exsm.NI4AqOloJfXh2dcDYDtUpmmF.2hPKNK	t	2026-05-31 13:54:22.568	\N	t	f	\N	\N	Gujranwala	f	\N	+927897795932	t	/uploads/products/profile_336_1780235662556.jpg	seller	t	f	2026-07-02 17:53:11.365	311	0	32.13219435101666	74.19784785477873	0
Layla Ali (Seller)	seller1010@scrapexchange.com	$2b$12$FzBiCzITesBruZF7gpic8OO.WHqIsVmC6KdAYgXU2gzwlsdZLTKt2	t	2026-05-31 13:54:22.769	\N	t	f	\N	\N	Rawalpindi	f	\N	+925901123959	t	/uploads/products/profile_543_1780235662758.jpg	seller	t	f	2026-07-02 17:53:11.367	312	0	33.58838855392626	73.21980343105625	0
Hana Jamal (Seller)	seller1111@scrapexchange.com	$2b$12$cpKc9/LzCovyqf.Sw3AhSubY1g6yt/MEE79fy0HyVEPymPHCfWYN.	t	2026-05-31 13:54:22.966	\N	t	f	\N	\N	Karachi	f	\N	+926587265946	t	/uploads/products/profile_879_1780235662956.jpg	seller	t	f	2026-07-02 17:53:11.37	313	0	24.90390082687993	67.04489704600451	0
Ali Karim (Seller)	seller1212@scrapexchange.com	$2b$12$Gyn9JbdBDrkkN09.qpXoYuxaXq.uY7KRaliHkVP.lZQggO0gi2Msq	t	2026-05-31 13:54:23.176	\N	t	f	\N	\N	Islamabad	f	\N	+927436619763	t	/uploads/products/profile_33_1780235663164.jpg	seller	t	f	2026-07-02 17:53:11.373	314	0	33.73067214276424	73.08305253784847	0
Yasmin Ibrahim (Seller)	seller1313@scrapexchange.com	$2b$12$f.O89jFRNjjCObMfkjat0.aUTFfOwDSPFrL2Y.9F2Pznr6JJ8eIIq	t	2026-05-31 13:54:23.394	\N	t	f	\N	\N	Lahore	f	\N	+9210939898147	t	/uploads/products/profile_360_1780235663382.jpg	seller	t	f	2026-07-02 17:53:11.376	315	0	31.58812120569826	74.36045395649303	0
Mariam Hussain (Seller)	seller1414@scrapexchange.com	$2b$12$d4O335RJGEFyGu/yk.yGwehvHEoMyc5R53EEgJBDqqyGs/NQNxrGe	t	2026-05-31 13:54:23.832	\N	t	f	\N	\N	Lahore	f	\N	+925588574613	t	/uploads/products/profile_882_1780235663588.jpg	seller	t	f	2026-07-02 17:53:11.379	316	0	31.55394838406799	74.3758851033149	0
Amina Omar (Seller)	seller1515@scrapexchange.com	$2b$12$U3dN/ILt8f3sruW/jD.DAO128sUNiwqHYte/ZJ.bLcBf2n6eEOo.u	t	2026-05-31 13:54:24.029	\N	t	f	\N	\N	Karachi	f	\N	+927752111892	t	/uploads/products/profile_137_1780235664018.jpg	seller	t	f	2026-07-02 17:53:11.381	317	0	24.84358345909031	66.95399994806642	0
Layla Rashid (Dealer)	dealer88_1780235959810@scrapexchange.com	$2b$12$AIHLzMJYCEdtqfc8QjFoeOwD2v065AnzlEb6m.ZIBuz5zgLMOA3p.	t	2026-05-31 13:59:20.004	\N	t	f	\N	\N	Karachi	f	\N	+926524782754	t	/uploads/products/profile_453_1780235959992.jpg	both	t	f	2026-07-02 17:53:11.384	370	0	24.85789669881324	67.04438402846208	0
Bilal Hussain (Dealer)	dealer99_1780235960005@scrapexchange.com	$2b$12$te8oCHybP4oPbyj4IR7ZBeN0TKWuMSAG98RAsajsZPuvSvDz6OLou	t	2026-05-31 13:59:20.201	\N	t	f	\N	\N	Peshawar	f	\N	+9210234310563	t	/uploads/products/profile_674_1780235960190.jpg	both	t	f	2026-07-02 17:53:11.386	371	0	33.97636214448907	71.4895848173193	0
Bilal Karim (Dealer)	dealer1010_1780235960202@scrapexchange.com	$2b$12$QFxuQcs0MzslqPgu/8Thuemp1vB0SUrbhKorcQ6DnXmii1CaFhZei	t	2026-05-31 13:59:20.403	\N	t	f	\N	\N	Rawalpindi	f	\N	+924336034110	t	/uploads/products/profile_578_1780235960391.jpg	both	t	f	2026-07-02 17:53:11.388	372	0	33.55590917710967	73.23740892453537	0
Muhammad Hussain (Dealer)	dealer1111_1780235960404@scrapexchange.com	$2b$12$ctSEN0C2pbLNBZSRX3Bz4eKUAHfvEoPrXvHNqOV3gmu/bPSKlR76m	t	2026-05-31 13:59:20.604	\N	t	f	\N	\N	Quetta	f	\N	+9210916769923	t	/uploads/products/profile_177_1780235960594.jpg	both	t	f	2026-07-02 17:53:11.39	373	0	30.20407367817941	66.979789295371	0
Hana Karim (Dealer)	dealer1212_1780235960605@scrapexchange.com	$2b$12$/KR4HdvdsDByVhdEnTpsBeWT9SlvkmlmiokJVEJgjFJsB8iUhqqZy	t	2026-05-31 13:59:20.804	\N	t	f	\N	\N	Quetta	f	\N	+925033766103	t	/uploads/products/profile_272_1780235960793.jpg	both	t	f	2026-07-02 17:53:11.392	374	0	30.16237871402407	66.97469527185481	0
Zara Ali (Dealer)	dealer1313_1780235960805@scrapexchange.com	$2b$12$McJI2gYNvU5Bdz9/emepiuhQmavsCutl1Hb2Gf8jBxyr4bBWB0s6G	t	2026-05-31 13:59:21.004	\N	t	f	\N	\N	Lahore	f	\N	+925094815192	t	/uploads/products/profile_882_1780235960994.jpg	both	t	f	2026-07-02 17:53:11.394	375	0	31.58354380179727	74.3170421379457	0
Fatima Hussain (Dealer)	dealer1414_1780235961005@scrapexchange.com	$2b$12$xaIs7SagYMzMi1PHOq7asuGAu3kYbTcVpGbMQM.CIb59BZJPfRuDa	t	2026-05-31 13:59:21.207	\N	t	f	\N	\N	Hyderabad	f	\N	+923913733488	t	/uploads/products/profile_248_1780235961194.jpg	both	t	f	2026-07-02 17:53:11.396	376	0	25.34681890996955	68.50929472473943	0
Hassan Ibrahim (Dealer)	dealer1515_1780235961208@scrapexchange.com	$2b$12$IxX6C5NMDzaqxIh3ZFrPS.l5dL5ww883IajwTJKITneoolHPYaKxi	t	2026-05-31 13:59:21.414	\N	t	f	\N	\N	Islamabad	f	\N	+928617116092	t	/uploads/products/profile_221_1780235961402.jpg	both	t	f	2026-07-02 17:53:11.398	377	0	33.64421309636538	73.07956231768202	0
Ayesha Hussein (Dealer)	dealer1616_1780235961415@scrapexchange.com	$2b$12$kn9cG9rg8DStVqxOiv0HtOt5zXHYr4MkwFFw3d13ZBYfKge1sN36e	t	2026-05-31 13:59:21.616	\N	t	f	\N	\N	Hyderabad	f	\N	+924781778404	t	/uploads/products/profile_994_1780235961604.jpg	both	t	f	2026-07-02 17:53:11.4	378	0	25.38609931938207	68.45761232210887	0
Tariq Hassan (Dealer)	dealer1818_1780235961813@scrapexchange.com	$2b$12$5BzcAgCrD9n3l587MPwNQeOoj0xoKCmzlSVc.IYu2whaZRF/tFk.a	t	2026-05-31 13:59:22.012	\N	t	f	\N	\N	Peshawar	f	\N	+929245221918	t	/uploads/products/profile_93_1780235962001.jpg	both	t	f	2026-07-02 17:53:11.403	380	0	34.00323361552694	71.55121435177658	0
Hassan Rashid (Dealer)	dealer1919_1780235962013@scrapexchange.com	$2b$12$r4moeWH1umdI0LxkhFE9AeWBrZI/NFAglPkRVv5eydobvkizSoJW.	t	2026-05-31 13:59:22.212	\N	t	f	\N	\N	Rawalpindi	f	\N	+924943324699	t	/uploads/products/profile_105_1780235962200.jpg	both	t	f	2026-07-02 17:53:11.405	381	0	33.59485925166891	73.15604709694601	0
Leila Malik (Dealer)	dealer2020_1780235962212@scrapexchange.com	$2b$12$9R5u8uukOtOdFbmRg3Gnk.G9Xwuqwqvrs5TxGlNixMkszR2I79nhC	t	2026-05-31 13:59:22.408	\N	t	f	\N	\N	Karachi	f	\N	+9210954649526	t	/uploads/products/profile_508_1780235962398.jpg	both	t	f	2026-07-02 17:53:11.406	382	0	24.885578957755	66.95961422993825	0
Samir Samir	buyer11_1780235962409@scrapexchange.com	$2b$12$MG2Ci13yYeyHUFEZ1D5rW.5DWZoX9E3M8/.GZb5ShbD9LCj1XztLq	t	2026-05-31 13:59:22.605	\N	t	f	\N	\N	Rawalpindi	f	\N	+927946122841	t	/uploads/products/profile_468_1780235962595.jpg	buyer	t	f	2026-07-02 17:53:11.408	383	0	33.5280488957131	73.20688035647171	0
Dina Rashid	buyer22_1780235962606@scrapexchange.com	$2b$12$GTVjVwfHE75Jvdeykr9yA.8.qHmYhnwWJjjAVPCSA9C7.Np89KSYW	t	2026-05-31 13:59:22.802	\N	t	f	\N	\N	Rawalpindi	f	\N	+923162579362	t	/uploads/products/profile_724_1780235962790.jpg	buyer	t	f	2026-07-02 17:53:11.41	384	0	33.54294515927823	73.1867982582894	0
Hassan Abdullah	buyer33_1780235962803@scrapexchange.com	$2b$12$.T7n6CzcMZ4wrQbmdymbCu6/PIa4uxBgqKvffcPZE9gqPVf6D74Ca	t	2026-05-31 13:59:23.528	\N	t	f	\N	\N	Karachi	f	\N	+926062874561	t	/uploads/products/profile_281_1780235962986.jpg	buyer	t	f	2026-07-02 17:53:11.412	385	0	24.82963804441144	66.99857108563457	0
Mariam Samir	buyer44_1780235963529@scrapexchange.com	$2b$12$ntLmFe2ySojJsk3wAfXUhehJPOoM90540RNMzGdKFf5064x4m5SE.	t	2026-05-31 13:59:23.726	\N	t	f	\N	\N	Karachi	f	\N	+925979277777	t	/uploads/products/profile_255_1780235963716.jpg	buyer	t	f	2026-07-02 17:53:11.413	386	0	24.84833952791164	66.99221425308515	0
Layla Rashid	buyer55_1780235963727@scrapexchange.com	$2b$12$hux9oNAefhikjulQekGGNu9QDDh8fC7I60/3rcFmlF9OcLm2z8Dha	t	2026-05-31 13:59:23.941	\N	t	f	\N	\N	Islamabad	f	\N	+927452066225	t	/uploads/products/profile_408_1780235963931.jpg	buyer	t	f	2026-07-02 17:53:11.415	387	0	33.70383036703033	73.0701720804907	0
Rania Hussein (Dealer)	dealer11@scrapexchange.com	$2b$12$MR8X8A8fAYoaLZBGP6VsI.phmdIrLon.c4kXVDwlfAybvm0EgAdHW	t	2026-05-31 13:54:14.138	\N	t	f	\N	\N	Lahore	f	\N	+928215670428	t	/uploads/products/profile_907_1780235654100.jpg	both	t	f	2026-07-02 17:53:11.417	273	0	31.54539041723808	74.34618104059462	0
Leila Abdullah (Dealer)	dealer22@scrapexchange.com	$2b$12$jKcXfA0YQWaZoSG/XiGJTub5HRRATs4cgYWmurpmD0sTD/RCKDkC6	t	2026-05-31 13:54:14.336	\N	t	f	\N	\N	Multan	f	\N	+923920624777	t	/uploads/products/profile_608_1780235654324.jpg	both	t	f	2026-07-02 17:53:11.419	274	0	30.1445541988069	71.41738082004326	0
Leila Abdullah (Dealer)	dealer33@scrapexchange.com	$2b$12$JZ.8VVPEbSk48c4/UDIXYOM8CM2uDFpLbBl2DrfV3izhPv8edpzmS	t	2026-05-31 13:54:14.533	\N	t	f	\N	\N	Lahore	f	\N	+929399183320	t	/uploads/products/profile_334_1780235654520.jpg	both	t	f	2026-07-02 17:53:11.42	275	0	31.59646461824317	74.31630004305127	0
Rania Jamal (Dealer)	dealer44@scrapexchange.com	$2b$12$0NGsBuoy/LPyLhrXXJl83u00/xVxBg4PEqgfa.fr/XuKabW1Q78f2	t	2026-05-31 13:54:14.732	\N	t	f	\N	\N	Islamabad	f	\N	+9210345354831	t	/uploads/products/profile_220_1780235654718.jpg	both	t	f	2026-07-02 17:53:11.422	276	0	33.68382930257344	73.07881170645643	0
Fatima Khan (Dealer)	dealer55@scrapexchange.com	$2b$12$jgiO0JcNtb7qfPjNoZAAMOopdZL8PE5kctLqdGG7unA08GnfOnnqW	t	2026-05-31 13:54:14.93	\N	t	f	\N	\N	Quetta	f	\N	+9211382957887	t	/uploads/products/profile_63_1780235654917.jpg	both	t	f	2026-07-02 17:53:11.423	277	0	30.22563670616541	67.02067818942125	0
Nadia Abdullah (Dealer)	dealer66@scrapexchange.com	$2b$12$ta.6vDCR68XWCyc00xl3ReiigAtjUYPKuPV9TP2Hbsz5eqzPk8J8C	t	2026-05-31 13:54:15.128	\N	t	f	\N	\N	Gujranwala	f	\N	+926465736889	t	/uploads/products/profile_165_1780235655115.jpg	both	t	f	2026-07-02 17:53:11.425	278	0	32.15888975429718	74.14700479345557	0
Dina Rashid (Dealer)	dealer77@scrapexchange.com	$2b$12$UVh3w9ibhc6ZF7RAp8nFo.wfkCZY0IJfUUw0lh1JVeaOX23g7lKnK	t	2026-05-31 13:54:15.324	\N	t	f	\N	\N	Multan	f	\N	+924490950632	t	/uploads/products/profile_616_1780235655311.jpg	both	t	f	2026-07-02 17:53:11.427	279	0	30.15220869786747	71.37632677843698	0
Omar Ali (Dealer)	dealer88@scrapexchange.com	$2b$12$yZKTouGuqyAPc2FGyobj5enXQrT6gwomTZ.FmNfHqSbx.LufWxSo6	t	2026-05-31 13:54:15.525	\N	t	f	\N	\N	Hyderabad	f	\N	+927029813577	t	/uploads/products/profile_521_1780235655511.jpg	both	t	f	2026-07-02 17:53:11.428	280	0	25.35953466158328	68.42751033326897	0
Tariq Hassan (Dealer)	dealer99@scrapexchange.com	$2b$12$iHX2rjsL9mcP5Mqbx7/q4umsxD4dl.oJVCZBCMrOuYN9tuMyTenza	t	2026-05-31 13:54:15.722	\N	t	f	\N	\N	Multan	f	\N	+929408956790	t	/uploads/products/profile_143_1780235655709.jpg	both	t	f	2026-07-02 17:53:11.43	281	0	30.1421983987185	71.40311354940026	0
Hana Samir (Dealer)	dealer1010@scrapexchange.com	$2b$12$bU7tWlA6mlhNun2CXjykxO68iaX34Y8FYV/4TbOGmQ7kIiMHC.eZm	t	2026-05-31 13:54:16.451	\N	t	f	\N	\N	Islamabad	f	\N	+923518465011	t	/uploads/products/profile_329_1780235655906.jpg	both	t	f	2026-07-02 17:53:11.431	282	0	33.65827764023522	73.08768247309725	0
Rashid Samir (Dealer)	dealer1111@scrapexchange.com	$2b$12$cHvPyUVsxDlnDLb4BzrmQeI/j55YO0SDYiEddM4UKyA8cOWxAcyWW	t	2026-05-31 13:54:16.652	\N	t	f	\N	\N	Gujranwala	f	\N	+9211961800287	t	/uploads/products/profile_992_1780235656639.jpg	both	t	f	2026-07-02 17:53:11.433	283	0	32.19034789486241	74.21260392961725	0
Hana Samir (Dealer)	dealer1212@scrapexchange.com	$2b$12$SsmJCL89f/wOLxbdwcQtcOTtmBgDibhYXWOVXqMRuqx/2niJ3XUcK	t	2026-05-31 13:54:16.854	\N	t	f	\N	\N	Islamabad	f	\N	+925091876575	t	/uploads/products/profile_435_1780235656841.jpg	both	t	f	2026-07-02 17:53:11.436	284	0	33.67463503233108	73.08839990232207	0
Muhammad Ahmed (Dealer)	dealer1313@scrapexchange.com	$2b$12$v4V946b7HfGYE9ANnOb2w.9rYc0G4CKeSsIHE9DqGFDdR9S3yNydq	t	2026-05-31 13:54:17.054	\N	t	f	\N	\N	Quetta	f	\N	+927405172655	t	/uploads/products/profile_905_1780235657043.jpg	both	t	f	2026-07-02 17:53:11.438	285	0	30.19534632661378	67.0173946304783	0
Yasmin Hassan (Dealer)	dealer1414@scrapexchange.com	$2b$12$5uLHxE0lMr8fUBEFT6dxF.0.f.QL1yYKmvmtMqr4Dt8tzz0DKitPG	t	2026-05-31 13:54:17.258	\N	t	f	\N	\N	Hyderabad	f	\N	+924780358113	t	/uploads/products/profile_308_1780235657246.jpg	both	t	f	2026-07-02 17:53:11.44	286	0	25.35279120030475	68.49597768246555	0
Hassan Khan (Dealer)	dealer1515@scrapexchange.com	$2b$12$yO.r2g9mtySycSi7ESWk9.LEFI0U7APKkdnGxjZZvoTla.dvMD5eC	t	2026-05-31 13:54:17.458	\N	t	f	\N	\N	Multan	f	\N	+928009125755	t	/uploads/products/profile_288_1780235657445.jpg	both	t	f	2026-07-02 17:53:11.443	287	0	30.11516448072413	71.38707176783673	0
Mariam Ali (Dealer)	dealer1616@scrapexchange.com	$2b$12$3NFzMpZRKT44wsvl48B5uedbGs5c5zTEt/9EqVO5IKlkQhimUxoXu	t	2026-05-31 13:54:17.661	\N	t	f	\N	\N	Multan	f	\N	+924243598564	t	/uploads/products/profile_824_1780235657649.jpg	both	t	f	2026-07-02 17:53:11.445	288	0	30.15997061742207	71.45548433707455	0
Hana Hussein (Dealer)	dealer1717@scrapexchange.com	$2b$12$zy.pVaxb0Nxl28pnIEKg/u9h6uBy6cmI/iarh9HTsMktt6GKS7v0K	t	2026-05-31 13:54:17.861	\N	t	f	\N	\N	Faisalabad	f	\N	+927334908352	t	/uploads/products/profile_994_1780235657848.jpg	both	t	f	2026-07-02 17:53:11.447	289	0	31.37064905815295	72.30340706626468	0
Rania Karim (Dealer)	dealer1818@scrapexchange.com	$2b$12$iRfQSc8vISEYU4.nKof7XOf9BzXBofb/jT7HA1CiY/YOLlkZsuMJu	t	2026-05-31 13:54:18.06	\N	t	f	\N	\N	Rawalpindi	f	\N	+929466789501	t	/uploads/products/profile_968_1780235658047.jpg	both	t	f	2026-07-02 17:53:11.449	290	0	33.61972141051071	73.17255495011774	0
Samir Hussein (Dealer)	dealer2020@scrapexchange.com	$2b$12$zxcSNu3gk/aOR8zpS0qsFOQKdq9QadJs2TWua/3Iu5SXbfmwMshYe	t	2026-05-31 13:54:18.458	\N	t	f	\N	\N	Lahore	f	\N	+924339169256	t	/uploads/products/profile_715_1780235658444.jpg	both	t	f	2026-07-02 17:53:11.454	292	0	31.50687906016469	74.31028701561266	0
Ayesha Ibrahim	buyer11@scrapexchange.com	$2b$12$d/4gFuNHHOmqa7nmQCWTFOivgiMk0Bgzly7w80gB6I3bpYRI04o4K	t	2026-05-31 13:54:18.96	\N	t	f	\N	\N	Multan	f	\N	+927547836033	t	/uploads/products/profile_736_1780235658642.jpg	buyer	t	f	2026-07-02 17:53:11.456	293	0	30.11653145654951	71.40890406671892	0
Ahmed Rashid	buyer22@scrapexchange.com	$2b$12$QwnwGyS4Bdckm/ms1OwI5eb7WxYgqVufwVOl1pTDU4X.eU0BI.key	t	2026-05-31 13:54:19.163	\N	t	f	\N	\N	Quetta	f	\N	+923823140319	t	/uploads/products/profile_130_1780235659152.jpg	buyer	t	f	2026-07-02 17:53:11.459	294	0	30.20443147314489	67.03637975936748	0
Nadia Samir	buyer33@scrapexchange.com	$2b$12$8XOR1Qng3U2Gnl.mUtC7iuBlRjve8LcSOEnfPw/Ko4tB5nUSz0qRy	t	2026-05-31 13:54:19.363	\N	t	f	\N	\N	Multan	f	\N	+927405755298	t	/uploads/products/profile_845_1780235659348.jpg	buyer	t	f	2026-07-02 17:53:11.461	295	0	30.19000246476855	71.41478602044172	0
Omar Ali	buyer44@scrapexchange.com	$2b$12$eMMoe3orF1BptRDVAUN.3elLHxLGg2eZa0E/mDgc3rPCYwGGD/La.	t	2026-05-31 13:54:19.558	\N	t	f	\N	\N	Islamabad	f	\N	+927935958331	t	/uploads/products/profile_423_1780235659547.jpg	buyer	t	f	2026-07-02 17:53:11.463	296	0	33.73311873468457	73.06183019918335	0
Ahmed Ibrahim	buyer55@scrapexchange.com	$2b$12$WHGXNoFuDmL7.esgb0KFROttoCxI8Fmv0oo9sfCKle8TIpSepp21a	t	2026-05-31 13:54:19.757	\N	t	f	\N	\N	Peshawar	f	\N	+926514403011	t	/uploads/products/profile_400_1780235659745.jpg	buyer	t	f	2026-07-02 17:53:11.465	297	0	33.9876697879908	71.57353783716079	0
Leila Hassan	buyer66@scrapexchange.com	$2b$12$spcW2Bqli5AwTz5WQCc7juTWz7aGIj5.VYuN.qc5miwzFPyT9xhr2	t	2026-05-31 13:54:19.956	\N	t	f	\N	\N	Quetta	f	\N	+928016020817	t	/uploads/products/profile_172_1780235659944.jpg	buyer	t	f	2026-07-02 17:53:11.467	298	0	30.22796534395297	66.97532007289331	0
Sarah Hussain	buyer77@scrapexchange.com	$2b$12$GqizybkXyeO0bRoL7o3OT.8RGlAaB6EPPgpXfFsAV6h3o.RSstWze	t	2026-05-31 13:54:20.154	\N	t	f	\N	\N	Hyderabad	f	\N	+926284657826	t	/uploads/products/profile_849_1780235660142.jpg	buyer	t	f	2026-07-02 17:53:11.468	299	0	25.36145003016796	68.4451847319423	0
Omar Jamal	buyer88@scrapexchange.com	$2b$12$Ht/bcx4ZKxUmA0zEphXbBuubQ9ytx4j3oviNH90cWI9tUzwCAdaAC	t	2026-05-31 13:54:20.352	\N	t	f	\N	\N	Gujranwala	f	\N	+927866616068	t	/uploads/products/profile_233_1780235660340.jpg	buyer	t	f	2026-07-02 17:53:11.47	300	0	32.14684946809442	74.15687560012636	0
Ahmed Hassan	buyer99@scrapexchange.com	$2b$12$TnpJ/TU6n2wgBJUIO30dN.cEb5sp7PeW3SvzWxhys/gAN9cE1iJtG	t	2026-05-31 13:54:20.554	\N	t	f	\N	\N	Rawalpindi	f	\N	+928582305349	t	/uploads/products/profile_95_1780235660539.jpg	buyer	t	f	2026-07-02 17:53:11.472	301	0	33.58619187252287	73.2130891507312	0
Muhammad Malik	buyer1010@scrapexchange.com	$2b$12$x7ehIBkv1AENZz5ZJ8/F2ugmkb8Y9nAkV0uQVgTCFJpE4uYK5MVIi	t	2026-05-31 13:54:20.755	\N	t	f	\N	\N	Multan	f	\N	+925057512777	t	/uploads/products/profile_329_1780235660743.jpg	buyer	t	f	2026-07-02 17:53:11.473	302	0	30.18842272742299	71.41061584960882	0
Hassan Ibrahim (Seller)	seller11@scrapexchange.com	$2b$12$nGEMdJ4YKicFk9oUPWZyWuBY/BfqZi8e7NpJKrsyisjBOA/SxIQAK	t	2026-05-31 13:54:20.955	\N	t	f	\N	\N	Gujranwala	f	\N	+927536269355	t	/uploads/products/profile_359_1780235660943.jpg	seller	t	f	2026-07-02 17:53:11.475	303	0	32.15628885503493	74.15621308528036	0
Tariq Malik (Seller)	seller22@scrapexchange.com	$2b$12$Q18Wv4j90t6.nWwGn0kAVu8Gyl7EKtd49XIu.kTlSIoVbLpKppNuC	t	2026-05-31 13:54:21.153	\N	t	f	\N	\N	Lahore	f	\N	+925967811105	t	/uploads/products/profile_517_1780235661140.jpg	seller	t	f	2026-07-02 17:53:11.477	304	0	31.53914757842002	74.30827545183772	0
Samir Ali (Seller)	seller33@scrapexchange.com	$2b$12$kjPKJpExMCVrARWd.X1oj.DiKYhMDE0GWJ.TPp3kol6isjMP07yMm	t	2026-05-31 13:54:21.349	\N	t	f	\N	\N	Hyderabad	f	\N	+928366204782	t	/uploads/products/profile_856_1780235661337.jpg	seller	t	f	2026-07-02 17:53:11.479	305	0	25.43284919684519	68.51887782780318	0
Nadia Samir (Seller)	seller44@scrapexchange.com	$2b$12$m4/LXxDK7dN13KRj1xNBbu6t7G9mpijn1KMyXAAWuBvbI7XTxLyQu	t	2026-05-31 13:54:21.546	\N	t	f	\N	\N	Rawalpindi	f	\N	+927935445424	t	/uploads/products/profile_364_1780235661535.jpg	seller	t	f	2026-07-02 17:53:11.481	306	0	33.61254373897638	73.18554431369958	0
Noura Jamal (Seller)	seller55@scrapexchange.com	$2b$12$BSB.cKia4I4IhsoVR3eM..T7WT1elg825FQv.NuSZR29m2nALf/xu	t	2026-05-31 13:54:21.758	\N	t	f	\N	\N	Quetta	f	\N	+925231056487	t	/uploads/products/profile_213_1780235661746.jpg	seller	t	f	2026-07-02 17:53:11.483	307	0	30.13260816515799	67.04583344391045	0
Nadia Malik	buyer66_1780235963942@scrapexchange.com	$2b$12$fg5.hFQk961YvYjx.TD0AuFWKYOAAd7/vv1gIrmzAQELcT4buN1Zy	t	2026-05-31 13:59:24.15	\N	t	f	\N	\N	Hyderabad	f	\N	+923838184256	t	/uploads/products/profile_126_1780235964138.jpg	buyer	t	f	2026-07-02 17:53:11.484	388	0	25.34867626052492	68.4848820079515	0
Layla Khan	buyer77_1780235964151@scrapexchange.com	$2b$12$df5vIZbW7reocioMlyL6e.CzdHmKLlcpdEK52yOIegIE6vqIP6jjK	t	2026-05-31 13:59:24.35	\N	t	f	\N	\N	Multan	f	\N	+929366181046	t	/uploads/products/profile_769_1780235964339.jpg	buyer	t	f	2026-07-02 17:53:11.486	389	0	30.11129002619972	71.47382986492478	0
Nadia Hussein	buyer88_1780235964351@scrapexchange.com	$2b$12$zAKss1oB6YS6RNiRilxynu0cha3xLzj038Oiu6vr6C0l1sXu0Eju6	t	2026-05-31 13:59:24.557	\N	t	f	\N	\N	Lahore	f	\N	+923998375249	t	/uploads/products/profile_772_1780235964546.jpg	buyer	t	f	2026-07-02 17:53:11.488	390	0	31.58995765027931	74.35108765931508	0
Ayesha Ahmed	buyer99_1780235964559@scrapexchange.com	$2b$12$mGF/JQk81b8/G/H4qahno.uWu/PPNU.uwAMjarlnnzPIeKgAwPMAW	t	2026-05-31 13:59:24.757	\N	t	f	\N	\N	Rawalpindi	f	\N	+928739026429	t	/uploads/products/profile_0_1780235964746.jpg	buyer	t	f	2026-07-02 17:53:11.489	391	0	33.59944852600741	73.1475091728562	0
Samir Karim	buyer1010_1780235964758@scrapexchange.com	$2b$12$D2ibyq7JL7HYaSP229vUHuI3AiVFb22Bz2V40ok1gvdZElRU2EEFK	t	2026-05-31 13:59:24.954	\N	t	f	\N	\N	Quetta	f	\N	+923115359587	t	/uploads/products/profile_180_1780235964945.jpg	buyer	t	f	2026-07-02 17:53:11.491	392	0	30.19594341686265	67.02489165448688	0
Noura Ahmed (Seller)	seller11_1780235964955@scrapexchange.com	$2b$12$rwZZrT.MlMZdswUF3D4mKuqmgdjjkTNgyQL03kRG3VwSFE8RUJrXC	t	2026-05-31 13:59:25.159	\N	t	f	\N	\N	Rawalpindi	f	\N	+928312541930	t	/uploads/products/profile_149_1780235965147.jpg	seller	t	f	2026-07-02 17:53:11.492	393	0	33.53493362267951	73.17774595074306	0
Dina Hassan (Seller)	seller22_1780235965159@scrapexchange.com	$2b$12$1Oui6S6Gw5.f/xfau1C3c.b7sjQKHUvM5yseAdvNjcqOemedUaZqW	t	2026-05-31 13:59:25.36	\N	t	f	\N	\N	Gujranwala	f	\N	+929108179468	t	/uploads/products/profile_809_1780235965349.jpg	seller	t	f	2026-07-02 17:53:11.494	394	0	32.18693956009719	74.22555994013314	0
Amina Malik (Seller)	seller33_1780235965360@scrapexchange.com	$2b$12$NbU26LT45Nfklsm0ZGhB3e8FBwkwjqj.D2c4Dhtlio7VGsB87ER0i	t	2026-05-31 13:59:25.556	\N	t	f	\N	\N	Gujranwala	f	\N	+9211763286663	t	/uploads/products/profile_323_1780235965543.jpg	seller	t	f	2026-07-02 17:53:11.496	395	0	32.15893222340665	74.1605757166244	0
Samir Mohamed (Seller)	seller44_1780235965557@scrapexchange.com	$2b$12$Jqp8UIyN1Zp.7hxoET8OK.Vbbx9fgwqlDvSQer.lMDKFdQpfRZaGu	t	2026-05-31 13:59:25.759	\N	t	f	\N	\N	Peshawar	f	\N	+928986651263	t	/uploads/products/profile_872_1780235965747.jpg	seller	t	f	2026-07-02 17:53:11.498	396	0	34.04199218226007	71.5011740928589	0
Hassan Hussain (Seller)	seller55_1780235965760@scrapexchange.com	$2b$12$tsXjpur83ir3aOCnBHkmLu/fOmhDaj9KkcPQPuo0JY5to.Ql1uuO.	t	2026-05-31 13:59:26.234	\N	t	f	\N	\N	Islamabad	f	\N	+928631085802	t	/uploads/products/profile_796_1780235965950.jpg	seller	t	f	2026-07-02 17:53:11.499	397	0	33.65335847378252	73.0014120177722	0
Hassan Jamal (Dealer)	dealer22_1780236045959@scrapexchange.com	$2b$12$wG/CrH3Djw.Vz7V2LdO6ve1f2Dpiz5e5j940WuTIdBVFFDLaxial2	t	2026-05-31 14:00:46.157	\N	t	f	\N	\N	Karachi	f	\N	+9210721564119	t	/uploads/products/profile_726_1780236046144.jpg	both	t	f	2026-07-02 17:53:11.502	409	0	24.84813200233222	66.95764839494905	0
Fatima Rashid (Dealer)	dealer33_1780236046158@scrapexchange.com	$2b$12$Le9/wENVDJ7KVCKUAUcc3Oiqqu44OKu4e6lDLHw4SV56pPYb6oWf2	t	2026-05-31 14:00:46.371	\N	t	f	\N	\N	Hyderabad	f	\N	+928979742139	t	/uploads/products/profile_417_1780236046358.jpg	both	t	f	2026-07-02 17:53:11.504	410	0	25.42665291130236	68.45274096258382	0
Sarah Hussein (Dealer)	dealer44_1780236046372@scrapexchange.com	$2b$12$STkqwa4u9BrMCdkUSUGT1eEp6.gIr3VyP.dK7u1PqXLdDDVtrZXBq	t	2026-05-31 14:00:46.568	\N	t	f	\N	\N	Faisalabad	f	\N	+926206988497	t	/uploads/products/profile_413_1780236046556.jpg	both	t	f	2026-07-02 17:53:11.505	411	0	31.45210094779259	72.37515710689142	0
Khalid Omar (Dealer)	dealer55_1780236046570@scrapexchange.com	$2b$12$qFgT8U0n5dEvF/VZnUah6eNDWWsoSeh/VMkMAMKctsmg9ONSxeyke	t	2026-05-31 14:00:46.765	\N	t	f	\N	\N	Faisalabad	f	\N	+926307567388	t	/uploads/products/profile_902_1780236046752.jpg	both	t	f	2026-07-02 17:53:11.507	412	0	31.4520918978649	72.38254251283551	0
Rania Abdullah (Dealer)	dealer66_1780236046766@scrapexchange.com	$2b$12$uAvRxMHGoM8llmEcKmoI3.1rVVmhfNI3ZY.HaffO2fVeM1bJ4WFWW	t	2026-05-31 14:00:46.965	\N	t	f	\N	\N	Peshawar	f	\N	+9211649450831	t	/uploads/products/profile_300_1780236046950.jpg	both	t	f	2026-07-02 17:53:11.509	413	0	34.06088860417896	71.55562060682789	0
Khalid Jamal (Dealer)	dealer77_1780236046966@scrapexchange.com	$2b$12$G5WSjrqZMuK4posN.wceS.kFK9B4u88HZnJiAtD1ykrpXtxBPYwye	t	2026-05-31 14:00:47.163	\N	t	f	\N	\N	Rawalpindi	f	\N	+9211931060512	t	/uploads/products/profile_589_1780236047149.jpg	both	t	f	2026-07-02 17:53:11.511	414	0	33.54749912029234	73.23953243634637	0
Layla Ali (Dealer)	dealer88_1780236047164@scrapexchange.com	$2b$12$7to8jKWRexYmFEX5Y0M1r.9rYb5R65AOPY7NSMHXpQ9ONoN2QiImy	t	2026-05-31 14:00:47.363	\N	t	f	\N	\N	Quetta	f	\N	+927744895073	t	/uploads/products/profile_397_1780236047350.jpg	both	t	f	2026-07-02 17:53:11.512	415	0	30.163852732288	67.04474852393176	0
Hassan Khan (Dealer)	dealer99_1780236047364@scrapexchange.com	$2b$12$paHr2VycRmkOFKuTRWw2g.K8RjZF02YKmatdO9MN144.93zAmCZYO	t	2026-05-31 14:00:47.568	\N	t	f	\N	\N	Faisalabad	f	\N	+927118420531	t	/uploads/products/profile_393_1780236047556.jpg	both	t	f	2026-07-02 17:53:11.514	416	0	31.37592988548482	72.36539895754633	0
Omar Hussein (Dealer)	dealer1010_1780236047569@scrapexchange.com	$2b$12$LA5NuDhjG6zvj/.SZhgXWuJBOpubZbWnmRjsgOyI.m5tA5JmH6SVm	t	2026-05-31 14:00:47.763	\N	t	f	\N	\N	Peshawar	f	\N	+923028542068	t	/uploads/products/profile_395_1780236047751.jpg	both	t	f	2026-07-02 17:53:11.515	417	0	34.06365680237625	71.54984622003943	0
Rashid Ahmed (Dealer)	dealer1111_1780236047764@scrapexchange.com	$2b$12$BZ9UNwDdbLHc4t2nww.HZukMaMbNxzCIK3Cs57mz220OJbaPSS5YC	t	2026-05-31 14:00:47.958	\N	t	f	\N	\N	Islamabad	f	\N	+926027556512	t	/uploads/products/profile_969_1780236047946.jpg	both	t	f	2026-07-02 17:53:11.517	418	0	33.64252220396629	73.02629534962334	0
Ali Rashid (Dealer)	dealer1212_1780236047959@scrapexchange.com	$2b$12$ypIrmcq7vhiKjtD4dl7bfeoV6Tbi/rBC/1lAELaZsJFUb2sC/t3ti	t	2026-05-31 14:00:48.155	\N	t	f	\N	\N	Lahore	f	\N	+9211067672201	t	/uploads/products/profile_817_1780236048143.jpg	both	t	f	2026-07-02 17:53:11.519	419	0	31.55116017410915	74.31785121370069	0
Bilal Samir (Dealer)	dealer1313_1780236048155@scrapexchange.com	$2b$12$evNv5ypWs8RmUrMIPfrJ8uVfZhIH8VCIzzm6zjwnHQWxdpaEPakGi	t	2026-05-31 14:00:48.355	\N	t	f	\N	\N	Karachi	f	\N	+925808054064	t	/uploads/products/profile_845_1780236048342.jpg	both	t	f	2026-07-02 17:53:11.521	420	0	24.86248444587132	66.98376289317804	0
Dina Hassan (Dealer)	dealer1414_1780236048356@scrapexchange.com	$2b$12$8rKsA9BfMNNrsxRefiGTNOn.j/rZOTHuBN2UJlLOtjVfRhS3fHVdC	t	2026-05-31 14:00:48.552	\N	t	f	\N	\N	Karachi	f	\N	+929228268910	t	/uploads/products/profile_196_1780236048542.jpg	both	t	f	2026-07-02 17:53:11.523	421	0	24.88401700228745	67.04085994472257	0
Sarah Samir (Dealer)	dealer1515_1780236048553@scrapexchange.com	$2b$12$LsXYwavuuRKs5s8.9TOYUuQOPoSYrPCCQkmihTG4.jFwrM5jX5bi.	t	2026-05-31 14:00:48.752	\N	t	f	\N	\N	Karachi	f	\N	+923368065426	t	/uploads/products/profile_349_1780236048738.jpg	both	t	f	2026-07-02 17:53:11.527	422	0	24.83694294326761	67.01292422881754	0
Noura Karim (Dealer)	dealer1616_1780236048752@scrapexchange.com	$2b$12$1gF2a2wzP4NzfrEzpWTxlumQFTf6Bin/QJog8CotHFOZ426RfeGUy	t	2026-05-31 14:00:48.952	\N	t	f	\N	\N	Faisalabad	f	\N	+928759506776	t	/uploads/products/profile_79_1780236048937.jpg	both	t	f	2026-07-02 17:53:11.529	423	0	31.43109748453016	72.36713044125811	0
Mariam Samir (Dealer)	dealer1717_1780236048953@scrapexchange.com	$2b$12$bwHV9.7Jigz7scyYbhvh..0bp8hx86Zkx8QKk0aw0tYdxq9Cm4og2	t	2026-05-31 14:00:49.152	\N	t	f	\N	\N	Peshawar	f	\N	+929391037999	t	/uploads/products/profile_223_1780236049138.jpg	both	t	f	2026-07-02 17:53:11.53	424	0	34.04942401919215	71.5151578504207	0
Nadia Karim (Dealer)	dealer1818_1780236049153@scrapexchange.com	$2b$12$Co/xuk9cCeGBoGMFuAf16eY6SrMHVHHstVt76/2K6fAwXJPR811F6	t	2026-05-31 14:00:49.35	\N	t	f	\N	\N	Gujranwala	f	\N	+925671342996	t	/uploads/products/profile_766_1780236049337.jpg	both	t	f	2026-07-02 17:53:11.532	425	0	32.11927446146395	74.14491963390319	0
Leila Ahmed (Dealer)	dealer1919_1780236049351@scrapexchange.com	$2b$12$iCKPpjTNCBo8btZhCz3YL.MD81ZvWERIa6MU1/yZX2y4lkN/HcuuK	t	2026-05-31 14:00:49.548	\N	t	f	\N	\N	Gujranwala	f	\N	+9211449855072	t	/uploads/products/profile_897_1780236049536.jpg	both	t	f	2026-07-02 17:53:11.533	426	0	32.13002426586562	74.13604501367294	0
Bilal Ali (Dealer)	dealer2020_1780236049549@scrapexchange.com	$2b$12$jnjjw.fxjlrcseudpGDmT.cIA5jQrswQuFO3tIg3h0TRNXhnIr9.O	t	2026-05-31 14:00:49.747	\N	t	f	\N	\N	Peshawar	f	\N	+929609874891	t	/uploads/products/profile_723_1780236049735.jpg	both	t	f	2026-07-02 17:53:11.535	427	0	34.01159246029059	71.53106661507371	0
Zara Malik	buyer11_1780236049748@scrapexchange.com	$2b$12$Jp8yO4/aCDMezFhf22aoTeZCp6/iVieeKLAVcXDwZMgHj2lZTLobe	t	2026-05-31 14:00:49.944	\N	t	f	\N	\N	Islamabad	f	\N	+926857245797	t	/uploads/products/profile_525_1780236049932.jpg	buyer	t	f	2026-07-02 17:53:11.537	428	0	33.63787846388717	73.04830383236913	0
Sarah Ibrahim	buyer22_1780236049945@scrapexchange.com	$2b$12$A1To/pzkp1kVQw7rNilgCOoZ/uMiSY7v2GGvH9ewTPBqsUnUcyVpu	t	2026-05-31 14:00:50.142	\N	t	f	\N	\N	Peshawar	f	\N	+929007509506	t	/uploads/products/profile_364_1780236050129.jpg	buyer	t	f	2026-07-02 17:53:11.538	429	0	34.03449427733791	71.54842678359859	0
Tariq Ibrahim	buyer33_1780236050143@scrapexchange.com	$2b$12$e7VIRVAwihOluv92IXWj9Otdjf7Km6yPn7N7HwXS9apfIhhYATCZe	t	2026-05-31 14:00:50.338	\N	t	f	\N	\N	Karachi	f	\N	+923211945310	t	/uploads/products/profile_211_1780236050325.jpg	buyer	t	f	2026-07-02 17:53:11.54	430	0	24.90853742424818	66.98186126228937	0
Nadia Samir	buyer44_1780236050339@scrapexchange.com	$2b$12$kpr0xA0dzxKqjkSsoYrTFuTBvIpixYPiVRF1FzKEbeHyBOpDHhFCi	t	2026-05-31 14:00:50.535	\N	t	f	\N	\N	Rawalpindi	f	\N	+929598577972	t	/uploads/products/profile_732_1780236050522.jpg	buyer	t	f	2026-07-02 17:53:11.541	431	0	33.60121274414937	73.1525186602394	0
Ayesha Karim	buyer55_1780236050535@scrapexchange.com	$2b$12$gW7FbD8FIFAwmUQdffLGiOHSuF5hu/lvfLZ8ctWa1mUkZaNuTOmA6	t	2026-05-31 14:00:50.731	\N	t	f	\N	\N	Faisalabad	f	\N	+926555187335	t	/uploads/products/profile_886_1780236050720.jpg	buyer	t	f	2026-07-02 17:53:11.543	432	0	31.40822338983151	72.32652886580209	0
Yasmin Karim	buyer66_1780236050732@scrapexchange.com	$2b$12$HaA1CB3Dr9TDHdy1uOwMAuBwCdVUED2OjmlqtF2bF.z5UIoKKuqpu	t	2026-05-31 14:00:50.925	\N	t	f	\N	\N	Quetta	f	\N	+926426256067	t	/uploads/products/profile_628_1780236050914.jpg	buyer	t	f	2026-07-02 17:53:11.545	433	0	30.22800938582693	67.06024152616473	0
Zara Karim	buyer88_1780236051122@scrapexchange.com	$2b$12$g.c2KzVBIQnwW4pUIuFMH.vU0DK4jXxDRr7PxY2kXMWEG.Kv0JxMK	t	2026-05-31 14:00:51.319	\N	t	f	\N	\N	Lahore	f	\N	+9211466661462	t	/uploads/products/profile_793_1780236051307.jpg	buyer	t	f	2026-07-02 17:53:11.548	435	0	31.50883187367419	74.39110701697219	0
Omar Jamal	buyer99_1780236051321@scrapexchange.com	$2b$12$tWHCz/PSNmhZOL2JCHL80eCzrHs13hAvtUwheI/C./fLZ6/FHKeJK	t	2026-05-31 14:00:51.518	\N	t	f	\N	\N	Faisalabad	f	\N	+9211160996013	t	/uploads/products/profile_947_1780236051506.jpg	buyer	t	f	2026-07-02 17:53:11.549	436	0	31.37336712296168	72.32142941530202	0
Khalid Mohamed	buyer1010_1780236051520@scrapexchange.com	$2b$12$xaqSx5j21GnIfq0L3F1ZJ.JIuExk/8R8ZhDhZq2bohY4./hZSVt8C	t	2026-05-31 14:00:51.714	\N	t	f	\N	\N	Islamabad	f	\N	+927092630093	t	/uploads/products/profile_124_1780236051704.jpg	buyer	t	f	2026-07-02 17:53:11.551	437	0	33.70839483360938	73.0113440463694	0
Rania Malik (Seller)	seller11_1780236051715@scrapexchange.com	$2b$12$QBBbaQQ/TgiHTisw/o6Xk.Kn0DLiUY7b9L96YuGRy4L..Vzpb5i.K	t	2026-05-31 14:00:51.911	\N	t	f	\N	\N	Multan	f	\N	+9211077243443	t	/uploads/products/profile_345_1780236051899.jpg	seller	t	f	2026-07-02 17:53:11.552	438	0	30.15303899206594	71.44585695602788	0
Yasmin Hussain (Seller)	seller22_1780236051912@scrapexchange.com	$2b$12$qfObwYt1r/CyMCNeIRx8Zu.zBlOjKCM5N627fXwhl2ND0/ExiMwK6	t	2026-05-31 14:00:52.127	\N	t	f	\N	\N	Hyderabad	f	\N	+9210252759610	t	/uploads/products/profile_913_1780236052114.jpg	seller	t	f	2026-07-02 17:53:11.553	439	0	25.36857317007991	68.4551356060583	0
Fatima Karim (Seller)	seller33_1780236052128@scrapexchange.com	$2b$12$u0xkdYz37Fk3YmoIiDMMfuxdgjX1mes64nv1vK074vGJBU5QKQI5C	t	2026-05-31 14:00:52.324	\N	t	f	\N	\N	Hyderabad	f	\N	+924474595463	t	/uploads/products/profile_983_1780236052311.jpg	seller	t	f	2026-07-02 17:53:11.555	440	0	25.38886393832127	68.49352546848858	0
Ali Khan (Seller)	seller44_1780236052325@scrapexchange.com	$2b$12$woiiO0mugaqr8M2uAsXA/ez4A.VpFk8QTrK9ELM2Fx4v/haVHH1ta	t	2026-05-31 14:00:52.521	\N	t	f	\N	\N	Hyderabad	f	\N	+9211287748360	t	/uploads/products/profile_164_1780236052509.jpg	seller	t	f	2026-07-02 17:53:11.556	441	0	25.44244862180131	68.47349317812525	0
Bilal Rashid (Seller)	seller55_1780236052523@scrapexchange.com	$2b$12$.D4vLslkSOCJtrNxV2LUrenc6PCvfhoJgXmiUAvXanAel7OY8dYXm	t	2026-05-31 14:00:52.718	\N	t	f	\N	\N	Hyderabad	f	\N	+9210805547997	t	/uploads/products/profile_530_1780236052706.jpg	seller	t	f	2026-07-02 17:53:11.558	442	0	25.37993790038218	68.45221634379035	0
Nadia Ibrahim (Seller)	seller66_1780236052719@scrapexchange.com	$2b$12$H6RGnYZtR6GfBx/nbzako.WMvigiokK1XJ6SEr0zkscdHZzFHBpbi	t	2026-05-31 14:00:52.915	\N	t	f	\N	\N	Quetta	f	\N	+925338311794	t	/uploads/products/profile_136_1780236052903.jpg	seller	t	f	2026-07-02 17:53:11.56	443	0	30.21629445693852	67.01966365140711	0
Noura Jamal (Seller)	seller77_1780236052916@scrapexchange.com	$2b$12$xhP7vcUE.hlZ16Ros4K0be0Qdr9vn4hL.Z3gvAnu3.JU4jlWENMT6	t	2026-05-31 14:00:53.112	\N	t	f	\N	\N	Hyderabad	f	\N	+927644021837	t	/uploads/products/profile_222_1780236053099.jpg	seller	t	f	2026-07-02 17:53:11.562	444	0	25.37690213579967	68.4639323191338	0
Ahmed Abdullah (Seller)	seller88_1780236053113@scrapexchange.com	$2b$12$8QpT9SXO8HHcE/41ocjMoeedWHBHVT8TYbbVoS4KcKU/rRTv6U3sy	t	2026-05-31 14:00:53.309	\N	t	f	\N	\N	Peshawar	f	\N	+928954323519	t	/uploads/products/profile_947_1780236053298.jpg	seller	t	f	2026-07-02 17:53:11.564	445	0	34.01141368519558	71.57165421938551	0
Ali Hussain (Seller)	seller99_1780236053309@scrapexchange.com	$2b$12$wSEp1Y0LyQDUs0Ia1cCpZuFYZmrbvEgOc6jllrwRR9IGGKjWKrJ1e	t	2026-05-31 14:00:53.506	\N	t	f	\N	\N	Multan	f	\N	+927142525833	t	/uploads/products/profile_139_1780236053492.jpg	seller	t	f	2026-07-02 17:53:11.566	446	0	30.17555800794291	71.46420267041748	0
Zara Hassan (Seller)	seller1010_1780236053507@scrapexchange.com	$2b$12$556nz8zAm.zqA1ynN2r/De2sPa0kPpOP0IZKC0CN982VvKJEZTpWS	t	2026-05-31 14:00:53.705	\N	t	f	\N	\N	Hyderabad	f	\N	+923576375291	t	/uploads/products/profile_376_1780236053691.jpg	seller	t	f	2026-07-02 17:53:11.567	447	0	25.34802616276414	68.49829441590569	0
Bilal Khan (Seller)	seller1111_1780236053705@scrapexchange.com	$2b$12$QOszlNtjanSsck4ifn2meeQmat1muICLdotIiDnj.Ip04o4zFOpRW	t	2026-05-31 14:00:53.902	\N	t	f	\N	\N	Rawalpindi	f	\N	+9210194327872	t	/uploads/products/profile_773_1780236053890.jpg	seller	t	f	2026-07-02 17:53:11.569	448	0	33.59452520619906	73.21196559980574	0
Sarah Ibrahim (Seller)	seller1212_1780236053903@scrapexchange.com	$2b$12$3/XAWsRBA.1pQm8vFEVnzeoisGGfWatvT1JUTHfud9U.pPcLnDntm	t	2026-05-31 14:00:54.311	\N	t	f	\N	\N	Gujranwala	f	\N	+925735371262	t	/uploads/products/profile_377_1780236054088.jpg	seller	t	f	2026-07-02 17:53:11.571	449	0	32.19246420344919	74.20250819366456	0
Omar Abdullah (Seller)	seller1313_1780236054313@scrapexchange.com	$2b$12$7RXec9Me7tHtuGKue5toBu0eGJFMT3doZB5Tqz3Rj83KPGxZ0X6UG	t	2026-05-31 14:00:54.51	\N	t	f	\N	\N	Hyderabad	f	\N	+9210879560052	t	/uploads/products/profile_349_1780236054498.jpg	seller	t	f	2026-07-02 17:53:11.573	450	0	25.4293931907638	68.51145631327704	0
Leila Hussein (Seller)	seller1414_1780236054511@scrapexchange.com	$2b$12$fWilPzC1dWnG0Qm45eCd.OjHzZo2rSgChzOBoE06nZ/BVEr9rXajW	t	2026-05-31 14:00:54.707	\N	t	f	\N	\N	Karachi	f	\N	+928852822282	t	/uploads/products/profile_173_1780236054695.jpg	seller	t	f	2026-07-02 17:53:11.574	451	0	24.83745878647285	67.02052595590398	0
Mariam Hassan (Seller)	seller1515_1780236054707@scrapexchange.com	$2b$12$pbrO7a283YKItC6rVWNPpuMCxho6nIHDtbvx1/BJZ6j3KWHiwh61y	t	2026-05-31 14:00:54.901	\N	t	f	\N	\N	Lahore	f	\N	+926483840946	t	/uploads/products/profile_54_1780236054891.jpg	seller	t	f	2026-07-02 17:53:11.576	452	0	31.52904857403306	74.35271044463676	0
Bilal Malik (Dealer)	dealer11_1780236202522@scrapexchange.com	$2b$12$zNHj7IlPsnUXKp6B03qQzu6RMtKe4FGHwdZbFckmTlo/qtc1vhAtW	t	2026-05-31 14:03:22.781	\N	t	f	\N	\N	Karachi	f	\N	+927402207187	t	/uploads/products/profile_49_1780236202712.jpg	both	t	f	2026-07-02 17:53:11.578	453	3.75	24.89625545506043	67.03808997019895	4
Rashid Ali (Dealer)	dealer22_1780236202784@scrapexchange.com	$2b$12$U7yt5W2FqHJyVWvuFrWL0uzs0pCHVfSSpqHkP8a77ngUOBCfSP0ze	t	2026-05-31 14:03:22.984	\N	t	f	\N	\N	Gujranwala	f	\N	+9211220109256	t	/uploads/products/profile_821_1780236202973.jpg	both	t	f	2026-07-02 17:53:11.58	454	4	32.13067814859004	74.13841838415055	13
Sarah Ahmed (Dealer)	dealer33_1780236202985@scrapexchange.com	$2b$12$mrIhqJiLZaK4Ycq76Grt5.d3UX8mrmHFiVBbj/FvDhtDJVTl.Hzd.	t	2026-05-31 14:03:23.39	\N	t	f	\N	\N	Rawalpindi	f	\N	+927753079409	t	/uploads/products/profile_451_1780236203172.jpg	both	t	f	2026-07-02 17:53:11.581	455	4.058823529411764	33.61758022499651	73.15506827316322	17
Layla Ali (Dealer)	dealer44_1780236203391@scrapexchange.com	$2b$12$/F5UmTi11beUtxUwEwP.TOxmcu1FhZ7EvtNmo8JC2yZVBpamt0C3W	t	2026-05-31 14:03:23.587	\N	t	f	\N	\N	Gujranwala	f	\N	+923625106238	t	/uploads/products/profile_425_1780236203576.jpg	both	t	f	2026-07-02 17:53:11.583	456	3.923076923076923	32.17199134608985	74.17029461414326	13
Ahmed Abdullah (Dealer)	dealer55_1780236203588@scrapexchange.com	$2b$12$AcRneGbAHZwYX9db68StPuXjI8t4PKQEfHEzcwNf3fq6oSY/0.cla	t	2026-05-31 14:03:23.787	\N	t	f	\N	\N	Karachi	f	\N	+9211496290303	t	/uploads/products/profile_505_1780236203773.jpg	both	t	f	2026-07-02 17:53:11.584	457	3.857142857142857	24.86032616069121	66.96940916319907	7
Ali Ahmed (Dealer)	dealer66_1780236203788@scrapexchange.com	$2b$12$s0P.h03E48hf69Nk7Yz6sOM.RQlyy4FsLq.VhvPKVQ6HzhvaI05G.	t	2026-05-31 14:03:23.984	\N	t	f	\N	\N	Gujranwala	f	\N	+929513661004	t	/uploads/products/profile_434_1780236203972.jpg	both	t	f	2026-07-02 17:53:11.586	458	4	32.13650695199622	74.14354277692348	12
Omar Karim (Dealer)	dealer77_1780236203986@scrapexchange.com	$2b$12$ki7SM/FJmibs4iwuUXzkwONvghAxVJaRfDwmsA6j9uUaAOq0MC33i	t	2026-05-31 14:03:24.181	\N	t	f	\N	\N	Faisalabad	f	\N	+929085119313	t	/uploads/products/profile_262_1780236204168.jpg	both	t	f	2026-07-02 17:53:11.588	459	4.076923076923077	31.3906064602054	72.34678207044956	13
Omar Ibrahim (Dealer)	dealer99_1780236204377@scrapexchange.com	$2b$12$liSPXwp8pfMfqU4gmi88RONdlnwPf7wgA/iS8i1SJHnNno0xd19f.	t	2026-05-31 14:03:24.573	\N	t	f	\N	\N	Lahore	f	\N	+928695339464	t	/uploads/products/profile_362_1780236204561.jpg	both	t	f	2026-07-02 17:53:11.592	461	4.125	31.58087999603828	74.30199335801514	8
Amina Abdullah (Dealer)	dealer1010_1780236204574@scrapexchange.com	$2b$12$TNpuMyFDcdrMRkej9xys1ONAFBlSGSpVPaceKTl7QytqnomxVoNLO	t	2026-05-31 14:03:24.768	\N	t	f	\N	\N	Karachi	f	\N	+924084513673	t	/uploads/products/profile_824_1780236204757.jpg	both	t	f	2026-07-02 17:53:11.594	462	3.75	24.8689258375835	66.99996598744833	4
Samir Hussein (Dealer)	dealer1111_1780236204769@scrapexchange.com	$2b$12$HcolvK722Be00sSQHdnlLePaLqOnmLvJIT6s2rv6p.Ag7KvICJ6di	t	2026-05-31 14:03:24.965	\N	t	f	\N	\N	Hyderabad	f	\N	+928865072952	t	/uploads/products/profile_595_1780236204953.jpg	both	t	f	2026-07-02 17:53:11.596	463	4	25.40640171895194	68.43889596323861	3
Hassan Ahmed (Dealer)	dealer1212_1780236204966@scrapexchange.com	$2b$12$Ssdn.u8I6lS.M2vd7SH8YeWsx8ibMFz5rUeL4nuPVM/V6VxWasMu6	t	2026-05-31 14:03:25.162	\N	t	f	\N	\N	Islamabad	f	\N	+9211212155547	t	/uploads/products/profile_83_1780236205149.jpg	both	t	f	2026-07-02 17:53:11.598	464	3.5	33.71691310658225	73.0113597030032	8
Bilal Malik (Dealer)	dealer1313_1780236205163@scrapexchange.com	$2b$12$EaOj7q32POAW6Fe4azBujua293ignPa384jIAi8eDgB9tpU/2H7sm	t	2026-05-31 14:03:25.36	\N	t	f	\N	\N	Multan	f	\N	+923952407271	t	/uploads/products/profile_336_1780236205348.jpg	both	t	f	2026-07-02 17:53:11.6	465	3.6	30.1246330948773	71.38920960621599	5
Dina Hussain (Dealer)	dealer1414_1780236205362@scrapexchange.com	$2b$12$vHsmJ3XZ70lZOC8jwjh4XeZGzFrATuLlmtLxOmyzWHMb/MPXyXWDW	t	2026-05-31 14:03:25.556	\N	t	f	\N	\N	Gujranwala	f	\N	+9211672110736	t	/uploads/products/profile_318_1780236205544.jpg	both	t	f	2026-07-02 17:53:11.602	466	3	32.16856241599656	74.18967655487744	2
Khalid Ali (Dealer)	dealer1515_1780236205557@scrapexchange.com	$2b$12$nQM5kci4T0DijaKpgP.vY.1hvHe51OXTQqLZ9CRwwRPca6WbLyugO	t	2026-05-31 14:03:25.752	\N	t	f	\N	\N	Karachi	f	\N	+925479081832	t	/uploads/products/profile_942_1780236205741.jpg	both	t	f	2026-07-02 17:53:11.604	467	4.375	24.90498968363293	66.9992928883881	8
Leila Ahmed (Dealer)	dealer1616_1780236205753@scrapexchange.com	$2b$12$ww/WvdsobVwmYmq6hfZzj.5FIHWB11L51XYakmZbxDEPoraHWz86S	t	2026-05-31 14:03:25.947	\N	t	f	\N	\N	Islamabad	f	\N	+925127970190	t	/uploads/products/profile_894_1780236205937.jpg	both	t	f	2026-07-02 17:53:11.606	468	3.846153846153846	33.65042397607652	73.0710754802724	13
Fatima Rashid (Dealer)	dealer1717_1780236205948@scrapexchange.com	$2b$12$V02XyuX8f18Pbe3vMvfh.O4/rzIoiBrbLJAs/Sz6OGWhSliS9cUcK	t	2026-05-31 14:03:26.143	\N	t	f	\N	\N	Gujranwala	f	\N	+925955497123	t	/uploads/products/profile_835_1780236206132.jpg	both	t	f	2026-07-02 17:53:11.608	469	4.333333333333333	32.20218945788264	74.14799801039437	3
Samir Malik (Dealer)	dealer1818_1780236206144@scrapexchange.com	$2b$12$NdtZ/PKx8tj9U.IRQ5frhe7AjS.JahOZaKKiK.sQNe2awBAwhNcke	t	2026-05-31 14:03:26.338	\N	t	f	\N	\N	Hyderabad	f	\N	+925985319442	t	/uploads/products/profile_873_1780236206326.jpg	both	t	f	2026-07-02 17:53:11.609	470	4	25.44129832825328	68.45240873478163	12
Yasmin Hussein (Dealer)	dealer1919_1780236206339@scrapexchange.com	$2b$12$xYWmGWv6hrZB37ex1OZ.XemI0k4hVS0g29YviMltzhHkIkFLZ8hwm	t	2026-05-31 14:03:26.536	\N	t	f	\N	\N	Faisalabad	f	\N	+9210417581358	t	/uploads/products/profile_868_1780236206524.jpg	both	t	f	2026-07-02 17:53:11.611	471	3.736842105263158	31.45452371248276	72.37117407596126	19
Mariam Khan (Dealer)	dealer2020_1780236206536@scrapexchange.com	$2b$12$bL44Q27q3tJNZSRV2ht9t.E78.KUXoAsbmu0PHy5bFFP0LkBgv1kW	t	2026-05-31 14:03:26.732	\N	t	f	\N	\N	Hyderabad	f	\N	+924496083513	t	/uploads/products/profile_441_1780236206720.jpg	both	t	f	2026-07-02 17:53:11.612	472	4.2	25.37019376249562	68.44445406494313	5
Layla Rashid	buyer11_1780236206733@scrapexchange.com	$2b$12$YtMnDg7ve91IDmFKVe6oFu5rKIi4wyjVeZsEz/LoMDEHa7jjttojm	t	2026-05-31 14:03:26.93	\N	t	f	\N	\N	Rawalpindi	f	\N	+929122701765	t	/uploads/products/profile_549_1780236206916.jpg	buyer	t	f	2026-07-02 17:53:11.614	473	0	33.58928512115325	73.23657985761903	0
Hassan Khan	buyer22_1780236206931@scrapexchange.com	$2b$12$.chiogwDfb42zLq8.Bk.WOGHe9Is/HeWOVA1q.797jIhZSROFddAW	t	2026-05-31 14:03:27.126	\N	t	f	\N	\N	Faisalabad	f	\N	+924135482285	t	/uploads/products/profile_278_1780236207115.jpg	buyer	t	f	2026-07-02 17:53:11.615	474	0	31.40636097068154	72.30475428565776	0
Mariam Hussain	buyer33_1780236207127@scrapexchange.com	$2b$12$KEnFkIFhoF2tfjIMV3gEuO1gd0dcQVjqzN5zC0pAoxLdmSEH9bv2W	t	2026-05-31 14:03:27.321	\N	t	f	\N	\N	Gujranwala	f	\N	+926730700378	t	/uploads/products/profile_746_1780236207310.jpg	buyer	t	f	2026-07-02 17:53:11.617	475	0	32.1900641923926	74.1430288512916	0
Hana Ahmed	buyer44_1780236207322@scrapexchange.com	$2b$12$gAxgJxjwblSfBMMLFTwHteXt4Sz2CVo7pVo0EMwRvwPieo4q.z38W	t	2026-05-31 14:03:27.515	\N	t	f	\N	\N	Islamabad	f	\N	+928342027188	t	/uploads/products/profile_261_1780236207506.jpg	buyer	t	f	2026-07-02 17:53:11.618	476	0	33.64977468057887	73.07735970576083	0
Khalid Jamal	buyer55_1780236207516@scrapexchange.com	$2b$12$nCFuU/pRFaEEokHWmgvJtuQMNnAEj.zsAcPa42uHibAmiOzCyYD1q	t	2026-05-31 14:03:27.71	\N	t	f	\N	\N	Gujranwala	f	\N	+928612121496	t	/uploads/products/profile_146_1780236207701.jpg	buyer	t	f	2026-07-02 17:53:11.62	477	0	32.18534913204133	74.15325243844711	0
Leila Ahmed	buyer66_1780236207711@scrapexchange.com	$2b$12$67sjhVZITgT9GpNL6O8HcumeLTH73iVyyQIHH4x2Tbww.DM7.xMZC	t	2026-05-31 14:03:27.904	\N	t	f	\N	\N	Faisalabad	f	\N	+9211422019523	t	/uploads/products/profile_255_1780236207894.jpg	buyer	t	f	2026-07-02 17:53:11.622	478	0	31.42067730285439	72.29687636523414	0
Yasmin Omar	buyer77_1780236207905@scrapexchange.com	$2b$12$Gsg6U59fiof8wBTiTpKRN.OqESdNDDoAPQ.KZ21fXvJHvwtAsRrHW	t	2026-05-31 14:03:28.101	\N	t	f	\N	\N	Hyderabad	f	\N	+928194122287	t	/uploads/products/profile_96_1780236208089.jpg	buyer	t	f	2026-07-02 17:53:11.623	479	0	25.3881945180548	68.48286756434882	0
Bilal Mohamed	buyer88_1780236208101@scrapexchange.com	$2b$12$IBGFjFmCOZy1WE4cd8Tps.HpQx4nC5LLqtOs17cPEvrIuflFBAWiG	t	2026-05-31 14:03:28.298	\N	t	f	\N	\N	Lahore	f	\N	+927913156893	t	/uploads/products/profile_229_1780236208287.jpg	buyer	t	f	2026-07-02 17:53:11.625	480	0	31.58423109520628	74.38562859902189	0
Leila Khan	buyer99_1780236208299@scrapexchange.com	$2b$12$TtZy6F1gdcIfJifFgQmdTOcDXwFBt..UY9qxM8C6loSIwlVAwnGaW	t	2026-05-31 14:03:28.494	\N	t	f	\N	\N	Faisalabad	f	\N	+929601729044	t	/uploads/products/profile_62_1780236208485.jpg	buyer	t	f	2026-07-02 17:53:11.626	481	0	31.45118465475652	72.32415439421972	0
Hassan Rashid	buyer1010_1780236208495@scrapexchange.com	$2b$12$5NrYNScrZIQph53NnatmM.lC.ReZ69Rq1/ru35QmJJ24SuopNM.Bm	t	2026-05-31 14:03:28.69	\N	t	f	\N	\N	Islamabad	f	\N	+925192688878	t	/uploads/products/profile_522_1780236208679.jpg	buyer	t	f	2026-07-02 17:53:11.628	482	0	33.67375203991384	73.03811456546255	0
Nadia Khan (Seller)	seller11_1780236208691@scrapexchange.com	$2b$12$knxDuGHvswxKvWY0qHgE2.nCFXLpMGh/CaGMW1MI16PqKlgQcgJMm	t	2026-05-31 14:03:28.886	\N	t	f	\N	\N	Rawalpindi	f	\N	+925187246901	t	/uploads/products/profile_313_1780236208875.jpg	seller	t	f	2026-07-02 17:53:11.63	483	4.181818181818182	33.60659643826236	73.1676643060948	11
Rashid Karim (Seller)	seller22_1780236208887@scrapexchange.com	$2b$12$u7NKjkoR.3AwNaJFAMz9zeSYEEObvEhQPrapHCrPWddOG6KweLBom	t	2026-05-31 14:03:29.084	\N	t	f	\N	\N	Multan	f	\N	+9210614695018	t	/uploads/products/profile_940_1780236209072.jpg	seller	t	f	2026-07-02 17:53:11.632	484	4.111111111111111	30.11073650639158	71.46514635142043	9
Rashid Ali (Seller)	seller33_1780236209085@scrapexchange.com	$2b$12$IO6uc.vlgsFMsbdUaAt3BuaL1jNacfMH4fLlcAnGEPIue82N.36q.	t	2026-05-31 14:03:29.28	\N	t	f	\N	\N	Rawalpindi	f	\N	+929270878538	t	/uploads/products/profile_72_1780236209269.jpg	seller	t	f	2026-07-02 17:53:11.633	485	4	33.61885419974649	73.23472005892928	6
Ayesha Khan (Seller)	seller55_1780236209484@scrapexchange.com	$2b$12$j7XzPGHnB6LFrG4Mi0aF9eIVtMGs1L1wuaqzCRPYcdVZ5hrybTTui	t	2026-05-31 14:03:29.682	\N	t	f	\N	\N	Peshawar	f	\N	+9211882115929	t	/uploads/products/profile_447_1780236209672.jpg	seller	t	f	2026-07-02 17:53:11.636	487	4.090909090909091	33.97023452871596	71.49057380881315	11
Fatima Rashid (Seller)	seller66_1780236209683@scrapexchange.com	$2b$12$2rm4v1wv2UmFB2t7IZ8gCuyx0HSnzq5D0UKkrG/wWYnlvZFZuGog6	t	2026-05-31 14:03:29.88	\N	t	f	\N	\N	Karachi	f	\N	+923113456705	t	/uploads/products/profile_224_1780236209868.jpg	seller	t	f	2026-07-02 17:53:11.638	488	4.142857142857143	24.88032114445129	67.02006299433062	7
Ahmed Ibrahim (Seller)	seller77_1780236209881@scrapexchange.com	$2b$12$QlliinItAtR7lcPJ7VPQee8OvtgqaBv8wpc.Fv2upj9myh74xCq82	t	2026-05-31 14:03:30.079	\N	t	f	\N	\N	Karachi	f	\N	+9211227330102	t	/uploads/products/profile_352_1780236210066.jpg	seller	t	f	2026-07-02 17:53:11.64	489	4.076923076923077	24.85609822165998	66.97875976685474	13
Mariam Jamal (Seller)	seller88_1780236210080@scrapexchange.com	$2b$12$gRsuFUnYZZSIH0EqUAfDpeS1jPmt4ZY1ltRxCSMwthTEXVy25tHE2	t	2026-05-31 14:03:30.276	\N	t	f	\N	\N	Lahore	f	\N	+925048652726	t	/uploads/products/profile_144_1780236210264.jpg	seller	t	f	2026-07-02 17:53:11.641	490	4.111111111111111	31.59711823026852	74.33484744726987	9
Mariam Malik (Seller)	seller99_1780236210277@scrapexchange.com	$2b$12$AgWgTCtlmAqClIk8dGWBzOl0/ElOdmaikoYHIBzsJDamjDvPRTdA.	t	2026-05-31 14:03:30.473	\N	t	f	\N	\N	Hyderabad	f	\N	+926528822091	t	/uploads/products/profile_917_1780236210462.jpg	seller	t	f	2026-07-02 17:53:11.643	491	3.9	25.34924146830688	68.43107475886603	10
Layla Rashid (Seller)	seller1010_1780236210475@scrapexchange.com	$2b$12$rLGV6XhwoZtO/N.EfFwb.uF/zZBroemyjZre7KA5GJ43m3mNvauda	t	2026-05-31 14:03:30.668	\N	t	f	\N	\N	Quetta	f	\N	+9210263204445	t	/uploads/products/profile_872_1780236210658.jpg	seller	t	f	2026-07-02 17:53:11.644	492	4.307692307692307	30.20271869117098	67.05961010636626	13
Ali Hassan (Seller)	seller1111_1780236210669@scrapexchange.com	$2b$12$kPsn7GP.yWGXIJb46B1Y8eBKtddYcXIG7qeBcOWfuJOKHfb9MXSeq	t	2026-05-31 14:03:30.868	\N	t	f	\N	\N	Quetta	f	\N	+923792153972	t	/uploads/products/profile_226_1780236210858.jpg	seller	t	f	2026-07-02 17:53:11.646	493	4.5	30.21200393358902	67.06366567043437	4
Muhammad Hussain (Seller)	seller1212_1780236210869@scrapexchange.com	$2b$12$Mli2sJxcMevkj19PmW8JI.rL8SrGpCb4zVw4B/ZSPuKZyjHCEY/qC	t	2026-05-31 14:03:31.069	\N	t	f	\N	\N	Hyderabad	f	\N	+923074809792	t	/uploads/products/profile_109_1780236211058.jpg	seller	t	f	2026-07-02 17:53:11.648	494	3.4	25.41560002607887	68.49865156630365	5
Nadia Hussein (Seller)	seller1313_1780236211071@scrapexchange.com	$2b$12$1qi.4lgW/OIqGyfNSm8ma.i/9GM9mIsQF1equ4oZuyIZI043Xye9W	t	2026-05-31 14:03:31.273	\N	t	f	\N	\N	Hyderabad	f	\N	+925481558824	t	/uploads/products/profile_287_1780236211262.jpg	seller	t	f	2026-07-02 17:53:11.649	495	4.5	25.40123452265378	68.46767001157454	10
Layla Hussein (Seller)	seller1414_1780236211275@scrapexchange.com	$2b$12$YxNu7WZHjnoPzy46sC6Ihu3xfriBuX4WNKv/01TDXbTdbePVtuptq	t	2026-05-31 14:03:31.481	\N	t	f	\N	\N	Peshawar	f	\N	+923054931367	t	/uploads/products/profile_250_1780236211469.jpg	seller	t	f	2026-07-02 17:53:11.651	496	4	33.98870379485433	71.49216572152109	11
Khalid Ali (Seller)	seller1515_1780236211482@scrapexchange.com	$2b$12$n9fpm/8kvSQuDEQfcz1NSeXdX1drG4qjUpgc93yXzIF28ZLnCOK92	t	2026-05-31 14:03:31.682	\N	t	f	\N	\N	Gujranwala	f	\N	+926178005434	t	/uploads/products/profile_389_1780236211671.jpg	seller	t	f	2026-07-02 17:53:11.652	497	3.777777777777778	32.18637497662573	74.1816582388195	9
Hana Rashid (Dealer)	dealer11_1780236517780@scrapexchange.com	$2b$12$JHJO/7ZByR1odk39.ooBTeiqe6.7dYA2bmBMuL7r4aO4xKRTLAZx2	t	2026-05-31 14:08:38.062	\N	t	f	\N	\N	Karachi	f	\N	+926027489393	t	/uploads/profiles/profile_586_1780236517969.jpg	both	t	f	2026-07-02 17:53:11.654	498	3.764705882352941	24.81576160365922	66.96017099058841	17
Hassan Samir (Dealer)	dealer22_1780236518065@scrapexchange.com	$2b$12$rFPxInAkug4A3AY2G.EMAeJp62IQRAYvASt.pAx3gX5z/nrhPvVUq	t	2026-05-31 14:08:38.268	\N	t	f	\N	\N	Lahore	f	\N	+924521135257	t	/uploads/profiles/profile_575_1780236518256.jpg	both	t	f	2026-07-02 17:53:11.655	499	3.833333333333333	31.56008504849197	74.31727366097837	6
Bilal Karim (Dealer)	dealer33_1780236518269@scrapexchange.com	$2b$12$HcWpAZicX1WOY6xllUxA4u0wI5/UzmgI2koR6JSErWVS7PJ7qUIne	t	2026-05-31 14:08:38.468	\N	t	f	\N	\N	Rawalpindi	f	\N	+926217278728	t	/uploads/profiles/profile_458_1780236518455.jpg	both	t	f	2026-07-02 17:53:11.657	500	3.8	33.52642287273672	73.15754841966532	10
Nadia Malik (Dealer)	dealer44_1780236518468@scrapexchange.com	$2b$12$wlCCnLfVYVfDPsNRrNy1Fe/skAcDjAgyglAFbTUGkkgtEpaCrjo8K	t	2026-05-31 14:08:39.036	\N	t	f	\N	\N	Rawalpindi	f	\N	+925378064366	t	/uploads/profiles/profile_465_1780236518654.jpg	both	t	f	2026-07-02 17:53:11.658	501	4.6	33.5949992685186	73.19639028496562	5
Dina Hassan (Dealer)	dealer55_1780236519037@scrapexchange.com	$2b$12$/B8F1AhlGipP2/7cYX8KD.fZqheHtmOkBd2PI/iMzSshrUDPRioEi	t	2026-05-31 14:08:39.234	\N	t	f	\N	\N	Hyderabad	f	\N	+928136987022	t	/uploads/profiles/profile_605_1780236519223.jpg	both	t	f	2026-07-02 17:53:11.659	502	4.666666666666667	25.3795328508996	68.50257888503288	3
Hana Malik (Dealer)	dealer66_1780236519235@scrapexchange.com	$2b$12$KgpmZsDW3Mr4GlER6HORnOPH.fQFzyWQYuAoOPLidLEkX.OffI9pS	t	2026-05-31 14:08:39.432	\N	t	f	\N	\N	Islamabad	f	\N	+9211211164442	t	/uploads/profiles/profile_690_1780236519419.jpg	both	t	f	2026-07-02 17:53:11.661	503	4.25	33.64290155014039	73.07519455003818	8
Layla Hussain (Dealer)	dealer77_1780236519433@scrapexchange.com	$2b$12$Cs3eCrdXjTWmN1BOVKhisO2NHb1dTwlbm7VTqAx4LMmmZOcs/G.pG	t	2026-05-31 14:08:39.638	\N	t	f	\N	\N	Peshawar	f	\N	+923329525347	t	/uploads/profiles/profile_246_1780236519628.jpg	both	t	f	2026-07-02 17:53:11.662	504	3.809523809523809	34.00492032919148	71.51136801218702	21
Omar Mohamed (Dealer)	dealer88_1780236519638@scrapexchange.com	$2b$12$XsPtMaKvDtQxdlwYuVJjEutvjE.atqHqbLP7HG1huBQPuSsPTmIB2	t	2026-05-31 14:08:39.837	\N	t	f	\N	\N	Lahore	f	\N	+9211758508676	t	/uploads/profiles/profile_955_1780236519826.jpg	both	t	f	2026-07-02 17:53:11.664	505	3.888888888888889	31.52683125900898	74.35809991176895	9
Nadia Ali (Dealer)	dealer99_1780236519838@scrapexchange.com	$2b$12$uytoagS0axGZOxnpqPMsae.7bbdq/BL.gHOETSxx/cEU.B2ICbvPe	t	2026-05-31 14:08:40.037	\N	t	f	\N	\N	Islamabad	f	\N	+9210135910305	t	/uploads/profiles/profile_986_1780236520025.jpg	both	t	f	2026-07-02 17:53:11.665	506	4	33.68131314805292	73.03660560201885	3
Rashid Samir (Dealer)	dealer1010_1780236520038@scrapexchange.com	$2b$12$VvGLw26sEHS0GHjvnZovXuzmVQtLcaA1xAH25el/jbnqKGd9mnJqq	t	2026-05-31 14:08:40.238	\N	t	f	\N	\N	Islamabad	f	\N	+926284282168	t	/uploads/profiles/profile_449_1780236520228.jpg	both	t	f	2026-07-02 17:53:11.666	507	4.142857142857143	33.66842606322456	73.07238432207855	7
Bilal Ali (Dealer)	dealer1111_1780236520239@scrapexchange.com	$2b$12$w4LNRPiiVxinDrDwYSWDkuqhslo2./kkLL/3q7kkKn6507/NAPi6a	t	2026-05-31 14:08:40.443	\N	t	f	\N	\N	Gujranwala	f	\N	+928437591950	t	/uploads/profiles/profile_798_1780236520431.jpg	both	t	f	2026-07-02 17:53:11.668	508	4.111111111111111	32.12603653621582	74.19773038313406	18
Nadia Hussein (Dealer)	dealer1212_1780236520444@scrapexchange.com	$2b$12$3PBEErtUiXR1rapz6JTJrOOHUF3952PyPsk7egWKbpv39xIDhOp06	t	2026-05-31 14:08:40.641	\N	t	f	\N	\N	Lahore	f	\N	+929328899188	t	/uploads/profiles/profile_493_1780236520629.jpg	both	t	f	2026-07-02 17:53:11.669	509	4.4	31.54219148602921	74.37169339710267	10
Mariam Abdullah (Dealer)	dealer1313_1780236520642@scrapexchange.com	$2b$12$eao6YBaGcqOWcApI2.xQ.ey21mH/EcSTVSUaQSaEnquTrLWGttWhq	t	2026-05-31 14:08:40.845	\N	t	f	\N	\N	Rawalpindi	f	\N	+923348194029	t	/uploads/profiles/profile_537_1780236520834.jpg	both	t	f	2026-07-02 17:53:11.671	510	4.333333333333333	33.57684453058811	73.21869595144307	12
Ayesha Ibrahim (Dealer)	dealer1414_1780236520846@scrapexchange.com	$2b$12$s1r/cIOgZKHGFn5nrGX4heKb8BBdespI5zDLCPKe4Vwm6VOobsPK.	t	2026-05-31 14:08:41.058	\N	t	f	\N	\N	Multan	f	\N	+9210109291983	t	/uploads/profiles/profile_470_1780236521046.jpg	both	t	f	2026-07-02 17:53:11.672	511	3.7	30.18356318962902	71.39814339422432	10
Tariq Rashid (Dealer)	dealer1616_1780236521264@scrapexchange.com	$2b$12$jgwhTIeyPtfWbEDJ2.R21Ol3XhWqg1uJhQAy9lnp7pfgt9nle7wwa	t	2026-05-31 14:08:41.466	\N	t	f	\N	\N	Peshawar	f	\N	+9210907270030	t	/uploads/profiles/profile_615_1780236521456.jpg	both	t	f	2026-07-02 17:53:11.676	513	4.833333333333333	34.020034125203	71.50516397049792	6
Bilal Omar (Dealer)	dealer1717_1780236521466@scrapexchange.com	$2b$12$Z/YmObDviLYB5MeO1X1p4uaHuQnLL1XESH1VClODbSqKPK6jbUGAi	t	2026-05-31 14:08:41.677	\N	t	f	\N	\N	Faisalabad	f	\N	+9211756647649	t	/uploads/profiles/profile_131_1780236521666.jpg	both	t	f	2026-07-02 17:53:11.678	514	3.954545454545455	31.46625078647905	72.37554570901474	22
Yasmin Hussein (Dealer)	dealer1818_1780236521678@scrapexchange.com	$2b$12$zlbLdXxdhXZ0/od4mBmYPeab6nMnw9NjUtiZfvCYldtNjVlWhcJ0q	t	2026-05-31 14:08:41.879	\N	t	f	\N	\N	Islamabad	f	\N	+926447208791	t	/uploads/profiles/profile_273_1780236521866.jpg	both	t	f	2026-07-02 17:53:11.68	515	4.166666666666667	33.65688932930467	73.00396903247491	6
Leila Hussain (Dealer)	dealer1919_1780236521880@scrapexchange.com	$2b$12$IHxkmGwX/Mkznsw6T38U8OzTGGxThQ.gEvWtlWN7BA9P9rirRCqLO	t	2026-05-31 14:08:42.081	\N	t	f	\N	\N	Peshawar	f	\N	+923924020051	t	/uploads/profiles/profile_613_1780236522070.jpg	both	t	f	2026-07-02 17:53:11.682	516	3.428571428571428	34.05828595967706	71.48158603133524	7
Omar Ibrahim (Dealer)	dealer2020_1780236522083@scrapexchange.com	$2b$12$GcFKgjRrDoNoRafp0PMLcuCx42EP6BsdCIjFHgojpYvirG66cHfGK	t	2026-05-31 14:08:42.28	\N	t	f	\N	\N	Islamabad	f	\N	+923425935919	t	/uploads/profiles/profile_641_1780236522266.jpg	both	t	f	2026-07-02 17:53:11.683	517	4.272727272727272	33.7146428233277	73.01425671458479	11
Rania Malik	buyer11_1780236522281@scrapexchange.com	$2b$12$St4t3YsQ5zi7R6IkQHVoSOMGJyOLc0KDwNo8Cqp0m7vKiQtM91d8S	t	2026-05-31 14:08:42.478	\N	t	f	\N	\N	Faisalabad	f	\N	+925348359227	t	/uploads/profiles/profile_675_1780236522467.jpg	buyer	t	f	2026-07-02 17:53:11.685	518	0	31.38450626082831	72.30029934095022	0
Tariq Hussein	buyer22_1780236522479@scrapexchange.com	$2b$12$nGQMirBW1o35zRI/udyx/ugVh/DmKsrahFIfbsTZFV7F0nRvEwkP.	t	2026-05-31 14:08:42.691	\N	t	f	\N	\N	Quetta	f	\N	+924406617250	t	/uploads/profiles/profile_357_1780236522681.jpg	buyer	t	f	2026-07-02 17:53:11.687	519	0	30.18158725023754	67.03096638971621	0
Sarah Hussain	buyer33_1780236522692@scrapexchange.com	$2b$12$Pi6U340IZ5era6gDh3BHbuzHuj9buEQY7ppYeAvTh/hhnzzo3S7w6	t	2026-05-31 14:08:42.904	\N	t	f	\N	\N	Karachi	f	\N	+927669976533	t	/uploads/profiles/profile_283_1780236522894.jpg	buyer	t	f	2026-07-02 17:53:11.689	520	0	24.84977747160131	66.97242320780936	0
Zara Omar	buyer44_1780236522905@scrapexchange.com	$2b$12$s99baJw6pgAFBx0HgzwFVe4kg7C4q64z8Ve8DYwAG567iP5v9mmB6	t	2026-05-31 14:08:43.113	\N	t	f	\N	\N	Multan	f	\N	+928348293938	t	/uploads/profiles/profile_375_1780236523102.jpg	buyer	t	f	2026-07-02 17:53:11.69	521	0	30.1177626639868	71.45912808021407	0
Zara Karim	buyer55_1780236523114@scrapexchange.com	$2b$12$a/viCa7kfYhLZAd5uM0uLOlwPHcqbtrpM1LDOBfAROzTzmCHyGGfW	t	2026-05-31 14:08:43.314	\N	t	f	\N	\N	Faisalabad	f	\N	+9210100677680	t	/uploads/profiles/profile_276_1780236523304.jpg	buyer	t	f	2026-07-02 17:53:11.692	522	0	31.46188079200203	72.38297872829033	0
Rania Mohamed	buyer66_1780236523314@scrapexchange.com	$2b$12$jbgaUQebN4I4lxFgTWPt3uAuDBg.4AL732mJpp4eqkXGbbAEZqHVK	t	2026-05-31 14:08:43.51	\N	t	f	\N	\N	Lahore	f	\N	+923609809575	t	/uploads/profiles/profile_259_1780236523500.jpg	buyer	t	f	2026-07-02 17:53:11.694	523	0	31.59267305840621	74.36258743944654	0
Hana Hussain	buyer77_1780236523511@scrapexchange.com	$2b$12$CsmCmVgsrFO/U1f0G4aAquEi/MMLrzidvux8qeyLi7B9j8Hditazi	t	2026-05-31 14:08:43.706	\N	t	f	\N	\N	Multan	f	\N	+9211008952499	t	/uploads/profiles/profile_411_1780236523696.jpg	buyer	t	f	2026-07-02 17:53:11.696	524	0	30.12036234334415	71.46367957109577	0
Hana Jamal	buyer88_1780236523706@scrapexchange.com	$2b$12$MP.Q8q5uebbCQjahT.kLm.74uN44c.2b0lOBI7hKyiKy3ahsj3xnC	t	2026-05-31 14:08:43.905	\N	t	f	\N	\N	Quetta	f	\N	+927340369812	t	/uploads/profiles/profile_957_1780236523892.jpg	buyer	t	f	2026-07-02 17:53:11.698	525	0	30.15697958865655	67.00434036672439	0
Tariq Jamal	buyer99_1780236523905@scrapexchange.com	$2b$12$CnnLpC7EzphcGwbEJJgizets2KQuaGwZJwEhQOAF7C30O7iQPUMN2	t	2026-05-31 14:08:44.104	\N	t	f	\N	\N	Rawalpindi	f	\N	+928169726749	t	/uploads/profiles/profile_598_1780236524092.jpg	buyer	t	f	2026-07-02 17:53:11.7	526	0	33.54807383702323	73.20629077517175	0
Zara Abdullah	buyer1010_1780236524105@scrapexchange.com	$2b$12$Hj8heinRlLisrR1NwBqfE.YgXdxctuUwV99CBmmq10eSfSlFBvL.6	t	2026-05-31 14:08:44.302	\N	t	f	\N	\N	Islamabad	f	\N	+9211478134668	t	/uploads/profiles/profile_78_1780236524290.jpg	buyer	t	f	2026-07-02 17:53:11.703	527	0	33.67809318530238	73.06596844106407	0
Hassan Hassan (Seller)	seller11_1780236524303@scrapexchange.com	$2b$12$H/6QF1VyOgIdDvXqD0qVluB6hMhFYn9EaFFUsnKgVWKquLNmhzgxW	t	2026-05-31 14:08:44.505	\N	t	f	\N	\N	Rawalpindi	f	\N	+9210338484997	t	/uploads/profiles/profile_719_1780236524493.jpg	seller	t	f	2026-07-02 17:53:11.705	528	3.916666666666667	33.60898637608209	73.1865346841431	12
Hassan Omar (Seller)	seller22_1780236524505@scrapexchange.com	$2b$12$1LYSTE.WjmyypzGScTjr0u0r19j7FJR14dJgvaJM3DehKN4CMHa.u	t	2026-05-31 14:08:44.716	\N	t	f	\N	\N	Multan	f	\N	+9211776901825	t	/uploads/profiles/profile_484_1780236524705.jpg	seller	t	f	2026-07-02 17:53:11.707	529	3.636363636363636	30.1282046219374	71.3803090784381	11
Leila Karim (Seller)	seller33_1780236524717@scrapexchange.com	$2b$12$osp.jiBTuH1SaLqv7i3the9m50bjI8oXglUoOIiV502HHkgq23n56	t	2026-05-31 14:08:44.923	\N	t	f	\N	\N	Hyderabad	f	\N	+925116176281	t	/uploads/profiles/profile_838_1780236524911.jpg	seller	t	f	2026-07-02 17:53:11.708	530	4	25.4424080310238	68.44222030384194	10
Nadia Malik (Seller)	seller44_1780236524924@scrapexchange.com	$2b$12$/WT9ahlJczOCpO0qWdvywOyG9f8cH5gUcMTk/n7cknROL8hEHPDGS	t	2026-05-31 14:08:45.127	\N	t	f	\N	\N	Faisalabad	f	\N	+923516015662	t	/uploads/profiles/profile_977_1780236525115.jpg	seller	t	f	2026-07-02 17:53:11.711	531	4.2	31.40927677797863	72.29809317866842	5
Yasmin Hussein (Seller)	seller55_1780236525128@scrapexchange.com	$2b$12$6W6lD4R3oZVKk/k791CuR.CitaWl0ynbIpqTHIM8vmJhRpbpNax.K	t	2026-05-31 14:08:45.333	\N	t	f	\N	\N	Hyderabad	f	\N	+925071973815	t	/uploads/profiles/profile_632_1780236525320.jpg	seller	t	f	2026-07-02 17:53:11.713	532	5	25.38459487857354	68.45397302282385	1
Yasmin Hassan (Seller)	seller66_1780236525334@scrapexchange.com	$2b$12$N8HhpF6arIq6nKUWxbpKGelySNXhzxr0xBjvL2xO1b0SBdT5x8au.	t	2026-05-31 14:08:45.538	\N	t	f	\N	\N	Karachi	f	\N	+928696306981	t	/uploads/profiles/profile_817_1780236525526.jpg	seller	t	f	2026-07-02 17:53:11.715	533	3.857142857142857	24.88087039821211	66.96070519604989	7
Ayesha Malik (Seller)	seller77_1780236525539@scrapexchange.com	$2b$12$nEZRdW3cRiOEnK.bPlYNKuYzgbCl6mjKAvZXJjbSDsohfjvEVNKK6	t	2026-05-31 14:08:45.741	\N	t	f	\N	\N	Hyderabad	f	\N	+926305292618	t	/uploads/profiles/profile_114_1780236525730.jpg	seller	t	f	2026-07-02 17:53:11.717	534	3.875	25.34932318325928	68.46624636430704	8
Omar Hussein (Seller)	seller88_1780236525741@scrapexchange.com	$2b$12$8O3CGsJsE7z65KASHOCqfOq2DtR40XSOqVuYDklnNK3GQq.9rQeZy	t	2026-05-31 14:08:45.941	\N	t	f	\N	\N	Faisalabad	f	\N	+9210900076069	t	/uploads/profiles/profile_464_1780236525930.jpg	seller	t	f	2026-07-02 17:53:11.719	535	3.666666666666667	31.42588670138581	72.3105122119237	6
Amina Samir (Seller)	seller99_1780236525941@scrapexchange.com	$2b$12$iPOYhEop49RtcOKnMS0lCO8lAQP9M.yz97QzMs7M.kBc6BMaUJmWa	t	2026-05-31 14:08:46.143	\N	t	f	\N	\N	Multan	f	\N	+926203759352	t	/uploads/profiles/profile_838_1780236526131.jpg	seller	t	f	2026-07-02 17:53:11.721	536	3.5	30.12992828414615	71.37722557352112	8
Leila Karim (Seller)	seller1010_1780236526144@scrapexchange.com	$2b$12$b/pjsvzHE4F9pUTn1tlvbe4ZsWShaPvXR4F2HOmA0DSByoUQZKLjm	t	2026-05-31 14:08:46.342	\N	t	f	\N	\N	Gujranwala	f	\N	+926613200970	t	/uploads/profiles/profile_902_1780236526333.jpg	seller	t	f	2026-07-02 17:53:11.722	537	3.777777777777778	32.16490484611876	74.2309262939414	9
Noura Omar (Seller)	seller66_1780235966235@scrapexchange.com	$2b$12$BijHqDLGReS9v4KksOZ4gOy5LpBYtYTPj39wTRLrYQf0dRVkMFsS2	t	2026-05-31 13:59:26.431	\N	t	f	\N	\N	Islamabad	f	\N	+924336250863	t	/uploads/products/profile_218_1780235966421.jpg	seller	t	f	2026-07-02 17:53:11.295	398	0	33.72408014097356	73.06441837687267	0
Sarah Abdullah (Dealer)	dealer11_1780235958049@scrapexchange.com	$2b$12$pYcEwfFg23onw1yb5Zv8xuC/qgAzuCMcuOJDWyYAh2z7oXXUNG2HC	t	2026-05-31 13:59:18.292	\N	t	f	\N	\N	Islamabad	f	\N	+925898530106	t	/uploads/products/profile_804_1780235958236.jpg	both	t	f	2026-07-02 17:53:11.343	363	0	33.69012301815853	73.02281986576259	0
Layla Jamal (Dealer)	dealer1717_1780235961617@scrapexchange.com	$2b$12$s0rJ6sM9NuN8BTI15HBzXOxw6dRGk0hjvGgyTkEHnZ6/HrWFYuGT2	t	2026-05-31 13:59:21.812	\N	t	f	\N	\N	Karachi	f	\N	+923096788706	t	/uploads/products/profile_361_1780235961802.jpg	both	t	f	2026-07-02 17:53:11.401	379	0	24.89101683518731	66.95544421276038	0
Hana Samir (Dealer)	dealer1919@scrapexchange.com	$2b$12$ZWFx7a5oatk3/pmnszXuxO567n4fjOAXY5GqBhUeKLEJiq3clCkJ.	t	2026-05-31 13:54:18.257	\N	t	f	\N	\N	Gujranwala	f	\N	+928036079038	t	/uploads/products/profile_892_1780235658243.jpg	both	t	f	2026-07-02 17:53:11.451	291	0	32.12356848022383	74.23347638690649	0
Ahmed Hussain (Dealer)	dealer11_1780236045702@scrapexchange.com	$2b$12$99aFFiiZ6/QNYwMM88wYF.6Zv0ruqnY2AgTgP7RgUP8ICRwGXism2	t	2026-05-31 14:00:45.957	\N	t	f	\N	\N	Peshawar	f	\N	+924324822926	t	/uploads/products/profile_252_1780236045889.jpg	both	t	f	2026-07-02 17:53:11.501	408	0	34.05728209891316	71.49775966413577	0
Amina Samir	buyer77_1780236050926@scrapexchange.com	$2b$12$lHzOA4ihLUgW1vvVKl1uWOpScysQmMs4h93WEXPVDxtEIt5D/6O2e	t	2026-05-31 14:00:51.121	\N	t	f	\N	\N	Multan	f	\N	+929046142068	t	/uploads/products/profile_736_1780236051109.jpg	buyer	t	f	2026-07-02 17:53:11.546	434	0	30.19624898713444	71.42050177869021	0
Sarah Khan (Dealer)	dealer88_1780236204182@scrapexchange.com	$2b$12$e2S4ri2QMIhQ9R9iSVySi.3eUcPzpmsxiIUDPiBdqJMAOZY137rR2	t	2026-05-31 14:03:24.376	\N	t	f	\N	\N	Faisalabad	f	\N	+923887220709	t	/uploads/products/profile_640_1780236204363.jpg	both	t	f	2026-07-02 17:53:11.59	460	4.666666666666667	31.4136375337367	72.3296354669457	3
Ayesha Malik (Seller)	seller44_1780236209281@scrapexchange.com	$2b$12$3rjvXZSL2brnkDPgIDl92.jWq/qb6IFSX5kJ3snx5GiB340DZgQaS	t	2026-05-31 14:03:29.483	\N	t	f	\N	\N	Faisalabad	f	\N	+924455419012	t	/uploads/products/profile_453_1780236209472.jpg	seller	t	f	2026-07-02 17:53:11.635	486	3.818181818181818	31.38381405346687	72.30317694849015	11
Hassan Ahmed (Dealer)	dealer1515_1780236521059@scrapexchange.com	$2b$12$7mclpLts/ngPa/hiF.Qlg.AfxZ3I200ljXmFR8fLPKBNwlQsqzKLi	t	2026-05-31 14:08:41.263	\N	t	f	\N	\N	Hyderabad	f	\N	+926046926587	t	/uploads/profiles/profile_176_1780236521253.jpg	both	t	f	2026-07-02 17:53:11.674	512	3.875	25.43250652987744	68.45688286975057	8
Muhammad Mohamed (Seller)	seller1111_1780236526343@scrapexchange.com	$2b$12$UAfqL3sbJKhL1VLhC4BZqOfJxrPO7oKOevl6CVHa1FjeiKsWzebGS	t	2026-05-31 14:08:46.543	\N	t	f	\N	\N	Multan	f	\N	+923175519856	t	/uploads/profiles/profile_36_1780236526531.jpg	seller	t	f	2026-07-02 17:53:11.724	538	4	30.17737819778166	71.4344051042548	4
Fatima Rashid (Seller)	seller1212_1780236526544@scrapexchange.com	$2b$12$NfZ2ju2.KJpDED7/Lrq/vuHYAWFasF51ebpXCxNLxGP85w/WThb4W	t	2026-05-31 14:08:46.741	\N	t	f	\N	\N	Hyderabad	f	\N	+927355747391	t	/uploads/profiles/profile_563_1780236526729.jpg	seller	t	f	2026-07-02 17:53:11.726	539	3.75	25.35067735692047	68.45729785240869	4
Omar Khan (Seller)	seller1313_1780236526743@scrapexchange.com	$2b$12$WsJTrpA8O04d0AiBBRDhC.JP/oavjOT9hsTpzBL01.sUasQGOv.Yq	t	2026-05-31 14:08:46.94	\N	t	f	\N	\N	Peshawar	f	\N	+927925945655	t	/uploads/profiles/profile_813_1780236526928.jpg	seller	t	f	2026-07-02 17:53:11.728	540	4.5	33.96639618654221	71.48024282562282	4
Samir Hassan (Seller)	seller1414_1780236526941@scrapexchange.com	$2b$12$WPuLX9dvkDJANrXeTf2E1uIinq5MtlAl4BMwddJnUMPkFVcLb5cHu	t	2026-05-31 14:08:47.139	\N	t	f	\N	\N	Rawalpindi	f	\N	+928719092649	t	/uploads/profiles/profile_500_1780236527128.jpg	seller	t	f	2026-07-02 17:53:11.73	541	4.125	33.60687211316539	73.23404021187932	8
Hana Ibrahim (Seller)	seller1515_1780236527139@scrapexchange.com	$2b$12$G0ZKkfqOy/zPYrZH.JwGNOBrUmX2IUiGj6MhuucKbCLAv5fVwxdia	t	2026-05-31 14:08:47.349	\N	t	f	\N	\N	Peshawar	f	\N	+9210776495418	t	/uploads/profiles/profile_134_1780236527339.jpg	seller	t	f	2026-07-02 17:53:11.732	542	4.2	34.00530728615033	71.48255836183425	5
\.


--
-- Name: AnalysisFeedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."AnalysisFeedback_id_seq"', 1, false);


--
-- Name: AnalysisRecord_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."AnalysisRecord_id_seq"', 1, false);


--
-- Name: ChatMessage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."ChatMessage_id_seq"', 1, false);


--
-- Name: FavoriteDealer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."FavoriteDealer_id_seq"', 1, false);


--
-- Name: Listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."Listing_id_seq"', 600, true);


--
-- Name: Offer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."Offer_id_seq"', 1, false);


--
-- Name: PriceHistory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."PriceHistory_id_seq"', 1, false);


--
-- Name: Review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."Review_id_seq"', 612, true);


--
-- Name: SavedLocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."SavedLocation_id_seq"', 1, false);


--
-- Name: Scan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."Scan_id_seq"', 1, false);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scrap_user
--

SELECT pg_catalog.setval('public."User_id_seq"', 542, true);


--
-- Name: AnalysisFeedback AnalysisFeedback_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisFeedback"
    ADD CONSTRAINT "AnalysisFeedback_pkey" PRIMARY KEY (id);


--
-- Name: AnalysisHistory AnalysisHistory_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisHistory"
    ADD CONSTRAINT "AnalysisHistory_pkey" PRIMARY KEY (id);


--
-- Name: AnalysisRecord AnalysisRecord_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisRecord"
    ADD CONSTRAINT "AnalysisRecord_pkey" PRIMARY KEY (id);


--
-- Name: ChatMessage ChatMessage_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."ChatMessage"
    ADD CONSTRAINT "ChatMessage_pkey" PRIMARY KEY (id);


--
-- Name: FavoriteDealer FavoriteDealer_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."FavoriteDealer"
    ADD CONSTRAINT "FavoriteDealer_pkey" PRIMARY KEY (id);


--
-- Name: Listing Listing_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Listing"
    ADD CONSTRAINT "Listing_pkey" PRIMARY KEY (id);


--
-- Name: Offer Offer_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Offer"
    ADD CONSTRAINT "Offer_pkey" PRIMARY KEY (id);


--
-- Name: PriceHistory PriceHistory_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."PriceHistory"
    ADD CONSTRAINT "PriceHistory_pkey" PRIMARY KEY (id);


--
-- Name: Review Review_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "Review_pkey" PRIMARY KEY (id);


--
-- Name: SavedLocation SavedLocation_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."SavedLocation"
    ADD CONSTRAINT "SavedLocation_pkey" PRIMARY KEY (id);


--
-- Name: Scan Scan_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Scan"
    ADD CONSTRAINT "Scan_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: AnalysisFeedback_analysisRecordId_key; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE UNIQUE INDEX "AnalysisFeedback_analysisRecordId_key" ON public."AnalysisFeedback" USING btree ("analysisRecordId");


--
-- Name: AnalysisFeedback_userId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "AnalysisFeedback_userId_idx" ON public."AnalysisFeedback" USING btree ("userId");


--
-- Name: AnalysisHistory_userId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "AnalysisHistory_userId_idx" ON public."AnalysisHistory" USING btree ("userId");


--
-- Name: AnalysisRecord_predictedMaterial_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "AnalysisRecord_predictedMaterial_idx" ON public."AnalysisRecord" USING btree ("predictedMaterial");


--
-- Name: AnalysisRecord_userId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "AnalysisRecord_userId_idx" ON public."AnalysisRecord" USING btree ("userId");


--
-- Name: ChatMessage_offerId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "ChatMessage_offerId_idx" ON public."ChatMessage" USING btree ("offerId");


--
-- Name: ChatMessage_senderId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "ChatMessage_senderId_idx" ON public."ChatMessage" USING btree ("senderId");


--
-- Name: FavoriteDealer_userId_dealerId_key; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE UNIQUE INDEX "FavoriteDealer_userId_dealerId_key" ON public."FavoriteDealer" USING btree ("userId", "dealerId");


--
-- Name: FavoriteDealer_userId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "FavoriteDealer_userId_idx" ON public."FavoriteDealer" USING btree ("userId");


--
-- Name: Listing_isActive_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Listing_isActive_idx" ON public."Listing" USING btree ("isActive");


--
-- Name: Listing_material_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Listing_material_idx" ON public."Listing" USING btree (material);


--
-- Name: Listing_status_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Listing_status_idx" ON public."Listing" USING btree (status);


--
-- Name: Listing_userId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Listing_userId_idx" ON public."Listing" USING btree ("userId");


--
-- Name: Offer_buyerId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Offer_buyerId_idx" ON public."Offer" USING btree ("buyerId");


--
-- Name: Offer_listingId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Offer_listingId_idx" ON public."Offer" USING btree ("listingId");


--
-- Name: Offer_parentOfferId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Offer_parentOfferId_idx" ON public."Offer" USING btree ("parentOfferId");


--
-- Name: PriceHistory_city_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "PriceHistory_city_idx" ON public."PriceHistory" USING btree (city);


--
-- Name: PriceHistory_material_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "PriceHistory_material_idx" ON public."PriceHistory" USING btree (material);


--
-- Name: Review_dealerId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Review_dealerId_idx" ON public."Review" USING btree ("dealerId");


--
-- Name: SavedLocation_userId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "SavedLocation_userId_idx" ON public."SavedLocation" USING btree ("userId");


--
-- Name: Scan_userId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "Scan_userId_idx" ON public."Scan" USING btree ("userId");


--
-- Name: User_email_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "User_email_idx" ON public."User" USING btree (email);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: User_googleId_idx; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE INDEX "User_googleId_idx" ON public."User" USING btree ("googleId");


--
-- Name: User_googleId_key; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE UNIQUE INDEX "User_googleId_key" ON public."User" USING btree ("googleId");


--
-- Name: User_phone_key; Type: INDEX; Schema: public; Owner: scrap_user
--

CREATE UNIQUE INDEX "User_phone_key" ON public."User" USING btree (phone);


--
-- Name: AnalysisFeedback AnalysisFeedback_analysisRecordId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisFeedback"
    ADD CONSTRAINT "AnalysisFeedback_analysisRecordId_fkey" FOREIGN KEY ("analysisRecordId") REFERENCES public."AnalysisRecord"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: AnalysisFeedback AnalysisFeedback_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisFeedback"
    ADD CONSTRAINT "AnalysisFeedback_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: AnalysisHistory AnalysisHistory_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisHistory"
    ADD CONSTRAINT "AnalysisHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: AnalysisRecord AnalysisRecord_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."AnalysisRecord"
    ADD CONSTRAINT "AnalysisRecord_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ChatMessage ChatMessage_offerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."ChatMessage"
    ADD CONSTRAINT "ChatMessage_offerId_fkey" FOREIGN KEY ("offerId") REFERENCES public."Offer"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ChatMessage ChatMessage_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."ChatMessage"
    ADD CONSTRAINT "ChatMessage_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: FavoriteDealer FavoriteDealer_dealerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."FavoriteDealer"
    ADD CONSTRAINT "FavoriteDealer_dealerId_fkey" FOREIGN KEY ("dealerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: FavoriteDealer FavoriteDealer_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."FavoriteDealer"
    ADD CONSTRAINT "FavoriteDealer_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Listing Listing_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Listing"
    ADD CONSTRAINT "Listing_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Offer Offer_buyerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Offer"
    ADD CONSTRAINT "Offer_buyerId_fkey" FOREIGN KEY ("buyerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Offer Offer_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Offer"
    ADD CONSTRAINT "Offer_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Offer Offer_parentOfferId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Offer"
    ADD CONSTRAINT "Offer_parentOfferId_fkey" FOREIGN KEY ("parentOfferId") REFERENCES public."Offer"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Review Review_dealerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "Review_dealerId_fkey" FOREIGN KEY ("dealerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Review Review_reviewerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Review"
    ADD CONSTRAINT "Review_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SavedLocation SavedLocation_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."SavedLocation"
    ADD CONSTRAINT "SavedLocation_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Scan Scan_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scrap_user
--

ALTER TABLE ONLY public."Scan"
    ADD CONSTRAINT "Scan_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: scrap_user
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict 9KLNdHc0vjumRNxMgYY7rqzuzkWFiOSnswrPSqukEurqgpD5cXOOacx3eFb0vbv

