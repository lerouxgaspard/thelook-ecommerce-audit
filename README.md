# 📊 TheLook E-Commerce - Audit de Performance

> **Audit stratégique du catalogue Fashion (Hoodies & Sweaters) - Période 2025-2026**  
> Analyse SQL avancée avec BigQuery pour identifier les leviers de croissance et d'optimisation.

---

## 🎯 Contexte & Objectifs

### Problématique
TheLook E-Commerce souhaite optimiser sa stratégie commerciale sur les catégories **Fashion Hoodies & Sweatshirts** et **Sweaters** en analysant 14 mois de données transactionnelles.

### Périmètre de l'Audit
- 📅 **Période** : 01 janvier 2025 → 27 février 2026 (14 mois)
- 🛍️ **Catégories** : Fashion Hoodies & Sweatshirts + Sweaters (Men & Women)
- 💰 **Volume** : 677 873€ de CA | 10 011 commandes | 9 704 clients

### Objectifs
1. 📈 **Mesurer la performance commerciale** (CA, marges, rentabilité)
2. 🎯 **Analyser l'acquisition client** (sources de trafic, taux de conversion)
3. ⚡ **Évaluer l'efficacité opérationnelle** (livraisons, retours)
4. 💎 **Comprendre la fidélisation** (CLV, rétention, segmentation)

---

## 🛠️ Méthodologie & Stack Technique

### Outils Utilisés
- **BigQuery** : Requêtage SQL sur dataset public Google (`thelook_ecommerce`)
- **SQL Avancé** : CTEs complexes, Window Functions, agrégations multi-niveaux
- **Antigravity** : Génération de visualisations et synthèse analytique
- **GitHub** : Versioning et documentation du projet

### Compétences SQL Démontrées
✅ **CTEs (Common Table Expressions)** : Structuration modulaire avec 6-7 CTEs par requête  
✅ **Window Functions** : `ROW_NUMBER()`, `LAG()`, parts de marché avec `OVER()`  
✅ **JOINs complexes** : INNER JOIN, LEFT JOIN, CROSS JOIN pour paramètres de dates  
✅ **Agrégations avancées** : GROUP BY, HAVING, SAFE_DIVIDE (gestion divisions par zéro)  
✅ **Transformations** : FORMAT_DATE, DATE_DIFF, CASE WHEN, CONCAT  

---

## 📂 Structure du Projet

```
📁 thelook-audit/
│
├── 📄 README.md                          # Ce fichier
├── 📄 thelook_audit_complet.sql          # 9 requêtes SQL structurées
│
├── 📁 data/
│   ├── 01_kpi_globaux.csv
│   ├── 02_performance_categorie.csv
│   ├── 03_top_produits.csv
│   ├── 04_evolution_mensuelle.csv
│   ├── 05_trafic_sources.csv
│   ├── 06_delais_livraison.csv
│   ├── 07_analyse_retours.csv
│   ├── 08_segmentation_clients.csv
│   └── 09_clv_retention.csv
│
├── 📁 visuals/
│   ├── dashboard.html                    # Dashboard interactif
│   └── dashboard.png                     # Screenshot dashboard
│
└── 📁 presentation/
    └── slides.pdf                        # Présentation exécutive
```

---

## 📊 Résultats Clés par Axe

### 🎯 AXE 1 : Performance Commerciale

#### KPIs Globaux
| Métrique | Valeur | Évaluation |
|----------|--------|------------|
| **CA Total** | 677 873€ | ✅ Solide sur 14 mois |
| **Nb Commandes** | 10 011 | ✅ Bonne activité |
| **Nb Clients** | 9 704 | ⚠️ Faible récurrence (1.03 commandes/client) |
| **Taux de marge** | **50.09%** | 🏆 Excellente rentabilité |
| **Panier moyen** | 67.71€ | ✅ Cohérent pour textile premium |
| **Taux de retour** | 9.89% | ⚠️ Légèrement au-dessus du benchmark (8%) |

#### Répartition par Segment
| Segment | CA | Part CA | Marge |
|---------|-----|---------|-------|
| **Sweaters Men** | 245 851€ | 36.3% | 49.9% |
| **Hoodies Men** | 183 296€ | 27.0% | 45.0% |
| **Sweaters Women** | 133 012€ | 19.6% | **55.1%** ⭐ |
| **Hoodies Women** | 115 714€ | 17.1% | 53.0% |

