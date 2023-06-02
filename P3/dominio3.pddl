; Jesús Miguel Rojas Gómez

(define (domain dominio3) ; definición del dominio

(:requirements :strips :fluents :typing) ; requisitos

	(:types ; tipos
		Entidad Localizaciones Recursos - object ; Entidad, Localizaciones, Recursos son objetos
		Unidades Edificios - Entidad ; Unidades, Edificios derivan de entidad
		tipoRecurso - Recursos ; tipoRecurso deriva de Recursos
		tipoUnidad - Unidades ; tipoUnidad deriva de Unidades
		tipoEdificio - Edificios ; tipoEdificio deriva de Edificios
	)

	(:constants ; constantes
		VCE - tipoUnidad ; VCE deriva de tipoUnidad
        ; añadido problema2: Extractor
		CentroDeMando Barracones Extractor - tipoEdificio ; CentroDeMando Barracones deriva de tipoEdificio
		Mineral Gas - tipoRecurso ; Mineral, Gas deriva de tipoRecurso
	)

	(:predicates
		(entidadEn ?ent - Entidad ?x - Localizaciones) ; entidad ent se encuentra en localizacion x
		(caminoEntre ?x1 - Localizaciones ?x2 - Localizaciones) ; hay un camino entre localizacion x1 y localizacion x2
		(edificioConstruido ?ed - Edificios) ; edificio es está construido
		(recursoEn ?rec - Recursos ?x - Localizaciones) ; recurso rec se encuentra en localizacion x
		(VCEextrayendo ?u - Unidades ?rec - Recursos) ; unidad u está extrayendo recuros rec
		(VCElibre ?u - Unidades) ; unidad u está libre

        ; añadido problema2: 
        (edificioNecesita ?ed - Edificios ?rec - Recursos) ; ed necesita rec para ser construido
        (edificioTipo ?ed - Edificios ?tipo - tipoEdificio) ; ed es del tipo tipoEdificio
        (recursoDisponible ?rec - Recursos) ; rec está disponible

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
		)
	)

	(:action Asignar ; accion asignar
        ; TODO: modificar problema2
		:parameters (?unidad - Unidades ?x - Localizaciones ?rec - Recursos) ; parametros
		:precondition (and 
			(entidadEn ?unidad ?x) ; unidad está en x
			(recursoEn ?rec ?x) ; hay rec en x
			(VCElibre ?unidad) ; unidad está libre

            ; añadido problema2
            (imply (recursoEn Gas ?x) ; si en x hay Gas, existe ed de tipo Extractor en x
                (exists (?ed - Edificios) (and
                    (edificioTipo ?ed Extractor)
                    (entidadEn ?ed ?x)
                ) )
            )
		)
		:effect (and 
			(VCEextrayendo ?unidad ?rec) ; unidad extrayendo rec
			(not (VCElibre ?unidad)) ; unidad no está libre
            (recursoDisponible ?rec) ; rec está disponible
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
                    (imply (edificioNecesita ?tipo ?rec) (recursoDisponible ?rec)) ; si ed necesita rec, rec está disponible
                ) )
            )
        )
        :effect (and 
            (entidadEn ?ed ?x) ; ed está en x
            (edificioConstruido ?ed) ; ed está construido
        )
    )
)