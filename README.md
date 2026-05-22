Github repository for my Master's thesis: A biophysical pipeline to study clonogenic cell survival and RBE in pre-clinical in vitro proton irradiations

Repository contents:
- AI logs: pdf files detailing my full conversations with ChatGPT that contributed to this thesis
- Calibration data_finalfornow: Folder with the results of the gafchromic film calibration
- Cell survival results: Folder containing the experimental data. Each experiment has a folder named DD_MM_YYYY with the raw colony counts and multiplicity results. For each experiment, there is also a folder EXP_DD_MM_YYYY that contains the raw data processed into surviving fractions per radiation type. It also contains the data obtained from R. Syljuåsen for U2OS cells.
- LET calculation in setup from RS sim: contains the simulated dose and LET data in the cell layer as exported from RS for the simulation with ROIs. It also contains the resulting dose and LET maps.
- Line dose analysis: contains a line profile exported from RS for the water phantom simulation. Also the results for the correction factor estimation in the back of the Bragg Peak.
- MATLAB codes: contains the MATLAB codes that were used to analyse the gafchromic films and establish the calibration curve.
- Mid LET calculation: contains the measured dose curve for 69.87 MeV to compare to the water phantom simulation. The water phantom simulation data itself is not in this repository as the files are too large.
**- Python codes: contains all the Python codes for analysing and generating results.**
- Snout position results: contains the RS exported data and the resulting LET/dose maps to verify that 0.13 cm snout position difference yields no different dose and LET.
- TOPAS_data: contains the TOPAS codes in 'codes', the dose and LET data for the created beam, the cell layer phase spaces for all configurations to calculate dose and LET (OUTPUTS_PHYSICS_...), and the MONAS lineal energy spectra for each setup, in batches if applicable (OUTPUTS_MONAS_...NR)
- Treatment plans: contains the treatment plans for the cell irradiations
- Uncertainty estimate results: contains the results for the bootstrap uncertainty analysis on the gafchromic film calibration curve
- X-ray spectrum calculations: contains the created SpekCalc spectrum and the downloaded NIST data for calculating the LET of the X-rays

All Python codes are written as Jupyter notebooks so that outputs were interactive and directly visible. The notebooks also contain notes about simulation setups and reasoning.
List of Python codes:
  - Analysis of RayStation simulation: Analyse the RS data for the simulation with ROIs to estimate mean dose and LET in the cell layer.
  - Bootstrap_uncertainty_estimate: Analyse the gafchromic film calibration results and refit the relation that was found in Matlab in a bootstrapping procedure to estimate the uncertainty interval
  - Cell survival analysis aggregated data: read in the surviving fraction per radiation type across all indicated experiments, correct multiplicity, create survival curves, estimate LQ fit parameters, create Rørvik fit and Rørvik RBE modelling. Perform mid LET prediction based on these fits.
  - Cell survival analysis per experiment: used to process the raw colony counts into files ready for input into 'Cell survival analysis aggregated data'. Plot histograms of the colony counts for analysis.
  - Does 0.13 cm snout position matter: analyse the dose and LET data in the 'Snout position results' folder to establish if different dose/LET values result in the cell layer when the snout position differs by 0.13 cm
  - Finding mid LET: Compare water phantom simulation data to dosimetry data. Find proximal and distal irradiation positions based on WET and calculate LET. Interpolate to find mid LET and associated amount of material needed to place the cells here.
  - Line dose analysis: analyse a line profile exported from RS for the water phantom simulation to estimate a correction factor between gafchromic film and ion chamber in the back of the BP
  - MONAS data analysis: Analyse MONAS lineal energy spectra and apply MKM equations to predict survival and RBE. Generate y approximation spectra and apply them to MKM to predict survival and RBE. Import experimental model and Rørvik predictions for comparison.
  - MONAS with more y approx models: implement several other methods of approximating y spectra for input into MKM. **Not included in the thesis**
  - RandisData: Partial copy of 'Cell survival analysis' scripts to calculate the LQ fit parameters for U2OS cells based on the data from R. Syljuåsen.
  - Random generator for multiplicity: random generator to select a square in the grid on a cell flask for multiplicity counting.
  - TOPAS beam analysis: read in the dose and LET data for the created beam. Compare to dosimetry data. Calculate LET in the cell layer.
  - X-ray spectrum calculations: read in the SpekCalc spectrum and NIST data. Implement the analytical equations to calculate LET of the X-rays.
