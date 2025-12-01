# Questionnaire de Sécurité XANADU

##  Vue d'ensemble

- **Total questions** : 35
- **Domaines couverts** : 10
- **Critiques (P0)** : 11 actions immédiates
- **Urgentes (P1)** : 12 actions 
- **Importantes (P2)** : 9 actions 
- **Moyen terme (P3)** : 3 actions 

---

##  Légende des Priorités

| Priorité | Description |
|----------|-------------|
| **P0** | IMMÉDIATE - Vulnérabilité critique |
| **P1** | URGENTE - Risque élevé |
| **P2** | IMPORTANTE - Amélioration sécurité |
| **P3** | MOYEN TERME - Préparation résilience |

##  Légende des Criticités

| Symbole | Criticité | Signification |
|---------|-----------|---------------|
|  | Critique | Risque maximum - Action urgente |
|  | Élevée | Risque important - À traiter rapidement |
|  | Moyenne | Risque modéré - À améliorer |
|  | Faible | Risque limité - À considérer |

---

##  Questions Détaillées


###  GOUVERNANCE ET POLITIQUE

#### GOV-01 - Une politique de sécurité formelle est-elle définie et approuvée par la direction ?  

**Criticité** : Critique  
**Priorité** : P1  
**État XANADU** :  Non - Aucune politique documentée

**Axes de Remédiation** :
1. Rédiger une politique de sécurité de 2-4 pages définissant les principes et rôles
2. Faire approuver par la direction et communiquer à 100% des collaborateurs

**Bonne Pratique** : Mise à jour annuelle, signature direction visible, formation obligatoire pour tous

---

#### GOV-02 - Un RSSI est-il désigné avec rôles et responsabilités clairs ?  

**Criticité** : Élevée  
**Priorité** : P1  
**État XANADU** :  Partiel - Responsables IT/Departement mais pas de RSSI

**Axes de Remédiation** :
1. Désigner un RSSI 
2. Créer un organigramme de sécurité avec rôles documentés

**Bonne Pratique** : RSSI rapporte à la direction générale, formations annuelles pour correspondants IT

---

#### GOV-03 - Un comité de pilotage sécurité se réunit-il régulièrement ?  

**Criticité** : Moyenne  
**Priorité** : P2  
**État XANADU** :  Non - Pas de comité formalisé

**Axes de Remédiation** :
1. Créer un Comité de sécurité (direction, DSI, RSSI, métier)
2. Planifier réunions trimestrielles avec ordre du jour structuré

**Bonne Pratique** : Tableau de bord KPI, suivi des actions, compte-rendu partagé à tous

---


###  GESTION DES IDENTITÉS ET ACCÈS

#### IAM-01 - Au moins 2 contrôleurs de domaine Active Directory sont-ils déployés ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - 1 seul DC (SPOF critique)

**Axes de Remédiation** :
1. Déployer un 2ème DC pour faire de la redondance
2. Configurer réplication AD sécurisée + sauvegarde quotidienne

**Bonne Pratique** : Minimum 2 DCs en production, tests mensuels de restauration AD

---

#### IAM-02 - Les utilisateurs ont-ils des droits limités (pas administrateur local) ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - TOUS les utilisateurs sont admin local

**Axes de Remédiation** :
1. Retirer les droits admins locaus de tous les postes
2. Déployer LAPS pour gérer les mots de passe admin locaux

**Bonne Pratique** : Utilisateurs standards sans droits admin, UAC obligatoire

---

#### IAM-03 - Tous les comptes sont-ils nominatifs (pas de comptes génériques) ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - Comptes génériques ERP (RH:RH)

**Axes de Remédiation** :
1. Supprimer les comptes générques pour des comptes nominatifs
2. Créer des comptes nominatifs et intégrer avec Active Directory

**Bonne Pratique** : Chaque action tracée par utilisateur, audit des accès admin mensuel

---

#### IAM-04 - Une politique de mots de passe robustes est-elle appliquée (12+ caractères) ?  

**Criticité** : Élevée  
**Priorité** : P1  
**État XANADU** :  Non - Paramètres par défaut

**Axes de Remédiation** :
1. Déployer GPO : 12 caractères min, complexité, verrouillage après 5 tentatives
2. Implémenter MFA pour accès sensibles (VPN, admin, ERP)

