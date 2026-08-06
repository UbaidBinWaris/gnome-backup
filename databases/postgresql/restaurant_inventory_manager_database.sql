--
-- PostgreSQL database dump
--

\restrict c31gSLB5yffFnW1Kg6d4rcnZesqNJ3XCmdNeVJF8D0dsyGhBolWp5eSCmdGUE7e

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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: calculate_margin_percent(); Type: FUNCTION; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE FUNCTION public.calculate_margin_percent() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.selling_price > 0 THEN
    NEW.margin_percent := ROUND(((NEW.selling_price - NEW.cost_per_serving) / NEW.selling_price * 100)::numeric, 2);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.calculate_margin_percent() OWNER TO restaurant_inventory_manager_user;

--
-- Name: update_order_balance(); Type: FUNCTION; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE FUNCTION public.update_order_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.remaining_balance := NEW.total_value - NEW.advance_received;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_order_balance() OWNER TO restaurant_inventory_manager_user;

--
-- Name: update_purchase_final_amount(); Type: FUNCTION; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE FUNCTION public.update_purchase_final_amount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.final_amount := NEW.total_amount + NEW.tax_amount - NEW.discount;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_purchase_final_amount() OWNER TO restaurant_inventory_manager_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    user_id uuid,
    action character varying(100) NOT NULL,
    entity_type character varying(100),
    entity_id character varying(100),
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(50),
    user_agent character varying(500),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audit_logs OWNER TO restaurant_inventory_manager_user;

--
-- Name: businesses; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.businesses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    tagline character varying(500),
    email character varying(255),
    phone character varying(20),
    address text,
    city character varying(100),
    country character varying(100),
    currency character varying(3) DEFAULT 'PKR'::character varying,
    logo_url character varying(500),
    owner_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.businesses OWNER TO restaurant_inventory_manager_user;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.clients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255),
    phone character varying(20),
    client_type character varying(50) NOT NULL,
    address text,
    city character varying(100),
    preferred_cuisine character varying(100),
    total_orders integer DEFAULT 0,
    total_spent numeric(12,2) DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.clients OWNER TO restaurant_inventory_manager_user;

--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.inventory_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    category character varying(100),
    unit character varying(50) NOT NULL,
    current_stock numeric(10,2) NOT NULL,
    minimum_stock numeric(10,2),
    maximum_stock numeric(10,2),
    cost_per_unit numeric(10,2) NOT NULL,
    selling_price numeric(10,2),
    supplier_id uuid,
    supplier_name character varying(255),
    barcode character varying(100),
    expiry_date date,
    storage_location character varying(100),
    is_active boolean DEFAULT true,
    reorder_quantity integer,
    reorder_point numeric(10,2),
    created_by uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_updated_by uuid
);


ALTER TABLE public.inventory_items OWNER TO restaurant_inventory_manager_user;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.invoices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid,
    user_id uuid,
    stripe_invoice_id character varying(255),
    invoice_number character varying(100),
    amount_due numeric(12,2) NOT NULL,
    amount_paid numeric(12,2) DEFAULT 0,
    status character varying(50) NOT NULL,
    due_date date,
    paid_at timestamp without time zone,
    pdf_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.invoices OWNER TO restaurant_inventory_manager_user;

--
-- Name: menu_item_ingredients; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.menu_item_ingredients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    menu_item_id uuid NOT NULL,
    inventory_item_id uuid,
    ingredient_name character varying(255) NOT NULL,
    quantity_required numeric(10,2) NOT NULL,
    unit character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.menu_item_ingredients OWNER TO restaurant_inventory_manager_user;

--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.menu_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category character varying(100) NOT NULL,
    cost_per_serving numeric(10,2) NOT NULL,
    selling_price numeric(10,2) NOT NULL,
    margin_percent numeric(5,2),
    ingredients jsonb,
    allergens jsonb,
    is_available boolean DEFAULT true,
    is_vegetarian boolean DEFAULT false,
    prep_time_minutes integer,
    image_url character varying(500),
    seasonal boolean DEFAULT false,
    season character varying(50),
    created_by uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp without time zone
);


ALTER TABLE public.menu_items OWNER TO restaurant_inventory_manager_user;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    user_id uuid NOT NULL,
    type character varying(100) NOT NULL,
    title character varying(255) NOT NULL,
    message text,
    reference_id character varying(100),
    reference_type character varying(50),
    is_read boolean DEFAULT false,
    read_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO restaurant_inventory_manager_user;

--
-- Name: order_items; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    menu_item_id uuid,
    item_name character varying(255) NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    cost_per_unit numeric(10,2),
    total_price numeric(12,2) NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.order_items OWNER TO restaurant_inventory_manager_user;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    order_number character varying(50) NOT NULL,
    client_id uuid,
    client_name character varying(255) NOT NULL,
    client_type character varying(50) NOT NULL,
    event_date date NOT NULL,
    event_type character varying(100),
    event_location text,
    guest_count integer NOT NULL,
    price_per_head numeric(10,2) NOT NULL,
    total_value numeric(12,2) NOT NULL,
    status character varying(50) DEFAULT 'Inquiry'::character varying NOT NULL,
    advance_received numeric(12,2) DEFAULT 0,
    remaining_balance numeric(12,2) NOT NULL,
    notes text,
    created_by uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    delivered_at timestamp without time zone,
    paid_at timestamp without time zone
);


