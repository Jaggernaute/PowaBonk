SELECT * FROM utilisateurs WHERE `nom`     LIKE :search_string
                              OR `prenom`  LIKE :search_string
                              OR `mail`    LIKE :search_string
                              OR `idBadge` LIKE :search_string;