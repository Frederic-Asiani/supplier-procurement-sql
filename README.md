# Performance des fournisseurs et approvisionnement

Étude SQL de pilotage des commandes d’achat d’un distributeur fictif : taux de service, livraisons en retard, volumes reçus, reste à livrer, concentration fournisseurs et fiabilité des commandes.

> **Projet de démonstration exécuté** : données entièrement **synthétiques**, aucun client ou commerce réel n'a fourni de données. Aucune réalisation client ni résultat en production n'est revendiqué.

## Livrables

- `demo.sqlite` : base SQLite fonctionnelle avec intégrité référentielle
- `schema.sql` : création des tables
- `analyses.sql` : 6 analyses métier exécutées
- `data/*.csv` : export intégral des tables
- `resultats_valides.json` : extraits reproduits des requêtes

## Utilisation

```bash
python -m sqlite3 demo.sqlite '.tables'
# Ouvrir demo.sqlite dans DB Browser for SQLite, puis exécuter analyses.sql
```

## Grain et taille
- `fournisseurs` : 8 lignes
- `produits` : 80 lignes
- `commandes` : 180 lignes
- `lignes_commande` : 509 lignes
- `livraisons` : 461 lignes

## Intérêt métier

Étude SQL de pilotage des commandes d’achat d’un distributeur fictif : taux de service, livraisons en retard, volumes reçus, reste à livrer, concentration fournisseurs et fiabilité des commandes.

## Indicateurs

Taux de service, Retards fournisseurs, Achats, Commandes ouvertes, Réception

Ce cas peut servir de base à un reporting Power BI ou Tableau après import des CSV.
