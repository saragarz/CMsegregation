# GENERAL QUERIES
AdmittedApplication(student:, course:, priority:, school_code:, school_name:,
    school_province:, school_municipality:, school_district:, school_district_name:,
    scoring_province:, scoring_municipality:, scoring_district:,
    scoring_district_name:, admitted:, withdrawn:, rejected:, enrolled:,
    score_minimum_income:, score_disability:, score_average_grade:,
    score_large_family:,
    score_residence:, score_former_student:, score_school_criteria:,
    score_siblings_enrolled:, score_working_guardian:, score_multiple_birth:,
    score_single_parent_family:, score_foster_care:, score_gender_violence:,
    total_score:, date:) :-
    Application(student:, course:, priority:, school_code:, school_name:,
        school_province:, school_municipality:, school_district:, school_district_name:,
        scoring_province:, scoring_municipality:, scoring_district:,
        scoring_district_name:, admission_school_code:, admitted:, withdrawn:,
        rejected:, enrolled:, score_minimum_income:, score_disability:,
        score_average_grade:, score_large_family:, score_residence:,
        score_former_student:, score_school_criteria:, score_siblings_enrolled:,
        score_working_guardian:, score_multiple_birth:,
        score_single_parent_family:, score_foster_care:, score_gender_violence:,
        total_score:, date:),
    course == "Tres Años",
    school_code == admission_school_code;


TotalStudentsSchool(students? +=1, school_code:) distinct :-
    AdmittedApplication(student:, school_code:);

TotalStudentsMunicipality(students? += school_students, municipality:) distinct :-
    TotalStudentsSchool(students:school_students, school_code:),
    School(school_code:, municipality_name:municipality);

TotalStudents(students? += school_students) distinct :-
    TotalStudentsSchool(students:school_students, school_code:);

MinimumIncome(minimum_income: "Yes", score_minimum_income: 2);
MinorityGroupStudent(student:) distinct :-
    Application(student:, score_minimum_income:),
    MinimumIncome(minimum_income: "Yes", score_minimum_income:);

MinorityGroupStudentsSchoolCount(students? += 1, school_code:) distinct :-
    AdmittedApplication(student:, school_code:, score_minimum_income:),
    MinimumIncome(minimum_income: "Yes", score_minimum_income:);

MinorityGroupStudentsSchoolDefault(students: 0, school_code:) distinct :-
    ~MinorityGroupStudentsSchoolCount(school_code:),
    TotalStudentsSchool(school_code:);

MinorityGroupStudentsSchool(students:, school_code:) distinct :-
    MinorityGroupStudentsSchoolCount(students:, school_code:) |
    MinorityGroupStudentsSchoolDefault(students:, school_code:);

MinorityGroupStudentsMunicipality(students? += school_students, municipality:) distinct :-
    MinorityGroupStudentsSchool(students:school_students, school_code:),
    School(school_code:, municipality_name:municipality);

MinorityGroupStudents(students? += school_students) distinct :-
    MinorityGroupStudentsSchool(students:school_students, school_code:);

SegregationValue(segregation_value:, minority_students_i:, minority_students:,
    total_students_i:, total_students:) :-
    minority_students > 0,
    segregation_value == minority_students_i/minority_students
         - total_students_i/total_students;

@OrderBy(Segregation, "segregation_value");
Segregation(segregation_value:, school_code:, school_name:,
    school_type_desc_abbr:, minority_school_students:, total_school_students:) :-
    School(school_code:, school_name:, school_type_desc_abbr:),
    MinorityGroupStudentsSchool(students:minority_school_students, school_code:),
    MinorityGroupStudents(students:minority_students),
    TotalStudentsSchool(students:total_school_students, school_code:),
    TotalStudents(students:total_students),
    (SegregationValue(segregation_value:,
    minority_students_i:minority_school_students, minority_students:,
        total_students_i:total_school_students, total_students:) |
    (minority_students == 0, segregation_value == 0));

@OrderBy(MunicipalitySegregation, "segregation_value");
MunicipalitySegregation(segregation_value:, municipality:, minority_municipality_students:,
    total_municipality_students:) :-
    MinorityGroupStudentsMunicipality(students:minority_municipality_students, municipality:),
    MinorityGroupStudents(students:minority_students),
    TotalStudentsMunicipality(students:total_municipality_students, municipality:),
    TotalStudents(students:total_students),
    (SegregationValue(segregation_value:,
    minority_students_i:minority_municipality_students, minority_students:,
        total_students_i:total_municipality_students, total_students:) |
    (minority_students == 0, segregation_value == 0));

