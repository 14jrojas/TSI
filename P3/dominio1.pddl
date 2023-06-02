; Jesús Miguel Rojas Gómez

(define (domain dominio1) ; definición del dominio

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
		CentroDeMando Barracones - tipoEdificio ; CentroDeMando Barracones deriva de tipoEdificio
		Mineral Gas - tipoRecurso ; Mineral, Gas deriva de tipoRecurso
	)

	(:predicates
		(entidadEn ?ent - Entidad ?x - Localizaciones) ; entidad ent se encuentra en localizacion x
		(caminoEntre ?x1 - Localizaciones ?x2 - Localizaciones) ; hay un camino entre localizacion x1 y localizacion x2
		(edificioConstruido ?ed - Edificios) ; edificio es está construido
		(recursoEn ?rec - Recursos ?x - Localizaciones) ; recurso rec se encuentra en localizacion x
		(VCEextrayendo ?u - Unidades ?rec - Recursos) ; unidad u está extrayendo recuros rec
		(VCElibre ?u - Unidades) ; unidad u está libre
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
		:parameters (?unidad - Unidades ?x - Localizaciones ?rec - Recursos) ; parametros
		:precondition (and 
			(entidadEn ?unidad ?x) ; unidad está en x
			(recursoEn ?rec ?x) ; hay rec en x
			(VCElibre ?unidad) ; unidad está libre
		)
		:effect (and 
			(VCEextrayendo ?unidad ?rec) ; unidad extrayendo rec
			(not (VCElibre ?unidad)) ; unidad no está libre
		)
	)
)