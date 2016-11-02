class MEDIA
	--
	-- Classe décrivant les médias
	--

creation {ANY}
	make


feature {ANY}
  -- variables
  titre: STRING
	nombre : INTEGER

	make_media is
			-- Creation d'un media
		do

		end

  ---------------------------------------
                --GETTER / SETTER
  ---------------------------------------
  get_titre  : STRING is
  do
    Result := titre
  end

  set_titre(valeur: STRING) is
  do
    titre.copy(titre)
  end

	get_nombre : INTEGER is
	do
		Result := nombre
	end

	set_nombre(valeur: INTEGER) is
  do
    nombre.copy(nombre)
  end

  ---------------------------------------
              --TO STRING
  ---------------------------------------
  to_string : STRING is
  do
		io.put_string("MEDIA : %N")
    io.put_string("Titre : " + titre + "%N%N")
		io.put_string("Nombre : " + nombre.to_string + "%N%N")
  end

  ---------------------------------------
              --EMPRUNTER MEDIA
  ---------------------------------------

  ---------------------------------------
              --RAPPORTER MEDIA
  ---------------------------------------

end -- class MEDIA
