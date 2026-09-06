--
-- PostgreSQL database dump
--

\restrict gbVCPmfcSCxseQTjOoap68snauF1T6WaiLTDMTUEx2jRkhhumWVsKfsRqk6z8bv

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
DROP TRIGGER IF EXISTS trg_log_medicine_price ON public.medicines;
DROP TRIGGER IF EXISTS trg_check_medicine_price ON public.medicines;
ALTER TABLE IF EXISTS ONLY public.suppliers DROP CONSTRAINT IF EXISTS suppliers_pkey;
ALTER TABLE IF EXISTS ONLY public.medicines DROP CONSTRAINT IF EXISTS medicines_pkey;
ALTER TABLE IF EXISTS ONLY public.medicines_log DROP CONSTRAINT IF EXISTS medicines_log_pkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_pkey;
DROP TABLE IF EXISTS public.suppliers;
DROP TABLE IF EXISTS public.medicines_log;
DROP TABLE IF EXISTS public.medicines;
DROP TABLE IF EXISTS public.deliveries;
DROP FUNCTION IF EXISTS public.retail_price(p_price numeric);
DROP FUNCTION IF EXISTS public.price_segment(p_price numeric);
DROP FUNCTION IF EXISTS public.log_medicine_price();
DROP FUNCTION IF EXISTS public.deliveries_by_supplier(p_supplier text);
DROP FUNCTION IF EXISTS public.check_medicine_price();
DROP FUNCTION IF EXISTS public.bad_commit(p_id integer);
--
-- Name: bad_commit(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bad_commit(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE medicines SET stock_quantity = stock_quantity + 10 WHERE id = p_id;
    COMMIT;  -- illegal inside a function
END;
$$;


ALTER FUNCTION public.bad_commit(p_id integer) OWNER TO postgres;

--
-- Name: check_medicine_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_medicine_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.price < 0 THEN
        RAISE EXCEPTION 'price cannot be negative (got %)', NEW.price;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_medicine_price() OWNER TO postgres;

--
-- Name: deliveries_by_supplier(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.deliveries_by_supplier(p_supplier text) RETURNS TABLE(medicine text, delivery_date date, quantity integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT m.name, d.delivery_date, d.quantity
    FROM deliveries d
    JOIN medicines m  ON m.id = d.medicine_id
    JOIN suppliers s  ON s.id = d.supplier_id
    WHERE s.name = p_supplier;
END;
$$;


ALTER FUNCTION public.deliveries_by_supplier(p_supplier text) OWNER TO postgres;

--
-- Name: log_medicine_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_medicine_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO medicines_log (medicine_id, action, old_price, new_price)
        VALUES (NEW.id, 'INSERT', NULL, NEW.price);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO medicines_log (medicine_id, action, old_price, new_price)
        VALUES (NEW.id, 'UPDATE', OLD.price, NEW.price);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_medicine_price() OWNER TO postgres;

--
-- Name: price_segment(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.price_segment(p_price numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF p_price  < 40 THEN
        RETURN 'budget';
    ELSIF p_price < 80 THEN
        RETURN 'mid-range';
    ELSE
        RETURN 'premium';
    END IF;
END;
$$;


ALTER FUNCTION public.price_segment(p_price numeric) OWNER TO postgres;

--
-- Name: retail_price(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.retail_price(p_price numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN ROUND(p_price * 1.25, 2);
END;
$$;


ALTER FUNCTION public.retail_price(p_price numeric) OWNER TO postgres;

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
-- Name: medicines_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicines_log (
    id integer NOT NULL,
    medicine_id integer NOT NULL,
    action text NOT NULL,
    old_price numeric,
    new_price numeric,
    logged_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.medicines_log OWNER TO postgres;

--
-- Name: medicines_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.medicines_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.medicines_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
1	Paracetamol	Darnytsia	tablets	28.0	120
2	Ibuprofen	Pharmak	tablets	52.0	90
\.


--
-- Data for Name: medicines_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicines_log (id, medicine_id, action, old_price, new_price, logged_at) FROM stdin;
1	13	INSERT	\N	65.0	2026-09-06 18:22:10.110287
2	1	UPDATE	25.0	28.0	2026-09-06 18:22:10.143724
3	2	UPDATE	45.0	52.0	2026-09-06 18:22:10.26382
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

SELECT pg_catalog.setval('public.medicines_id_seq', 13, true);


--
-- Name: medicines_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicines_log_id_seq', 3, true);


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
-- Name: medicines_log medicines_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines_log
    ADD CONSTRAINT medicines_log_pkey PRIMARY KEY (id);


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
-- Name: medicines trg_check_medicine_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_medicine_price BEFORE INSERT OR UPDATE OF price ON public.medicines FOR EACH ROW EXECUTE FUNCTION public.check_medicine_price();


--
-- Name: medicines trg_log_medicine_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_medicine_price AFTER INSERT OR UPDATE OF price ON public.medicines FOR EACH ROW EXECUTE FUNCTION public.log_medicine_price();


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
-- PostgreSQL database dump complete
--

\unrestrict gbVCPmfcSCxseQTjOoap68snauF1T6WaiLTDMTUEx2jRkhhumWVsKfsRqk6z8bv