ALTER TABLE public.orders OWNER TO restaurant_inventory_manager_user;

--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.payment_methods (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    stripe_payment_method_id character varying(255),
    stripe_customer_id character varying(255),
    type character varying(50),
    card_brand character varying(50),
    card_last4 character varying(4),
    card_exp_month integer,
    card_exp_year integer,
    is_default boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payment_methods OWNER TO restaurant_inventory_manager_user;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid,
    order_id uuid,
    purchase_id uuid,
    client_id uuid,
    amount numeric(12,2) NOT NULL,
    payment_method character varying(50),
    reference_number character varying(100),
    notes text,
    recorded_by uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_id uuid,
    stripe_payment_intent_id character varying(255),
    stripe_customer_id character varying(255),
    currency character varying(3) DEFAULT 'usd'::character varying,
    status character varying(50),
    description text,
    metadata jsonb
);


ALTER TABLE public.payments OWNER TO restaurant_inventory_manager_user;

--
-- Name: purchase_items; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.purchase_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_id uuid NOT NULL,
    inventory_item_id uuid,
    ingredient_name character varying(255) NOT NULL,
    quantity numeric(10,2) NOT NULL,
    unit character varying(50) NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    total_price numeric(12,2) NOT NULL,
    quantity_received numeric(10,2),
    received_at timestamp without time zone,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.purchase_items OWNER TO restaurant_inventory_manager_user;

--
-- Name: purchases; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.purchases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    purchase_order_number character varying(50) NOT NULL,
    supplier_id uuid NOT NULL,
    supplier_name character varying(255),
    purchase_date date NOT NULL,
    expected_delivery_date date,
    actual_delivery_date date,
    total_amount numeric(12,2) NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0,
    discount numeric(10,2) DEFAULT 0,
    final_amount numeric(12,2) NOT NULL,
    payment_status character varying(50) DEFAULT 'Pending'::character varying,
    amount_paid numeric(12,2) DEFAULT 0,
    status character varying(50) DEFAULT 'Ordered'::character varying,
    notes text,
    linked_order_id uuid,
    created_by uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    paid_at timestamp without time zone
);


ALTER TABLE public.purchases OWNER TO restaurant_inventory_manager_user;

--
-- Name: refunds; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.refunds (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    payment_id uuid,
    stripe_refund_id character varying(255),
    amount numeric(12,2) NOT NULL,
    reason text,
    status character varying(50),
    created_by uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.refunds OWNER TO restaurant_inventory_manager_user;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.role_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_id uuid NOT NULL,
    permission character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.role_permissions OWNER TO restaurant_inventory_manager_user;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_system_role boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.roles OWNER TO restaurant_inventory_manager_user;

--
-- Name: staff; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.staff (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    user_id uuid,
    name character varying(255) NOT NULL,
    email character varying(255),
    phone character varying(20),
    role_id uuid NOT NULL,
    "position" character varying(100),
    salary numeric(12,2),
    hire_date date,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp without time zone
);


ALTER TABLE public.staff OWNER TO restaurant_inventory_manager_user;

--
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.stock_movements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    inventory_item_id uuid NOT NULL,
    movement_type character varying(50) NOT NULL,
    quantity_change numeric(10,2) NOT NULL,
    previous_stock numeric(10,2),
    new_stock numeric(10,2),
    reference_id character varying(100),
    reference_type character varying(50),
    created_by uuid,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.stock_movements OWNER TO restaurant_inventory_manager_user;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    business_id uuid,
    stripe_subscription_id character varying(255),
    stripe_customer_id character varying(255),
    plan_name character varying(100) NOT NULL,
    plan_price numeric(10,2) NOT NULL,
    billing_interval character varying(20),
    status character varying(50) NOT NULL,
    current_period_start timestamp without time zone,
    current_period_end timestamp without time zone,
    cancel_at_period_end boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.subscriptions OWNER TO restaurant_inventory_manager_user;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.suppliers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255),
    phone character varying(20),
    address text,
    city character varying(100),
    payment_terms character varying(100),
    bank_details jsonb,
    contact_person character varying(255),
    is_active boolean DEFAULT true,
    total_purchases numeric(12,2) DEFAULT 0,
    average_delivery_days integer,
    rating numeric(3,1),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.suppliers OWNER TO restaurant_inventory_manager_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255),
    first_name character varying(100),
    last_name character varying(100),
    phone character varying(20),
    role character varying(50) DEFAULT 'user'::character varying NOT NULL,
    business_id uuid,
    is_active boolean DEFAULT true,
    last_login timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp without time zone,
    role_id uuid,
    oauth_provider character varying(50),
    oauth_id character varying(255),
    stripe_customer_id character varying(255)
);


ALTER TABLE public.users OWNER TO restaurant_inventory_manager_user;

--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.audit_logs (id, business_id, user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent, created_at) FROM stdin;
\.


