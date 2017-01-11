class LIVRE inherit MEDIA redefine to_string end
	--
	-- Classe décrivant les livres
	--

creation {ANY}
	make_livre

feature {}


feature {ANY}
	--variables
	auteur: STRING

	make_livre (nv_titre: STRING; nv_auteur: STRING; nv_nombre: INTEGER) is
			-- Creation d'un livre
		do
			titre := ""
			auteur := ""
			titre.copy(nv_titre)
			auteur.copy(nv_auteur)
			nombre := nv_nombre
		end

		---------------------------------------
	                --GETTER / SETTER
	  ---------------------------------------
	  get_auteur  : STRING is
	  do
	    Result := auteur
	  end

	  set_auteur(valeur: STRING) is
	  do
	    auteur.copy(valeur)
	  end

	  ---------------------------------------
	              --TO STRING
	  ---------------------------------------
	  to_string is
	  do
		io.put_string("==================================================================%N")
		io.put_string("MEDIA                : LIVRE%N")
		io.put_string("Titre                : " + titre + "%N")
	    io.put_string("Auteur               : " + auteur + "%N")	
		io.put_string("Nombre d'exemplaires : " + nombre.to_string + "%N")
		io.put_string("==================================================================%N%N")
	  end

		---------------------------------------
	              -- LIVRE EXISTE
	  ---------------------------------------
	  is_livre_exist(livre: LIVRE) : BOOLEAN is
	  do
			Result:= (titre.as_lower.is_equal(livre.get_titre.as_lower) and auteur.as_lower.is_equal(livre.get_auteur.as_lower))
	  end


end -- class LIVRE
