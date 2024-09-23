--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

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
-- Name: type_contenu; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.type_contenu AS (
	type boolean,
	texte character varying(500),
	start boolean,
	fin boolean
);


ALTER TYPE public.type_contenu OWNER TO postgres;

--
-- Name: type_resolution1; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.type_resolution1 AS (
	texte character varying(100),
	contenuinitial integer,
	typeresolution integer,
	conditionspeciale integer,
	contenufinal integer,
	contenufinalbis integer
);


ALTER TYPE public.type_resolution1 OWNER TO postgres;

--
-- Name: count_resolutions(anyarray); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_resolutions(tableau_param anyarray) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    resolution_count INTEGER := 0;
    item RECORD;
BEGIN
    FOREACH item IN ARRAY tableau_param
    LOOP
        IF (item).type = false THEN
            resolution_count := resolution_count + 1;
        END IF;
    END LOOP;
    
    RETURN resolution_count;
END;
$$;


ALTER FUNCTION public.count_resolutions(tableau_param anyarray) OWNER TO postgres;

--
-- Name: delete_livre(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_livre(livreid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

	delete from resolution as c
	using (select * from livre as x left join contenu as w on x.livre_id =w.livre) as d
	where d.livre_id = livreId and c.contenu_initial = d.contenu_id;
	
	delete from contenu as b
	using livre as a 
    where b.livre = a.livre_id and a.livre_id = livreId;
	
	delete from livre as a
	where a.livre_id = livreId;
	

END;
$$;


ALTER FUNCTION public.delete_livre(livreid integer) OWNER TO postgres;

--
-- Name: get_contenu_by_livre_next(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_contenu_by_livre_next(id_contenu integer) RETURNS TABLE(contenu_initial character varying, start boolean, fin boolean, resolution_id integer, resolution character varying, contenu_final integer, contenu_final_bis integer, type_resolution integer, condition_speciale integer)
    LANGUAGE plpgsql
    AS $$
begin
return query
select d.texte as contenu, d.start, d.fin, h.resolution_id, h.texte as resolution, h.contenu_final, h.contenu_final_bis, h.type_resolution, h.condition_speciale 
from resolution as h join contenu as d on h.contenu_initial = d.contenu_id
where d.contenu_id = id_contenu;
end;
$$;


ALTER FUNCTION public.get_contenu_by_livre_next(id_contenu integer) OWNER TO postgres;

--
-- Name: get_contenu_by_livre_start(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_contenu_by_livre_start(id_livre integer) RETURNS TABLE(contenu_initial character varying, start boolean, fin boolean, resolution_id integer, resolution character varying, contenu_final integer, contenu_final_bis integer, type_resolution integer, condition_speciale integer)
    LANGUAGE plpgsql
    AS $$
begin
return query
select d.texte as contenu, d.start, d.fin, h.resolution_id, h.texte as resolution, h.contenu_final, h.contenu_final_bis, h.type_resolution, h.condition_speciale 
from resolution as h join contenu as d on h.contenu_initial = d.contenu_id
where d.livre = id_livre and d.start = true;
end;
$$;


ALTER FUNCTION public.get_contenu_by_livre_start(id_livre integer) OWNER TO postgres;

--
-- Name: get_max_contenu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_max_contenu() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    max_value INTEGER;
    max_plus_one INTEGER;
BEGIN
    -- Trouver la valeur maximale dans la colonne "ma_colonne" de la table "ma_table"
    SELECT MAX(contenu_id) INTO max_value FROM contenu;

    -- Ajouter 1 au maximum pour obtenir le maximum + 1
    max_plus_one := max_value + 1;

    -- Retourner le résultat
    RETURN max_plus_one;
END;
$$;


ALTER FUNCTION public.get_max_contenu() OWNER TO postgres;

--
-- Name: get_max_contenu_post(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_max_contenu_post() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    max_value INTEGER;

BEGIN
    SELECT MIN(contenu_id) INTO max_value FROM contenu AS c WHERE c.livre = get_max_livre()-1;
    RETURN max_value;
END;
$$;


ALTER FUNCTION public.get_max_contenu_post() OWNER TO postgres;

--
-- Name: get_max_livre(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_max_livre() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    max_value INTEGER;
    max_plus_one INTEGER;
BEGIN
    -- Trouver la valeur maximale dans la colonne "ma_colonne" de la table "ma_table"
    SELECT MAX(livre_id) INTO max_value FROM livre;

    -- Ajouter 1 au maximum pour obtenir le maximum + 1
    max_plus_one := max_value + 1;

    -- Retourner le résultat
    RETURN max_plus_one;
END;
$$;


ALTER FUNCTION public.get_max_livre() OWNER TO postgres;

--
-- Name: get_max_resolution(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_max_resolution() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    max_value INTEGER;
    max_plus_one INTEGER;
BEGIN
    -- Trouver la valeur maximale dans la colonne "ma_colonne" de la table "ma_table"
    SELECT MAX(resolution_id) INTO max_value FROM resolution;

    -- Ajouter 1 au maximum pour obtenir le maximum + 1
    max_plus_one := max_value + 1;

    -- Retourner le résultat
    RETURN max_plus_one;
END;
$$;


ALTER FUNCTION public.get_max_resolution() OWNER TO postgres;

--
-- Name: post(character varying, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.post(titre character varying, auteur integer, tableau_contenu character varying, tableau_resolution character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    num_contenu_value INTEGER;
BEGIN
	perform post_livre(titre, 0);
	num_contenu_value := post_story_contenu(array[tableau_contenu]::type_contenu[]);
	perform post_story_resolution(array[tableau_resolution]::type_resolution1[], num_contenu_value);
END;
$$;


ALTER FUNCTION public.post(titre character varying, auteur integer, tableau_contenu character varying, tableau_resolution character varying) OWNER TO postgres;

--
-- Name: post_livre(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.post_livre(titrep character varying, auteurp integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO livre (livre_id, titre, auteur)
    VALUES (get_max_livre(), titreP, auteurP);
	RETURN get_max_livre()-1;
END;
$$;


ALTER FUNCTION public.post_livre(titrep character varying, auteurp integer) OWNER TO postgres;

--
-- Name: post_livre_and_contenu_resolution(character varying, integer, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.post_livre_and_contenu_resolution(p_titre character varying, p_auteur integer, p_contenu text, p_resolution text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_post_result INTEGER; -- Variable pour stocker le résultat de la fonction post
BEGIN
  -- Appeler la fonction post_livre
  perform post_livre(p_titre, p_auteur);

  -- Convertir le texte JSON de p_contenu en type_contenu[]
  INSERT INTO temp_contenu_table(contenu) VALUES (p_contenu::type_contenu[]);

  -- Appeler la fonction post avec les données insérées dans temp_contenu_table
  select post(array_agg(c)) INTO v_post_result FROM temp_contenu_table c;

  -- Convertir le texte JSON de p_resolution en type_resolution1[]
  INSERT INTO temp_resolution_table(resolution) VALUES (p_resolution::type_resolution1[]);

  -- Appeler la fonction post_story_resolution avec les données insérées dans temp_resolution_table et v_post_result
  perform post_story_resolution(array_agg(r), v_post_result) FROM temp_resolution_table r;
END;
$$;


ALTER FUNCTION public.post_livre_and_contenu_resolution(p_titre character varying, p_auteur integer, p_contenu text, p_resolution text) OWNER TO postgres;

--
-- Name: post_story(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.post_story(tableau_param character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
    item RECORD;
    contenu_id INTEGER;
    condition_speciale_value VARCHAR(255);
    resolution_count INTEGER;
    first_contenu BOOLEAN := true;
    num_livre INTEGER;
BEGIN
    -- Compter le nombre d'objets de type résolution dans le tableau
    resolution_count := count_resolutions(tableau_param);
    num_livre := get_max_livre();

    FOREACH item IN ARRAY tableau_param
    LOOP
        IF (item).type = true THEN
            -- Insérer le contenu dans la table1 et récupérer l'ID auto-incrémenté si c'est la première itération
            IF first_contenu THEN
                INSERT INTO table1 (contenu_id, livre, texte, start, fin)
                VALUES (get_max_contenu(), num_livre, (item).texte, (item).start, (item).fin)
				RETURNING contenu_id INTO contenu_id;
                first_contenu := false; 
            ELSE
                -- Si ce n'est pas la première itération, insérer le contenu dans la table1
                INSERT INTO table1 (contenu_id, livre, texte, start, fin)
                VALUES (get_max_contenu(), num_livre, (item).texte, (item).start, (item).fin);
            END IF;
        ELSE
            -- Vérifier si la condition spéciale est '100' et remplacer par NULL si nécessaire
            condition_speciale_value := (item).conditionSpeciale;
            IF condition_speciale_value = '100' THEN
                condition_speciale_value := NULL;
            END IF;

            -- Utiliser l'ID du contenu inséré pour remplir les colonnes "contenuFinal" et "contenuFinalBis"
            INSERT INTO table2 (resolution_id, texte, contenu_initial, type_resolution, condition_speciale, contenu_final, contenu_final_bis)
            VALUES (
				get_max_resolution(),
                (item).texte,
                (item).contenuInitial,
                (item).typeResolution,
                condition_speciale_value,
                COALESCE(contenu_id, 0) + COALESCE((item).contenuFinal, 0) - resolution_count + 1,
                COALESCE(contenu_id, 0) + COALESCE((item).contenuFinalBis, 0) - resolution_count + 1
            );
        END IF;
    END LOOP;
END;
$$;


ALTER FUNCTION public.post_story(tableau_param character varying[]) OWNER TO postgres;

--
-- Name: post_story_contenu(public.type_contenu[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.post_story_contenu(tableau_param public.type_contenu[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
    item RECORD;
    contenu_id_save INTEGER;
    first_contenu BOOLEAN := true;
    num_livre INTEGER;
BEGIN
    num_livre := get_max_livre()-1;

    FOREACH item IN ARRAY tableau_param
    LOOP
        IF first_contenu THEN
            INSERT INTO contenu (contenu_id, livre, texte, start, fin)
            VALUES (get_max_contenu(), num_livre, (item).texte, (item).start, (item).fin)
			RETURNING contenu_id INTO contenu_id_save;
                first_contenu := false; 
        ELSE
            INSERT INTO contenu (contenu_id, livre, texte, start, fin)
            VALUES (get_max_contenu(), num_livre, (item).texte, (item).start, (item).fin);
    	END IF;
    END LOOP;
	RETURN contenu_id_save;
END;
$$;


ALTER FUNCTION public.post_story_contenu(tableau_param public.type_contenu[]) OWNER TO postgres;

--
-- Name: post_story_resolution(public.type_resolution1[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.post_story_resolution(tableau_param public.type_resolution1[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    item RECORD;
    condition_speciale_value integer;
	contenu_final_bis integer;
	get_contenu_max_post_value integer;
BEGIN
	
	get_contenu_max_post_value := get_max_contenu_post();
    FOREACH item IN ARRAY tableau_param
    LOOP
        condition_speciale_value := (item).conditionSpeciale;
        IF condition_speciale_value = 100 THEN
            condition_speciale_value := NULL;
        END IF;
		contenu_final_bis := (item).contenuFinalBis;
        IF contenu_final_bis IS NULL THEN
            contenu_final_bis := NULL;
		ELSE 
			contenu_final_bis := COALESCE(get_contenu_max_post_value, 0) + COALESCE((item).contenuFinalBis, 0);

        END IF;

        INSERT INTO resolution (resolution_id, texte, contenu_initial, type_resolution, condition_speciale, contenu_final, contenu_final_bis)
        VALUES (
			get_max_resolution(),
            (item).texte,
            (item).contenuInitial + get_contenu_max_post_value,
            (item).typeResolution,
            condition_speciale_value,
            COALESCE(get_contenu_max_post_value, 0) + COALESCE((item).contenuFinal, 0),
            contenu_final_bis
        );
    END LOOP;
END;
$$;


ALTER FUNCTION public.post_story_resolution(tableau_param public.type_resolution1[]) OWNER TO postgres;

--
-- Name: select_bibli_fctn(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.select_bibli_fctn() RETURNS TABLE(id integer, titre character varying, auteur character varying, tags character varying[])
    LANGUAGE plpgsql
    AS $$
begin 
return query
SELECT h.livre_id, h.titre, s.pseudo, array_agg(z.tag_name) AS tag
FROM bibliotheque
NATURAL JOIN livre AS h
NATURAL JOIN auteur AS s
LEFT JOIN tag_list AS w ON h.livre_id = w.livre_id
LEFT JOIN tag AS z ON w.tag_id = z.tag_id
GROUP BY h.livre_id, h.titre, s.pseudo;
end;
$$;


ALTER FUNCTION public.select_bibli_fctn() OWNER TO postgres;

--
-- Name: select_bibli_titre_fctn(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.select_bibli_titre_fctn(var_titre character varying) RETURNS TABLE(livre_id integer, titre character varying, auteur character varying, tags character varying[])
    LANGUAGE plpgsql
    AS $$
begin 
return query
select h.livre_id, h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
where s.pseudo = var_titre or h.titre = var_titre or z.tag_name = var_titre
group by h.titre, s.pseudo, h.livre_id;
end;
$$;


ALTER FUNCTION public.select_bibli_titre_fctn(var_titre character varying) OWNER TO postgres;

--
-- Name: select_bibliotheque(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.select_bibliotheque()
    LANGUAGE sql
    AS $$
select h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
group by h.titre, s.pseudo
$$;


ALTER PROCEDURE public.select_bibliotheque() OWNER TO postgres;

--
-- Name: select_bibliotheque_pseudo(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.select_bibliotheque_pseudo(IN var_pseudo character varying)
    LANGUAGE sql
    AS $$
select h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
where s.pseudo = var_pseudo
group by h.titre, s.pseudo
$$;


ALTER PROCEDURE public.select_bibliotheque_pseudo(IN var_pseudo character varying) OWNER TO postgres;

--
-- Name: select_bibliotheque_tag(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.select_bibliotheque_tag(IN var_tag character varying)
    LANGUAGE sql
    AS $$
select h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
where z.tag_name = var_tag
group by h.titre, s.pseudo;
$$;


ALTER PROCEDURE public.select_bibliotheque_tag(IN var_tag character varying) OWNER TO postgres;

--
-- Name: select_bibliotheque_titre(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.select_bibliotheque_titre(IN var_titre character varying)
    LANGUAGE sql
    AS $$
select h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
where h.titre = var_titre
group by h.titre, s.pseudo
$$;


ALTER PROCEDURE public.select_bibliotheque_titre(IN var_titre character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auteur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auteur (
    auteur_id integer NOT NULL,
    nom character varying(50),
    prenom character varying(50),
    pseudo character varying(50),
    mdp character varying(50),
    mail character varying(50)
);


ALTER TABLE public.auteur OWNER TO postgres;

--
-- Name: auteur_auteur_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auteur_auteur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auteur_auteur_id_seq OWNER TO postgres;

--
-- Name: auteur_auteur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auteur_auteur_id_seq OWNED BY public.auteur.auteur_id;


--
-- Name: bibliotheque; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bibliotheque (
    bibliotheque_id integer NOT NULL,
    livre integer,
    auteur integer
);


ALTER TABLE public.bibliotheque OWNER TO postgres;

--
-- Name: bibliotheque_bibliotheque_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bibliotheque_bibliotheque_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bibliotheque_bibliotheque_id_seq OWNER TO postgres;

--
-- Name: bibliotheque_bibliotheque_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bibliotheque_bibliotheque_id_seq OWNED BY public.bibliotheque.bibliotheque_id;


--
-- Name: condition_speciale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.condition_speciale (
    condition_speciale_id integer NOT NULL,
    condition_speciale character varying(50),
    jeton integer
);


ALTER TABLE public.condition_speciale OWNER TO postgres;

--
-- Name: condition_speciale_condition_speciale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.condition_speciale_condition_speciale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.condition_speciale_condition_speciale_id_seq OWNER TO postgres;

--
-- Name: condition_speciale_condition_speciale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.condition_speciale_condition_speciale_id_seq OWNED BY public.condition_speciale.condition_speciale_id;


--
-- Name: contenu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contenu (
    contenu_id integer NOT NULL,
    livre integer,
    texte character varying(500),
    start boolean,
    fin boolean
);


ALTER TABLE public.contenu OWNER TO postgres;

--
-- Name: contenu_contenu_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contenu_contenu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contenu_contenu_id_seq OWNER TO postgres;

--
-- Name: contenu_contenu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contenu_contenu_id_seq OWNED BY public.contenu.contenu_id;


--
-- Name: jeton; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jeton (
    jeton_id integer NOT NULL,
    ref_jeton integer,
    livre integer,
    nom character varying(50),
    effet character varying(100)
);


ALTER TABLE public.jeton OWNER TO postgres;

--
-- Name: jeton_jeton_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jeton_jeton_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jeton_jeton_id_seq OWNER TO postgres;

--
-- Name: jeton_jeton_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jeton_jeton_id_seq OWNED BY public.jeton.jeton_id;


--
-- Name: list_jeton; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.list_jeton (
    jeton_id integer NOT NULL,
    ref_jeton character varying(50)
);


ALTER TABLE public.list_jeton OWNER TO postgres;

--
-- Name: list_jeton_jeton_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.list_jeton_jeton_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.list_jeton_jeton_id_seq OWNER TO postgres;

--
-- Name: list_jeton_jeton_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.list_jeton_jeton_id_seq OWNED BY public.list_jeton.jeton_id;


--
-- Name: livre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.livre (
    livre_id integer NOT NULL,
    titre character varying(50),
    auteur integer
);


ALTER TABLE public.livre OWNER TO postgres;

--
-- Name: livre_livre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.livre_livre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.livre_livre_id_seq OWNER TO postgres;

--
-- Name: livre_livre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.livre_livre_id_seq OWNED BY public.livre.livre_id;


--
-- Name: personnage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personnage (
    personnage_id integer NOT NULL,
    auteur integer,
    prenom character varying(50),
    stat_pv integer,
    stat_force integer,
    stat_vitesse integer,
    stat_puissance integer,
    stat_intelligence integer,
    stat_courage integer
);


ALTER TABLE public.personnage OWNER TO postgres;

--
-- Name: personnage_personnage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personnage_personnage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnage_personnage_id_seq OWNER TO postgres;

--
-- Name: personnage_personnage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personnage_personnage_id_seq OWNED BY public.personnage.personnage_id;


--
-- Name: resolution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resolution (
    resolution_id integer NOT NULL,
    contenu_initial integer,
    texte character varying(100),
    type_resolution integer,
    condition_speciale integer,
    contenu_final integer,
    contenu_final_bis integer
);


ALTER TABLE public.resolution OWNER TO postgres;

--
-- Name: resolution_resolution_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resolution_resolution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resolution_resolution_id_seq OWNER TO postgres;

--
-- Name: resolution_resolution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resolution_resolution_id_seq OWNED BY public.resolution.resolution_id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    tag_id integer NOT NULL,
    tag_name character varying(50)
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: tag_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag_list (
    livre_id integer,
    tag_id integer
);


ALTER TABLE public.tag_list OWNER TO postgres;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tag_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tag_tag_id_seq OWNER TO postgres;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tag_tag_id_seq OWNED BY public.tag.tag_id;


--
-- Name: type_resolution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_resolution (
    type_resolution_id integer NOT NULL,
    type_resolution_name character varying(50)
);


ALTER TABLE public.type_resolution OWNER TO postgres;

--
-- Name: type_resolution_type_resolution_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_resolution_type_resolution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.type_resolution_type_resolution_id_seq OWNER TO postgres;

--
-- Name: type_resolution_type_resolution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_resolution_type_resolution_id_seq OWNED BY public.type_resolution.type_resolution_id;


--
-- Name: auteur auteur_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auteur ALTER COLUMN auteur_id SET DEFAULT nextval('public.auteur_auteur_id_seq'::regclass);


--
-- Name: bibliotheque bibliotheque_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bibliotheque ALTER COLUMN bibliotheque_id SET DEFAULT nextval('public.bibliotheque_bibliotheque_id_seq'::regclass);


--
-- Name: condition_speciale condition_speciale_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condition_speciale ALTER COLUMN condition_speciale_id SET DEFAULT nextval('public.condition_speciale_condition_speciale_id_seq'::regclass);


--
-- Name: contenu contenu_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contenu ALTER COLUMN contenu_id SET DEFAULT nextval('public.contenu_contenu_id_seq'::regclass);


--
-- Name: jeton jeton_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jeton ALTER COLUMN jeton_id SET DEFAULT nextval('public.jeton_jeton_id_seq'::regclass);


--
-- Name: list_jeton jeton_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.list_jeton ALTER COLUMN jeton_id SET DEFAULT nextval('public.list_jeton_jeton_id_seq'::regclass);


--
-- Name: livre livre_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livre ALTER COLUMN livre_id SET DEFAULT nextval('public.livre_livre_id_seq'::regclass);


--
-- Name: personnage personnage_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personnage ALTER COLUMN personnage_id SET DEFAULT nextval('public.personnage_personnage_id_seq'::regclass);


--
-- Name: resolution resolution_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resolution ALTER COLUMN resolution_id SET DEFAULT nextval('public.resolution_resolution_id_seq'::regclass);


--
-- Name: tag tag_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag ALTER COLUMN tag_id SET DEFAULT nextval('public.tag_tag_id_seq'::regclass);


--
-- Name: type_resolution type_resolution_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_resolution ALTER COLUMN type_resolution_id SET DEFAULT nextval('public.type_resolution_type_resolution_id_seq'::regclass);


--
-- Data for Name: auteur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auteur (auteur_id, nom, prenom, pseudo, mdp, mail) FROM stdin;
0	dece	toto	toto	toto1234	toto@test.be
\.


--
-- Data for Name: bibliotheque; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bibliotheque (bibliotheque_id, livre, auteur) FROM stdin;
0	0	0
\.


--
-- Data for Name: condition_speciale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.condition_speciale (condition_speciale_id, condition_speciale, jeton) FROM stdin;
1	 dice 1	\N
2	 dice 2	\N
3	 dice 3	\N
4	 dice 4	\N
5	 dice 5	\N
6	 dice 6	\N
7	 dice 7	\N
8	 dice 8	\N
9	 dice 9	\N
10	 dice 10	\N
11	 dice 11	\N
12	 dice 12	\N
13	 dice 13	\N
14	 dice 14	\N
15	 dice 15	\N
16	 dice 16	\N
17	 dice 17	\N
18	 dice 18	\N
19	 dice 19	\N
20	 dice 20	\N
\.


--
-- Data for Name: contenu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contenu (contenu_id, livre, texte, start, fin) FROM stdin;
0	0	ceci est le premier contenu du premier livre	t	f
1	0	ceci est le deuxieme contenu du premier livre	f	f
3	1	seul contenu livre 2	t	t
2	0	ceci est le 3eme contenu du premier livre	f	t
4	2	Alors que vous vous baladiez, vous tombez sur 2 statues qui vous regardent fixement	t	f
5	2	Nos amies semblent apprécier le geste et vous répondent d un mouvement de tete	f	f
6	2	Votre ton dédaigneux ne semble pas les mettre de bonne humeur bien au contraire, elles se rapprochent de vous et vous bottent les fesses ce qui vous renvoie d oû vous venez	f	f
7	2	Vous passez votre chemin sans encombre, après tout ce ne sont que des statues	f	t
8	2	Après de longues minutes à faire connaissance les statues finissent par vous offrir un petit médaillon, comme quoi, tout finit par payer un jour	f	t
11	4	testfctn	t	f
12	4	testfctn	f	t
13	5	testbug	t	f
14	5	faute	f	t
15	5	vraifin	f	t
16	6	test	t	f
17	6	test	f	t
18	7	la banane	t	f
19	7	test	f	t
20	7	test	f	t
21	8	start	t	f
22	8	fin1	f	t
23	8	fin2	f	t
24	9	il y a des inondations	t	f
25	9	les pompiez évacue le site	f	t
26	9	par chance vous entendez le dernier appel et vous évacuez	f	t
27	9	distrait vous loupez l appel	f	t
28	10	test9	t	f
29	10	t	f	t
30	11	tt	t	f
31	11	t	f	t
32	12	j ai une banane	t	f
33	12	je n ai plus de banane	f	t
34	12	je la rattrape	f	f
35	12	elle tombe je glisse	f	t
36	12	contenu1	f	f
37	12	contenu2	f	f
\.


--
-- Data for Name: jeton; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jeton (jeton_id, ref_jeton, livre, nom, effet) FROM stdin;
\.


--
-- Data for Name: list_jeton; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.list_jeton (jeton_id, ref_jeton) FROM stdin;
\.


--
-- Data for Name: livre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.livre (livre_id, titre, auteur) FROM stdin;
0	premier	0
1	deuxieme	0
2	demonstration	0
4	testfctn	0
5	testfaute	0
6	test3	0
7	test	0
8	testdice	0
9	inondation	0
10	test9	0
11	test10	0
12	la banane	0
\.


--
-- Data for Name: personnage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personnage (personnage_id, auteur, prenom, stat_pv, stat_force, stat_vitesse, stat_puissance, stat_intelligence, stat_courage) FROM stdin;
\.


--
-- Data for Name: resolution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resolution (resolution_id, contenu_initial, texte, type_resolution, condition_speciale, contenu_final, contenu_final_bis) FROM stdin;
0	0	0 vers 1	0	\N	1	\N
1	0	0 vers 2	0	\N	2	\N
2	1	1 vers 2	0	\N	2	\N
3	3	\N	\N	\N	\N	\N
4	2	\N	\N	\N	\N	\N
5	4	vous leurs dites bonjour!	0	\N	5	\N
6	4	vous êtes pressé, pas de temp à perdre!	0	\N	7	\N
7	4	vous leurs faites comprendre qu elles sont sur votre passage!	0	\N	6	\N
8	5	malgrés votre empressement, vous prenez le temps de faire la conversation	0	\N	8	\N
9	5	étant un peu pressé, vous continuez votre chemin après un gentil signe de la main	0	\N	7	\N
10	6	encaisser l affront	0	\N	4	\N
11	7	\N	\N	\N	\N	\N
12	8	\N	\N	\N	\N	\N
14	11	testfctn	0	\N	12	\N
15	12	null	\N	\N	11	\N
16	13	hein	0	\N	14	\N
17	14	null	\N	\N	13	\N
18	14	test	0	\N	15	\N
19	15	null	\N	\N	13	\N
20	16	test	0	\N	17	\N
21	17	null	\N	\N	16	\N
22	18	2	1	2	19	20
23	19	null	\N	\N	18	\N
24	20	null	\N	\N	18	\N
25	21	dic	1	10	22	23
26	22	null	\N	\N	21	\N
27	23	null	\N	\N	21	\N
28	24	vous appelez les pompiers	0	\N	25	\N
29	25	null	\N	\N	24	\N
30	24	vous prenez des photos	1	13	26	27
31	26	null	\N	\N	24	\N
32	27	null	\N	\N	24	\N
33	28	t	0	\N	29	\N
34	29	null	\N	\N	28	\N
35	28	t	0	\N	29	\N
36	30	tt	0	\N	31	\N
37	31	null	\N	\N	30	\N
38	30	t	1	5	31	31
39	32	je la mange	0	\N	33	\N
40	32	je la lance en l air	1	10	34	35
41	33	null	\N	\N	32	\N
42	34	je la mange	0	\N	33	\N
43	35	null	\N	\N	32	\N
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (tag_id, tag_name) FROM stdin;
0	arcade
1	fun
2	horreur
3	enigme
4	policier
5	fantasy
\.


--
-- Data for Name: tag_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag_list (livre_id, tag_id) FROM stdin;
0	0
0	1
1	0
2	0
2	1
\.


--
-- Data for Name: type_resolution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_resolution (type_resolution_id, type_resolution_name) FROM stdin;
0	choix simple
1	lancer de dés
2	jetons
\.


--
-- Name: auteur_auteur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auteur_auteur_id_seq', 1, false);


--
-- Name: bibliotheque_bibliotheque_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bibliotheque_bibliotheque_id_seq', 1, false);


--
-- Name: condition_speciale_condition_speciale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.condition_speciale_condition_speciale_id_seq', 1, false);


--
-- Name: contenu_contenu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contenu_contenu_id_seq', 1, true);


--
-- Name: jeton_jeton_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jeton_jeton_id_seq', 1, false);


--
-- Name: list_jeton_jeton_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.list_jeton_jeton_id_seq', 1, false);


--
-- Name: livre_livre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.livre_livre_id_seq', 7, true);


--
-- Name: personnage_personnage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personnage_personnage_id_seq', 1, false);


--
-- Name: resolution_resolution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resolution_resolution_id_seq', 1, false);


--
-- Name: tag_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_tag_id_seq', 1, true);


--
-- Name: type_resolution_type_resolution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_resolution_type_resolution_id_seq', 1, false);


--
-- Name: auteur auteur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auteur
    ADD CONSTRAINT auteur_pkey PRIMARY KEY (auteur_id);


--
-- Name: bibliotheque bibliotheque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bibliotheque
    ADD CONSTRAINT bibliotheque_pkey PRIMARY KEY (bibliotheque_id);


--
-- Name: condition_speciale condition_speciale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condition_speciale
    ADD CONSTRAINT condition_speciale_pkey PRIMARY KEY (condition_speciale_id);


--
-- Name: contenu contenu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contenu
    ADD CONSTRAINT contenu_pkey PRIMARY KEY (contenu_id);


--
-- Name: jeton jeton_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jeton
    ADD CONSTRAINT jeton_pkey PRIMARY KEY (jeton_id);


--
-- Name: jeton jeton_ref_jeton_livre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jeton
    ADD CONSTRAINT jeton_ref_jeton_livre_key UNIQUE (ref_jeton, livre);


--
-- Name: list_jeton list_jeton_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.list_jeton
    ADD CONSTRAINT list_jeton_pkey PRIMARY KEY (jeton_id);


--
-- Name: livre livre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livre
    ADD CONSTRAINT livre_pkey PRIMARY KEY (livre_id);


--
-- Name: personnage personnage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personnage
    ADD CONSTRAINT personnage_pkey PRIMARY KEY (personnage_id);


--
-- Name: resolution resolution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resolution
    ADD CONSTRAINT resolution_pkey PRIMARY KEY (resolution_id);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- Name: type_resolution type_resolution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_resolution
    ADD CONSTRAINT type_resolution_pkey PRIMARY KEY (type_resolution_id);


--
-- Name: bibliotheque bibliotheque_auteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bibliotheque
    ADD CONSTRAINT bibliotheque_auteur_fkey FOREIGN KEY (auteur) REFERENCES public.auteur(auteur_id);


--
-- Name: bibliotheque bibliotheque_livre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bibliotheque
    ADD CONSTRAINT bibliotheque_livre_fkey FOREIGN KEY (livre) REFERENCES public.livre(livre_id);


--
-- Name: condition_speciale condition_speciale_jeton_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condition_speciale
    ADD CONSTRAINT condition_speciale_jeton_fkey FOREIGN KEY (jeton) REFERENCES public.jeton(jeton_id);


--
-- Name: contenu contenu_livre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contenu
    ADD CONSTRAINT contenu_livre_fkey FOREIGN KEY (livre) REFERENCES public.livre(livre_id);


--
-- Name: jeton jeton_livre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jeton
    ADD CONSTRAINT jeton_livre_fkey FOREIGN KEY (livre) REFERENCES public.livre(livre_id);


--
-- Name: jeton jeton_ref_jeton_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jeton
    ADD CONSTRAINT jeton_ref_jeton_fkey FOREIGN KEY (ref_jeton) REFERENCES public.list_jeton(jeton_id);


--
-- Name: livre livre_auteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livre
    ADD CONSTRAINT livre_auteur_fkey FOREIGN KEY (auteur) REFERENCES public.auteur(auteur_id);


--
-- Name: personnage personnage_auteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personnage
    ADD CONSTRAINT personnage_auteur_fkey FOREIGN KEY (auteur) REFERENCES public.auteur(auteur_id);


--
-- Name: resolution resolution_condition_speciale_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resolution
    ADD CONSTRAINT resolution_condition_speciale_fkey FOREIGN KEY (condition_speciale) REFERENCES public.condition_speciale(condition_speciale_id);


--
-- Name: resolution resolution_contenu_final_bis_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resolution
    ADD CONSTRAINT resolution_contenu_final_bis_fkey FOREIGN KEY (contenu_final_bis) REFERENCES public.contenu(contenu_id);


--
-- Name: resolution resolution_contenu_final_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resolution
    ADD CONSTRAINT resolution_contenu_final_fkey FOREIGN KEY (contenu_final) REFERENCES public.contenu(contenu_id);


--
-- Name: resolution resolution_contenu_initial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resolution
    ADD CONSTRAINT resolution_contenu_initial_fkey FOREIGN KEY (contenu_initial) REFERENCES public.contenu(contenu_id);


--
-- Name: resolution resolution_type_resolution_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resolution
    ADD CONSTRAINT resolution_type_resolution_fkey FOREIGN KEY (type_resolution) REFERENCES public.type_resolution(type_resolution_id);


--
-- Name: tag_list tag_list_livre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag_list
    ADD CONSTRAINT tag_list_livre_id_fkey FOREIGN KEY (livre_id) REFERENCES public.livre(livre_id);


--
-- Name: tag_list tag_list_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag_list
    ADD CONSTRAINT tag_list_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(tag_id);


--
-- PostgreSQL database dump complete
--

