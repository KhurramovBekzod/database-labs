--
-- PostgreSQL database dump
--

\restrict RzWZCT3hVmK4WKbMQ6ueoWNnh8AJTlwiovAgS0Ejsuh5StVtMrhWJfCDxdfKPtP

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
-- PostgreSQL database dump complete
--

\unrestrict RzWZCT3hVmK4WKbMQ6ueoWNnh8AJTlwiovAgS0Ejsuh5StVtMrhWJfCDxdfKPtP

