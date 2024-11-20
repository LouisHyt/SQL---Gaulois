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