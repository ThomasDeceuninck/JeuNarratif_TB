-- Database: JeuNarratif

-- DROP DATABASE IF EXISTS "JeuNarratif";

CREATE DATABASE "JeuNarratif"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'French_France.1252'
    LC_CTYPE = 'French_France.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	
create table auteur (

	auteur_id serial primary key,
	nom varchar(50),
	prenom varchar(50),
	pseudo varchar(50),
	mdp varchar(50),
	mail varchar(50)

);
	
create table personnage (

	personnage_id serial primary key,
	auteur int references auteur (auteur_id),
	prenom varchar (50),
	stat_pv int,
	stat_force int,
	stat_vitesse int,
	stat_puissance int,
	stat_intelligence int,
	stat_courage int

);

create table livre (

	livre_id serial primary key,
	titre varchar(50),
	auteur int references auteur(auteur_id)
	
);

create table bibliotheque (

	bibliotheque_id serial primary key,
	livre int references livre (livre_id),
	auteur int references auteur (auteur_id)

);




create table contenu (

	contenu_id serial primary key,
	livre int references livre(livre_id),
	texte varchar(500)

);


create table type_resolution(

	type_resolution_id serial primary key,
	type_resolution_name varchar(50)

);


create table list_jeton(

	jeton_id serial primary key,
	ref_jeton varchar(50)

);


create table jeton (

	jeton_id serial primary key,
	ref_jeton int references list_jeton(jeton_id),
	livre int references livre(livre_id),
	nom varchar(50),
	effet varchar(100),
	unique(ref_jeton, livre)

);

drop table jeton;


create table condition_speciale (

	condition_speciale_id serial primary key,
	condition_speciale varchar(50),
	jeton int references jeton(jeton_id)

);


create table resolution (

	resolution_id serial primary key,
	contenu_initial int references contenu(contenu_id),
	texte varchar(100),
	type_resolution int references type_resolution(type_resolution_id),
	condition_speciale int references condition_speciale(condition_speciale_id)

);



create table tag(

	tag_id serial primary key,
	tag_name varchar(50)

);


create table tag_list(

	livre_id int references livre(livre_id),
	tag_id int references tag(tag_id)
	

);







