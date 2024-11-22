-- PARTIE 1

-- 1
SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um'

-- 2
SELECT COUNT(pr.id_personnage) AS total, li.nom_lieu
FROM personnage pr
INNER JOIN lieu li ON li.id_lieu = pr.id_lieu
GROUP BY pr.id_lieu
ORDER BY total DESC

-- 3
SELECT pr.nom_personnage, pr.adresse_personnage, li.nom_lieu, sp.nom_specialite
FROM personnage pr
INNER JOIN lieu li ON pr.id_lieu = li.id_lieu
INNER JOIN specialite sp ON sp.id_specialite = pr.id_specialite
ORDER BY li.nom_lieu ASC, pr.nom_personnage

-- 4
SELECT sp.nom_specialite, COUNT(pr.id_personnage) AS total
FROM specialite sp
INNER JOIN personnage pr ON pr.id_specialite = sp.id_specialite
GROUP BY sp.id_specialite
ORDER BY total DESC

-- 5
SELECT bt.nom_bataille, DATE_FORMAT(bt.date_bataille, "%d/%m/%y") AS bataille_date, li.nom_lieu
FROM bataille bt
INNER JOIN lieu li ON li.id_lieu = bt.id_lieu
ORDER BY bt.date_bataille DESC

-- 6
SELECT pot.nom_potion, SUM(ing.cout_ingredient * com.qte) AS cout
FROM potion pot
INNER JOIN composer com ON com.id_potion = pot.id_potion
INNER JOIN ingredient ing ON ing.id_ingredient = com.id_ingredient
GROUP BY pot.id_potion
ORDER BY cout DESC


-- 7
SELECT ing.nom_ingredient, ing.cout_ingredient, com.qte
FROM ingredient ing
INNER JOIN composer com ON com.id_ingredient = ing.id_ingredient
WHERE com.id_potion = (
	SELECT id_potion
	FROM potion
	WHERE nom_potion LIKE "Santé"
)

-- 8
SELECT pr.nom_personnage, pc.qte
FROM personnage pr
INNER JOIN prendre_casque pc ON pc.id_personnage = pr.id_personnage
WHERE pc.id_bataille = (
	SELECT id_bataille
	FROM bataille
	WHERE nom_bataille LIKE "Bataille du village gaulois"
)
HAVING pc.qte >= ALL(
	SELECT pc.qte
	FROM personnage pr
	INNER JOIN prendre_casque pc ON pc.id_personnage = pr.id_personnage
	WHERE pc.id_bataille = (
		SELECT id_bataille
		FROM bataille
		WHERE nom_bataille LIKE "Bataille du village gaulois"
	)
)

-- 9
SELECT pr.nom_personnage, SUM(bo.dose_boire) AS potions_bue
FROM personnage pr
INNER JOIN boire bo ON bo.id_personnage = pr.id_personnage
GROUP BY pr.id_personnage
ORDER BY potions_bue DESC

-- 10
SELECT ba.nom_bataille, SUM(pc.qte) AS total
FROM bataille ba
INNER JOIN prendre_casque pc ON pc.id_bataille = ba.id_bataille
GROUP BY ba.id_bataille
ORDER BY total DESC
LIMIT 1

-- OU (MIEUX)
SELECT ba.nom_bataille, SUM(pc.qte) AS total
FROM bataille ba
INNER JOIN prendre_casque pc ON pc.id_bataille = ba.id_bataille
GROUP BY ba.id_bataille
HAVING total >= ALL(
	SELECT SUM(pc.qte) AS total
	FROM bataille ba
	INNER JOIN prendre_casque pc ON pc.id_bataille = ba.id_bataille
	GROUP BY ba.id_bataille
)
-- 
CREATE VIEW nb_casque_pris
AS
	SELECT ba.nom_bataille AS nom_bataille, SUM(pc.qte) AS total
	FROM bataille ba
	INNER JOIN prendre_casque pc ON pc.id_bataille = ba.id_bataille
	GROUP BY ba.id_bataille
;

SELECT nom_bataille, total
FROM nb_casque_pris
HAVING total >= ALL(
	SELECT total
	FROM nb_casque_pris
)


-- 11
SELECT tc.nom_type_casque, COUNT(ca.id_type_casque) AS total ,SUM(ca.cout_casque) AS cout
FROM type_casque tc
INNER JOIN casque ca ON ca.id_type_casque = tc.id_type_casque
GROUP BY tc.id_type_casque

-- 12
SELECT po.nom_potion
FROM potion po
INNER JOIN composer co ON co.id_potion = po.id_potion
INNER JOIN ingredient ing ON ing.id_ingredient = co.id_ingredient
WHERE ing.nom_ingredient LIKE "Poisson frais"