--
-- Data for Name: businesses; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.businesses (id, name, tagline, email, phone, address, city, country, currency, logo_url, owner_id, is_active, created_at, updated_at) FROM stdin;
550e8400-e29b-41d4-a716-446655440000	Mommy's Kitchen	Artisan Catering & Gourmet Home Dining	hello@mommyskitchen.pk	0332-5172782	\N	Karachi	Pakistan	PKR	\N	\N	t	2025-12-22 20:09:39.613787	2025-12-22 20:09:39.613787
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.clients (id, business_id, name, email, phone, client_type, address, city, preferred_cuisine, total_orders, total_spent, is_active, created_at, updated_at) FROM stdin;
950e8400-e29b-41d4-a716-446655440001	550e8400-e29b-41d4-a716-446655440000	Ahmed & Fatima	ahmed.fatima@email.com	0300-1234567	Wedding	\N	\N	\N	0	0.00	t	2025-12-22 20:09:39.634237	2025-12-22 20:09:39.634237
950e8400-e29b-41d4-a716-446655440002	550e8400-e29b-41d4-a716-446655440000	Tech Solutions Pvt Ltd	hr@techsolutions.pk	021-5678901	Corporate	\N	\N	\N	0	0.00	t	2025-12-22 20:09:39.634237	2025-12-22 20:09:39.634237
950e8400-e29b-41d4-a716-446655440003	550e8400-e29b-41d4-a716-446655440000	Malik Family	malik.family@email.com	0321-9876543	Family	\N	\N	\N	0	0.00	t	2025-12-22 20:09:39.634237	2025-12-22 20:09:39.634237
\.


