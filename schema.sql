PRAGMA foreign_keys=ON;
CREATE TABLE fournisseurs(id INTEGER PRIMARY KEY,nom TEXT NOT NULL,pays TEXT NOT NULL);
CREATE TABLE produits(id INTEGER PRIMARY KEY,nom TEXT NOT NULL,categorie TEXT NOT NULL,cout_unitaire_usd REAL NOT NULL CHECK(cout_unitaire_usd>0),stock_minimum INTEGER NOT NULL CHECK(stock_minimum>=0));
CREATE TABLE commandes(id INTEGER PRIMARY KEY,fournisseur_id INTEGER NOT NULL REFERENCES fournisseurs(id),date_commande TEXT NOT NULL,date_promesse TEXT NOT NULL,statut TEXT NOT NULL CHECK(statut IN ('livree','partielle','en_attente')));
CREATE TABLE lignes_commande(id INTEGER PRIMARY KEY,commande_id INTEGER NOT NULL REFERENCES commandes(id),reference_id INTEGER NOT NULL REFERENCES produits(id),quantite_commandee INTEGER NOT NULL CHECK(quantite_commandee>0),prix_achat_unitaire REAL NOT NULL CHECK(prix_achat_unitaire>0));
CREATE TABLE livraisons(id INTEGER PRIMARY KEY,ligne_id INTEGER NOT NULL REFERENCES lignes_commande(id),date_livraison TEXT NOT NULL,quantite_recue INTEGER NOT NULL CHECK(quantite_recue>0));
CREATE INDEX idx_cmd_fournisseur ON commandes(fournisseur_id,date_commande);