**Bonne Pratique** : Gestionnaire de mots de passe recommandé, expiration 90 jours

---

#### IAM-05 - Les accès distants (VPN) sont-ils sécurisés avec MFA ?  

**Criticité** : Critique  
**Priorité** : P1  
**État XANADU** :  Non - Pas de VPN actuellement

**Axes de Remédiation** :
1. Déployer un VPN pour le travail à distance
2. Activer MFA obligatoire (Authenticator, SMS ou clé physique)

**Bonne Pratique** : TLS 1.3, split tunneling désactivé, session timeout 30 min

---


###  PROTECTION DES DONNÉES

#### DATA-01 - Les données sont-elles classifiées (Critiques/Importantes/Moins critiques) ?  

**Criticité** : Élevée  
**Priorité** : P2  
**État XANADU** :  Oui - Classification existante (ERP/RH/Personnel)

**Axes de Remédiation** :
1. Valider et documenter la classification actuelle
2. Étendre à TOUTES les données (Cloud, temporaires, caches)

**Bonne Pratique** : Révision annuelle, métadonnées de classification dans les fichiers

---

#### DATA-02 - La stratégie 3-2-1 est-elle appliquée (3 copies, 2 supports, 1 hors-site) ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - NAS + 2 disques (pas hors-site)

**Axes de Remédiation** :
1. Implémenter une backup offline ou dans le Cloud
2. Déconnecter disques externes du réseau après chaque copie

**Bonne Pratique** : Chiffrement AES-256, sauvegardes immuables 30-60 jours

---

#### DATA-03 - Les sauvegardes sont-elles testées régulièrement (restauration) ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - Aucun test documenté

**Axes de Remédiation** :
1. Créer plan de test trimestriel avec restauration complète et partielle
2. Mesurer et documenter RTO/RPO réels

**Bonne Pratique** : Test mensuel pour données critiques, taux de succès 100% requis

---

#### DATA-04 - Les sauvegardes sont-elles protégées contre ransomware (immuables) ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - Accessibles du réseau

**Axes de Remédiation** :
1. Déployer sauvegardes immuables (WORM) en cloud
2. Stocker les disques externes hors des locaux

**Bonne Pratique** : Isolation réseau stricte, air gap, alertes sur modifications

---

#### DATA-05 - Les partages sont-ils configurés par service (pas ouverts à tous) ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - NAS 'ouvert à tous'

**Axes de Remédiation** :
1. Supprimer partages génériques, créer partages par service
2. Implémenter matrice de droits NTFS selon organigramme

**Bonne Pratique** : Groupes AD par service, quotas disque, audit mensuel des accès

---

#### DATA-06 - Le chiffrement est-il activé (données au repos et en transit) ?  

**Criticité** : Élevée  
**Priorité** : P1  
**État XANADU** :  Partiel - Pas de HTTPS sur ERP

**Axes de Remédiation** :
1. Déployer HTTPS/TLS 1.2+ sur ERP immédiatement
2. Activer BitLocker sur tous les portables via GPO

**Bonne Pratique** : AES-256 minimum, certificats valides, rotation annuelle des clés

---


###  SÉCURITÉ RÉSEAU

#### NET-01 - Le réseau est-il segmenté en VLANs par service ?  

**Criticité** : Élevée  
**Priorité** : P0  
**État XANADU** :  Non - Réseau plat

**Axes de Remédiation** :
1. Créer VLANs par service (Compta, RH, Commercial, Labo, Management)
2. Déployer pare-feu inter-VLAN avec politique DENY par défaut

**Bonne Pratique** : VLAN de management isolé, isolation serveurs critiques

---

#### NET-02 - Un pare-feu d'entreprise est-il déployé avec IDS/IPS ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - Routeur/box basique

**Axes de Remédiation** :
1. Déployer pare-feu d'entreprise (Fortinet, Palo Alto, Cisco)
2. Configurer règles DENY par défaut, logging centralisé

**Bonne Pratique** : IDS/IPS activé, audit trimestriel des règles, redondance HA

---

#### NET-03 - Le lien MPLS vers site distant est-il redondé ?  

**Criticité** : Moyenne  
**Priorité** : P2  
**État XANADU** :  Partiel - MPLS SLA 99,9% mais pas de backup

