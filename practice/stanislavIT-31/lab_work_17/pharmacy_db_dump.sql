--
-- PostgreSQL database dump
--

\restrict MsndxEZJP3dnnbGZBkFFg02PkSKfSFc5zqJzfpTfR1bwGaiNHvQJuKk5KTmvdmF

-- Dumped from database version 17.11
-- Dumped by pg_dump version 17.11

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

ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_supplier_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_medicine_id_fkey;
ALTER TABLE IF EXISTS ONLY public.suppliers DROP CONSTRAINT IF EXISTS suppliers_pkey;
ALTER TABLE IF EXISTS ONLY public.medicines DROP CONSTRAINT IF EXISTS medicines_pkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_pkey;
DROP TABLE IF EXISTS public.suppliers;
DROP MATERIALIZED VIEW IF EXISTS public.medicines_in_stock_mat;
DROP VIEW IF EXISTS public.medicines_in_stock;
DROP TABLE IF EXISTS public.medicines;
DROP TABLE IF EXISTS public.deliveries;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliveries (
    id integer NOT NULL,
    medicine_id integer NOT NULL,
    supplier_id integer NOT NULL,
    delivery_date date NOT NULL,
    quantity integer NOT NULL,
    purchase_price numeric
);


ALTER TABLE public.deliveries OWNER TO postgres;

--
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.deliveries ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.deliveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: medicines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicines (
    id integer NOT NULL,
    name text NOT NULL,
    manufacturer text,
    form text,
    price numeric NOT NULL,
    stock_quantity integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.medicines OWNER TO postgres;

--
-- Name: medicines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.medicines ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.medicines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: medicines_in_stock; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.medicines_in_stock AS
 SELECT id,
    name,
    manufacturer,
    form,
    price,
    stock_quantity
   FROM public.medicines
  WHERE (stock_quantity >= 80);


ALTER VIEW public.medicines_in_stock OWNER TO postgres;

--
-- Name: medicines_in_stock_mat; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.medicines_in_stock_mat AS
 SELECT id,
    name,
    manufacturer,
    form,
    price,
    stock_quantity
   FROM public.medicines
  WHERE (stock_quantity >= 60)
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.medicines_in_stock_mat OWNER TO postgres;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    name text NOT NULL,
    contact_person text,
    phone text,
    city text
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.suppliers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deliveries (id, medicine_id, supplier_id, delivery_date, quantity, purchase_price) FROM stdin;
1	5	10	2025-09-01	76	85.85
2	2	4	2025-08-18	40	65.25
3	11	12	2025-08-26	12	17.44
4	4	7	2024-05-22	84	39.52
5	9	9	2025-07-24	80	36.46
6	12	8	2025-05-09	39	19.65
7	4	6	2024-12-18	98	24.81
8	4	12	2025-05-24	85	88.13
9	9	10	2025-02-27	34	33.70
10	6	3	2025-01-23	78	20.13
11	1	1	2025-12-05	91	79.48
12	8	2	2024-10-10	70	48.30
13	6	3	2024-05-28	71	19.13
14	2	7	2025-02-19	90	64.92
15	3	3	2025-02-08	25	54.65
16	7	10	2024-09-13	67	82.68
17	5	10	2025-05-19	89	14.82
18	12	2	2024-11-07	43	62.83
19	3	4	2024-09-03	30	10.21
20	8	12	2025-05-02	39	33.05
\.


--
-- Data for Name: medicines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicines (id, name, manufacturer, form, price, stock_quantity) FROM stdin;
1	Paracetamol	Darnytsia	tablets	25.0	120
2	Ibuprofen	Pharmak	tablets	45.0	90
3	No-Spa	Chinoin	tablets	110.0	60
4	Aspirin	Bayer	tablets	55.0	80
5	Mukaltin	Ternopharm	tablets	30.0	100
6	Validol	Darnytsia	tablets	20.0	70
7	Amoxicillin	Kyivmedpreparat	capsules	65.0	50
8	Loratadine	Pharmak	tablets	40.0	65
9	Cough syrup	Ternopharm	syrup	85.0	40
10	Burn cream	Darnytsia	ointment	95.0	35
11	Vitamin C	Pharmak	tablets	60.0	110
12	Activated charcoal	Kyivmedpreparat	tablets	15.0	150
13	Nimesil	Berlin-Chemie	powder	65.0	45
14	Smecta	Ipsen	powder	95.0	90
15	Rennie	Bayer	tablets	75.0	88
16	Efferalgan	Upsa	tablets	90.0	80
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (id, name, contact_person, phone, city) FROM stdin;
1	Optima-Pharm	Taras Bondarenko	+380****0001	Lviv
2	BaDM	Maria Rudenko	+380****0002	Kyiv
3	Venta.Ltd	Yulia Kravets	+380****0003	Lviv
4	Alba Ukraine	Oksana Honcharenko	+380****0004	Poltava
5	Fra-M	Roman Lytvyn	+380****0005	Vinnytsia
6	Medpharmcom	Sofia Zakharchenko	+380****0006	Odesa
7	Liky Control	Maksym Oliinyk	+380****0007	Cherkasy
8	Pharmacy Holding	Maksym Melnyk	+380****0008	Vinnytsia
9	UniPharma	Andriy Lytvyn	+380****0009	Dnipro
10	Pharmpostach	Bohdan Hrytsenko	+380****0010	Poltava
11	Medzabezpechennia	Ihor Kravets	+380****0011	Odesa
12	Lixem	Maksym Melnyk	+380****0012	Vinnytsia
\.


--
-- Name: deliveries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deliveries_id_seq', 20, true);


--
-- Name: medicines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicines_id_seq', 16, true);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 12, true);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- Name: medicines medicines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: deliveries deliveries_medicine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_medicine_id_fkey FOREIGN KEY (medicine_id) REFERENCES public.medicines(id) ON DELETE RESTRICT;


--
-- Name: deliveries deliveries_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE RESTRICT;


--
-- Name: medicines_in_stock_mat; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.medicines_in_stock_mat;


--
-- PostgreSQL database dump complete
--

\unrestrict MsndxEZJP3dnnbGZBkFFg02PkSKfSFc5zqJzfpTfR1bwGaiNHvQJuKk5KTmvdmF

