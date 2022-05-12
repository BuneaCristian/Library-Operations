CREATE TABLE Persoana (
	id_pers NUMBER NOT NULL,
	nume VARCHAR (20) NOT NULL,
	telefon VARCHAR (15) NOT NULL,
	adresa VARCHAR (30) NOT NULL);

CREATE TABLE Carte (
	id_carte NUMBER NOT NULL,
	titlu VARCHAR (20) NOT NULL,
	nr_pagini NUMBER NOT NULL,
	nr_exemplare NUMBER NOT NULL,
	gen VARCHAR (10) NOT NULL);

CREATE TABLE Imprumut (
	id_carte NUMBER NOT NULL,
	id_imp NUMBER NOT NULL,
	datai DATE,
	datar DATE,
	nr_zile NUMBER NOT NULL);

CREATE_TABLE Autor (
	id_carte NUMBER NOT NULL,
	id_aut NUMBER NOT NULL);

INSERT INTO PERSOANA (id_pers, nume, telefon, adresa) VALUES ('1', 'Jules Verne', '0767985739', 'Cluj-Napoca');
INSERT INTO PERSOANA (id_pers, nume, telefon, adresa) VALUES ('2', 'Michelle Obama', '+4407526875312', 'Resita');
INSERT INTO PERSOANA (id_pers, nume, telefon, adresa) VALUES ('3', 'Stephen Hawking', '0774412365', 'Baia-Mare');
INSERT INTO PERSOANA (id_pers, nume, telefon, adresa) VALUES ('4', 'Nikola Tesla', '+440752369873', 'Zalau');
INSERT INTO PERSOANA (id_pers, nume, telefon, adresa) VALUES ('5', 'Alexandre Dumas', '0774569320', 'Constanta');
INSERT INTO PERSOANA (id_pers, nume, telefon, adresa) VALUES ('6', 'JK Rowling', '+440705012598', 'Buzau');
INSERT INTO PERSOANA (id_pers, nume, telefon, adresa) VALUES ('7', 'Karl May', '0714744523', 'Arad');
INSERT INTO PERSOANA (id_pers, nume, telefon, adresa) VALUES ('8', 'Cristian Presura', '0715832523', 'Bistrita');

INSERT INTO CARTE (id_carte, titlu, nr_pagini, nr_exemplare, gen) VALUES ('1', 'Povestea mea', '448', '80', 'Autobiografie');
INSERT INTO CARTE (id_carte, titlu, nr_pagini, nr_exemplare, gen) VALUES ('2', 'Inventiile mele', '208', '740', 'Autobiografie');
INSERT INTO CARTE (id_carte, titlu, nr_pagini, nr_exemplare, gen) VALUES ('3', 'Ocolul Pamantului in 80 de zile', '148', '57', 'Fantastic');
INSERT INTO CARTE (id_carte, titlu, nr_pagini, nr_exemplare, gen) VALUES ('4', 'Masca de fier', '96', '1100', 'Copii')
INSERT INTO CARTE (id_carte, titlu, nr_pagini, nr_exemplare, gen) VALUES ('5', 'Testamentul incasului', '412', '70', 'Copii');
INSERT INTO CARTE (id_carte, titlu, nr_pagini, nr_exemplare, gen) VALUES ('6', 'Harry Potter si Talismanele mortii', '608', '90', 'Fantastic');
INSERT INTO CARTE (id_carte, titlu, nr_pagini, nr_exemplare, gen) VALUES ('7', 'Gaurile negre: Prelegerile Reaith', '78', '30', 'Tehnic');
INSERT INTO CARTE (id_carte, titlu, nr_pagini, nr_exemplare, gen) VALUES ('8', 'Fizica povestita', '648', '45', 'Tehnic');