**Axes de Remédiation** :
1. Prévoir lien de secours (4G/5G) avec basculement automatique
2. Tester basculement mensuel, monitorer latence/jitter

**Bonne Pratique** : RTO < 1 minute, RODC sur site distant pour continuité

---

#### NET-04 - Les logs réseau sont-ils centralisés (SIEM) ?  

**Criticité** : Élevée  
**Priorité** : P2  
**État XANADU** :  Non - Logs locaux

**Axes de Remédiation** :
1. Déployer SIEM/collecteur logs (Graylog, ELK, Splunk)
2. Centraliser logs pare-feu, AD, serveurs, NAS

**Bonne Pratique** : Rétention 1 an minimum, alertes temps réel, dashboards

---


###  SÉCURITÉ DES APPLICATIONS

#### APP-01 - L'ERP est-il accessible uniquement en HTTPS ?  

**Criticité** : Critique  
**Priorité** : P1  
**État XANADU** :  Non - HTTP (données en clair)

**Axes de Remédiation** :
1. Déployer certificat SSL/TLS 1.2+ sur ERP
2. Forcer redirection HTTP → HTTPS, désactiver protocoles obsolètes

**Bonne Pratique** : Certificat valide renouvelé automatiquement, HSTS activé

---

#### APP-02 - L'authentification ERP est-elle centralisée avec AD ?  

**Criticité** : Critique  
**Priorité** : P1  
**État XANADU** :  Non - Base locale, comptes génériques

**Axes de Remédiation** :
1. Intégrer authentification ERP avec Active Directory (LDAP)
2. Supprimer tous les comptes génériques, activer MFA

**Bonne Pratique** : SSO pour transparence, session timeout 30 min inactivité

---

#### APP-03 - La base PostgreSQL est-elle durcie et sécurisée ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - Config par défaut probable

**Axes de Remédiation** :
1. Configurer pg_hba.conf : restreindre IPs, forcer SSL
2. Créer comptes nominatifs avec droits minimum (RBAC)

**Bonne Pratique** : Audit PostgreSQL activé, backups chiffrés, WAF en frontal

---

#### APP-04 - Office 365 est-il sécurisé (MFA, DLP) ?  

**Criticité** : Élevée  
**Priorité** : P1  
**État XANADU** :  Partiel - Utilisé mais config inconnue

**Axes de Remédiation** :
1. Activer MFA pour TOUS les comptes O365
2. Configurer DLP pour bloquer fuite données sensibles

**Bonne Pratique** : Azure AD Connect pour SSO, accès conditionnel par géolocalisation

---


###  PROTECTION ANTIVIRUS

#### AV-01 - Tous les équipements ont-ils un antivirus/EDR centralisé ?  

**Criticité** : Critique  
**Priorité** : P1  
**État XANADU** :  Non - Couverture hétérogène

**Axes de Remédiation** :
1. Déployer EDR centralisé sur 100% des équipements (serveurs + postes)
2. Remplacer antivirus gratuits par solution d'entreprise unique

**Bonne Pratique** : Console centralisée, agents non-désinstallables, scan temps réel

---

#### AV-02 - Les signatures antivirus sont-elles à jour automatiquement ?  

**Criticité** : Élevée  
**Priorité** : P1  
**État XANADU** :  Non - Laissé à discrétion utilisateurs

**Axes de Remédiation** :
1. Forcer mises à jour automatiques quotidiennes
2. Configurer alertes si signature > 7 jours sans update

**Bonne Pratique** : Déploiement via GPO/MDM, tests EICAR réguliers

---


###  GESTION VULNÉRABILITÉS

#### VULN-01 - Les mises à jour sont-elles appliquées selon un planning ?  

**Criticité** : Critique  
**Priorité** : P1  
**État XANADU** :  Non - Non contrôlées

**Axes de Remédiation** :
1. Déployer WSUS pour gestion centralisée des mises à jour
2. Établir calendrier mensuel : patches critiques < 7j, importants < 30j

**Bonne Pratique** : Fenêtres de maintenance, groupes Dev/Test puis Prod, rollback documenté

---

#### VULN-02 - Des scans de vulnérabilités sont-ils réalisés régulièrement ?  

