-- 1
SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um'

-- 2
SELECT COUNT(pr.id_personnage) AS total, li.nom_lieu
FROM personnage pr
JOIN lieu li ON li.id_lieu = pr.id_lieu
GROUP BY pr.id_lieu
ORDER BY total DESC

-- 3
SELECT pr.nom_personnage, pr.adresse_personnage, li.nom_lieu, sp.nom_specialite
FROM personnage pr
JOIN lieu li ON pr.id_lieu = li.id_lieu
JOIN specialite sp ON sp.id_specialite = pr.id_specialite
ORDER BY li.nom_lieu ASC, pr.nom_personnage

-- 4
SELECT sp.nom_specialite, COUNT(pr.id_personnage) AS total
FROM specialite sp
JOIN personnage pr ON pr.id_specialite = sp.id_specialite
GROUP BY sp.id_specialite
ORDER BY total DESC

-- 5
SELECT bt.nom_bataille, DATE_FORMAT(bt.date_bataille, "%d/%m/%y") AS bataille_date, li.nom_lieu
FROM bataille bt
JOIN lieu li ON li.id_lieu = bt.id_lieu
ORDER BY STR_TO_DATE(bataille_date, "%d/%m/%y") DESC

-- 6
SELECT pot.nom_potion, SUM(ing.cout_ingredient * com.qte) AS cout
FROM potion pot
JOIN composer com ON com.id_potion = pot.id_potion
JOIN ingredient ing ON ing.id_ingredient = com.id_ingredient
GROUP BY pot.id_potion
ORDER BY cout DESC


-- 7
SELECT ing.nom_ingredient, ing.cout_ingredient, com.qte
FROM ingredient ing
JOIN composer com ON com.id_ingredient = ing.id_ingredient
WHERE com.id_potion = (
	SELECT id_potion
	FROM potion
	WHERE nom_potion LIKE "Santé"
)

-- 8
SELECT pr.nom_personnage, pc.qte
FROM personnage pr
JOIN prendre_casque pc ON pc.id_personnage = pr.id_personnage
WHERE pc.id_bataille = (
	SELECT id_bataille
	FROM bataille
	WHERE nom_bataille LIKE "Bataille du village gaulois"
)
HAVING pc.qte >= ALL(
	SELECT pc.qte
	FROM personnage pr
	JOIN prendre_casque pc ON pc.id_personnage = pr.id_personnage
	WHERE pc.id_bataille = (
		SELECT id_bataille
		FROM bataille
		WHERE nom_bataille LIKE "Bataille du village gaulois"
	)
)

-- 9
SELECT pr.nom_personnage, SUM(bo.dose_boire) AS potions_bue
FROM personnage pr
JOIN boire bo ON bo.id_personnage = pr.id_personnage
GROUP BY pr.id_personnage
ORDER BY potions_bue DESC

-- 10
SELECT ba.nom_bataille, SUM(pc.qte) AS total
FROM bataille ba
JOIN prendre_casque pc ON pc.id_bataille = ba.id_bataille
GROUP BY ba.id_bataille
ORDER BY total DESC
LIMIT 1
-- OU
SELECT ba.nom_bataille, SUM(pc.qte) AS total
FROM bataille ba
JOIN prendre_casque pc ON pc.id_bataille = ba.id_bataille
GROUP BY ba.id_bataille
HAVING total >= ALL(
	SELECT SUM(pc.qte) AS total
	FROM bataille ba
	JOIN prendre_casque pc ON pc.id_bataille = ba.id_bataille
	GROUP BY ba.id_bataille
)
-- 
CREATE VIEW nb_casque_pris
AS
	SELECT ba.nom_bataille AS nom_bataille, SUM(pc.qte) AS total
	FROM bataille ba
	JOIN prendre_casque pc ON pc.id_bataille = ba.id_bataille
	GROUP BY ba.id_bataille

SELECT nom_bataille, total
FROM nb_casque_pris
HAVING total >= ALL(
	SELECT total
	FROM nb_casque_pris
)


-- 11
SELECT tc.nom_type_casque, COUNT(ca.id_type_casque) AS total ,SUM(ca.cout_casque) AS cout
FROM type_casque tc
JOIN casque ca ON ca.id_type_casque = tc.id_type_casque
GROUP BY tc.id_type_casque

-- 12
SELECT po.nom_potion
FROM potion po
JOIN composer co ON co.id_potion = po.id_potion
JOIN ingredient ing ON ing.id_ingredient = co.id_ingredient
WHERE ing.nom_ingredient LIKE "Poisson frais"

-- 13
CREATE VIEW lieu_population
AS
	SELECT li.nom_lieu AS nom_lieu, COUNT(per.id_personnage) AS population
	FROM lieu li
	JOIN personnage per ON per.id_lieu = li.id_lieu
	GROUP BY li.id_lieu
;

SELECT nom_lieu, population 
FROM lieu_population
WHERE nom_lieu NOT LIKE "%Village gaulois%"
ORDER BY population DESC


-- 14