INSERT INTO IMPRUMUT (id_carte, id_imp, datai, datar, nr_zile) VALUES ('2', '4', '2020-10-17', '2020-11-16', '90');
INSERT INTO IMPRUMUT (id_carte, id_imp, datai, datar, nr_zile) VALUES ('5', '2', '2020-06-10', ' , '60');
INSERT INTO IMPRUMUT (id_carte, id_imp, datai, datar, nr_zile) VALUES ('3', '5', '2021-04-23', , '120');
INSERT INTO IMPRUMUT (id_carte, id_imp, datai, datar, nr_zile) VALUES ('3', '7', '2019-12-15', , '90');
INSERT INTO IMPRUMUT (id_carte, id_imp, datai, datar, nr_zile) VALUES ('7', '1', '2021-11-30', , '30');

INSERT INTO AUTOR (id_carte, id_aut) VALUES ('3', '1');
INSERT INTO AUTOR (id_carte, id_aut) VALUES ('5', '6');
INSERT INTO AUTOR (id_carte, id_aut) VALUES ('3', '2');
INSERT INTO AUTOR (id_carte, id_aut) VALUES ('1', '4');

ALTER TABLE Persoana ADD CONSTRAINT PK_PERSOANA PRIMARY KEY (id_pers);

ALTER TABLE Carte ADD CONSTRAINT PK_CARTE PRIMARY KEY (id_carte);

ALTER TABLE Imprumut ADD CONSTRAINT PK_IMPRUMUT PRIMARY KEY (id_carte, id_imp, datai);

ALTER TABLE Autor ADD CONSTRAINT PK_AUTOR PRIMARY KEY (id_carte, id_aut);

ALTER TABLE Imprumut ADD CONSTRAINT FK_Imp_Carte FOREIGN KEY (id_carte)
				REFERENCES Carte (id_carte);

ALTER TABLE Autor ADD CONSTRAINT FK_Autorul_Cartii FOREIGN KEY (id_carte)
				REFERENCES Carte (id_carte);

ALTER TABLE Imprumut ADD CONSTRAINT FK_Pers_Imp FOREIGN KEY (id_imp)
				REFERENCES Persoana (id_pers);

ALTER TABLE Autor ADD CONSTRAINT FK_Pers_Aut FOREIGN KEY (id_aut)
				REFERENCES Persoana (id_pers);

ALTER TABLE Carte ADD rezumat varchar (255);

ALTER TABLE Carte ADD CONSTRAINT CK_gen CHECK (gen = 'Autobiografie' or gen = 'Copii'
						or gen = 'Fantastic' or gen = Tehnic');

ALTER TABLE Carte ADD CONSTRAINT CK_exemplare CHECK (gen = 'Tehnic' and nr_exemplare > 10);

SELECT *
FROM Persoana
WHERE telefon LIKE '+44%'
ORDER BY adresa;

SELECT *
FROM Imprumut
WHERE datar > datai + nr_zile
ORDER BY nr_zile DESC, datai ASC;

SELECT Persoana.nume, Persoana.adresa, Persoana.telefon
FROM Persoana
FULL OUTER JOIN Imprumut ON Persoana.id_pers = Imprumut.id_imp
WHERE (datar - nr_zile) > 7;

SELECT a1.Autor, a2.Autor, c1.gen, c2.gen
FROM Autor a1, Autor a2, Carte c1, Carte c2
FULL OUTER JOIN a1.id_carte = a2.id_carte AND c1.gen = c2.gen;

SELECT *
FROM Carte
WHERE EXISTS (SELECT gen 
		FROM Carte
		WHERE titlu like '%India%');

SELECT Persoana.nume, Carte.titlu
FROM Persoana
JOIN Autor ON Autor.id_aut = Persoana.id_carte
JOIN Carte ON Carte.id_carte = Autor.id_carte
WHERE Autor.id_carte IN (SELECT a1.id_carte
			FROM Autor a1
			JOIN Autor a2 ON a1.id_carte = a2.id_carte
			WHERE a1.id_carte = a2.id_carte AND a1.id_aut != a2.id_aut);

SELECT Persoana.nume, MAX(Imprumut.datar - Imprumut.nr_zile)
FROM Persoana, Imprumut;

SELECT MIN(nr_pagini), AVG(nr_pagini), MAX(nr_pagini)
FROM Carte
WHERE gen = ANY (SELECT gen FROM Carte);

UPDATE Persoana
SET id_pers = '9', nume = 'Mircea Cartarescu', telefon = '0210134567';

UPDATE Carte
SET id_carte = '9', titlu = 'Visul', nr_pagini = '294', nr_exemplare = '100', gen = 'Fantastic';

DELETE 
FROM Carte
WHERE datai = NULL;

UPDATE
FROM Imprumut
WHERE (SYSDATE > (datai + nr_zile))

SELECT nr_zile = SYSDATE - datai
FROM Imprumut;