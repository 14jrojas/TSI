; Jesús Miguel Rojas Gómez

(define (problem problema8) ; defición del problema

	(:domain dominio8) ; dominio donde se define

	(:objects ; objetos
		LOC11 LOC12 LOC13 LOC14 LOC15 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 LOC42 LOC43 LOC44 - Localizaciones ; localizaciones del mapa
		; añadido problema2: VCE2, Extractor1
        ; añadido problema3: VCE3, Barracones1
        ; añadido problema4: Marine1, Marine2, Soldado1
        VCE1 VCE2 VCE3 Marine1 Marine2 Soldado1 - Unidades ; unidades del problema
		CentroDeMando1 Extractor1 Barracones1 - Edificios ; edificios del problema
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
        ; modificado problema4:
        ;(entidadEn VCE2 LOC11) ; VCE2 está en LOC11
        ;(VCElibre VCE2) ; VCE2 está libre
        ; añadido problema3:
        ;(entidadEn VCE3 LOC11) ; VCE3 está en LOC11
        ;(VCElibre VCE3) ; VCE3 está libre

		(recursoEn Mineral LOC22) ; hay Mineral en LOC24
		(recursoEn Mineral LOC44) ; hay Mineral en LOC44
        ; añadido problema2:
        (recursoEn Gas LOC15) ; hay Gas en LOC15

        ; añadido problema2:
        (entidadNecesita Extractor Mineral) ; extractor necesita Mineral para construirse
        (edificioTipo Extractor1 Extractor) ; Extractor1 es de tipo Extractor
        (edificioTipo CentroDeMando1 CentroDeMando) ; CentroDeMandos1 es de tipo CentroDeMando
        ; añadido problema3:
        (edificioTipo Barracones1 Barracones) ; Barracones1 es de tipo Barracones
        (entidadNecesita Barracones Mineral) ; Barracones necesita Mineral para construirse
        (entidadNecesita Barracones Gas) ; Barracones necesita Gas para construirse
        ; añadido problema4:
        (entidadNecesita VCE Mineral) ; VCE necesitan Mineral
        (entidadNecesita Marine Mineral) ; Marine necesitan Mineral
        (entidadNecesita Soldado Mineral) ; Soldado necesitan Mineral y Gas
        (entidadNecesita Soldado Gas)
        (unidadNecesita VCE CentroDeMando) ; VCE son generados en CentrosDeMando
        (unidadNecesita Marine Barracones) ; Marine son generados en Barracones
        (unidadNecesita Soldado Barracones) ; Solado son generados en Barracones
        (unidadTipo Marine1 Marine) ; Marine1 es de tipo Marine
        (unidadTipo Marine2 Marine) ; Marine2 es de tipo Marine
        (unidadTipo Soldado1 Soldado) ; Soldado1 es de tipo Soldado
        (unidadTipo VCE1 VCE) ; VCE1 es de tipo VCE
        (unidadTipo VCE2 VCE) ; ""
        (unidadTipo VCE3 VCE) ; ""
        ; añadido problema7:
        ; tabla de costes
        (= (entidadNecesita Barracones Mineral) 40)
        (= (entidadNecesita Barracones Gas) 10)
        (= (entidadNecesita Extractor Mineral) 10)
        (= (entidadNecesita Extractor Gas) 0)
        (= (entidadNecesita VCE Mineral) 5)
        (= (entidadNecesita VCE Gas) 0)
        (= (entidadNecesita Marine Mineral) 10)
        (= (entidadNecesita Marine Gas) 15)
        (= (entidadNecesita Soldado Mineral) 30)
        (= (entidadNecesita Soldado Gas) 40)
        ; limites
        (= (limiteRecurso Mineral) 50)
        (= (limiteRecurso Gas) 60)
        ; cantidades iniciales
        (= (cantidadRecurso Mineral) 0)
        (= (cantidadRecurso Gas) 0)
        ; cantidades por tiempo
        (= (recolectaRecurso Mineral) 5)
        (= (recolectaRecurso Gas) 10)
        ; extrayendo inicialmente
        (= (totalExtrayendo Mineral LOC22) 0)
        (= (totalExtrayendo Mineral LOC44) 0)
        (= (totalExtrayendo Gas LOC15) 0)

        ; añadido problema8:
        (= (distancia LOC11 LOC12) 10)
		(= (distancia LOC12 LOC11) 10)
		(= (distancia LOC11 LOC21) 10)
		(= (distancia LOC21 LOC11) 10)
		(= (distancia LOC21 LOC31) 10)
		(= (distancia LOC31 LOC21) 10)
		(= (distancia LOC31 LOC32) 10)
		(= (distancia LOC32 LOC31) 10)
		(= (distancia LOC12 LOC22) 10)
		(= (distancia LOC22 LOC12) 10)
		(= (distancia LOC22 LOC32) 10)
		(= (distancia LOC32 LOC22) 10)
		(= (distancia LOC32 LOC42) 10)
		(= (distancia LOC42 LOC32) 10)
		(= (distancia LOC42 LOC43) 20)
		(= (distancia LOC43 LOC42) 20)
		(= (distancia LOC43 LOC44) 10)
		(= (distancia LOC44 LOC43) 10)
		(= (distancia LOC44 LOC15) 40)
		(= (distancia LOC15 LOC44) 40)
		(= (distancia LOC15 LOC14) 10)
		(= (distancia LOC14 LOC15) 10)
		(= (distancia LOC14 LOC24) 10)
		(= (distancia LOC24 LOC14) 10)
		(= (distancia LOC44 LOC34) 10)
		(= (distancia LOC34 LOC44) 10)
		(= (distancia LOC24 LOC23) 10)
		(= (distancia LOC23 LOC24) 10)
		(= (distancia LOC23 LOC33) 10)
		(= (distancia LOC33 LOC23) 10)
		(= (distancia LOC23 LOC13) 10)
		(= (distancia LOC13 LOC23) 10)
		(= (distancia LOC23 LOC22) 20)
		(= (distancia LOC22 LOC23) 20)

        (= (velocidadUnidad VCE) 1)
        (= (velocidadUnidad Marine) 5)
        (= (velocidadUnidad Soldado) 10)

        (= (tiempoRecolectar Mineral) 10)
        (= (tiempoRecolectar Gas) 5)

        (= (tiempoEntidad Barracones) 50)
        (= (tiempoEntidad Extractor) 20)
        (= (tiempoEntidad VCE) 10)
        (= (tiempoEntidad Marine) 20)
        (= (tiempoEntidad Soldado) 30)

        (= (tiempo) 0)

    )

	(:goal (and
		(entidadEn Marine1 LOC31) ; Marine1 en LOC31
        (entidadEn Marine2 LOC24) ; Marine2 en LOC24
        (entidadEn Soldado1 LOC12) ; Soldado1 en LOC12
		(entidadEn Barracones1 LOC33) ; Barracones1 en LOC33
        (< (tiempo) 559) ; tiempo < optimo
	))

    (:metric minimize (tiempo)) ; metrica minimizar tiempo
)
