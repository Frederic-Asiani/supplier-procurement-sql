-- ANALYSE 1 | Taux de service fournisseurs en quantite
WITH reception AS (SELECT l.id,l.commande_id,l.quantite_commandee,COALESCE(SUM(v.quantite_recue),0) recue FROM lignes_commande l LEFT JOIN livraisons v ON v.ligne_id=l.id GROUP BY l.id)
SELECT f.nom fournisseur,SUM(r.quantite_commandee) qte_commandee,SUM(r.recue) qte_recue,
ROUND(100.0*SUM(r.recue)/SUM(r.quantite_commandee),2) taux_service_pct
FROM reception r JOIN commandes c ON c.id=r.commande_id JOIN fournisseurs f ON f.id=c.fournisseur_id
GROUP BY f.id ORDER BY taux_service_pct DESC;
-- ANALYSE 2 | Delai de livraison moyen et retards en jours
SELECT f.nom fournisseur,COUNT(v.id) receptions,
ROUND(AVG(JULIANDAY(v.date_livraison)-JULIANDAY(c.date_commande)),1) delai_moyen_jours,
ROUND(AVG(MAX(0,JULIANDAY(v.date_livraison)-JULIANDAY(c.date_promesse))),1) retard_moyen_jours
FROM livraisons v JOIN lignes_commande l ON l.id=v.ligne_id JOIN commandes c ON c.id=l.commande_id JOIN fournisseurs f ON f.id=c.fournisseur_id
GROUP BY f.id ORDER BY retard_moyen_jours DESC;
-- ANALYSE 3 | Valeur des lignes ouvertes non recues
WITH rec AS (SELECT l.id,COALESCE(SUM(v.quantite_recue),0) q FROM lignes_commande l LEFT JOIN livraisons v ON v.ligne_id=l.id GROUP BY l.id)
SELECT c.id commande,f.nom fournisseur,c.date_promesse,
SUM((l.quantite_commandee-r.q)*l.prix_achat_unitaire) valeur_non_recue_usd
FROM lignes_commande l JOIN commandes c ON c.id=l.commande_id JOIN fournisseurs f ON f.id=c.fournisseur_id JOIN rec r ON r.id=l.id
GROUP BY c.id HAVING valeur_non_recue_usd>0 ORDER BY valeur_non_recue_usd DESC LIMIT 20;
-- ANALYSE 4 | Concentration des achats par fournisseur
SELECT f.nom fournisseur,COUNT(DISTINCT c.id) commandes,
ROUND(SUM(l.quantite_commandee*l.prix_achat_unitaire),2) montant_commande_usd
FROM lignes_commande l JOIN commandes c ON c.id=l.commande_id JOIN fournisseurs f ON f.id=c.fournisseur_id
GROUP BY f.id ORDER BY montant_commande_usd DESC;
-- ANALYSE 5 | Receptions par categorie et mois
SELECT SUBSTR(v.date_livraison,1,7) mois,r.categorie,SUM(v.quantite_recue) unites_recues,
ROUND(SUM(v.quantite_recue*l.prix_achat_unitaire),2) montant_recu_usd
FROM livraisons v JOIN lignes_commande l ON l.id=v.ligne_id JOIN produits r ON r.id=l.reference_id
GROUP BY mois,r.categorie ORDER BY mois,r.categorie;
-- ANALYSE 6 | Taux de lignes livrees integralement
WITH rec AS (SELECT l.id,l.quantite_commandee,COALESCE(SUM(v.quantite_recue),0) q FROM lignes_commande l LEFT JOIN livraisons v ON v.ligne_id=l.id GROUP BY l.id)
SELECT COUNT(*) total_lignes,SUM(CASE WHEN q>=quantite_commandee THEN 1 ELSE 0 END) lignes_completes,
ROUND(100.0*SUM(CASE WHEN q>=quantite_commandee THEN 1 ELSE 0 END)/COUNT(*),2) lignes_completes_pct
FROM rec;
