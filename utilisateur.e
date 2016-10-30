class UTILISATEUR
	--
	-- Classe décrivant les utilisateurs
	--

creation {ANY}
	make_utilisateur

feature {}
	nom, prenom, identifiant: STRING
	administrateur: BOOLEAN

feature {ANY}
	make_utilisateur (nv_nom: STRING; nv_prenom: STRING; nv_id: STRING; nv_admin: BOOLEAN) is
			-- Creation d'un utilisateur
		do
			nom := ""
			prenom := ""
			identifiant := ""
			administrateur := False
			nom.copy(nv_nom)
			prenom.copy(nv_prenom)
			identifiant.copy(nv_id)
			administrateur := nv_admin
		end

	      -------------
			--FONCTIONS--
	      -------------

			--*GETTERS*--

	get_nom: STRING is
		do
			Result:= nom
		end

	get_prenom: STRING is
		do
			Result:= prenom
		end

	get_identifiant: STRING is
		do
			Result:= identifiant
		end

	is_admin: BOOLEAN is
		do
			Result:= True
		end

			--*SETTERS*--

	set_nom (nv_nom: STRING) is
		do
			nom.copy(nv_nom)
		end

	set_prenom (nv_prenom: STRING) is
		do
			prenom.copy(nv_prenom)
		end

	set_identifiant (nv_id: STRING) is
		do
			identifiant.copy(nv_id)
		end

	set_administrateur (nv_admin: BOOLEAN) is
		do
			administrateur.copy(nv_admin)
		end

	user_exist(utilisateur: UTILISATEUR): BOOLEAN is
		do
			Result:=identifiant.is_equal(utilisateur.get_identifiant)
		end

	display_user : STRING is
		do
			Result:= "Utilisateur : %N Nom : " + nom + " " + prenom + "%N " + "Identifiant: %N" + identifiant + "%N " + "Administrateur? : %N" + administrateur.to_string
		end

end -- class UTILISATEUR
