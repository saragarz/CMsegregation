# Visualization of (non-)segregation in the "Comunidad de Madrid"

In this repository, you can find interactive web maps designed to visualize the (non-)segregation of  minimum-income students across different schools and municipalities
in the "Comunidad de Madrid". We analyze over 100,000 applications for the first year of preschool (age 3) during the 2023/2024 school year.


We present visualizations of segregation at three levels:
- Segregation of each school with respect to the entire "Comunidad de Madrid" ([`global_segregation_schools.html`](global_segregation_schools.html)).
- Segregation of each municipality in respect to the "Comunidad de Madrid" ([`global_segregation_municipalities.html`](global_segregation_municipalities.html)).
- Segregation of each school considering only its own municipality ([`local_segregation_schools.html`](local_segregation_schools.html)).

Each map displays the following information for each school or municipality:
- **Name.**
- **Number of inimum-income students admitted.**
- **Total number of students admitted.**
- **Segregation Value.**
  - Computed using a disaggregated version of Gorard's segregation index:
  
    Segregation Value = A_n / A_N - T_n / T_N
    
    where:
    - `N` refers to the total area considered (e.g., *Comunidad de Madrid* or a specific municipality).
    - `n` refers to the specific school or municipality being analyzed.
    - `A_i` is the number of minimum-income students admitted in `i`.
    - `T_i` is the total number of students admitted in `i`.
      
  - Schools/municipalities which segregation value is positive (indicating a surplus of minimum-income students) are colored in red.
  - Schools/municipalities which segregation value is negative (indicating a shortage of minimum-income students) are colored in blue.
