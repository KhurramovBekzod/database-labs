--
-- PostgreSQL database dump
--

\restrict H9u5W601etzpOAGwZUKOxNRYX3T1vJvTjhFhKGOlyX1WCvBR2kPBXsM4jeB6phO

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

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
-- Name: customer_feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_feedback (
    feedback_id integer NOT NULL,
    customer character varying(100),
    comment text
);


ALTER TABLE public.customer_feedback OWNER TO postgres;

--
-- Name: customer_feedback_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_feedback_feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_feedback_feedback_id_seq OWNER TO postgres;

--
-- Name: customer_feedback_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_feedback_feedback_id_seq OWNED BY public.customer_feedback.feedback_id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    name character varying(100),
    city character varying(50)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(100),
    department character varying(50)
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_employee_id_seq OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- Name: large_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.large_table (
    id integer,
    created_at date,
    value numeric
)
PARTITION BY RANGE (created_at);


ALTER TABLE public.large_table OWNER TO postgres;

--
-- Name: large_table_2023; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.large_table_2023 (
    id integer,
    created_at date,
    value numeric
);


ALTER TABLE public.large_table_2023 OWNER TO postgres;

--
-- Name: large_table_2024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.large_table_2024 (
    id integer,
    created_at date,
    value numeric
);


ALTER TABLE public.large_table_2024 OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    customer_id integer,
    order_date date,
    total numeric(10,2)
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(100),
    price numeric(10,2)
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_import; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products_import (
    product_id integer,
    product_name character varying(100),
    price numeric(10,2)
);


ALTER TABLE public.products_import OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: sales_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_data (
    region character varying(50),
    amount numeric(10,2)
);


ALTER TABLE public.sales_data OWNER TO postgres;

--
-- Name: staging_customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staging_customers (
    customer_id integer,
    name character varying(100),
    city character varying(50)
);


ALTER TABLE public.staging_customers OWNER TO postgres;

--
-- Name: target_customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.target_customers (
    customer_id integer NOT NULL,
    name character varying(100),
    city character varying(50)
);


ALTER TABLE public.target_customers OWNER TO postgres;

--
-- Name: large_table_2023; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.large_table ATTACH PARTITION public.large_table_2023 FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');


--
-- Name: large_table_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.large_table ATTACH PARTITION public.large_table_2024 FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


--
-- Name: customer_feedback feedback_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_feedback ALTER COLUMN feedback_id SET DEFAULT nextval('public.customer_feedback_feedback_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Data for Name: customer_feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_feedback (feedback_id, customer, comment) FROM stdin;
1	Aibek	Fast delivery, good price
2	Ainura	The box said "fragile", but it was fine
3	Bakyt	Okay
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, name, city) FROM stdin;
1	Aibek	Bishkek
2	Ainura	Osh
3	Bakyt	Karakol
4	Gulzat	Naryn
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, first_name, last_name, email, department) FROM stdin;
1	Aibek	Sharshenov	aibek@company.kg	IT
2	Ainura	Toktomamatova	\N	Sales
3	Bakyt	Mamatov	bakyt@company.kg	IT
4	Meerim	Bekova	meerim@company.kg	HR
\.


--
-- Data for Name: large_table_2023; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.large_table_2023 (id, created_at, value) FROM stdin;
1	2023-03-10	10
2	2023-11-20	20
\.


--
-- Data for Name: large_table_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.large_table_2024 (id, created_at, value) FROM stdin;
3	2024-05-05	30
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, customer_id, order_date, total) FROM stdin;
1	1	2026-09-01	250.00
2	2	2026-09-15	95.50
3	3	2026-10-02	430.00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, price) FROM stdin;
1	Laptop	950.00
2	Mouse	25.00
3	Keyboard	45.00
\.


--
-- Data for Name: products_import; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products_import (product_id, product_name, price) FROM stdin;
\.


--
-- Data for Name: sales_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_data (region, amount) FROM stdin;
\.


--
-- Data for Name: staging_customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staging_customers (customer_id, name, city) FROM stdin;
\.


--
-- Data for Name: target_customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.target_customers (customer_id, name, city) FROM stdin;
1	Aibek	Old city
9	Timur	Talas
\.


--
-- Name: customer_feedback_feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_feedback_feedback_id_seq', 3, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 4, true);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 4, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 3, true);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 3, true);


--
-- Name: customer_feedback customer_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_feedback
    ADD CONSTRAINT customer_feedback_pkey PRIMARY KEY (feedback_id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: target_customers target_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.target_customers
    ADD CONSTRAINT target_customers_pkey PRIMARY KEY (customer_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- PostgreSQL database dump complete
--

\unrestrict H9u5W601etzpOAGwZUKOxNRYX3T1vJvTjhFhKGOlyX1WCvBR2kPBXsM4jeB6phO

