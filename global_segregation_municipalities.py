import duckdb
from logica.common import logica_lib
import folium
import matplotlib
from matplotlib import colors
from shapely import wkb
import geopandas

def style_polygon(segregation, min_segregation, max_segregation):
    epsilon = 1e-5
    norm_pos = colors.Normalize(vmin=epsilon, vmax=max_segregation)
    norm_neg = colors.Normalize(vmin=epsilon, vmax=abs(min_segregation))
    if segregation > 0:
        color = colors.to_hex(matplotlib.colormaps['Reds'](norm_pos(segregation)))
    elif segregation < 0:
        color = colors.to_hex(matplotlib.colormaps['Blues'](norm_neg(abs(segregation))))
    else:
        color = 'white'
    return {
        'fillColor': color,
        'color': 'black',
        'weight': 1,
        'fillOpacity': 0.7
    }

def polygon_municipality(municipality, min_segregation, max_segregation, polygons):
    polygon = polygons[polygons['municipality'] == municipality['municipality']]

    if not polygon.empty:
        gdf = geopandas.GeoDataFrame([{
            'municipality': municipality['municipality'],
            'segregation_value': municipality['segregation_value'],
            'minority_municipality_students': municipality['minority_municipality_students'],
            'total_municipality_students': municipality['total_municipality_students'],
            'geometry': polygon.iloc[0]['geometry']
        }], geometry='geometry')
        gdf['geometry'] = gdf['geometry'].simplify(tolerance=0.001)

        return folium.GeoJson(
            gdf.to_json(),
            name=str(municipality['municipality']),
            tooltip=folium.GeoJsonTooltip(
                fields=['municipality', 'segregation_value',
                        'minority_municipality_students', 'total_municipality_students'],
                aliases=['Municipality', 'Segregation value', 'Minimum-income students', 'Total students']
            ),
            style=style_polygon(municipality['segregation_value'], min_segregation, max_segregation)
        )
    else:
        print(f"No geometry found for {municipality['municipality']}")
        return None


db_path = "../data/madrid.duckdb"
connection = duckdb.connect(db_path)

municipalities = logica_lib.RunPredicateToPandas('segregation.l',
                                     'MunicipalitySegregation',
                                     connection=connection)
polygons = logica_lib.RunPredicateToPandas('segregation.l',
                                                 'PolygonMunicipality',
                                                 connection=connection)
polygons['geometry'] = polygons['polygon'].apply(lambda b: wkb.loads(bytes(b)))

map = folium.Map(location=[40.4168, -3.7038], zoom_start=9)

max_segregation = max(municipalities['segregation_value'])
min_segregation = min(municipalities['segregation_value'])

for _, municipality in municipalities.iterrows():
        p = polygon_municipality(municipality, min_segregation, max_segregation, polygons)
        if p != None:
            p.add_to(map)

map.save(f"global_segregation_municipalities.html")

connection.close()