💡 **Insight** : Segment Men = 63% du CA, mais produits Women ont +5 points de marge.

#### Évolution Temporelle (🔥 Point clé)
| Période | CA | Croissance |
|---------|-----|------------|
| Déc 2025 | 55 617€ | +9.15% |
| Jan 2026 | 69 594€ | **+25.13%** 🔥 |
| Fév 2026 | 112 349€ | **+61.44%** 🚀 |

💡 **Insight majeur** : Explosion du CA en février 2026 → Identifier les facteurs (promo, nouveaux produits, saisonnalité).

---

### 🎯 AXE 2 : Acquisition & Conversion

#### Performance par Canal
| Source | Sessions | Taux Conversion | CA | Panier Moyen |
|--------|----------|-----------------|-----|--------------|
| Email | 74 840 | 9.67% | 7.2M€ | **997€** 🏆 |
| Adwords | 49 601 | 11.44% | 4.8M€ | 845€ |
| YouTube | 16 706 | **15.1%** ⭐ | 1.7M€ | 688€ |
| Facebook | 16 497 | **15.06%** | 1.6M€ | 657€ |
| Organic | 8 394 | **15.3%** | 802K€ | 625€ |

💡 **Insights** :
- ⚠️ **Paradoxe Email** : Plus gros CA mais conversion faible → Clients VIP/Récurrents
- 🚀 **YouTube/Facebook** : Meilleurs taux de conversion (15%) → Canaux à prioriser
- 📈 **Organic sous-exploité** : 15.3% conversion mais seulement 8K sessions → Potentiel SEO énorme

---

### 🎯 AXE 3 : Efficacité Opérationnelle

#### Délais de Livraison : ✅ **EXCELLENT**
- Délai total moyen : **3.04 jours** 🏆
- Livraisons lentes (>7j) : **0.8%** (négligeable)

💡 **Point fort** : Logistique performante, pas de problème opérationnel.

#### Analyse des Retours : ⚠️ **VIGILANCE REQUISE**
| Catégorie | Département | Taux Retour | CA Perdu |
|-----------|-------------|-------------|----------|
| **Sweaters Women** | Women | **10.66%** 🔴 | 14 688€ |
| **Hoodies Women** | Women | 10.21% | 11 662€ |
| Hoodies Men | Men | 9.75% | 17 045€ |
| Sweaters Men | Men | 9.66% | 23 666€ |

💡 **Insights** :
- Taux global 9.89% > benchmark textile (~8%)
- Women retourne +1 point de plus que Men → Problème taille/fit
- **67K€ de CA perdu** en retours (coût logistique + produit)

---

### 🎯 AXE 4 : Rétention & Fidélité 🚨 **ALERTE ROUGE**

#### Segmentation Clients (Catastrophique)
| Segment | Nb Clients | % Clients | % CA |
|---------|------------|-----------|------|
| **Ponctuel (1 achat)** | 9 180 | **94.6%** 🔴 | 89.6% |
| Occasionnel (2) | 498 | 5.1% | 9.7% |
| Régulier (3-4) | 26 | 0.3% | 0.7% |
| **Fidèle (5+)** | **0** | **0%** 😱 | 0% |

#### CLV & Rétention
| Métrique | Valeur | Benchmark | Écart |
|----------|--------|-----------|-------|
| **Taux de rétention** | **5.4%** 🔴 | 20-40% | **-7x** |
| CLV moyenne | 70.8€ | - | Très faible |
| Nb achats/client | **1.06** | 2-3 | **-50%** |

💡 **Insights CRITIQUES** :
- 😱 **94.6% de clients ponctuels** = Aucune récurrence = Business non-viable
- 🚨 **ZÉRO client fidèle** = Absence totale de programme de fidélisation
- ⚠️ **Taux de rétention 5.4%** (7x sous le benchmark) = Hémorragie de clients

---

## 📊 Analyse Détaillée

### A. Points Forts (🚀)