-- 13
CREATE VIEW lieu_population
AS
	SELECT li.nom_lieu AS nom_lieu, COUNT(per.id_personnage) AS population
	FROM lieu li
	INNER JOIN personnage per ON per.id_lieu = li.id_lieu
	GROUP BY li.id_lieu
;

SELECT nom_lieu, population 
FROM lieu_population
WHERE nom_lieu NOT LIKE "%Village gaulois%"
ORDER BY population DESC

-- OU
SELECT li.nom_lieu AS nom_lieu, COUNT(per.id_personnage) AS population
FROM lieu li
INNER JOIN personnage per ON per.id_lieu = li.id_lieu
GROUP BY li.id_lieu
HAVING li.nom_lieu NOT LIKE "%Village gaulois%" AND population >= ALL (
	SELECT COUNT(per.id_personnage) AS population
	FROM lieu li
	INNER JOIN personnage per ON per.id_lieu = li.id_lieu
	GROUP BY li.nom_lieu
	HAVING li.nom_lieu NOT LIKE "%Village gaulois%"
)

-- 14
SELECT per.nom_personnage
FROM personnage per
LEFT JOIN boire bo ON per.id_personnage = bo.id_personnage
WHERE bo.id_personnage IS NULL

-- OU
SELECT nom_personnage
FROM personnage
WHERE id_personnage NOT IN (
	SELECT id_personnage
	FROM boire
)

-- 15
SELECT per.nom_personnage
FROM personnage per
LEFT JOIN autoriser_boire ab ON per.id_personnage = ab.id_personnage
WHERE ab.id_potion IS NULL OR ab.id_personnage NOT IN (
	SELECT per.id_personnage
	FROM personnage per
	INNER JOIN autoriser_boire ab ON per.id_personnage = ab.id_personnage
	INNER JOIN potion po ON ab.id_potion = po.id_potion
	WHERE po.nom_potion LIKE "%Magique%"
)


-- Partie 2

-- A
INSERT INTO personnage (nom_personnage, adresse_personnage, image_personnage, id_lieu, id_specialite)
VALUES (
	"Champdeblix",
	"Ferme Hantassion",
	"indisponible.jpg",
	(SELECT id_lieu FROM lieu WHERE nom_lieu LIKE "%Rotomagus%"),
	(SELECT id_specialite FROM specialite WHERE nom_specialite LIKE "%Agriculteur%")
)

-- B
INSERT INTO autoriser_boire
VALUES(
	(SELECT id_potion FROM potion WHERE nom_potion LIKE "%Magique%"),
	(SELECT id_personnage FROM personnage WHERE nom_personnage LIKE "%Bonemine%")
)


-- C
DELETE ca.*
FROM casque ca
LEFT JOIN type_casque tc ON ca.id_type_casque = tc.id_type_casque
LEFT JOIN prendre_casque pc ON ca.id_casque = pc.id_casque
WHERE tc.nom_type_casque LIKE "Grec" AND pc.id_bataille IS NULL

-- D
UPDATE personnage
SET 
	adresse_personnage = "Prison",
	id_lieu = (
		SELECT id_lieu
		FROM lieu
		WHERE nom_lieu LIKE "Condate"
	)
WHERE nom_personnage LIKE "Zérozérosix"

-- E
DELETE co.*
FROM composer co
INNER JOIN potion po ON co.id_potion = po.id_potion
INNER JOIN ingredient ing ON co.id_ingredient = ing.id_ingredient
WHERE po.nom_potion LIKE "Soupe" AND ing.nom_ingredient LIKE "Persil"

--OU
DELETE FROM composer
WHERE id_potion = (
	SELECT id_potion
	FROM potion
	WHERE nom_potion LIKE "Soupe"
) AND id_ingredient = (
	SELECT id_ingredient
	FROM ingredient
	WHERE nom_ingredient LIKE "Persil"
)

-- F
UPDATE prendre_casque pr
INNER JOIN casque ca ON pr.id_casque = ca.id_casque
INNER JOIN bataille ba ON pr.id_bataille = ba.id_bataille
INNER JOIN personnage per ON pr.id_personnage = per.id_personnage
SET 
	pr.id_casque = (
		SELECT id_casque
		FROM casque
		WHERE nom_casque LIKE "Weisenau" 
	),
	pr.qte = 42
WHERE 
	ca.nom_casque LIKE "Ostrogoth" 
	AND 
	ba.nom_bataille LIKE "Attaque de la banque postale" 
	AND 
	per.nom_personnage LIKE "Obélix"
	