**Criticité** : Moyenne  
**Priorité** : P2  
**État XANADU** :  Non - Pas de scans

**Axes de Remédiation** :
1. Déployer scanner réseau (Nessus, OpenVAS) pour scans trimestriels
2. Implémenter process de remédiation : scoring CVSS, priorisation, tracking

**Bonne Pratique** : Pen tests annuels par cabinet externe, rapports avec recommandations

---

#### VULN-03 - Un inventaire logiciels/versions est-il maintenu ?  

**Criticité** : Moyenne  
**Priorité** : P2  
**État XANADU** :  Non - Pas d'inventaire centralisé

**Axes de Remédiation** :
1. Déployer outil d'inventaire automatique (GLPI, OCS Inventory)
2. Tracker versions EOL, alerter 12 mois avant support end

**Bonne Pratique** : CMDB unique, auto-découverte, planification upgrades

---


###  POSTES DE TRAVAIL

#### END-01 - Les utilisateurs ont-ils des comptes standards (pas admin local) ?  

**Criticité** : Critique  
**Priorité** : P0  
**État XANADU** :  Non - Tous admin locaux

**Axes de Remédiation** :
1. Retirer droits admin de TOUS les utilisateurs immédiatement
2. Utiliser LAPS pour gérer mots de passe admin (rotation 30j)

**Bonne Pratique** : UAC obligatoire, audit mensuel escalades privilèges

---

#### END-02 - Les portables sont-ils chiffrés (BitLocker/FileVault) ?  

**Criticité** : Élevée  
**Priorité** : P1  
**État XANADU** :  Non - Pas de chiffrement

**Axes de Remédiation** :
1. Déployer BitLocker Windows via GPO sur tous les portables
2. Stocker clés de récupération dans Azure Key Vault

**Bonne Pratique** : TPM activé, wipe à distance (MDM), audit trimestriel compliance

---

#### END-03 - Tous les postes sont-ils joints au domaine AD ?  

**Criticité** : Élevée  
**Priorité** : P2  
**État XANADU** :  Probablement - À vérifier

**Axes de Remédiation** :
1. Vérifier 100% des postes joints à AD
2. Déployer GPO standards (pare-feu, antivirus, updates)

**Bonne Pratique** : Images standards par type, déploiement OSD automatisé

---


###  SENSIBILISATION

#### AWARE-01 - Un programme de formation sécurité est-il déployé ?  

**Criticité** : Moyenne  
**Priorité** : P2  
**État XANADU** :  Non - Absent

**Axes de Remédiation** :
1. Créer programme de sensibilisation annuel obligatoire (1-2h)
2. Lancer campagnes phishing mensuelles avec rapports

**Bonne Pratique** : E-learning + sessions groupe, certificats signés, newsletter trimestrielle

---

#### AWARE-02 - Une politique d'usage acceptable (AUP) est-elle formalisée ?  

**Criticité** : Moyenne  
**Priorité** : P2  
**État XANADU** :  Non - Pas documentée

**Axes de Remédiation** :
1. Rédiger AUP couvrant internet, email, données, télétravail
2. Signature obligatoire lors onboarding, mise à jour annuelle

**Bonne Pratique** : Document simple et lisible, conséquences documentées, DLP pour enforcement

---


###  GESTION DES INCIDENTS

#### INC-01 - Un plan de continuité (PCA) est-il défini et testé ?  

**Criticité** : Élevée  
**Priorité** : P3  
**État XANADU** :  Non - Pas de PCA

**Axes de Remédiation** :
1. Rédiger PCA avec RTO/RPO par service
2. Tests annuels minimum (tabletop exercises)

**Bonne Pratique** : RTO < 4h critiques, équipe de crise nommée, documentation hors-site

---

#### INC-02 - Une procédure de réponse aux incidents est-elle documentée ?  

**Criticité** : Élevée  
**Priorité** : P3  
**État XANADU** :  Non - Pas de procédure

**Axes de Remédiation** :
1. Créer playbooks incidents (ransomware, breach, DDoS)
2. Définir rôles : détection, containment, eradication, recovery

**Bonne Pratique** : Communication plan interne/externe, débriefing post-incident

---

#### INC-03 - Les incidents sont-ils tracés et analysés ?  

