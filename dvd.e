class DVD
	--
	-- Classe décrivant les DVD
	--

creation {ANY}
	make

feature {}


feature {ANY}
	--variables
	annee : STRING
	acteur : STRING
	realisateur : STRING
	type : STRING

	make_dvd (nv_titre: STRING; nv_annee: STRING; nv_nombre: STRING; nv_acteur: STRING; nv_realisateur: STRING) is
			-- Creation d'un DVD
		do

		end

		---------------------------------------
	                --GETTER / SETTER
	  ---------------------------------------
	  get_annee  : STRING is
	  do
	    Result := annee
	  end

	  set_annee(valeur: STRING) is
	  do
	    annee.copy(annee)
	  end

		get_acteur  : STRING is
	  do
	    Result := acteur
	  end

	  set_acteur(valeur: STRING) is
	  do
	    acteur.copy(acteur)
	  end

		get_realisateur  : STRING is
	  do
	    Result := realisateur
	  end

	  set_realisateur(valeur: STRING) is
	  do
	    realisateur.copy(realisateur)
	  end

		get_type  : STRING is
	  do
	    Result := acteur
	  end

	  set_type(valeur: STRING) is
	  do
	    type.copy(type)
	  end

	  ---------------------------------------
	              --TO STRING
	  ---------------------------------------
	  to_string : STRING is
	  do
			io.put_string("MEDIA : %N")
	    io.put_string("Acteur : " + acteur + "%N%N")
			io.put_string("Realisateur : " + realisateur + "%N%N")
			io.put_string("Type : " + type + "%N%N")
			io.put_string("Annee : " + annee + "%N%N")
	  end

end -- class DVD
