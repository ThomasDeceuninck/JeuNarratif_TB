


CREATE OR REPLACE PROCEDURE select_bibliotheque_tag
(IN var_tag varchar(50))
LANGUAGE SQL
AS $$
select h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
where z.tag_name = var_tag
group by h.titre, s.pseudo;
$$;


CREATE OR REPLACE PROCEDURE select_bibliotheque_titre
(IN var_titre varchar(50))
LANGUAGE SQL
AS $$
select t.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as t natural join auteur as s natural join tag_list as w natural join tag as z
where t.titre = var_titre
group by t.titre, s.pseudo
$$;


CREATE OR REPLACE PROCEDURE select_bibliotheque_pseudo
(IN var_pseudo varchar(50))
LANGUAGE SQL
AS $$
select h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
where s.pseudo = var_pseudo
group by h.titre, s.pseudo
$$;


CREATE OR REPLACE PROCEDURE select_bibliotheque()
LANGUAGE SQL
AS $$
select h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
group by h.titre, s.pseudo
$$;





---------------------------------------------------------------------------




create or replace function select_bibli_fctn()
returns table (id integer, titre varchar(50), auteur varchar(50), tags varchar[])
language plpgsql
as 
$$
begin 
return query
select h.livre_id, h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
group by h.titre, s.pseudo, h.livre_id;
end;
$$;



create or replace function select_bibli_titre_fctn(var_titre varchar(50))
returns table (livre_id integer, titre varchar(50), auteur varchar(50), tags varchar[])
language plpgsql
as 
$$
begin 
return query
select h.livre_id, h.titre, s.pseudo, array_agg(z.tag_name) as tag
from bibliotheque natural join livre as h natural join auteur as s natural join tag_list as w natural join tag as z
where s.pseudo = var_titre or h.titre = var_titre or z.tag_name = var_titre
group by h.titre, s.pseudo, h.livre_id;
end;
$$;



create or replace function get_contenu_by_livre_start (id_livre integer)
returns table (contenu_initial varchar(500), start boolean, fin boolean, resolution_id integer, resolution varchar(100), contenu_final integer, contenu_final_bis integer, type_resolution integer, condition_speciale integer)
language plpgsql
as 
$$
begin
return query
select d.texte as contenu, d.start, d.fin, h.resolution_id, h.texte as resolution, h.contenu_final, h.contenu_final_bis, h.type_resolution, h.condition_speciale 
from resolution as h join contenu as d on h.contenu_initial = d.contenu_id
where d.livre = id_livre and d.start = true;
end;
$$;



create or replace function get_contenu_by_livre_next (id_contenu integer)
returns table (contenu_initial varchar(500), start boolean, fin boolean, resolution_id integer, resolution varchar(100), contenu_final integer, contenu_final_bis integer, type_resolution integer, condition_speciale integer)
language plpgsql
as 
$$
begin
return query
select d.texte as contenu, d.start, d.fin, h.resolution_id, h.texte as resolution, h.contenu_final, h.contenu_final_bis, h.type_resolution, h.condition_speciale 
from resolution as h join contenu as d on h.contenu_initial = d.contenu_id
where d.contenu_id = id_contenu;
end;
$$;



---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION post_story(tableau_param[])
RETURNS VOID 
LANGUAGE PLPGSQL
AS
$$

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
$$










CREATE OR REPLACE FUNCTION post_story_contenu(tableau_param type_contenu[])
RETURNS INTEGER 
LANGUAGE PLPGSQL
AS
$$
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
$$










CREATE OR REPLACE FUNCTION post_story_resolution(tableau_param type_resolution1[], contenu_num)
RETURNS VOID
LANGUAGE PLPGSQL
AS
$$
DECLARE
    item RECORD;
    condition_speciale_value integer;
	contenu_final_bis integer;
BEGIN

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
			contenu_final_bis := COALESCE(contenu_num, 0) + COALESCE((item).contenuFinalBis, 0);

        END IF;

        INSERT INTO resolution (resolution_id, texte, contenu_initial, type_resolution, condition_speciale, contenu_final, contenu_final_bis)
        VALUES (
			get_max_resolution(),
            (item).texte,
            (item).contenuInitial + contenu_num,
            (item).typeResolution,
            condition_speciale_value,
            COALESCE(contenu_num, 0) + COALESCE((item).contenuFinal, 0),
            contenu_final_bis
        );
    END LOOP;
END;


-------------------------------------------------




CREATE OR REPLACE FUNCTION count_resolutions(tableau_param ANYARRAY)
RETURNS INTEGER 
LANGUAGE PLPGSQL
AS
$$
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
$$





CREATE OR REPLACE FUNCTION get_max_livre()
RETURNS INTEGER AS
$$
DECLARE
    max_value INTEGER;
    max_plus_one INTEGER;
BEGIN
    -- Trouver la valeur maximale dans la colonne "ma_colonne" de la table "ma_table"
    SELECT MAX(livre) INTO max_value FROM contenu;

    -- Ajouter 1 au maximum pour obtenir le maximum + 1
    max_plus_one := max_value + 1;

    -- Retourner le résultat
    RETURN max_plus_one;
END;
$$
LANGUAGE PLPGSQL;





CREATE OR REPLACE FUNCTION get_max_contenu()
RETURNS INTEGER AS
$$
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
$$
LANGUAGE PLPGSQL;





CREATE OR REPLACE FUNCTION get_max_resolution()
RETURNS INTEGER AS
$$
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
$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION post_livre(titreP VARCHAR(50), auteurP integer)
RETURNS INTEGER
LANGUAGE PLPGSQL
AS
$$
BEGIN
	INSERT INTO livre (livre_id, titre, auteur)
    VALUES (get_max_livre(), titreP, auteurP);
	RETURN get_max_livre()-1;
END;
$$;



CREATE OR REPLACE FUNCTION delete_livre(livreId INTEGER)
RETURNS VOID 
LANGUAGE PLPGSQL
AS
$$
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

------------- 