--
-- Data for Name: inventory_items; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.inventory_items (id, business_id, name, category, unit, current_stock, minimum_stock, maximum_stock, cost_per_unit, selling_price, supplier_id, supplier_name, barcode, expiry_date, storage_location, is_active, reorder_quantity, reorder_point, created_by, created_at, updated_at, last_updated_by) FROM stdin;
750e8400-e29b-41d4-a716-446655440001	550e8400-e29b-41d4-a716-446655440000	Basmati Rice	\N	kg	150.00	50.00	\N	280.00	\N	650e8400-e29b-41d4-a716-446655440001	Grain Masters	\N	\N	\N	t	\N	\N	\N	2025-12-22 20:09:39.627936	2025-12-22 20:09:39.627936	\N
750e8400-e29b-41d4-a716-446655440002	550e8400-e29b-41d4-a716-446655440000	Chicken	\N	kg	45.00	30.00	\N	520.00	\N	650e8400-e29b-41d4-a716-446655440002	Fresh Farms	\N	\N	\N	t	\N	\N	\N	2025-12-22 20:09:39.627936	2025-12-22 20:09:39.627936	\N
750e8400-e29b-41d4-a716-446655440003	550e8400-e29b-41d4-a716-446655440000	Cooking Oil	\N	liter	25.00	20.00	\N	450.00	\N	650e8400-e29b-41d4-a716-446655440003	Oil Corp	\N	\N	\N	t	\N	\N	\N	2025-12-22 20:09:39.627936	2025-12-22 20:09:39.627936	\N
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.invoices (id, order_id, user_id, stripe_invoice_id, invoice_number, amount_due, amount_paid, status, due_date, paid_at, pdf_url, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: menu_item_ingredients; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.menu_item_ingredients (id, menu_item_id, inventory_item_id, ingredient_name, quantity_required, unit, created_at) FROM stdin;
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.menu_items (id, business_id, name, description, category, cost_per_serving, selling_price, margin_percent, ingredients, allergens, is_available, is_vegetarian, prep_time_minutes, image_url, seasonal, season, created_by, created_at, updated_at, deleted_at) FROM stdin;
850e8400-e29b-41d4-a716-446655440001	550e8400-e29b-41d4-a716-446655440000	Chicken Biryani	\N	Rice	280.00	550.00	49.09	\N	\N	t	f	\N	\N	f	\N	\N	2025-12-22 20:09:39.630773	2025-12-22 20:09:39.630773	\N
850e8400-e29b-41d4-a716-446655440002	550e8400-e29b-41d4-a716-446655440000	Seekh Kebab	\N	BBQ	200.00	450.00	55.56	\N	\N	t	f	\N	\N	f	\N	\N	2025-12-22 20:09:39.630773	2025-12-22 20:09:39.630773	\N
850e8400-e29b-41d4-a716-446655440003	550e8400-e29b-41d4-a716-446655440000	Mutton Korma	\N	Main	420.00	850.00	50.59	\N	\N	t	f	\N	\N	f	\N	\N	2025-12-22 20:09:39.630773	2025-12-22 20:09:39.630773	\N
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.notifications (id, business_id, user_id, type, title, message, reference_id, reference_type, is_read, read_at, created_at) FROM stdin;
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.order_items (id, order_id, menu_item_id, item_name, quantity, unit_price, cost_per_unit, total_price, notes, created_at) FROM stdin;
070a11cd-6526-48ea-9404-f19c225842bb	84d2cf4f-d94c-4257-a321-8b2ff0533194	\N	Consequatur deserunt Event (37 guests)	37	86.00	\N	3182.00	\N	2025-12-22 23:50:28.867157
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.orders (id, business_id, order_number, client_id, client_name, client_type, event_date, event_type, event_location, guest_count, price_per_head, total_value, status, advance_received, remaining_balance, notes, created_by, created_at, updated_at, delivered_at, paid_at) FROM stdin;
84d2cf4f-d94c-4257-a321-8b2ff0533194	550e8400-e29b-41d4-a716-446655440000	ORD-1766429428859-PF6MZ	\N	Debitis deleniti pro	Individual	1971-10-25	Consequatur deserunt	\N	37	86.00	3182.00	Inquiry	0.00	3182.00	\N	\N	2025-12-22 23:50:28.860329	2025-12-22 23:50:28.860329	\N	\N
\.


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.payment_methods (id, user_id, stripe_payment_method_id, stripe_customer_id, type, card_brand, card_last4, card_exp_month, card_exp_year, is_default, created_at) FROM stdin;
5f7c3a33-beca-49be-a5a1-65f96bec5a05	26205adc-b09e-4514-b082-a57868a2a345	pm_1ShDaS1OjPeeqfDhRRhPorvF	cus_TeWLG8oY9s9xtP	card	visa	4242	11	2028	t	2025-12-22 23:12:06.172824
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.payments (id, business_id, order_id, purchase_id, client_id, amount, payment_method, reference_number, notes, recorded_by, created_at, updated_at, user_id, stripe_payment_intent_id, stripe_customer_id, currency, status, description, metadata) FROM stdin;
9ecaa1d2-f190-40a8-b62d-53b746df355e	\N	\N	\N	\N	5.00	\N	\N	\N	\N	2025-12-22 23:09:52.085295	2025-12-22 23:09:52.085295	26205adc-b09e-4514-b082-a57868a2a345	pi_3ShDYJ1OjPeeqfDh13mxg7AE	cus_TeWLG8oY9s9xtP	usd	pending	Eius pariatur Quibu	\N
46b5cea0-7b78-4f5b-a968-6e79454ac031	\N	\N	\N	\N	5.00	\N	\N	\N	\N	2025-12-22 23:10:00.679471	2025-12-22 23:10:00.679471	26205adc-b09e-4514-b082-a57868a2a345	pi_3ShDYS1OjPeeqfDh0JmTTUTL	cus_TeWLG8oY9s9xtP	usd	pending	Eius pariatur Quibu	\N
78184706-364f-425b-941b-0bd1a3e7c27f	\N	\N	\N	\N	21.00	\N	\N	\N	\N	2025-12-22 23:33:04.494704	2025-12-22 23:33:04.494704	26205adc-b09e-4514-b082-a57868a2a345	pi_3ShDum1OjPeeqfDh1Rye3PfV	cus_TeWLG8oY9s9xtP	usd	pending	ncfuwdegcbvwdieljfcds;jfcwe9;0fjuccwe	\N
5d8e8e49-376d-46f0-aeaf-7f8c600c6292	\N	\N	\N	\N	21.00	\N	\N	\N	\N	2025-12-22 23:33:09.362172	2025-12-22 23:33:09.362172	26205adc-b09e-4514-b082-a57868a2a345	pi_3ShDur1OjPeeqfDh0j0M4AwI	cus_TeWLG8oY9s9xtP	usd	pending	ncfuwdegcbvwdieljfcds;jfcwe9;0fjuccwe	\N
d00fcbc2-5cfc-4e2f-9cc5-ff5f58d5396b	\N	\N	\N	\N	21.00	\N	\N	\N	\N	2025-12-22 23:33:37.884613	2025-12-22 23:33:37.884613	26205adc-b09e-4514-b082-a57868a2a345	pi_3ShDvJ1OjPeeqfDh0m0CHLOl	cus_TeWLG8oY9s9xtP	usd	pending	Quick payment	\N
bc9fe440-e547-4e8f-8391-b0b8e45c3b7c	\N	\N	\N	\N	21.00	\N	\N	\N	\N	2025-12-22 23:37:37.504773	2025-12-22 23:37:37.504773	26205adc-b09e-4514-b082-a57868a2a345	pi_3ShDzB1OjPeeqfDh0GZcTPNr	cus_TeWLG8oY9s9xtP	usd	pending	dwqedfcwefwe	\N
\.


--
-- Data for Name: purchase_items; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.purchase_items (id, purchase_id, inventory_item_id, ingredient_name, quantity, unit, unit_price, total_price, quantity_received, received_at, notes, created_at) FROM stdin;
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.purchases (id, business_id, purchase_order_number, supplier_id, supplier_name, purchase_date, expected_delivery_date, actual_delivery_date, total_amount, tax_amount, discount, final_amount, payment_status, amount_paid, status, notes, linked_order_id, created_by, created_at, updated_at, paid_at) FROM stdin;
\.


--
-- Data for Name: refunds; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.refunds (id, payment_id, stripe_refund_id, amount, reason, status, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.role_permissions (id, role_id, permission, created_at) FROM stdin;
e8ce9f33-94fa-4fa7-a774-fa6a7c1f6ae9	560e8400-e29b-41d4-a716-446655440001	manage_staff	2025-12-22 20:09:39.617962
9202f53a-46cb-4573-ab3c-6fbbf9cbe1b6	560e8400-e29b-41d4-a716-446655440001	manage_roles	2025-12-22 20:09:39.617962
9067c08e-3450-43fe-b7a7-bbf20392d9bb	560e8400-e29b-41d4-a716-446655440001	manage_menu	2025-12-22 20:09:39.617962
4c2b1ccb-d0cd-4e44-9602-37aca538e5c5	560e8400-e29b-41d4-a716-446655440001	manage_inventory	2025-12-22 20:09:39.617962
0e4fc8c5-0ce5-4336-b4b0-f2de7e96aa09	560e8400-e29b-41d4-a716-446655440001	manage_orders	2025-12-22 20:09:39.617962
ff3708ce-0d5f-462a-b51d-130b65885775	560e8400-e29b-41d4-a716-446655440001	manage_purchases	2025-12-22 20:09:39.617962
f55ee11f-7562-455b-9dfe-8a5c5e7e107a	560e8400-e29b-41d4-a716-446655440001	view_reports	2025-12-22 20:09:39.617962
cee27888-bdd2-44bc-8593-49743a30fbe9	560e8400-e29b-41d4-a716-446655440001	manage_settings	2025-12-22 20:09:39.617962
879c2a6e-de89-4b53-b337-267a6c03d5df	560e8400-e29b-41d4-a716-446655440001	manage_clients	2025-12-22 20:09:39.617962
cd065575-4cbb-4e27-8a09-a8a93ce9c711	560e8400-e29b-41d4-a716-446655440001	manage_suppliers	2025-12-22 20:09:39.617962
5bcf8537-7b19-4065-8359-2c29fbbd09d8	560e8400-e29b-41d4-a716-446655440002	manage_menu	2025-12-22 20:09:39.621499
ae14e919-c746-473e-b6a7-6266cc1ef9a4	560e8400-e29b-41d4-a716-446655440002	manage_inventory	2025-12-22 20:09:39.621499
5d09764a-1cf2-498a-ade3-f87c77d43d0e	560e8400-e29b-41d4-a716-446655440002	manage_orders	2025-12-22 20:09:39.621499
da67f62b-c5f4-4dd0-8c4f-b9964d48bfb3	560e8400-e29b-41d4-a716-446655440002	manage_purchases	2025-12-22 20:09:39.621499
24e51709-4233-487a-a3e3-1e93a841eb25	560e8400-e29b-41d4-a716-446655440002	view_reports	2025-12-22 20:09:39.621499
da82d62e-d47b-415a-b602-4aa6015e191a	560e8400-e29b-41d4-a716-446655440002	manage_clients	2025-12-22 20:09:39.621499
a86ec7e1-aae9-498e-ab32-ac1bef18f14a	560e8400-e29b-41d4-a716-446655440002	manage_suppliers	2025-12-22 20:09:39.621499
d728207a-90d0-4adb-bb8a-f7ad41fe5424	560e8400-e29b-41d4-a716-446655440003	manage_menu	2025-12-22 20:09:39.623125
a1e3120b-ef2f-4d7e-b218-c4117d53f6ca	560e8400-e29b-41d4-a716-446655440003	manage_orders	2025-12-22 20:09:39.623125
10cd0d9b-86e0-4499-abeb-61dcba4faea6	560e8400-e29b-41d4-a716-446655440003	manage_inventory	2025-12-22 20:09:39.623125
f736f404-7635-4f63-abd7-d6af8b82aec2	560e8400-e29b-41d4-a716-446655440003	view_reports	2025-12-22 20:09:39.623125
f3e19424-4430-4f6b-ac17-e31cb4704cd4	560e8400-e29b-41d4-a716-446655440004	view_reports	2025-12-22 20:09:39.624428
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.roles (id, business_id, name, description, is_system_role, created_at, updated_at) FROM stdin;
560e8400-e29b-41d4-a716-446655440001	550e8400-e29b-41d4-a716-446655440000	Super Admin	Full system access and business configuration	t	2025-12-22 20:09:39.615621	2025-12-22 20:09:39.615621
560e8400-e29b-41d4-a716-446655440002	550e8400-e29b-41d4-a716-446655440000	Manager	Can manage menu, orders, and inventory	t	2025-12-22 20:09:39.615621	2025-12-22 20:09:39.615621
560e8400-e29b-41d4-a716-446655440003	550e8400-e29b-41d4-a716-446655440000	Staff	Can view and update menu and orders	t	2025-12-22 20:09:39.615621	2025-12-22 20:09:39.615621
560e8400-e29b-41d4-a716-446655440004	550e8400-e29b-41d4-a716-446655440000	Viewer	Read-only access to reports and analytics	t	2025-12-22 20:09:39.615621	2025-12-22 20:09:39.615621
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.staff (id, business_id, user_id, name, email, phone, role_id, "position", salary, hire_date, is_active, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.stock_movements (id, business_id, inventory_item_id, movement_type, quantity_change, previous_stock, new_stock, reference_id, reference_type, created_by, notes, created_at) FROM stdin;
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.subscriptions (id, user_id, business_id, stripe_subscription_id, stripe_customer_id, plan_name, plan_price, billing_interval, status, current_period_start, current_period_end, cancel_at_period_end, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.suppliers (id, business_id, name, email, phone, address, city, payment_terms, bank_details, contact_person, is_active, total_purchases, average_delivery_days, rating, notes, created_at, updated_at) FROM stdin;
650e8400-e29b-41d4-a716-446655440001	550e8400-e29b-41d4-a716-446655440000	Grain Masters	info@grainmasters.pk	021-1234567	\N	\N	\N	\N	Ahmed Khan	t	0.00	\N	\N	\N	2025-12-22 20:09:39.625593	2025-12-22 20:09:39.625593
650e8400-e29b-41d4-a716-446655440002	550e8400-e29b-41d4-a716-446655440000	Fresh Farms	contact@freshfarms.pk	021-2345678	\N	\N	\N	\N	Fatima Ahmed	t	0.00	\N	\N	\N	2025-12-22 20:09:39.625593	2025-12-22 20:09:39.625593
650e8400-e29b-41d4-a716-446655440003	550e8400-e29b-41d4-a716-446655440000	Oil Corp	sales@oilcorp.pk	021-3456789	\N	\N	\N	\N	Hassan Ali	t	0.00	\N	\N	\N	2025-12-22 20:09:39.625593	2025-12-22 20:09:39.625593
a442b804-9f22-4bde-b00e-f8c8567bcbff	550e8400-e29b-41d4-a716-446655440000	Iusto veniam velit 	miwegos@mailinator.com	Ut sit qui harum ut 	Inventore ipsum est 	Consequat Placeat 	\N	\N	\N	t	0.00	\N	\N	\N	2025-12-22 22:50:18.007543	2025-12-22 22:50:18.007543
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: restaurant_inventory_manager_user
--

COPY public.users (id, email, password_hash, first_name, last_name, phone, role, business_id, is_active, last_login, created_at, updated_at, deleted_at, role_id, oauth_provider, oauth_id, stripe_customer_id) FROM stdin;
350e8400-e29b-41d4-a716-446655440000	user@restaurant.com	$2a$10$l34mIvYD5XSwPZfJKd2nDO8s3mryUHRA466pKnm.TuAMuKXUveO2K	John	Doe	0300-1000002	user	550e8400-e29b-41d4-a716-446655440000	t	\N	2025-12-22 20:41:35.182518	2025-12-22 20:41:35.182518	\N	\N	\N	\N	\N
450e8400-e29b-41d4-a716-446655440000	staff@restaurant.com	$2a$10$qEtp5ekZAkyU98t.5wrnvunvmV.QlSFaLHm2/hNOgHPqLS9TT9SKS	Jane	Smith	0300-1000003	user	550e8400-e29b-41d4-a716-446655440000	t	\N	2025-12-22 20:41:35.182518	2025-12-22 20:41:35.182518	\N	\N	\N	\N	\N
150e8400-e29b-41d4-a716-446655440000	admin@restaurant.com	$2a$10$EY/QzQ0MBtDkO8.6tJ0NKOl0wc5aNMoUQY5PdHUy0O14UDGJ3nGmS	Admin	User	0300-1000000	admin	550e8400-e29b-41d4-a716-446655440000	t	2025-12-22 20:46:36.46731	2025-12-22 20:41:35.182518	2025-12-22 20:41:35.182518	\N	\N	\N	\N	\N
d9a231e6-02e6-4e7a-82bf-60a8841cf07e	bodo@mailinator.com	$2b$10$aB1MDO8DtzGxt9fx7O38Xerezo025virGe1vogbQwlWk70XQGTrua	Len	Dodson	+1 (835) 503-1002	user	\N	t	2025-12-22 21:53:22.715567	2025-12-22 21:53:07.881348	2025-12-22 21:53:07.881348	\N	\N	\N	\N	\N
26205adc-b09e-4514-b082-a57868a2a345	ubaidwaris34@gmail.com	\N	Ubaid	Waris	\N	user	\N	t	\N	2025-12-22 22:21:40.447413	2025-12-22 22:21:40.447413	\N	\N	google	111576590241021639788	cus_TeWLG8oY9s9xtP
250e8400-e29b-41d4-a716-446655440000	manager@restaurant.com	$2a$10$IvRzr.bYSHIhtfpqzygq.egMkAMA0xY9IAF7J9CuQ9FJNkfwxxSX6	Manager	User	0300-1000001	user	550e8400-e29b-41d4-a716-446655440000	t	2025-12-22 23:40:18.742509	2025-12-22 20:41:35.182518	2025-12-22 20:41:35.182518	\N	\N	\N	\N	\N
\.


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: businesses businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_number_key UNIQUE (invoice_number);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: menu_item_ingredients menu_item_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.menu_item_ingredients
    ADD CONSTRAINT menu_item_ingredients_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_stripe_payment_method_id_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_stripe_payment_method_id_key UNIQUE (stripe_payment_method_id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: purchase_items purchase_items_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_purchase_order_number_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_purchase_order_number_key UNIQUE (purchase_order_number);


--
-- Name: refunds refunds_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_pkey PRIMARY KEY (id);


--
-- Name: refunds refunds_stripe_refund_id_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_stripe_refund_id_key UNIQUE (stripe_refund_id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_role_id_permission_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_permission_key UNIQUE (role_id, permission);


--
-- Name: roles roles_business_id_name_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_business_id_name_key UNIQUE (business_id, name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (id);


--
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_stripe_subscription_id_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_stripe_subscription_id_key UNIQUE (stripe_subscription_id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: payments unique_stripe_payment_intent; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT unique_stripe_payment_intent UNIQUE (stripe_payment_intent_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_audit_logs_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_audit_logs_business_id ON public.audit_logs USING btree (business_id);


--
-- Name: idx_audit_logs_created_at; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_audit_logs_created_at ON public.audit_logs USING btree (created_at);


--
-- Name: idx_audit_logs_entity_type; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_audit_logs_entity_type ON public.audit_logs USING btree (entity_type);


--
-- Name: idx_audit_logs_user_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_audit_logs_user_id ON public.audit_logs USING btree (user_id);


--
-- Name: idx_businesses_owner_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_businesses_owner_id ON public.businesses USING btree (owner_id);


--
-- Name: idx_clients_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_clients_business_id ON public.clients USING btree (business_id);


--
-- Name: idx_clients_client_type; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_clients_client_type ON public.clients USING btree (client_type);


--
-- Name: idx_inventory_items_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_inventory_items_business_id ON public.inventory_items USING btree (business_id);


--
-- Name: idx_inventory_items_expiry_date; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_inventory_items_expiry_date ON public.inventory_items USING btree (expiry_date);


--
-- Name: idx_inventory_items_stock_check; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_inventory_items_stock_check ON public.inventory_items USING btree (current_stock, minimum_stock);


--
-- Name: idx_inventory_items_supplier_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_inventory_items_supplier_id ON public.inventory_items USING btree (supplier_id);


--
-- Name: idx_invoices_order_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_invoices_order_id ON public.invoices USING btree (order_id);


--
-- Name: idx_menu_item_ingredients_inventory_item_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_menu_item_ingredients_inventory_item_id ON public.menu_item_ingredients USING btree (inventory_item_id);


--
-- Name: idx_menu_item_ingredients_menu_item_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_menu_item_ingredients_menu_item_id ON public.menu_item_ingredients USING btree (menu_item_id);


--
-- Name: idx_menu_items_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_menu_items_business_id ON public.menu_items USING btree (business_id);


--
-- Name: idx_menu_items_category; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_menu_items_category ON public.menu_items USING btree (category);


--
-- Name: idx_menu_items_is_available; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_menu_items_is_available ON public.menu_items USING btree (is_available);


--
-- Name: idx_notifications_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_notifications_business_id ON public.notifications USING btree (business_id);


--
-- Name: idx_notifications_is_read; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_notifications_is_read ON public.notifications USING btree (is_read);


--
-- Name: idx_notifications_type; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);


--
-- Name: idx_notifications_user_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_notifications_user_id ON public.notifications USING btree (user_id);


--
-- Name: idx_order_items_menu_item_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_order_items_menu_item_id ON public.order_items USING btree (menu_item_id);


--
-- Name: idx_order_items_order_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id);


--
-- Name: idx_orders_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_orders_business_id ON public.orders USING btree (business_id);


--
-- Name: idx_orders_client_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_orders_client_id ON public.orders USING btree (client_id);


--
-- Name: idx_orders_event_date; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_orders_event_date ON public.orders USING btree (event_date);


--
-- Name: idx_orders_order_number; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_orders_order_number ON public.orders USING btree (order_number);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_payment_methods_user_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_payment_methods_user_id ON public.payment_methods USING btree (user_id);


--
-- Name: idx_payments_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_payments_business_id ON public.payments USING btree (business_id);


--
-- Name: idx_payments_client_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_payments_client_id ON public.payments USING btree (client_id);


--
-- Name: idx_payments_created_at; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_payments_created_at ON public.payments USING btree (created_at);


--
-- Name: idx_payments_order_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_payments_order_id ON public.payments USING btree (order_id);


--
-- Name: idx_payments_status; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_payments_status ON public.payments USING btree (status);


--
-- Name: idx_payments_user_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_payments_user_id ON public.payments USING btree (user_id);


--
-- Name: idx_purchase_items_inventory_item_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_purchase_items_inventory_item_id ON public.purchase_items USING btree (inventory_item_id);


--
-- Name: idx_purchase_items_purchase_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_purchase_items_purchase_id ON public.purchase_items USING btree (purchase_id);


--
-- Name: idx_purchases_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_purchases_business_id ON public.purchases USING btree (business_id);


--
-- Name: idx_purchases_purchase_date; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_purchases_purchase_date ON public.purchases USING btree (purchase_date);


--
-- Name: idx_purchases_status; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_purchases_status ON public.purchases USING btree (status);


--
-- Name: idx_purchases_supplier_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_purchases_supplier_id ON public.purchases USING btree (supplier_id);


--
-- Name: idx_refunds_payment_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_refunds_payment_id ON public.refunds USING btree (payment_id);


--
-- Name: idx_role_permissions_permission; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_role_permissions_permission ON public.role_permissions USING btree (permission);


--
-- Name: idx_role_permissions_role_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_role_permissions_role_id ON public.role_permissions USING btree (role_id);


--
-- Name: idx_roles_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_roles_business_id ON public.roles USING btree (business_id);


--
-- Name: idx_staff_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_staff_business_id ON public.staff USING btree (business_id);


--
-- Name: idx_staff_is_active; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_staff_is_active ON public.staff USING btree (is_active);


--
-- Name: idx_staff_role_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_staff_role_id ON public.staff USING btree (role_id);


--
-- Name: idx_staff_user_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_staff_user_id ON public.staff USING btree (user_id);


--
-- Name: idx_stock_movements_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_stock_movements_business_id ON public.stock_movements USING btree (business_id);


--
-- Name: idx_stock_movements_created_at; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_stock_movements_created_at ON public.stock_movements USING btree (created_at);


--
-- Name: idx_stock_movements_inventory_item_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_stock_movements_inventory_item_id ON public.stock_movements USING btree (inventory_item_id);


--
-- Name: idx_stock_movements_movement_type; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_stock_movements_movement_type ON public.stock_movements USING btree (movement_type);


--
-- Name: idx_subscriptions_user_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_subscriptions_user_id ON public.subscriptions USING btree (user_id);


--
-- Name: idx_suppliers_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_suppliers_business_id ON public.suppliers USING btree (business_id);


--
-- Name: idx_suppliers_name; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_suppliers_name ON public.suppliers USING btree (name);


--
-- Name: idx_users_business_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_users_business_id ON public.users USING btree (business_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: idx_users_role_id; Type: INDEX; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE INDEX idx_users_role_id ON public.users USING btree (role_id);


--
-- Name: menu_items trigger_calculate_margin_percent; Type: TRIGGER; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TRIGGER trigger_calculate_margin_percent BEFORE INSERT OR UPDATE ON public.menu_items FOR EACH ROW EXECUTE FUNCTION public.calculate_margin_percent();


--
-- Name: orders trigger_update_order_balance; Type: TRIGGER; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TRIGGER trigger_update_order_balance BEFORE INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_order_balance();


--
-- Name: purchases trigger_update_purchase_final_amount; Type: TRIGGER; Schema: public; Owner: restaurant_inventory_manager_user
--

CREATE TRIGGER trigger_update_purchase_final_amount BEFORE INSERT OR UPDATE ON public.purchases FOR EACH ROW EXECUTE FUNCTION public.update_purchase_final_amount();


--
-- Name: audit_logs audit_logs_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: businesses businesses_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: clients clients_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: users fk_users_business_id; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_business_id FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: inventory_items inventory_items_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: inventory_items inventory_items_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: inventory_items inventory_items_last_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_last_updated_by_fkey FOREIGN KEY (last_updated_by) REFERENCES public.users(id);


--
-- Name: inventory_items inventory_items_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: invoices invoices_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: invoices invoices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: menu_item_ingredients menu_item_ingredients_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.menu_item_ingredients
    ADD CONSTRAINT menu_item_ingredients_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: menu_item_ingredients menu_item_ingredients_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.menu_item_ingredients
    ADD CONSTRAINT menu_item_ingredients_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: menu_items menu_items_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: menu_items menu_items_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: notifications notifications_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: orders orders_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: orders orders_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: payment_methods payment_methods_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payments payments_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: payments payments_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: payments payments_purchase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES public.purchases(id) ON DELETE CASCADE;


--
-- Name: payments payments_recorded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_recorded_by_fkey FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- Name: payments payments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: purchase_items purchase_items_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: purchase_items purchase_items_purchase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchase_items
    ADD CONSTRAINT purchase_items_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES public.purchases(id) ON DELETE CASCADE;


--
-- Name: purchases purchases_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: purchases purchases_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: purchases purchases_linked_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_linked_order_id_fkey FOREIGN KEY (linked_order_id) REFERENCES public.orders(id);


--
-- Name: purchases purchases_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: refunds refunds_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: refunds refunds_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(id);


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: roles roles_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: staff staff_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: staff staff_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE RESTRICT;


--
-- Name: staff staff_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: stock_movements stock_movements_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: stock_movements stock_movements_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: stock_movements stock_movements_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: subscriptions subscriptions_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: suppliers suppliers_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: restaurant_inventory_manager_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO restaurant_inventory_manager_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO restaurant_inventory_manager_user;


--
-- PostgreSQL database dump complete
--

\unrestrict c31gSLB5yffFnW1Kg6d4rcnZesqNJ3XCmdNeVJF8D0dsyGhBolWp5eSCmdGUE7e

