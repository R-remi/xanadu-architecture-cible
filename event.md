| Événement | Criticité | Source | Action Déclenchée | Justification de la pertinence pour la sécurité |
| :--- | :--- | :--- | :--- | :--- |
| **Espace disque < 10%** | Majeure | Serveur (Agent) | Alerte Email Admin + Création Ticket | Évite l'arrêt brutal des services (AD, ERP) par saturation (Déni de service involontaire). |
| **Service "PostgreSQL" arrêté** | Critique | Serveur ERP | Tentative redémarrage auto (script) + SMS Admin | Le cœur de métier est à l'arrêt. Impact immédiat sur la production et le CA. |
| **Liaison MPLS Down** | Critique | Routeur (SNMP) | SMS Admin | Perte de connexion critique entre le siège (Atlantis) et le Labo (Springfield). |
| **Détection Malware/Virus** | Critique | Console Antivirus | Isolement réseau automatique du poste + Alerte | Empêche la propagation latérale d'un rançongiciel sur le réseau sain. |
| **5 Échecs de login successifs** | Moyenne | Contrôleur de Domaine (Logs) | Alerte "Brute Force Suspecté" | Détection précoce d'une tentative d'intrusion ou d'un compte compromis. |
| **Usage CPU > 90% (15min)** | Moyenne | Serveurs | Alerte Performance | Peut indiquer un processus hors de contrôle ou un minage de cryptomonnaie illicite (Cryptojacking). |
| **Modif. Groupe "Admin du Domaine"** | Critique | Active Directory | Alerte Immédiate (SMS) | Indicateur fort d'une élévation de privilèges malveillante (Persistance de l'attaquant). |
| **Sauvegarde backeup échouée** | Majeure | Serveur Backup | Ticket Incident | Risque de perte de données irrémédiable en cas de crash futur (Rupture du PCA). |
| **Onduleur sur batterie** | Majeure | Salle Serveur (SNMP) | Alerte "Coupure Courant" + Extinction propre si > 15min | Protège l'intégrité physique du matériel et évite la corruption des bases de données. |
| **Trafic sortant anormal (> 500 Mbps)** | Critique | Pare-feu | Blocage flux + Alerte Exfiltration | Indique potentiellement un vol de données massif en cours vers l'extérieur (Exfiltration). |
