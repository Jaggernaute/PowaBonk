select * from utilisateurs where `nom` like :search_string
                              or `prenom` like :search_string
                              or `mail` like :search_string
                              or `idBadge` like :search_string;