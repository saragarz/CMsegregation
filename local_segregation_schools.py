import duckdb
from folium import FeatureGroup

from logica.common import logica_lib
from pyproj import Transformer
import folium
import matplotlib
from matplotlib import colors

db_path = "../data/madrid.duckdb"
connection = duckdb.connect(db_path)

def school_lat_lon(school_code, schools_coordinates):
    school_coordinates = schools_coordinates.loc[schools_coordinates['school_code'] == school_code]
    if school_coordinates.empty:
        return None, None
    else:
        transformer = Transformer.from_crs("EPSG:25830", "EPSG:4326", always_xy=True)
        lon, lat = transformer.transform(school_coordinates.iloc[0]['x'], school_coordinates.iloc[0]['y'])
        return lat, lon

def marker_circle(lat, lon, radius, color, color_fill, popup):
    marker = folium.CircleMarker(
        location=[lat, lon],
        radius=radius,
        color=color,
        weight=1,
        fill=True,
        fill_color=color_fill,
        fill_opacity=0.7,
        popup=popup
    )
    return marker

def marker_school_segregation(school_segregation, min_segregation, max_segregation, schools_coordinates):
    code = school_segregation['school_code']
    name = school_segregation['school_type_desc_abbr']+" "+school_segregation['school_name']
    segregation = school_segregation['segregation_value']
    minority_students = school_segregation['minority_school_students']
    total_students = school_segregation['total_school_students']
    lat, lon = school_lat_lon(code, schools_coordinates)
    popup = (f"{name}<br>"
             f"segregation value = {segregation}<br>"
             f"Minimum-income students: {int(minority_students)}<br>"
             f"Total students: {int(total_students)}<br>")
    if lat != None and  lon != None:
        min_radius = 4
        max_radius = 12
        if segregation > 0:
            radius = min_radius + (segregation/max_segregation) * (max_radius-min_radius)
            color = colors.to_hex(matplotlib.colormaps['Reds'](segregation/max_segregation))
            return marker_circle(lat, lon, radius, 'red', color, popup)
        elif segregation < 0:
            radius = min_radius + (segregation/min_segregation) * (max_radius-min_radius)
            color = colors.to_hex(matplotlib.colormaps['Blues'](segregation/min_segregation))
            return marker_circle(lat, lon, radius, 'blue', color, popup)
        else:
            return marker_circle(lat, lon, min_radius, 'white', 'white', popup)
    else:
        return None

map = folium.Map(location=[40.4168, -3.7038], zoom_start=9)
schools_segregation = logica_lib.RunPredicateToPandas('segregation.l',
                                                      'MunicipalSegregation', connection=connection)
schools_coordinates = logica_lib.RunPredicateToPandas('segregation.l',
                                                      'SchoolCoordinates', connection=connection)
max_segregation = max(schools_segregation['segregation_value'])
min_segregation = min(schools_segregation['segregation_value'])

all_muni = folium.FeatureGroup(name="All municipalities", show=False)
municipality_markers = {}
for _, school_segregation in schools_segregation.iterrows():
    muni = school_segregation['municipality']
    if muni not in municipality_markers:
        municipality_markers[muni] = folium.FeatureGroup(name=f'{muni}', show=False)
    max_segregation = max(schools_segregation[schools_segregation['municipality']==school_segregation['municipality']]['segregation_value'])
    min_segregation = min(schools_segregation[schools_segregation['municipality']==school_segregation['municipality']]['segregation_value'])
    marker_school_segregation(
        school_segregation, min_segregation, max_segregation, schools_coordinates).add_to(municipality_markers[muni])
    marker_school_segregation(
        school_segregation, min_segregation, max_segregation, schools_coordinates).add_to(all_muni)

all_muni.add_to(map)

for muni_name in sorted(municipality_markers.keys()):
    municipality_schools = municipality_markers[muni_name]
    municipality_schools.add_to(map)

folium.LayerControl(collapsed=False).add_to(map)

map.save(f"local_segregation_schools.html")

connection.close()