@OrderBy(MunicipalSegregation, "segregation_value");
MunicipalSegregation(segregation_value:, school_code:, school_name:,
    school_type_desc_abbr:, municipality:, minority_school_students:,
    total_school_students:) :-
    School(school_code:, school_name:, school_type_desc_abbr:,
        municipality_name:municipality),
    MinorityGroupStudentsSchool(students:minority_school_students, school_code:),
    MinorityGroupStudentsMunicipality(students:minority_municipality_students, municipality:),
    TotalStudentsSchool(students:total_school_students, school_code:),
    TotalStudentsMunicipality(students:total_municipality_students, municipality:),
    minority_municipality_students >= 10,
    SegregationValue(segregation_value:,
        minority_students_i:minority_school_students,
        minority_students:minority_municipality_students,
        total_students_i:total_school_students,
        total_students:total_municipality_students);

@OrderBy(NearbyOppositeSchools, "surplus desc");
NearbyOppositeSchools(school_code1:, school_name1:, surplus:,
school_code2:, school_name2:, shortage:, distance:, municipality:,
minority_municipality_students:)
:-
    max_distance == 500,
    min_moved_students = 1,
    SchoolsDistance(distance:, school_code1:, school_code2:),
    distance <= max_distance,
    MunicipalitySegregation(municipality:, minority_municipality_students:,
        total_municipality_students:),
    MunicipalSegregation(segregation_value:segregation_value1,
        school_code:school_code1, municipality:),
    surplus = segregation_value1*minority_municipality_students,
    surplus >= min_moved_students,
    MunicipalSegregation(segregation_value:segregation_value2,
        school_code:school_code2, municipality:),
    shortage = -segregation_value2*minority_municipality_students,
    shortage >= min_moved_students,
    SchoolTypeName(school_type_name:school_name1, school_code:school_code1),
    SchoolTypeName(school_type_name:school_name2, school_code:school_code2);

@OrderBy(ExtremeSchools, "imbalance");
ExtremeSchools(imbalance:, school_code:, school_name:, minority_students:,
    total_students:) distinct :-
    ExtremeSchoolsSurplus(school_code:, school_name:, minority_students:,
        total_students:, imbalance:)
    |
    ExtremeSchoolsShortage(school_code:, school_name:, minority_students:,
        total_students:, imbalance:);

ExtremeSchoolsSurplus(school_code:, school_name:, minority_students:,
    total_students:, imbalance:) distinct :-
    NearbyOppositeSchools(school_code1:school_code, school_name1:school_name,
        surplus:),
    imbalance == surplus,
    MinorityGroupStudentsSchool(students:minority_students, school_code:),
    TotalStudentsSchool(students:total_students, school_code:);

ExtremeSchoolsShortage(school_code:, school_name:, minority_students:,
    total_students:, imbalance:) distinct :-
    NearbyOppositeSchools(school_code2:school_code, school_name2:school_name,
        shortage:),
    imbalance == -shortage,
    MinorityGroupStudentsSchool(students:minority_students, school_code:),
    TotalStudentsSchool(students:total_students, school_code:);

# SCHOOLS LOCATION
SchoolCoordinates(x:, y:, school_code:, school_name:) :-
    School(school_code:,  school_name:, address_coord_x:x, address_coord_y:y);

SchoolsDistance(distance:, school_code1:, school_code2:) :-
    SchoolCoordinates(x:x1, y:y1, school_code:school_code1),
    SchoolCoordinates(x:x2, y:y2, school_code:school_code2),
    Distance(distance:, x1:, y1:, x2:, y2:);

Distance(distance:, x1:, y1:, x2:, y2:) :-
    distance = Sqrt((x1-x2)^2 + (y1-y2)^2);

SchoolTypeName(school_type_name:school_type_desc_abbr++" "++school_name, school_code:) :-
    School(school_code:, school_name:, school_type_desc_abbr:);

# MUNICIPALITIES LOCATION
PolygonMunicipality(polygon:, municipality:) :-
    GeometryMunicipality(NAMEUNIT: municipality, geometry:polygon);
