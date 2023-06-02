; Jesús Miguel Rojas Gómez

(define (domain dominio6) ; definición del dominio

(:requirements :strips :fluents :typing) ; requisitos

	(:types ; tipos
        ; añadido problema5: Investigaciones
		Entidad Localizaciones Recursos Investigaciones - object ; Entidad, Localizaciones, Recursos son objetos
		Unidades Edificios - Entidad ; Unidades, Edificios derivan de entidad
		tipoRecurso - Recursos ; tipoRecurso deriva de Recursos
		tipoUnidad - Unidades ; tipoUnidad deriva de Unidades
		tipoEdificio - Edificios ; tipoEdificio deriva de Edificios
        tipoInvestigacion - Investigaciones ; tipoInvestigacion deriva de Inverstigaciones
	)

	(:constants ; constantes
        ; añadido problema4: Marine Soldado
		VCE Marine Soldado - tipoUnidad ; VCE Marine Soldado deriva de tipoUnidad
        ; añadido problema2: Extractor
        ; añadido problema5: Laboratorio, Especia
		CentroDeMando Barracones Extractor Laboratorio - tipoEdificio ; CentroDeMando Barracones deriva de tipoEdificio
		Mineral Gas Especia - tipoRecurso ; Mineral, Gas deriva de tipoRecurso
        Spartan - tipoInvestigacion ; Spartan deriva de tipoInvestigacion
    )

    ; añadido problema6:
    (:functions
        (coste) ; costo del plan
    )

	(:predicates
		(entidadEn ?ent - Entidad ?x - Localizaciones) ; entidad ent se encuentra en localizacion x
		(caminoEntre ?x1 - Localizaciones ?x2 - Localizaciones) ; hay un camino entre localizacion x1 y localizacion x2
		(edificioConstruido ?ed - Edificios) ; edificio es está construido
		(recursoEn ?rec - Recursos ?x - Localizaciones) ; recurso rec se encuentra en localizacion x
		(VCEextrayendo ?u - Unidades ?rec - Recursos) ; unidad u está extrayendo recuros rec
		(VCElibre ?u - Unidades) ; unidad u está libre

        ; añadido problema2: 
        ; modificado problema4:
        ; modificado problema5:
        (entidadNecesita ?obj - object ?rec - Recursos) ; obj necesita rec para ser construido
        (edificioTipo ?ed - Edificios ?tipo - tipoEdificio) ; ed es del tipo tipoEdificio
        (recursoDisponible ?rec - Recursos) ; rec está disponible

        ; añadido problema4:
        (unidadTipo ?unidad - Unidades ?tipo - tipoUnidad) ; unidad es del tipo tipoUnidad
        (unidadNecesita ?unidad - tipoUnidad ?ed - tipoEdificio) ; unidad necesita ed para ser generada

        ; añadido problema5:
        (investigacionDisponible ?inv - Investigaciones) ; inv está disponible
        (investigacionTipo ?inv - Investigaciones ?tipo - tipoInvestigacion) ; inv es del tipo tipoInvertigacion

	)

	(:action Navegar ; accion navegar
		:parameters (?unidad - Unidades ?origen - Localizaciones ?destino - Localizaciones) ; parametros
		:precondition (and 
			(entidadEn ?unidad ?origen) ; unidad está en origen
			(caminoEntre ?origen ?destino) ; hay un camino entre origen y destino
			(VCElibre ?unidad) ; unidad está libre
		)
		:effect (and 
			(entidadEn ?unidad ?destino) ; unidad unidad ahora está en destino
			(not (entidadEn ?unidad ?origen)) ; unidad unidad no está en origen
            (increase (coste) 1) ; incrementa el coste
		)
	)

	(:action Asignar ; accion asignar
        ; TODO: modificar problema2
		:parameters (?unidad - Unidades ?x - Localizaciones) ; parametros
		:precondition (and 
			(entidadEn ?unidad ?x) ; unidad está en x
			(exists (?rec - tipoRecurso) (and
				(recursoEn ?rec ?x) )
			) ; hay rec en x
			(VCElibre ?unidad) ; unidad está libre

            ; añadido problema2:
            (imply (recursoEn Gas ?x) ; si en x hay Gas, existe ed de tipo Extractor en x
                (exists (?ed - Edificios) (and
                    (edificioTipo ?ed Extractor)
                    (entidadEn ?ed ?x)
                ) )
            )
            
            ; añadido problema4:
            (unidadTipo ?unidad VCE) ; para asignar debe ser de tipo VCE
		)
		:effect (and 
			(forall (?rec - tipoRecurso) ; para todo recurso
				(when (and (recursoEn ?rec ?x)) ; cuando rec esta en x 
					(and
						(VCEextrayendo ?unidad ?rec) ; unidad extrayendo rec
						(not (VCElibre ?unidad)) ; unidad no está libre
						(recursoDisponible ?rec) ; rec está disponible
					)
				)
			)
            (increase (coste) 1)
		)
	)

    (:action Construir ; accion construir
        ; modificado problema3:
        :parameters (?unidad - Unidades ?ed - Edificios ?x - Localizaciones) ;  parametros
        :precondition (and 
            (entidadEn ?unidad ?x) ; la unidad está en x
            (not (edificioConstruido ?ed)) ; el edificio ed no está construido aún
            (VCElibre ?unidad) ; la unidad está libre
            ; modificado problema3:
            (not (exists (?ed2 - Edificios) (entidadEn ?ed2 ?x))) ; no hay mas edificios en x
            (forall (?rec - tipoRecurso) ; para todo recurso
                (exists (?tipo - tipoEdificio) (and ; existe el tipo de edificio y
                    (edificioTipo ?ed ?tipo) ; ed es del tipo dado
                    (imply (entidadNecesita ?tipo ?rec) (recursoDisponible ?rec)) ; si ed necesita rec, rec está disponible
                ) )
            )
            ; añadido problema4:
            (unidadTipo ?unidad VCE) ; para construir debe ser de tipo VCE
        )
        :effect (and 
            (entidadEn ?ed ?x) ; ed está en x
            (edificioConstruido ?ed) ; ed está construido
            (increase (coste) 1)
        )
    )

    ; añadido problema4:
    (:action Reclutar ; accion reclutar
        :parameters (?ed - Edificios ?unidad - Unidades ?x - Localizaciones) ; parametros
        :precondition (and 
            (forall (?rec - tipoRecurso) ; para todo recurso
                (exists (?tipo - tipoUnidad) (and ; existe el tipo de unidad y
                    (unidadTipo ?unidad ?tipo) ; unidad es del tipo dado
                    (imply (entidadNecesita ?tipo ?rec) (recursoDisponible ?rec)) ; si entidad necesita rec, rec está disponible
                ) )
            )
            (forall (?ed2 - tipoEdificio) ; para todo edificio
                (exists (?tipo - tipoUnidad) (and ; existe el tipo de unidad y
                    (unidadTipo ?unidad ?tipo) ; unidad es del tipo dado
                    (imply (unidadNecesita ?tipo ?ed2) (edificioTipo ?ed ?ed2)) ; si unidad necesita un edificio, este es del tipo que necesita
                ) )
            )
            (entidadEn ?ed ?x)
            (not (exists (?x2 - Localizaciones) (entidadEn ?unidad ?x2) )) ; la unidad no se encuentra en ninguna localizacion
            
            ; añadido problema5:
            (imply (unidadTipo ?unidad Soldado) ; si hay una unidad de tipo Soldado
                (exists (?inv - Investigaciones) (and ; existe una investigacion inv y
                    (investigacionDisponible ?inv) ; está disponible
                    (investigacionTipo ?inv Spartan) ; es de tipo Spartan
                ) )
            )
        )
        :effect (and 
            (entidadEn ?unidad ?x)
            (VCElibre ?unidad)
            (increase (coste) 1)
        )
    )

    (:action Investigar ; accion investigar
        :parameters (?ed - Edificios ?inv - Investigaciones) ; parametros
        :precondition (and 
            (edificioTipo ?ed Laboratorio)
            (edificioConstruido ?ed)
            ; (not (investigacionDisponible ?inv))
            (forall (?rec - tipoRecurso) ; para todo recurso
                (exists (?tipo - tipoInvestigacion) (and ; existe tipo investigacion y
                    (investigacionTipo ?inv ?tipo) ; investigacion es del tipo dado
                    (imply (entidadNecesita ?tipo ?rec) (recursoDisponible ?rec)) ; si investigacion necesita recurso, este esta disponible
                ) )
            )
        )
        :effect (and 
            (investigacionDisponible ?inv) ; se crea la investigacion
            (increase (coste) 1)
        )
    )
    
    
)