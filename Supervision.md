# Dispositif de Surveillance et Supervision

Pour garantir la stabilité du système d'information de XANADU et prévenir les incidents (tels que les attaques par rançongiciel ou les pannes critiques), nous déployons une architecture de supervision centralisée.

## 1. Outils de Supervision Sélectionnés

* **ZABBIX (Cœur de la supervision)**
* *Rôle :* Surveiller l'état de santé de l'infrastructure (Disque, CPU, RAM, Réseau, Services).
* *Justification :* Solution robuste capable de monitorer l'environnement de XANADU (Windows Server, Linux à Springfield, Routeurs MPLS, Imprimantes).

* **GRAYLOG (Centralisation des logs & Sécurité)**
* *Rôle :* Collecter, centraliser et analyser les journaux d'événements (logs) de tous les serveurs et pare-feu.
* *Justification :* Indispensable pour la **traçabilité**, la détection d'intrusions et l'audit post-incident.

* **GLPI (Gestion de parc et Tickets)**
* *Rôle :* Gestion des tickets d'incidents.
* *Justification :* Interfacé avec Zabbix, il permet la création automatique d'un ticket lorsqu'une alerte critique est levée, assurant le suivi des SLA.

## 2. Méthodologie de Collecte des Données

Nous utilisons trois méthodes pour récupérer les informations, adaptées à chaque type d'équipement sur les sites d'Atlantis et Springfield :

1. **Agents logiciels (Zabbix Agent)**
* *Cibles :* Contrôleur de Domaine, Serveur ERP, Serveurs Linux (Labo), Postes critiques.
* *Fonctionnement :* Installation d'un service léger sur la machine qui remonte des métriques précises (Usage CPU, Espace Disque, État des services PostgreSQL/AD) de manière chiffrée.

2. **Protocole SNMP (Simple Network Management Protocol)**
* *Cibles :* Équipements réseau et matériels sans OS complet (Routeurs MPLS, Switchs, Onduleurs, Imprimantes/Copieurs).
* *Fonctionnement :* Interrogation périodique de l'équipement (Polling) pour connaître l'état des ports, le niveau de consommables ou l'état de la batterie.

3. **Syslog & Winlogbeat**
* *Cibles :* Tous les équipements (Sécurité).
* *Fonctionnement :* Envoi en temps réel des journaux de sécurité (connexions, erreurs, modifications de droits) vers le serveur central Graylog.

## 3. Architecture Générale de la Surveillance

Mettre un schéma ici

**Flux de surveillance :**

* **Zone Atlantis :** Communication directe via le réseau d'administration.
* **Liaison MPLS :** Des sondes ICMP mesurent en permanence la qualité du lien (Latence < 50ms, Perte de paquets < 0.1%) pour vérifier le respect du SLA opérateur

## 4. Politique d'Alerting et Événements Surveillés

Conformément à l'analyse des risques et aux exigences du directeur, voici la matrice des 10 événements déclencheurs configurés. Ils couvrent la Disponibilité, l'Intégrité et la Confidentialité.

| Événement (Trigger) | Criticité | Source | Action Automatique | Justification Sécurité & Métier |
| --- | --- | --- | --- | --- |
| **Espace disque < 10%** | Majeure | Serveur (Agent) | Alerte Email Admin + Ticket GLPI | Prévention de l'arrêt brutal des services (AD, ERP) par saturation (Déni de service involontaire). |
| **Service "PostgreSQL" arrêté** | Critique | Serveur ERP | Tentative redémarrage auto (script) + SMS Admin | Le cœur de métier est à l'arrêt. Impact immédiat sur la production et le CA. |
| **Liaison MPLS Down** | Critique | Routeur (SNMP) | SMS Admin + Ticket | Perte de connexion critique entre le siège (Atlantis) et le Labo (Springfield). |
| **Détection Malware/Virus** | Critique | Console Antivirus | Isolement réseau automatique du poste + Alerte | Empêche la propagation latérale d'un rançongiciel sur le réseau sain. |
| **5 Échecs de login successifs** | Moyenne | AD (Logs) | Alerte "Brute Force Suspecté" | Détection précoce d'une tentative d'intrusion ou d'un compte compromis. |
| **Usage CPU > 90% (15min)** | Moyenne | Serveurs | Alerte Performance | Peut indiquer un processus hors de contrôle ou un minage de cryptomonnaie illicite (Cryptojacking). |
| **Modif. Groupe "Admin du Domaine"** | Critique | Active Directory | Alerte Immédiate (SMS) | Indicateur fort d'une élévation de privilèges malveillante (Persistance de l'attaquant). |
| **Sauvegarde Backup échouée** | Majeure | Serveur Backup | Ticket Incident | Risque de perte de données irrémédiable en cas de crash futur (Rupture du PCA). |
| **Onduleur sur batterie** | Majeure | Salle Serveur (SNMP) | Alerte "Coupure Courant" + Extinction propre si > 15min | Protège l'intégrité physique du matériel et évite la corruption des bases de données. |
| **Trafic sortant anormal (> 500 Mbps)** | Critique | Pare-feu | Blocage flux + Alerte Exfiltration | Indique potentiellement un vol de données massif en cours vers l'extérieur (Exfiltration). |

## 5. Tableaux de Bord (Reporting)

Deux niveaux de visualisation sont mis en place :

* **Vue "Direction" (Météo des services) :** Indicateurs synthétiques (Vert/Orange/Rouge) sur l'état des services critiques (ERP, Messagerie, Liaison inter-sites).
* **Vue "Technique" :** Graphiques détaillés pour les administrateurs (Latence, IOPS, files d'attente, logs d'erreurs) permettant le diagnostic rapide.
