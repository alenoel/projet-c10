-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Lun 06 Mars 2017 à 10:29
-- Version du serveur :  5.7.14
-- Version de PHP :  5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `projetplasse`
--

-- --------------------------------------------------------

--
-- Structure de la table `equipe`
--

DROP TABLE IF EXISTS `equipe`;
CREATE TABLE IF NOT EXISTS `equipe` (
  `idEquipe` int(10) NOT NULL,
  `idPersonne` int(10) NOT NULL,
  `dateCreation` char(32) COLLATE utf8_bin DEFAULT NULL,
  `nomEquipe` char(32) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`idEquipe`),
  KEY `I_FK_EQUIPE_ETUDIANT` (`idPersonne`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Déclencheurs `equipe`
--
DROP TRIGGER IF EXISTS `insPersonneEquipe`;
DELIMITER $$
CREATE TRIGGER `insPersonneEquipe` BEFORE INSERT ON `equipe` FOR EACH ROW BEGIN
	DECLARE nb integer;
    SELECT COUNT(*) INTO nb FROM inscrit
    WHERE idPersonne= new.idPersonne;
    IF(nb=0)
    THEN
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT="Inscription impossible, pas inscrit";
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `equipe_projet`
--

DROP TABLE IF EXISTS `equipe_projet`;
CREATE TABLE IF NOT EXISTS `equipe_projet` (
  `idEquipe` int(10) NOT NULL,
  `idProjet` int(10) NOT NULL,
  PRIMARY KEY (`idEquipe`,`idProjet`),
  KEY `I_FK_EQUIPE_PROJET_PROJET` (`idEquipe`),
  KEY `I_FK_EQUIPE_PROJET_EQUIPE` (`idProjet`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Structure de la table `inscrit`
--

DROP TABLE IF EXISTS `inscrit`;
CREATE TABLE IF NOT EXISTS `inscrit` (
  `idPersonne` int(10) NOT NULL,
  `idPromo` int(10) NOT NULL,
  PRIMARY KEY (`idPersonne`,`idPromo`),
  KEY `I_FK_INSCRIT_PROMOTION` (`idPersonne`),
  KEY `I_FK_INSCRIT_ETUDIANT` (`idPromo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Structure de la table `membreequipe`
--

DROP TABLE IF EXISTS `membreequipe`;
CREATE TABLE IF NOT EXISTS `membreequipe` (
  `idEquipe` int(10) NOT NULL,
  `idMembreEquipe` int(10) NOT NULL,
  `idPersonne` int(10) NOT NULL,
  PRIMARY KEY (`idEquipe`,`idMembreEquipe`,`idPersonne`),
  KEY `I_FK_MEMBREEQUIPE_ETUDIANT` (`idEquipe`),
  KEY `I_FK_MEMBREEQUIPE_EQUIPE` (`idMembreEquipe`),
  KEY `I_FK_MEMBREEQUIPE_PROJET` (`idPersonne`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Structure de la table `personne`
--

DROP TABLE IF EXISTS `personne`;
CREATE TABLE IF NOT EXISTS `personne` (
  `idPersonne` int(10) NOT NULL AUTO_INCREMENT,
  `nom` char(32) COLLATE utf8_bin DEFAULT NULL,
  `prenom` char(32) COLLATE utf8_bin DEFAULT NULL,
  `mdp` varchar(20) COLLATE utf8_bin NOT NULL,
  `formateur` tinyint(1) NOT NULL,
  `etudiant` tinyint(1) NOT NULL,
  `email` varchar(50) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idPersonne`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `personne`
--

INSERT INTO `personne` (`idPersonne`, `nom`, `prenom`, `mdp`, `formateur`, `etudiant`, `email`) VALUES
(1, 'Ajaada', 'zoubir', 'zoubir', 0, 1, 'ajaada.zoubir@hotmail.com'),
(2, 'Diwouta', 'marie', 'marie', 0, 1, 'diwouta.marie@jesuisbon.com'),
(3, 'Lenoel', 'arnaud', 'arnaud', 1, 1, 'lenoel.arnaud@jesuisunebete.com'),
(4, 'Chamffort', 'matthieu', 'matthieu', 1, 1, 'chamffort.matthieu@jesuisbon.com');

-- --------------------------------------------------------

--
-- Structure de la table `projet`
--

DROP TABLE IF EXISTS `projet`;
CREATE TABLE IF NOT EXISTS `projet` (
  `idProjet` int(10) NOT NULL AUTO_INCREMENT,
  `idPromotion` int(10) NOT NULL,
  `idPersonne` int(10) NOT NULL,
  `titre` char(32) COLLATE utf8_bin DEFAULT NULL,
  `dateCreation` char(32) COLLATE utf8_bin DEFAULT NULL,
  `dateFin` char(32) COLLATE utf8_bin DEFAULT NULL,
  `sujet` char(32) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`idProjet`),
  KEY `I_FK_PROJET_PROMOTION` (`idPromotion`),
  KEY `I_FK_PROJET_FORMATEUR` (`idPersonne`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Structure de la table `promotion`
--

DROP TABLE IF EXISTS `promotion`;
CREATE TABLE IF NOT EXISTS `promotion` (
  `idPromo` int(10) NOT NULL,
  `intitulle` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`idPromo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `equipe`
--
ALTER TABLE `equipe`
  ADD CONSTRAINT `fk_equipe_personne` FOREIGN KEY (`idPersonne`) REFERENCES `personne` (`idPersonne`);

--
-- Contraintes pour la table `equipe_projet`
--
ALTER TABLE `equipe_projet`
  ADD CONSTRAINT `fk_equipeprojet_equipe` FOREIGN KEY (`idEquipe`) REFERENCES `equipe` (`idEquipe`),
  ADD CONSTRAINT `fk_equipeprojet_projet` FOREIGN KEY (`idProjet`) REFERENCES `projet` (`idProjet`);

--
-- Contraintes pour la table `inscrit`
--
ALTER TABLE `inscrit`
  ADD CONSTRAINT `fk_inscrit_personne` FOREIGN KEY (`idPersonne`) REFERENCES `personne` (`idPersonne`),
  ADD CONSTRAINT `fk_inscrit_promo` FOREIGN KEY (`idPromo`) REFERENCES `promotion` (`idPromo`);

--
-- Contraintes pour la table `membreequipe`
--
ALTER TABLE `membreequipe`
  ADD CONSTRAINT `fk_membreequipe_equipe` FOREIGN KEY (`idEquipe`) REFERENCES `equipe` (`idEquipe`),
  ADD CONSTRAINT `fk_membreequipe_personne` FOREIGN KEY (`idPersonne`) REFERENCES `personne` (`idPersonne`);

--
-- Contraintes pour la table `projet`
--
ALTER TABLE `projet`
  ADD CONSTRAINT `fk_projet_personne` FOREIGN KEY (`idPersonne`) REFERENCES `personne` (`idPersonne`),
  ADD CONSTRAINT `fk_projet_promo` FOREIGN KEY (`idPromotion`) REFERENCES `promotion` (`idPromo`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
