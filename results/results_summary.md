# Results summary

This folder contains lightweight visual and tabular outputs extracted from the project documentation and MATLAB Live Script. Raw RF measurement datasets are intentionally not included.

## Included figures

| File | Description |
|---|---|
| `low_frequency_white_noise_input.png` | Example low-frequency white-noise input signal used for amplitude modulation. |
| `rf_output_white_noise_95mhz.png` | Example RF output signal at 95 MHz modulated by white noise. |
| `input_output_data_55mhz_handel.png` | MATLAB `iddata` input-output plot for the Handel excitation at 55 MHz. |
| `nlarx_validation_response_8877.png` | Validation response comparison for the selected NLARX configuration. |
| `nlarx_validation_negative_fit_raw.png` | Raw validation comparison retained for traceability. |
| `nlarx_validation_after_detrend_negative_fit.png` | Detrended validation comparison retained for traceability. |

## Tabular outputs

| File | Description |
|---|---|
| `dataset_summary.csv` | Measurement setup and dataset metadata. |
| `identification_summary.csv` | Model families and configurations explored in MATLAB. |

## Best model note

The MATLAB Live Script reports a best-fit search result obtained on the sweep excitation at 65 MHz using an NLARX model with `na = 4`, `nb = [4 4]` and `nk = [1 1]`.
