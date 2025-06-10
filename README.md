# Visualization of (non-)segregation in Comunidad de Madrid

In this repo you can find some interactive web maps created to visualize the (non-)segregation of  minimum-income students across different schools and municipalities
in the Community of Madrid. We analysis the +100k applications of the first year of preschool (age 3) in the school year 2023/2024.

We present the visualization of three segregation levels:
- Segregation of each school with respect to the entire Community of Madrid (*school_CAM_segregation.html*).
- Segregation of each municipality in respect to the Community of Madrid (*municipality_segregation.html*).
- Segregation of each school considering only its own municipality (*school_municipal_segregation.html*).

In each map you can observe the following information for each school/municipality:
- **Name.**
- **Low-income students admitted.**
- **Total students admitted.**
- **Segregation Value.**
  - Computed desagregating the Gorard's segregation index:
  
    Segregation Value = M_A / M_B - T_A / T_B
    
    where:
    - A refers to the school/municipality observed.
    - B refers to the total area considered.
    - M_A is the number of minimum-income students admitted in A.
    - M_B is the number of minimum-income students admitted in B.
    - T_A is the total number of students admitted in A.
    - T_B is the total number of students admitted in B.
      
  - Schools/municipalities which segregation value is positive are colored in red.
  - Schools/municipalities which segregation value is negative are colored in blue.
