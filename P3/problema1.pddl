; Jesús Miguel Rojas Gómez

(define (problem problema1) ; defición del problema

	(:domain dominio1) ; dominio donde se define

	(:objects ; objetos
		LOC11 LOC12 LOC13 LOC14 LOC15 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 LOC42 LOC43 LOC44 - Localizaciones ; localizaciones del mapa
		VCE1 - Unidades ; unidades del problema
		CentroDeMando1 - Edificios ; edificios del problema
	)

	(:init
		; representa el grafo del problema
		; caminos de ida y vuelta: si hay un camino entre A y B, hay un camino entre B y A
		(caminoEntre LOC11 LOC12)
		(caminoEntre LOC12 LOC11)
		(caminoEntre LOC11 LOC21)
		(caminoEntre LOC21 LOC11)
		(caminoEntre LOC21 LOC31)
		(caminoEntre LOC31 LOC21)
		(caminoEntre LOC31 LOC32)
		(caminoEntre LOC32 LOC31)
		(caminoEntre LOC12 LOC22)
		(caminoEntre LOC22 LOC12)
		(caminoEntre LOC22 LOC32)
		(caminoEntre LOC32 LOC22)
		(caminoEntre LOC32 LOC42)
		(caminoEntre LOC42 LOC32)
		(caminoEntre LOC42 LOC43)
		(caminoEntre LOC43 LOC42)
		(caminoEntre LOC43 LOC44)
		(caminoEntre LOC44 LOC43)
		(caminoEntre LOC44 LOC15)
		(caminoEntre LOC15 LOC44)
		(caminoEntre LOC15 LOC14)
		(caminoEntre LOC14 LOC15)
		(caminoEntre LOC14 LOC24)
		(caminoEntre LOC24 LOC14)
		(caminoEntre LOC44 LOC34)
		(caminoEntre LOC34 LOC44)
		(caminoEntre LOC24 LOC23)
		(caminoEntre LOC23 LOC24)
		(caminoEntre LOC23 LOC33)
		(caminoEntre LOC33 LOC23)
		(caminoEntre LOC23 LOC13)
		(caminoEntre LOC13 LOC23)
		(caminoEntre LOC23 LOC22)
		(caminoEntre LOC22 LOC23)

		(edificioConstruido CentroDeMando1) ; CentroDeMando1 construido
		(entidadEn CentroDeMando1 LOC11) ; CentroDeMando1 está en LOC11
		(entidadEn VCE1 LOC11) ; VCE1 está en LOC11
		(VCElibre VCE1) ; VCE1 está libre

		(recursoEn Mineral LOC24) ; hay Mineral en LOC24
		(recursoEn Mineral LOC44) ; hay Mineral en LOC44
	)

	(:goal (and
		(VCEextrayendo VCE1 Mineral) ; objetivo: que VCE1 extraiga Mineral
	))
)
