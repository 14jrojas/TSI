; Jesús Miguel Rojas Gómez

(define (problem problema2) ; defición del problema

	(:domain dominio2) ; dominio donde se define

	(:objects ; objetos
		LOC11 LOC12 LOC13 LOC14 LOC15 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 LOC42 LOC43 LOC44 - Localizaciones ; localizaciones del mapa
		; añadido problema2: VCE2, Extractor1
        VCE1 VCE2 - Unidades ; unidades del problema
		CentroDeMando1 Extractor1 - Edificios ; edificios del problema
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

        (entidadEn CentroDeMando1 LOC11) ; CentroDeMando1 está en LOC11
		(edificioConstruido CentroDeMando1) ; CentroDeMando1 construido
		(entidadEn VCE1 LOC11) ; VCE1 está en LOC11
		(VCElibre VCE1) ; VCE1 está libre
        ; añadido problema2:
        (entidadEn VCE2 LOC11) ; VCE2 está en LOC11
        (VCElibre VCE2) ; VCE2 está libre

		(recursoEn Mineral LOC24) ; hay Mineral en LOC24
		(recursoEn Mineral LOC44) ; hay Mineral en LOC44
        ; añadido problema2:
        (recursoEn Gas LOC15) ; hay Gas en LOC15

        ; añadido problema2:
        (edificioNecesita Extractor Mineral) ; extractor necesita Mineral para construirse
        (edificioTipo Extractor1 Extractor) ; Extractor1 es de tipo Extractor
        (edificioTipo CentroDeMando1 CentroDeMando) ; CentroDeMandos1 es de tipo CentroDeMando
	)

	(:goal (and
		(recursoDisponible Gas) ; objetivo: generar Gas
	))
)