**Criticité** : Moyenne  
**Priorité** : P3  
**État XANADU** :  Non - Pas de registre

**Axes de Remédiation** :
1. Créer registre des incidents (date, impact, cause, action)
2. Rapporter incidents critiques à CODIR, statistiques trimestrielles

**Bonne Pratique** : Dashboard incidents, tendances analysées, corrective actions implémentées

---



## 📊 Tableau Synthétique Complet

| ID | Domaine | Question Complète | Criticité | Priorité | État |
|:---:|---------|------------------|-----------|----------|------|
| GOV-01 | Gouvernance et Politique | Une politique de sécurité formelle est-elle définie et approuvée par la direction ? |  Critique |  P1 |  Non - Aucune politique documentée |
| GOV-02 | Gouvernance et Politique | Un RSSI est-il désigné avec rôles et responsabilités clairs ? |  Élevée |  P1 |  Partiel - Responsables IT/Departement mais... |
| GOV-03 | Gouvernance et Politique | Un comité de pilotage sécurité se réunit-il régulièrement ? |  Moyenne |  P2 |  Non - Pas de comité formalisé |
| IAM-01 | Gestion des Identités et Accès | Au moins 2 contrôleurs de domaine Active Directory sont-ils déployés ? |  Critique |  P0 |  Non - 1 seul DC (SPOF critique) |
| IAM-02 | Gestion des Identités et Accès | Les utilisateurs ont-ils des droits limités (pas administrateur local) ? |  Critique |  P0 |  Non - TOUS les utilisateurs sont admin loca... |
| IAM-03 | Gestion des Identités et Accès | Tous les comptes sont-ils nominatifs (pas de comptes génériques) ? |  Critique |  P0 |  Non - Comptes génériques ERP (RH:RH) |
| IAM-04 | Gestion des Identités et Accès | Une politique de mots de passe robustes est-elle appliquée (12+ caractères) ? |  Élevée |  P1 |  Non - Paramètres par défaut |
| IAM-05 | Gestion des Identités et Accès | Les accès distants (VPN) sont-ils sécurisés avec MFA ? |  Critique |  P1 |  Non - Pas de VPN actuellement |
| DATA-01 | Protection des Données | Les données sont-elles classifiées (Critiques/Importantes/Moins critiques) ? |  Élevée |  P2 |  Oui - Classification existante (ERP/RH/Pers... |
| DATA-02 | Protection des Données | La stratégie 3-2-1 est-elle appliquée (3 copies, 2 supports, 1 hors-site) ? |  Critique |  P0 |  Non - NAS + 2 disques (pas hors-site) |
| DATA-03 | Protection des Données | Les sauvegardes sont-elles testées régulièrement (restauration) ? |  Critique |  P0 |  Non - Aucun test documenté |
| DATA-04 | Protection des Données | Les sauvegardes sont-elles protégées contre ransomware (immuables) ? |  Critique |  P0 |  Non - Accessibles du réseau |
| DATA-05 | Protection des Données | Les partages sont-ils configurés par service (pas ouverts à tous) ? |  Critique |  P0 |  Non - NAS 'ouvert à tous' |
| DATA-06 | Protection des Données | Le chiffrement est-il activé (données au repos et en transit) ? |  Élevée |  P1 |  Partiel - Pas de HTTPS sur ERP |
| NET-01 | Sécurité Réseau | Le réseau est-il segmenté en VLANs par service ? |  Élevée |  P0 |  Non - Réseau plat |
| NET-02 | Sécurité Réseau | Un pare-feu d'entreprise est-il déployé avec IDS/IPS ? |  Critique |  P0 |  Non - Routeur/box basique |
| NET-03 | Sécurité Réseau | Le lien MPLS vers site distant est-il redondé ? |  Moyenne |  P2 |  Partiel - MPLS SLA 99,9% mais pas de backu... |
| NET-04 | Sécurité Réseau | Les logs réseau sont-ils centralisés (SIEM) ? |  Élevée |  P2 |  Non - Logs locaux |
| APP-01 | Sécurité des Applications | L'ERP est-il accessible uniquement en HTTPS ? |  Critique |  P1 |  Non - HTTP (données en clair) |
| APP-02 | Sécurité des Applications | L'authentification ERP est-elle centralisée avec AD ? |  Critique |  P1 |  Non - Base locale, comptes génériques |
| APP-03 | Sécurité des Applications | La base PostgreSQL est-elle durcie et sécurisée ? |  Critique |  P0 |  Non - Config par défaut probable |
| APP-04 | Sécurité des Applications | Office 365 est-il sécurisé (MFA, DLP) ? |  Élevée |  P1 |  Partiel - Utilisé mais config inconnue |
| AV-01 | Protection Antivirus | Tous les équipements ont-ils un antivirus/EDR centralisé ? |  Critique |  P1 |  Non - Couverture hétérogène |
| AV-02 | Protection Antivirus | Les signatures antivirus sont-elles à jour automatiquement ? |  Élevée |  P1 |  Non - Laissé à discrétion utilisateurs |
| VULN-01 | Gestion Vulnérabilités | Les mises à jour sont-elles appliquées selon un planning ? |  Critique |  P1 |  Non - Non contrôlées |
| VULN-02 | Gestion Vulnérabilités | Des scans de vulnérabilités sont-ils réalisés régulièrement ? |  Moyenne |  P2 |  Non - Pas de scans |
| VULN-03 | Gestion Vulnérabilités | Un inventaire logiciels/versions est-il maintenu ? |  Moyenne |  P2 |  Non - Pas d'inventaire centralisé |
| END-01 | Postes de Travail | Les utilisateurs ont-ils des comptes standards (pas admin local) ? |  Critique |  P0 |  Non - Tous admin locaux |
| END-02 | Postes de Travail | Les portables sont-ils chiffrés (BitLocker/FileVault) ? |  Élevée |  P1 |  Non - Pas de chiffrement |
| END-03 | Postes de Travail | Tous les postes sont-ils joints au domaine AD ? |  Élevée |  P2 |  Probablement - À vérifier |
| AWARE-01 | Sensibilisation | Un programme de formation sécurité est-il déployé ? |  Moyenne |  P2 |  Non - Absent |
| AWARE-02 | Sensibilisation | Une politique d'usage acceptable (AUP) est-elle formalisée ? |  Moyenne |  P2 |  Non - Pas documentée |
| INC-01 | Gestion des Incidents | Un plan de continuité (PCA) est-il défini et testé ? |  Élevée |  P3 |  Non - Pas de PCA |
| INC-02 | Gestion des Incidents | Une procédure de réponse aux incidents est-elle documentée ? |  Élevée |  P3 |  Non - Pas de procédure |
| INC-03 | Gestion des Incidents | Les incidents sont-ils tracés et analysés ? |  Moyenne |  P3 |  Non - Pas de registre |


---

## 📈 Statistiques par Priorité

###  P0 - IMMÉDIATE
**11 actions critiques à traiter d'urgence :**
- IAM-01, IAM-02, IAM-03, DATA-02, DATA-03, DATA-04, DATA-05, NET-01, NET-02, APP-03, END-01

###  P1 - URGENTE 
**12 actions urgentes :**
- GOV-01, GOV-02, IAM-04, IAM-05, DATA-06, APP-01, APP-02, APP-04, AV-01, AV-02, VULN-01, END-02

###  P2 - IMPORTANTE 
**9 actions importantes :**
- GOV-03, DATA-01, NET-03, NET-04, VULN-02, VULN-03, END-03, AWARE-01, AWARE-02

###  P3 - MOYEN TERME 
**3 actions moyen terme :**
- INC-01, INC-02, INC-03

---

## 🔐 Éléments CAID Garantis

Chaque mesure du questionnaire garantit les 4 piliers de sécurité :

| Pilier | Exemples pour XANADU |
|--------|----------------------|
| **Confidentialité** | VLANs séparant les données, droits d'accès par service, chiffrement |
| **Intégrité** | Audit Active Directory, pare-feu validant les flux, comptes nominatifs |
| **Disponibilité** | Redondance DC, sauvegardes 3-2-1, MPLS SLA 99,9%, PCA |
| **Traçabilité** | Logs centralisés, comptes nominatifs jamais génériques, audit mensuel |

---

*Questionnaire de sécurité préparé pour XANADU - November 2025*  
*Conforme ANSSI, ISO 27001, et recommandations cybersécurité*
