# Visualization of (non-)segregation in the "Comunidad de Madrid"

In this repository, you can find interactive web maps designed to visualize the (non-)segregation of  minimum-income students across different schools and municipalities
in the "Comunidad de Madrid". We analyze over 100,000 applications for the first year of preschool (age 3) during the 2023/2024 school year.


We present visualizations of segregation at three levels:
- Segregation of each school with respect to the entire "Comunidad de Madrid" ([`global_segregation_schools.html`](global_segregation_schools.html)).
- Segregation of each municipality in respect to the "Comunidad de Madrid" ([`global_segregation_municipalities.html`](global_segregation_municipalities.html)).
- Segregation of each school in the context of its own municipality ([`local_segregation_schools.html`](local_segregation_schools.html)).

Each map displays the following information for each school or municipality:
- **Name.**
- **Number of minimum-income students admitted.**
- **Total number of students admitted.**
- **Segregation Value.**
  - Computed using a disaggregated version of Gorard's segregation index:
  
    Segregation Value = `A_n` / `A_N` - `T_n` / `T_N`
    
    where:
    - `N` refers to the total area considered (e.g., *Comunidad de Madrid* or a specific municipality).
    - `n` refers to the specific school or municipality being analyzed.
    - `A_i` is the number of minimum-income students admitted in `i`.
    - `T_i` is the total number of students admitted in `i`.
      
  - Schools/municipalities which segregation value is positive (indicating a surplus of minimum-income students) are colored in red.
  - Schools/municipalities which segregation value is negative (indicating a shortage of minimum-income students) are colored in blue.


This research is part of the project **VAE: Value-Aware Systems. Value Engineering in Artificial Intelligence Systems**, subproject: **Value-Conscious Systems**, funded by **MCIN / AEI / 10.13039/501100011033**, and by the **European Union – NextGenerationEU / PRTR**.

The used data was provided by the "Consejería de Educación de la Comunidad de Madrid" upon request by Mar Moreno Rebato and José Antonio Rodríguez García, as described in their article:  
**"El acceso a los datos en los procesos de asignación de plazas escolares con fines de investigación científica: La utilización de la inteligencia artificial en este contexto"**,  
*Revista Española de la Transparencia*, no. 21, pp. 129–156, June 2025.  
[https://revistatransparencia.com/ojs/index.php/ret/article/view/359](https://revistatransparencia.com/ojs/index.php/ret/article/view/359) — DOI: [10.51915/ret.359](https://doi.org/10.51915/ret.359)
