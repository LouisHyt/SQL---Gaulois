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

