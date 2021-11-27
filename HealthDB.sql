--
-- PostgreSQL database dump
--

-- Dumped from database version 11.11 (Ubuntu 11.11-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.3

-- Started on 2021-11-26 20:58:18

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 24 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 4146 (class 0 OID 0)
-- Dependencies: 24
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 956 (class 1255 OID 4130494)
-- Name: actualizar(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.actualizar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.nombre <> OLD.nombre THEN
		 INSERT INTO actividad(id, oldvar, newvar, fecha)
		 VALUES(new.id,old.nombre,new.nombre,now());
	END IF;

	IF NEW.apellido <> OLD.apellido THEN
		 INSERT INTO actividad(id, oldvar, newvar, fecha)
		 VALUES(new.id,old.apellido,new.apellido,now());
	END IF;

	IF NEW.celular <> OLD.celular THEN
		 INSERT INTO actividad(id, oldvar, newvar, fecha)
		 VALUES(new.id,CAST(old.celular AS varchar),CAST(new.celular AS varchar),now());
	END IF;

	IF NEW.correo <> OLD.correo THEN
		 INSERT INTO actividad(id, oldvar, newvar, fecha)
		 VALUES(new.id,old.correo,new.correo,now());
	END IF;

	IF NEW.activo <> OLD.activo THEN
		 INSERT INTO actividad(id, oldvar, newvar, fecha)
		 VALUES(new.id,CAST(old.activo AS varchar),CAST(new.activo AS varchar),now());
	END IF;

	IF NEW.usuario <> OLD.usuario THEN
		 INSERT INTO actividad(id, oldvar, newvar, fecha)
		 VALUES(new.id,CAST(old.activo AS varchar),CAST(new.avtivo AS varchar),now());
	END IF;

	IF NEW.contraseña <> OLD.contraseña THEN
		 INSERT INTO actividad(id, oldvar, newvar, fecha)
		 VALUES(new.id,old.contraseña,new.contraseña,now());
	END IF;

	RETURN NEW;
END;
$$;


--
-- TOC entry 955 (class 1255 OID 3764196)
-- Name: random_between(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.random_between(low integer, high integer) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$;


SET default_tablespace = '';

--
-- TOC entry 234 (class 1259 OID 4130320)
-- Name: actividad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.actividad (
    id integer,
    oldvar character(50),
    newvar character(50),
    fecha date
);


--
-- TOC entry 225 (class 1259 OID 3712268)
-- Name: citas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.citas (
    idcita integer NOT NULL,
    idpaciente integer,
    idmedico integer,
    fecha date,
    estado integer,
    comentario character varying(1000)
);


--
-- TOC entry 227 (class 1259 OID 3712785)
-- Name: clasificacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clasificacion (
    id_clasificacion integer NOT NULL,
    categoria character varying(150)
);


--
-- TOC entry 228 (class 1259 OID 3712897)
-- Name: enfermedad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.enfermedad (
    id_enfermedad integer NOT NULL,
    nombre character varying(300),
    clasificacion integer,
    descripcion character varying(1000)
);


--
-- TOC entry 231 (class 1259 OID 3713113)
-- Name: enfermedad_tratamiento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.enfermedad_tratamiento (
    id_enfermedad integer NOT NULL,
    id_tratamiento integer NOT NULL,
    registro date
);


--
-- TOC entry 230 (class 1259 OID 3713018)
-- Name: estado_citas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estado_citas (
    id_estado integer NOT NULL,
    nombre character varying(100)
);


--
-- TOC entry 229 (class 1259 OID 3712923)
-- Name: historia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historia (
    id_historia integer NOT NULL,
    id_paciente integer,
    id_enfermedad integer,
    registro date,
    descripcion character varying(1000),
    id_medico integer,
    id_tratamiento integer
);


--
-- TOC entry 223 (class 1259 OID 3709956)
-- Name: medico; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medico (
    id_medico integer NOT NULL,
    idusuario integer,
    registro date
);


--
-- TOC entry 224 (class 1259 OID 3712258)
-- Name: paciente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.paciente (
    idpaciente integer NOT NULL,
    idusuario integer,
    registro date,
    vive boolean
);


--
-- TOC entry 222 (class 1259 OID 3693101)
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    cedula integer,
    nombre character varying(150),
    apellido character varying(150),
    celular character varying(50),
    correo character varying(150),
    activo boolean,
    usuario character varying(100),
    "contraseña" character varying(100),
    rh integer
);


--
-- TOC entry 235 (class 1259 OID 4190319)
-- Name: informacion_citas; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.informacion_citas AS
 SELECT c.idcita,
    (((u.nombre)::text || ' '::text) || (u.apellido)::text) AS paciente,
    (((u2.nombre)::text || ' '::text) || (u2.apellido)::text) AS medico,
    c.fecha,
    ec.nombre AS estado
   FROM (((((public.citas c
     JOIN public.paciente p ON ((c.idpaciente = p.idpaciente)))
     JOIN public.medico m ON ((c.idmedico = m.id_medico)))
     JOIN public.usuario u ON ((p.idusuario = u.id)))
     JOIN public.usuario u2 ON ((m.idusuario = u2.id)))
     JOIN public.estado_citas ec ON ((c.estado = ec.id_estado)));


--
-- TOC entry 233 (class 1259 OID 3764190)
-- Name: tipo_sangre; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_sangre (
    id_tipo integer NOT NULL,
    rh character varying(6)
);


--
-- TOC entry 232 (class 1259 OID 3764188)
-- Name: tipo_sangre_id_tipo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tipo_sangre_id_tipo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4147 (class 0 OID 0)
-- Dependencies: 232
-- Name: tipo_sangre_id_tipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tipo_sangre_id_tipo_seq OWNED BY public.tipo_sangre.id_tipo;


--
-- TOC entry 226 (class 1259 OID 3712301)
-- Name: tratamiento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tratamiento (
    id_tratamiento integer NOT NULL,
    nombre character varying(300),
    descripcion character varying(1000)
);


--
-- TOC entry 3962 (class 2604 OID 3764193)
-- Name: tipo_sangre id_tipo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_sangre ALTER COLUMN id_tipo SET DEFAULT nextval('public.tipo_sangre_id_tipo_seq'::regclass);


--
-- TOC entry 4140 (class 0 OID 4130320)
-- Dependencies: 234
-- Data for Name: actividad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.actividad VALUES (3, 'daniel @correo.com                                ', 'Daniel                                            ', '2021-11-23');
INSERT INTO public.actividad VALUES (4, 'Alejandro                                         ', 'Juan                                              ', '2021-11-23');


--
-- TOC entry 4131 (class 0 OID 3712268)
-- Dependencies: 225
-- Data for Name: citas; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.citas VALUES (2, 2, 3, '2021-11-12', 1, 'Medicina General');
INSERT INTO public.citas VALUES (4, 5, 4, '2021-11-12', 4, 'Medicina General');
INSERT INTO public.citas VALUES (5, 1, 9, '2021-11-12', 2, 'Medicina General');
INSERT INTO public.citas VALUES (6, 6, 3, '2021-11-12', 2, 'Medicina General');
INSERT INTO public.citas VALUES (7, 8, 5, '2021-11-12', 1, 'Medicina General');
INSERT INTO public.citas VALUES (8, 9, 7, '2021-11-12', 2, 'Medicina General');
INSERT INTO public.citas VALUES (1, 1, 1, '2021-11-12', 2, 'Medicina General');
INSERT INTO public.citas VALUES (3, 4, 3, '2021-11-12', 4, 'Medicina General');


--
-- TOC entry 4133 (class 0 OID 3712785)
-- Dependencies: 227
-- Data for Name: clasificacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.clasificacion VALUES (1, 'LEVE');
INSERT INTO public.clasificacion VALUES (2, 'GRAVE');
INSERT INTO public.clasificacion VALUES (3, 'MUY GRAVE');


--
-- TOC entry 4134 (class 0 OID 3712897)
-- Dependencies: 228
-- Data for Name: enfermedad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.enfermedad VALUES (1, 'Pulmonia', 3, NULL);
INSERT INTO public.enfermedad VALUES (3, 'Bronquitis', 1, NULL);
INSERT INTO public.enfermedad VALUES (4, 'Autismo', 3, NULL);
INSERT INTO public.enfermedad VALUES (5, 'Insuficiencia cardiaca', 3, NULL);
INSERT INTO public.enfermedad VALUES (6, 'Artritis', 2, NULL);
INSERT INTO public.enfermedad VALUES (7, 'Cancer', 3, NULL);
INSERT INTO public.enfermedad VALUES (8, 'Leucemia', 3, NULL);
INSERT INTO public.enfermedad VALUES (9, 'Diabetes', 2, NULL);
INSERT INTO public.enfermedad VALUES (2, 'Albinismo', 3, NULL);


--
-- TOC entry 4137 (class 0 OID 3713113)
-- Dependencies: 231
-- Data for Name: enfermedad_tratamiento; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.enfermedad_tratamiento VALUES (1, 2, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (1, 3, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (3, 2, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (4, 6, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (5, 6, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (6, 2, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (7, 3, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (8, 8, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (9, 9, NULL);
INSERT INTO public.enfermedad_tratamiento VALUES (9, 2, NULL);


--
-- TOC entry 4136 (class 0 OID 3713018)
-- Dependencies: 230
-- Data for Name: estado_citas; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.estado_citas VALUES (1, 'RESERVADO');
INSERT INTO public.estado_citas VALUES (2, 'CANCELADO');
INSERT INTO public.estado_citas VALUES (3, 'REALIZADO');
INSERT INTO public.estado_citas VALUES (4, 'EN PROCESO DE ASIGNACION');


--
-- TOC entry 4135 (class 0 OID 3712923)
-- Dependencies: 229
-- Data for Name: historia; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.historia VALUES (1, 2, 3, '2021-09-08', '', 2, 3);
INSERT INTO public.historia VALUES (2, 2, 7, '2021-09-08', '', 5, 7);
INSERT INTO public.historia VALUES (3, 5, 9, '2011-09-08', '', 7, 2);
INSERT INTO public.historia VALUES (4, 4, 1, '2016-09-18', '', 8, 5);
INSERT INTO public.historia VALUES (5, 7, 2, '2016-09-18', '', 8, 6);
INSERT INTO public.historia VALUES (6, 6, 1, '2017-09-24', '', 8, 5);
INSERT INTO public.historia VALUES (7, 8, 5, '2006-09-03', '', 7, 5);
INSERT INTO public.historia VALUES (8, 5, 2, '2016-09-03', '', 5, 2);
INSERT INTO public.historia VALUES (9, 9, 3, '2021-04-13', '', 5, 5);
INSERT INTO public.historia VALUES (10, 3, 5, '2006-09-03', '', 4, 5);


--
-- TOC entry 4129 (class 0 OID 3709956)
-- Dependencies: 223
-- Data for Name: medico; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.medico VALUES (2, 4, '2021-10-22');
INSERT INTO public.medico VALUES (3, 10, '2021-09-23');
INSERT INTO public.medico VALUES (4, 20, '2021-09-23');
INSERT INTO public.medico VALUES (5, 9, '2021-08-23');
INSERT INTO public.medico VALUES (6, 15, '2021-08-23');
INSERT INTO public.medico VALUES (7, 17, '2021-06-23');
INSERT INTO public.medico VALUES (8, 11, '2021-05-21');
INSERT INTO public.medico VALUES (9, 16, '2021-08-30');
INSERT INTO public.medico VALUES (10, 3, '2021-06-23');
INSERT INTO public.medico VALUES (1, 11, '2021-03-12');


--
-- TOC entry 4130 (class 0 OID 3712258)
-- Dependencies: 224
-- Data for Name: paciente; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.paciente VALUES (1, 14, '2021-08-23', true);
INSERT INTO public.paciente VALUES (2, 7, '2021-06-23', true);
INSERT INTO public.paciente VALUES (3, 1, '2021-05-21', true);
INSERT INTO public.paciente VALUES (4, 6, '2021-08-30', true);
INSERT INTO public.paciente VALUES (5, 13, '2021-06-23', true);
INSERT INTO public.paciente VALUES (6, 11, '2021-08-23', true);
INSERT INTO public.paciente VALUES (7, 18, '2021-06-23', true);
INSERT INTO public.paciente VALUES (8, 5, '2021-05-21', true);
INSERT INTO public.paciente VALUES (9, 2, '2021-08-30', true);
INSERT INTO public.paciente VALUES (10, 9, '2021-06-23', true);


--
-- TOC entry 4139 (class 0 OID 3764190)
-- Dependencies: 233
-- Data for Name: tipo_sangre; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tipo_sangre VALUES (1, 'A+');
INSERT INTO public.tipo_sangre VALUES (2, 'A-');
INSERT INTO public.tipo_sangre VALUES (3, 'B+');
INSERT INTO public.tipo_sangre VALUES (4, 'B-');
INSERT INTO public.tipo_sangre VALUES (5, 'AB+');
INSERT INTO public.tipo_sangre VALUES (6, 'AB-');
INSERT INTO public.tipo_sangre VALUES (7, 'O+');
INSERT INTO public.tipo_sangre VALUES (8, 'O-');


--
-- TOC entry 4132 (class 0 OID 3712301)
-- Dependencies: 226
-- Data for Name: tratamiento; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tratamiento VALUES (1, 'Acetaminofen', NULL);
INSERT INTO public.tratamiento VALUES (2, 'Atorvastatatina', NULL);
INSERT INTO public.tratamiento VALUES (3, 'Anticoagulante HR57', NULL);
INSERT INTO public.tratamiento VALUES (4, 'Vitamina B7', NULL);
INSERT INTO public.tratamiento VALUES (5, 'Antibiotico A64', NULL);
INSERT INTO public.tratamiento VALUES (6, 'Milanta', NULL);
INSERT INTO public.tratamiento VALUES (7, 'Paracetamol', NULL);
INSERT INTO public.tratamiento VALUES (8, 'Aspirina', NULL);
INSERT INTO public.tratamiento VALUES (9, 'Diclofenaco', NULL);
INSERT INTO public.tratamiento VALUES (10, 'Metronidazol', NULL);


--
-- TOC entry 4128 (class 0 OID 3693101)
-- Dependencies: 222
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.usuario VALUES (72, 620935275, 'Luis Arturo', 'Villegas Corredor', '31297515', 'arturoco@correo.com', true, 'artco', 'ar452', 6);
INSERT INTO public.usuario VALUES (96, 845086412, 'Leoard Christopher', 'Walker McDorly', '31804472', 'mcdorly@correo.com', true, 'mcdly', 'res21', 4);
INSERT INTO public.usuario VALUES (28, 1405763646, 'Julian', 'Santos', '31291912', 'dantos@correo.com', true, 'asao', 'aras2', 6);
INSERT INTO public.usuario VALUES (86, 911631137, 'Daniel James', 'Lenon Dicaprio', '31462741', 'dalecap@correo.com', true, 'dalecap', 'dl14ew', 2);
INSERT INTO public.usuario VALUES (1, 1121118207, 'Luis Arturo', 'Mercado Doller', '31618601', 'luis arturo@correo.com', false, 'luis arturo', 'Lui8207', 5);
INSERT INTO public.usuario VALUES (2, 251470681, 'Daniel Fernando', 'Villegas Corredor', '31246683', 'daniel fernando@correo.com', true, 'daniel fernando', 'Dan0681', 5);
INSERT INTO public.usuario VALUES (7, 690007822, 'Marcela', 'Villegas Corredor', '31507083', 'marcela@correo.com', true, 'marcela', 'Mar7822', 1);
INSERT INTO public.usuario VALUES (8, 1335706638, 'Dana Patricia', 'Walker McDorly', '32103255', 'dana patricia@correo.com', true, 'dana patricia', 'Dan6638', 2);
INSERT INTO public.usuario VALUES (9, 1327099887, 'Julio', 'Santos', '31609303', 'julio @correo.com', false, 'julio', 'Jul9887', 5);
INSERT INTO public.usuario VALUES (10, 1419794239, 'Christopher', 'Lenon Dicaprio', '31279044', 'christopher@correo.com', true, 'christopher', 'Chr4239', 6);
INSERT INTO public.usuario VALUES (11, 1423895644, 'Tom', 'Mercado Doller', '31990126', 'tom@correo.com', false, 'tom', 'Tom5644', 7);
INSERT INTO public.usuario VALUES (12, 1240248901, 'Arthur', 'Villegas Corredor', '31966677', 'arthur @correo.com', false, 'arthur', 'Art8901', 7);
INSERT INTO public.usuario VALUES (13, 1061280320, 'Leonard', 'Walker McDorly', '31511649', 'leonard@correo.com', true, 'leonard', 'Leo0320', 8);
INSERT INTO public.usuario VALUES (14, 80135828, 'Juan', 'Santos', '31501674', 'juan@correo.com', true, 'juan', 'Jua5828', 8);
INSERT INTO public.usuario VALUES (15, 964339853, 'Pedro', 'Lenon Dicaprio', '31677056', 'pedro@correo.com', false, 'pedro', 'Ped9853', 5);
INSERT INTO public.usuario VALUES (16, 1126299416, 'Lola', 'Mercado Doller', '31146809', 'lola@correo.com', true, 'lola', 'Lol9416', 2);
INSERT INTO public.usuario VALUES (17, 876637503, 'Marcos', 'Villegas Corredor', '31123504', 'marcos@correo.com', true, 'marcos', 'Mar7503', 1);
INSERT INTO public.usuario VALUES (18, 257936655, 'Ricardo', 'Walker McDorly', '31232892', 'ricardo@correo.com', false, 'ricardo', 'Ric6655', 4);
INSERT INTO public.usuario VALUES (19, 1261922589, 'Laura', 'Santos', '31656143', 'laura@correo.com', true, 'laura', 'Lau2589', 3);
INSERT INTO public.usuario VALUES (20, 1400630042, 'Isabela', 'Lenon Dicaprio', '32089118', 'isabela@correo.com', false, 'isabela', 'Isa0042', 4);
INSERT INTO public.usuario VALUES (5, 832640502, 'Sam', 'Lenon Dicaprio', '31984341', 'sam@correo.com', true, 'sam', 'Sam0502', 4);
INSERT INTO public.usuario VALUES (6, 1040382564, 'Julian', 'Mercado Doller', '32062031', 'julian@correo.com', true, 'julian', 'Jul2564', 2);
INSERT INTO public.usuario VALUES (3, 367202396, 'Daniel', 'Walker McDorly', '31310278', 'Daniel', true, 'daniel', 'Dan2396', 8);
INSERT INTO public.usuario VALUES (4, 914392860, 'Juan', 'Santos', '31173902', 'alejandro@correo.com', true, 'alejandro', 'Ale2860', 1);


--
-- TOC entry 4148 (class 0 OID 0)
-- Dependencies: 232
-- Name: tipo_sangre_id_tipo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tipo_sangre_id_tipo_seq', 8, true);


--
-- TOC entry 3975 (class 2606 OID 3712275)
-- Name: citas citas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_pkey PRIMARY KEY (idcita);


--
-- TOC entry 3979 (class 2606 OID 3712789)
-- Name: clasificacion clasificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clasificacion
    ADD CONSTRAINT clasificacion_pkey PRIMARY KEY (id_clasificacion);


--
-- TOC entry 3981 (class 2606 OID 3712904)
-- Name: enfermedad enfermedad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enfermedad
    ADD CONSTRAINT enfermedad_pkey PRIMARY KEY (id_enfermedad);


--
-- TOC entry 3987 (class 2606 OID 3713117)
-- Name: enfermedad_tratamiento enfermedad_tratamiento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enfermedad_tratamiento
    ADD CONSTRAINT enfermedad_tratamiento_pkey PRIMARY KEY (id_enfermedad, id_tratamiento);


--
-- TOC entry 3985 (class 2606 OID 3713022)
-- Name: estado_citas estado_citas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estado_citas
    ADD CONSTRAINT estado_citas_pkey PRIMARY KEY (id_estado);


--
-- TOC entry 3983 (class 2606 OID 3712930)
-- Name: historia historia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historia
    ADD CONSTRAINT historia_pkey PRIMARY KEY (id_historia);


--
-- TOC entry 3971 (class 2606 OID 3709960)
-- Name: medico medico_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medico
    ADD CONSTRAINT medico_pkey PRIMARY KEY (id_medico);


--
-- TOC entry 3973 (class 2606 OID 3712262)
-- Name: paciente paciente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_pkey PRIMARY KEY (idpaciente);


--
-- TOC entry 3989 (class 2606 OID 3764195)
-- Name: tipo_sangre tipo_sangre_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_sangre
    ADD CONSTRAINT tipo_sangre_pkey PRIMARY KEY (id_tipo);


--
-- TOC entry 3977 (class 2606 OID 3712308)
-- Name: tratamiento tratamiento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tratamiento
    ADD CONSTRAINT tratamiento_pkey PRIMARY KEY (id_tratamiento);


--
-- TOC entry 3965 (class 2606 OID 3693110)
-- Name: usuario usuario_cedula_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_cedula_key UNIQUE (cedula);


--
-- TOC entry 3967 (class 2606 OID 3693108)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 3969 (class 2606 OID 3693112)
-- Name: usuario usuario_usuario_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_usuario_key UNIQUE (usuario);


--
-- TOC entry 3963 (class 1259 OID 4190369)
-- Name: user_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_name ON public.usuario USING btree (nombre);


--
-- TOC entry 4004 (class 2620 OID 4130518)
-- Name: usuario actualizacion; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER actualizacion AFTER UPDATE ON public.usuario FOR EACH ROW EXECUTE PROCEDURE public.actualizar();


--
-- TOC entry 4003 (class 2606 OID 4130323)
-- Name: actividad actividad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT actividad_id_fkey FOREIGN KEY (id) REFERENCES public.usuario(id);


--
-- TOC entry 3995 (class 2606 OID 3764110)
-- Name: citas citas_estado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_estado_fkey FOREIGN KEY (estado) REFERENCES public.estado_citas(id_estado);


--
-- TOC entry 3994 (class 2606 OID 3712281)
-- Name: citas citas_idmedico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_idmedico_fkey FOREIGN KEY (idmedico) REFERENCES public.medico(id_medico);


--
-- TOC entry 3993 (class 2606 OID 3712276)
-- Name: citas citas_idpaciente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_idpaciente_fkey FOREIGN KEY (idpaciente) REFERENCES public.paciente(idpaciente);


--
-- TOC entry 3996 (class 2606 OID 3712905)
-- Name: enfermedad enfermedad_clasificacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enfermedad
    ADD CONSTRAINT enfermedad_clasificacion_fkey FOREIGN KEY (clasificacion) REFERENCES public.clasificacion(id_clasificacion);


--
-- TOC entry 4001 (class 2606 OID 3713118)
-- Name: enfermedad_tratamiento enfermedad_tratamiento_id_enfermedad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enfermedad_tratamiento
    ADD CONSTRAINT enfermedad_tratamiento_id_enfermedad_fkey FOREIGN KEY (id_enfermedad) REFERENCES public.enfermedad(id_enfermedad);


--
-- TOC entry 4002 (class 2606 OID 3713123)
-- Name: enfermedad_tratamiento enfermedad_tratamiento_id_tratamiento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enfermedad_tratamiento
    ADD CONSTRAINT enfermedad_tratamiento_id_tratamiento_fkey FOREIGN KEY (id_tratamiento) REFERENCES public.tratamiento(id_tratamiento);


--
-- TOC entry 3998 (class 2606 OID 3712936)
-- Name: historia historia_id_enfermedad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historia
    ADD CONSTRAINT historia_id_enfermedad_fkey FOREIGN KEY (id_enfermedad) REFERENCES public.enfermedad(id_enfermedad);


--
-- TOC entry 3999 (class 2606 OID 3768110)
-- Name: historia historia_id_medico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historia
    ADD CONSTRAINT historia_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES public.medico(id_medico);


--
-- TOC entry 3997 (class 2606 OID 3712931)
-- Name: historia historia_id_paciente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historia
    ADD CONSTRAINT historia_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES public.paciente(idpaciente);


--
-- TOC entry 4000 (class 2606 OID 3768136)
-- Name: historia historia_id_tratamiento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historia
    ADD CONSTRAINT historia_id_tratamiento_fkey FOREIGN KEY (id_tratamiento) REFERENCES public.tratamiento(id_tratamiento);


--
-- TOC entry 3991 (class 2606 OID 3768179)
-- Name: medico medico_idusuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medico
    ADD CONSTRAINT medico_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(id);


--
-- TOC entry 3992 (class 2606 OID 3712263)
-- Name: paciente paciente_idusuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(id);


--
-- TOC entry 3990 (class 2606 OID 3768160)
-- Name: usuario usuario_rh_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_rh_fkey FOREIGN KEY (rh) REFERENCES public.tipo_sangre(id_tipo);


-- Completed on 2021-11-26 20:59:39

--
-- PostgreSQL database dump complete
--

