class DVD inherit MEDIA redefine to_string end
	--
	-- Classe décrivant les DVD
	--

creation {ANY}
	make_dvd

feature {}


feature {ANY}
	--variables
	annee : STRING
	acteurs : ARRAY[STRING]
	realisateurs : ARRAY[STRING]
	type : STRING

	make_dvd (nv_titre: STRING; nv_annee: STRING; nv_nombre: INTEGER; nv_acteurs: ARRAY[STRING]; nv_realisateurs: ARRAY[STRING]; nv_type : STRING) is
			-- Creation d'un DVD
		do
			titre := ""
			annee := ""
			type := ""
			-- Initialisation tableaux
			create realisateurs.with_capacity(0,0)
			realisateurs.append_collection(nv_realisateurs)

			create acteurs.with_capacity(0,0)
			acteurs.append_collection(nv_acteurs)

			titre.copy(nv_titre)
			annee.copy(nv_annee)
			type.copy(nv_type)
			nombre.copy(nv_nombre)
			acteurs.copy(nv_acteurs)
			realisateurs.copy(nv_realisateurs)
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
	    annee.copy(valeur)
	  end

		get_acteurs  : ARRAY[STRING] is
	  do
	    Result := acteurs
	  end

	  set_acteurs(valeur: STRING) is
	  do
	    acteurs.add_last(valeur)
	  end

		get_realisateurs  : ARRAY[STRING] is
	  do
	    Result := realisateurs
	  end

	  set_realisateurs(valeur: STRING) is
	  do
	    realisateurs.add_last(valeur)
	  end

		get_type  : STRING is
	  do
	    Result := type
	  end

	  set_type(valeur: STRING) is
	  do
	    type.copy(valeur)
	  end

	  ---------------------------------------
	              --TO STRING
	  ---------------------------------------
	  to_string : STRING is
	  do
			io.put_string("MEDIA : %N")
	    --io.put_string("Acteur : " + acteurs + "%N%N")
			--io.put_string("Realisateur : " + realisateurs + "%N%N")
			io.put_string("Type : " + type + "%N%N")
			io.put_string("Annee : " + annee + "%N%N")
			io.put_string("------------------------------- %N%N")
	  end

end -- class DVD
