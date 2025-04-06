# Projet de Gestion des Clients, Produits et Factures
![spirng_logo+flutter_logo](https://img-c.udemycdn.com/course/480x270/5039460_8fad_4.jpg)

## A propos

Ce projet a été réalisé dans un cadre scolaire afin de créer une architecture microservice offrant une API qu'une application cliente (mobile dans ce cas), viendra consommer.

* Université : Université Catholique de l'Afrique de l'Ouest - Unité Universitaire du Togo ([UCAO-UUT](https://ucao-uut.tg/)).

* Institut : Cycle Ingénieur - Master 1

* Cours : Programmation avancée en Java et microservices

* Parcours : Cybersécurité

* Année scolaire : 2024-2025

* Professeur en charge : M. SEWAVI Maurice

* Projet réalisé par :
    * KOUDOSSOU Messan Dhani Justin

## Description

Ce projet est une application complète développée en Java avec Spring Boot, illustrant une architecture de microservices. Il comprend cinq services principaux qui interagissent entre eux, ainsi qu'une application mobile développée en Flutter pour Android, permettant aux utilisateurs de gérer les clients, les produits et les factures.

## Structure du Dossier

Le dossier contient les codes sources des éléments suivants :

1. **Service Gateway** : Point d'entrée unique pour toutes les requêtes des clients. Dossier : ``gateway-service``.

2. **Service Eureka** : Gestion de la configuration et du registre des services, assurant la découverte des services. Dossier : ``config-service``.

3. **Service Client** : Responsabilité de la gestion des clients et de leurs informations. Dossier : ``client-service``.

4. **Service Produit** : Gestion des produits, y compris leurs détails et caractéristiques. Dossier : ``product-service``.

5. **Service Facturation** : Gestion des factures et des transactions associées. Dossier : ``billing-service``.

6. **Application Mobile** : Développée en Flutter pour Android, cette application permet aux utilisateurs de gérer les clients, les produits et les factures à partir d'une interface utilisateur intuitive. Dossier : ``mobile_app``.

## Installation

Pour exécuter le projet, veuillez suivre les étapes ci-dessous :

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/Onzk/tp-microservice
   ```

2. Accédez aux répertoires des services et exécutez-les avec Maven :
   ```bash
   cd <nom_du_service>
   mvn spring-boot:run
   ```

3. Pour l'application mobile, ouvrez le projet dans votre IDE Flutter et exécutez-le sur un émulateur ou un appareil Android. N'oubliez pas modifier le fichier ``./lib/properties.dart`` en mettant l'adresse IP de votre machine sur le réseau ou `127.0.0.1`, si vous utlisez un émulateur sur votre machine locale.

## Utilisation

Après avoir démarré tous les services, vous pouvez interagir avec l'application mobile pour accéder à l'API via le service Gateway. L'application permet de gérer les clients, les produits et les factures de manière intuitive.