- 🚀 **Acquisition Organique & Sociale Performante** : YouTube, Facebook et l'Organic affichent d'excellents taux de conversion (>15%), largement supérieurs à l'emailing (9.67%).
- 🚀 **Croissance Explosive** : Le CA a bondi de +61.44% en février 2026 (112 349€), démontrant la capacité du site à générer des pics de vente majeurs.
- 🚀 **Efficacité Logistique** : Le délai de livraison moyen est très bon avec 3.04 jours, et seulement 0.8% de livraisons problématiques (>7j).
- 🚀 **Solide Taux de Marge Cible Women** : Les catégories Sweaters et Fashion Hoodies pour femmes dégagent d'excellents taux de marge (respectivement 55.1% et 53.0%), supérieurs à ceux des hommes.

### B. Problèmes Critiques (🚨)

- 🚨 **Rétention Catastrophique (Alerte Rouge)** : Seulement 5.4% de taux de rétention. Sur 9 704 clients, 94.6% n'ont effectué qu'un seul achat, et il n'y a **aucun client fidèle** (5 achats ou +). Le business s'épuise en acquisition "one-shot".
- 🚨 **Taux de Retour Préoccupant** : Le taux de retour frôle les 10% (9.89%), poussé notamment par la catégorie Sweaters Women (10.66%), engendrant 14 688€ de perte de CA directe.
- 🚨 **Dépendance et Faible LTV** : Une CLV (Customer Lifetime Value) très faible à 70.8€, reflétant l'absence de ré-achat (1.06 achat/client en moyenne).

### C. Recommandations Actionnables (🎯)

- 🎯 **Lancer un programme de fidélité et de ré-engagement automatisé**
  - **Action** : Créer des triggers e-mails (ex: offrir 15% sur un 2e achat dans les 30 jours, offres anniversaires).
  - **KPI cible** : Passer de 5.4% à au moins 15% de taux de rétention en 6 mois.
  - **Impact estimé** : +67K€ de CA récurrent grâce à l'augmentation du CLV.

- 🎯 **Audit des "Sweaters Women" pour réduire les retours**
  - **Action** : Analyser les motifs de retour (coupe, matière) et intégrer un "guide des tailles" détaillé sur les fiches produits.
  - **KPI cible** : Réduire le taux de retour sous la barre des 7.5%.
  - **Impact estimé** : Sauvegarde d'environ 6K€ à 10K€ de marge nette perdue en logistique retour.

- 🎯 **Réallocation du budget média Analytics-Driven**
  - **Action** : Déplacer des budgets Adwords (11.4% conv) vers les sources hautes performances comme YouTube / Facebook / SEO (qui convertissent à +15%).
  - **KPI cible** : Améliorer le taux de conversion global de +1.5 points.
  - **Impact estimé** : Hausse du CA de 15% à budget d'acquisition constant.

- 🎯 **Upsell au sein du Checkout**
  - **Action** : Mettre en place des recommandations intelligentes (associer un Hoodie à l'achat d'un Sweater).
  - **KPI cible** : Faire passer le panier moyen de 67.71€ à 75.00€.
  - **Impact estimé** : +10% de CA global immédiat lors de la première commande.

---

## 📈 Dashboard Interactif

Le dashboard HTML interactif visualise les 4 axes d'analyse avec :
- KPIs cards (CA, Marge, Panier Moyen, Taux Retour)
- Évolution mensuelle (graph ligne)
- Performance par segment (barres)
- Trafic par source (funnel)
- Alerte rétention (pie chart + jauge)

👉 *[Ouvrir le Dashboard](https://lerouxgaspard.github.io/thelook-ecommerce-audit/The_Look_audit/Dashboard.html)*

![Dashboard Overview](https://lerouxgaspard.github.io/thelook-ecommerce-audit/The_Look_audit/Dashboard_the_look.png)

---

## 👤 Auteur

**Gaspard Leroux**  
Data Analyst | Eugenia School  
📧 gleroux@eugeniaschool.com  
📅 Février 2026

---

## 📚 Ressources

- **Dataset** : [BigQuery Public Data - TheLook E-Commerce](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce)
- **Documentation** : [Google Cloud BigQuery](https://cloud.google.com/bigquery/docs)

---

*Dernière mise à jour : 27 février 2026*
