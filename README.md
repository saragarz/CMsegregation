# Visualización de la segregación (o no) por renta mínima en la Comunidad de Madrid

En este mapa están representados todos los municipios de la Comunidad de Madrid que recibieron solicitudes de alumnos para estudiar en alguno de sus centros educativos públicos o concertados en el curso 2023/2024 para el nivel educativo "Tres años".

La segregación se puede observar de 3 maneras distintas en el mapa:
- Segregación de cada municipio respecto a la Comunidad de Madrid (botón **Municipios** del panel de la derecha).
- Segregación de los centros escolares de un municipios concreto respecto a dicho municipio (botones **Centros [municipio]** del panel de la derecha).
- Centros cercanos dentro de un mismo municipio que tienen segregación opuesta (botón **Extremos cercanos (< [metros] m)** del panel de la derecha).

## Segregación de cada municipio respecto a la CM
Para determinar la segregación de cada municipio:
1. Se calcula la proporción de alumnos de renta mínima en el municipio en comparación con toda la Comunidad (_rm_).
2. Se calcula la proporción de alumnos totales en el municipio en comparación con la Comunidad (_t_).
3. A _rm_ se le resta _t_, esta resta es su índice de segregación.

El color de cada municipio representa la segregación de cada uno respecto a la Comunidad de Madrid en su totalidad:
- El color rojo indica un índice de segregación positivo, más alumnos de renta mínima en ese municipio de los que deberían.
- El color azul un índice de segregación negativo, menos alumnos de renta mínima en el municipio de los deseables.

Cuanto más se aleja el municipio de la uniformidad,  más intensos los colores.

Pasando el ratón por encima de cada municipio se pueden ver más datos:
- Nombre del municipio.
- Índice de segregación.
- Alumnos de renta mínima.
- Alumnos totales.

## Segregación de los centros de un municipio
Para determinar la segregación de cada centro:
1. Se calcula la proporción de alumnos de renta mínima en el centro en comparación con todo el municipio (_rmi_).
2. Se calcula la proporción de alumnos totales en el centro en comparación con los alumnos totales del municipio (_ti_).
3. A _rmi_ se le resta _ti_, esta resta es su índice de segregación.

El color de cada centro representa la segregación de cada uno respecto al municipio en su totalidad:
- El color rojo indica un índice de segregación positivo, más alumnos de renta mínima en ese municipio de los que deberían.
- El color azul un índice de segregación negativo, menos alumnos de renta mínima en el municipio de los deseables.
Cuanto más intensos los colores y más grandes los círculos, más se aleja el municipio de la uniformidad.

Pasando el ratón por cada centro se pueden ver más datos:
- Nombre del centro.
- Índice de segregación (_gi_).
- Alumnos de renta mínima.
- Alumnos totales.

## Centros cercanos de segregación opuesta
Para destacar algunos casos interesantes, se pueden visualizar centros de segregación lo suficientemente opuesta (un _gi_ de signo contrario y mayor que 0.2 en valor absoluto) que estén a una distancia menor a:
- 1 kilómetro.
- 500 metros.
- 300 metros.
- 100 metros.
