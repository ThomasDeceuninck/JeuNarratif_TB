insert into auteur (auteur_id, nom, prenom, pseudo, mdp, mail) values (0, 'dece', 'toto', 'toto', 'toto1234', 'toto@test.be');
insert into livre (livre_id, titre, auteur) values (0, 'premier', 0);
insert into livre (livre_id, titre, auteur) values (1, 'deuxieme', 0);
insert into bibliotheque (bibliotheque_id, livre, auteur) values (0, 0, 0);

insert into contenu (contenu_id, livre, texte, start) values (2, 0, 'ceci est le 3eme contenu du premier livre', false);

insert into contenu (contenu_id, livre, texte, start) values (3, 1, 'seul contenu livre 2', true);
insert into resolution (resolution_id, contenu_initial, texte, type_resolution, condition_speciale, contenu_final) values (3, 3, null, null, null, null);



insert into tag (tag_id, tag_name) values (0, 'arcade');
insert into tag (tag_name) values ('fun');
insert into tag_list (livre_id, tag_id) values (0, 0);
insert into tag_list (livre_id, tag_id) values (0, 1);
insert into tag_list (livre_id, tag_id) values (1, 0);