CREATE TABLE admins
(
    id       INT          AUTO_INCREMENT
                          PRIMARY KEY,
    username VARCHAR(32)  NOT NULL,
    password VARCHAR(512) NOT NULL,
    CONSTRAINT admins_id_uindex
        UNIQUE (id),
    CONSTRAINT admins_username_uindex
        UNIQUE (username)
);
CREATE TABLE utilisateurs
(
    id             INT          AUTO_INCREMENT
                                PRIMARY KEY,
    nom            varchar(20)  NOT NULL,
    prenom         varchar(30)  NOT NULL,
    mail           varchar(128) NOT NULL,
    idBadge        varchar(50)  NOT NULL,
    password       varchar(80)  NOT NULL,
    `derniere-res` datetime     NULL,
    CONSTRAINT utilisateurs_nbadge_uindex
        UNIQUE (idBadge),
    CONSTRAINT utilisateurss_mail_uindex
        UNIQUE (mail)
);
CREATE TABLE planing
(
    id             INT     AUTO_INCREMENT
                           PRIMARY KEY,
    utilisateur_id INT     NULL,
    id_horraire    INT(40) NULL,
    CONSTRAINT planing_utilisateurs_id_fk
        FOREIGN KEY (id)
            REFERENCES utilisateurs (id)
);